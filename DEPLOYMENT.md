# Deployment Guide

## Prerequisites

1. **Production Database**: PostgreSQL is strongly recommended for production
2. **Environment Variables**: Set all required variables (see `.env.example`)
3. **Secret Key**: Generate a strong, random secret key

## Quick Setup

### 1. Install Dependencies

```bash
pip install -r requirements.txt
```

### 2. Configure Environment Variables

Copy `.env.example` to `.env` and update the values:

```bash
cp .env.example .env
```

**Required variables:**
- `SECRET_KEY`: Generate using `python -c "import os; print(os.urandom(32).hex())"`
- `DATABASE_URL`: PostgreSQL connection string (e.g., `postgresql://user:pass@localhost/dbname`)
- `FLASK_ENV`: Set to `production`
- `SESSION_COOKIE_SECURE`: Set to `True` once HTTPS is in place. Leave `False` temporarily if serving over plain HTTP (otherwise browsers will discard the session cookie).

### 2a. Session configuration checklist

- Ensure the production process exports a **stable** `SECRET_KEY`. If it is missing, Flask auto-generates a new one on every restart and all sessions/logins are invalidated.
- Export `SESSION_COOKIE_SECURE=False` whenever the app is exposed over HTTP during setup/testing. Switch it back to `True` immediately after TLS is enabled.
- If you rely on `flask-session` or server-side session storage, point `SESSION_FILE_DIR` (or equivalent) to a directory outside your repo and exclude it from git.

### 2b. Copying SQLite data (temporary workflows)

If you are still using the bundled SQLite database during early deployments:

1. Copy the populated file from your dev machine: `scp path/to/instance/site.db user@server:/var/www/mlasjad/instance/site.db`
2. Create the `instance/` directory on the server first (`mkdir -p /var/www/mlasjad/instance`).
3. Stop Gunicorn before replacing the file, then restart it so the new data is picked up.
4. Treat this as a stop-gap—plan to migrate to PostgreSQL and scripted migrations before production launch.

### 2c. Migrating from SQLite to PostgreSQL

1. **Install PostgreSQL locally** (e.g., `brew install postgresql@15`) and on the VPS (`sudo apt install postgresql`).
2. **Install the Python driver**: `pip install psycopg2-binary` (already listed in `requirements.txt`).
3. **Create the target database**
   ```bash
   # local example
   createdb mlasjad
   # server example
   sudo -u postgres createdb mlasjad
   sudo -u postgres createuser --pwprompt mlasjad_app
   sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE mlasjad TO mlasjad_app;"
   ```
4. **Point the app at PostgreSQL** by setting `DATABASE_URL=postgresql+psycopg2://user:password@host:5432/mlasjad` in your `.env` (locally) or environment variables (server) and run `flask db upgrade` to create the schema.
5. **Copy data from SQLite** into the empty PostgreSQL database:
   ```bash
   python scripts/sqlite_to_postgres.py \
       --sqlite instance/site.db \
       --postgres "$DATABASE_URL"
   ```
6. Repeat the same steps on the VPS (run migrations, copy the SQLite snapshot once) and then retire the SQLite file.
7. From this point on, use `pg_dump`/`pg_restore` to move data between environments instead of copying SQLite files.

### 3. Initialize Database

```bash
# Create database tables
flask db upgrade

# Or if starting fresh
python -c "from website import app, db; app.app_context().push(); db.create_all()"
```

## Deployment Options

### Option 1: Heroku

1. Install Heroku CLI and login
2. Create a new Heroku app:
   ```bash
   heroku create your-app-name
   ```

3. Add PostgreSQL addon:
   ```bash
   heroku addons:create heroku-postgresql:hobby-dev
   ```

4. Set environment variables:
   ```bash
   heroku config:set SECRET_KEY="your-generated-secret-key"
   heroku config:set FLASK_ENV=production
   ```

5. Deploy:
   ```bash
   git push heroku main
   ```

6. Run migrations:
   ```bash
   heroku run flask db upgrade
   ```

### Option 2: VPS (DigitalOcean, AWS EC2, etc.)

1. **Install system dependencies:**
   ```bash
   sudo apt update
   sudo apt install python3-pip python3-venv postgresql nginx
   ```

2. **Clone repository and setup:**
   ```bash
   git clone <your-repo>
   cd web1
   python3 -m venv venv
   source venv/bin/activate
   pip install -r requirements.txt
   ```

3. **Configure PostgreSQL:**
   ```bash
   sudo -u postgres psql
   CREATE DATABASE your_db_name;
   CREATE USER your_user WITH PASSWORD 'your_password';
   GRANT ALL PRIVILEGES ON DATABASE your_db_name TO your_user;
   \q
   ```

4. **Set environment variables:**
   ```bash
   cp .env.example .env
   nano .env  # Edit with your values
   ```

5. **Run with Gunicorn:**
   ```bash
   gunicorn wsgi:app --workers 4 --bind 0.0.0.0:8000
   ```

6. **Setup Nginx as reverse proxy** (optional but recommended)

7. **Setup systemd service** for auto-restart

### Option 3: Docker

Create `Dockerfile`:

```dockerfile
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

ENV FLASK_ENV=production
ENV PORT=8000

EXPOSE 8000

CMD ["gunicorn", "wsgi:app", "--workers", "4", "--bind", "0.0.0.0:8000"]
```

Build and run:
```bash
docker build -t web1 .
docker run -p 8000:8000 --env-file .env web1
```

## Production Checklist

- [ ] Set `FLASK_ENV=production`
- [ ] Generate and set strong `SECRET_KEY`
- [ ] Use PostgreSQL (not SQLite)
- [ ] Run `flask db upgrade` against PostgreSQL in every environment before pushing data
- [ ] Capture backups with `pg_dump` before deploying schema changes
- [ ] Set `DEBUG=False` in `.env`
- [ ] Enable HTTPS/SSL
- [ ] Set `SESSION_COOKIE_SECURE=True` (after HTTPS is enabled; keep `False` only while testing on HTTP)
- [ ] Configure firewall rules
- [ ] Set up regular database backups
- [ ] Configure logging
- [ ] Set up monitoring (e.g., Sentry, New Relic)
- [ ] Review file upload security
- [ ] Set appropriate file size limits
- [ ] Add rate limiting (e.g., Flask-Limiter)
- [ ] Review and test all endpoints

## Security Notes

1. **Never commit `.env` file** - It's in `.gitignore`
2. **Rotate secret keys periodically**
3. **Use environment-specific configurations**
4. **Keep dependencies updated**: `pip install --upgrade -r requirements.txt`
5. **Monitor logs** for suspicious activity
6. **Implement rate limiting** for login/registration endpoints
7. **Use HTTPS only** in production

## Database Migrations

When you make changes to database models:

```bash
flask db migrate -m "Description of changes"
flask db upgrade
```

## Running Locally for Development

```bash
export FLASK_ENV=development
python website.py
```

Or use the environment variables:
```bash
export DEBUG=True
export SECRET_KEY=dev-key-not-for-production
python website.py
```

## Troubleshooting

### Database Connection Issues
- Check `DATABASE_URL` format
- Verify database credentials
- Ensure database server is running

### Import Errors
- Verify all dependencies in `requirements.txt` are installed
- Check Python version compatibility (3.11+ recommended)

### File Upload Issues
- Check folder permissions for `static/uploads/`
- Verify `STUDENT_HUB_MAX_FILE_SIZE` setting

## Support

For issues or questions, check:
- Application logs
- Database logs
- Gunicorn/WSGI server logs
