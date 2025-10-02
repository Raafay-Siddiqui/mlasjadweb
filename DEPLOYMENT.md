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
- [ ] Set `DEBUG=False` in `.env`
- [ ] Enable HTTPS/SSL
- [ ] Set `SESSION_COOKIE_SECURE=True`
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
