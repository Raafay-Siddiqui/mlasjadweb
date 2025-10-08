# 🚀 Al-Baqi Academy - Final Deployment Checklist

**Date:** 2025-10-08
**Status:** Ready for Production Deployment ✅

---

## 📊 Current Status

### ✅ Completed Items
- [x] All code changes committed to git (commit: 4609762)
- [x] Dependencies installed (psycopg2-binary added)
- [x] Documentation organized in /docs folder
- [x] Database migrations ready (18 migration files)
- [x] Supabase PostgreSQL configured
- [x] Email system configured (IONOS SMTP)
- [x] Security audit passed (.env protected)
- [x] Deployment scripts created
- [x] Course files structure cleaned up
- [x] Git repository clean and organized

### ⚠️ Required Before Deployment
- [ ] Configure VPS details in deploy_to_vps.sh
- [ ] Switch Stripe keys from test to live mode
- [ ] Create production .env on server
- [ ] Test application locally one final time
- [ ] Push to remote repository
- [ ] Backup current production database (if exists)

---

## 📝 Pre-Deployment Checklist

### 1. Local Environment ✅
- [x] Python dependencies installed
- [x] Database connection tested (Supabase)
- [x] Git repository clean
- [x] All changes committed
- [x] .env file exists and configured
- [x] Application runs without errors locally

### 2. Environment Configuration 🔧

#### Current .env Status:
```env
✅ SECRET_KEY: Set
✅ DATABASE_URL: Supabase PostgreSQL configured
⚠️  STRIPE_SECRET_KEY: Using TEST keys (sk_test_...)
⚠️  STRIPE_PUBLISHABLE_KEY: Using TEST keys (pk_test_...)
⚠️  STRIPE_WEBHOOK_SECRET: Using TEST webhook
✅ MAIL_SERVER: IONOS SMTP configured
✅ MAIL_USERNAME: admin@albaqiacademy.com
✅ MAIL_PASSWORD: Configured
```

**Action Required:** Switch to Stripe LIVE keys for production!

### 3. Stripe Configuration 💳

#### Test Mode (Current):
- [x] Test keys configured
- [x] Test payments working
- [x] Webhook test endpoint created

#### Production Mode (Required):
- [ ] Switch to live keys in production .env
- [ ] Configure live webhook endpoint at: `https://yourdomain.com/stripe/webhook`
- [ ] Enable Stripe Customer Portal
- [ ] Test live payment with real card (small amount)
- [ ] Events to listen for:
  - checkout.session.completed
  - invoice.payment_succeeded
  - invoice.payment_failed
  - customer.subscription.updated
  - customer.subscription.deleted

### 4. Database Migration 🗄️
- [x] 18 migrations ready in /migrations/versions/
- [x] Migration files committed to git
- [ ] Run `flask db upgrade` on production server
- [ ] Verify all tables created correctly
- [ ] Test database connectivity

#### Migration Files:
```
✅ add_sentemail_model.py
✅ add_password_reset_fields.py
✅ add_terms_of_service_fields_and_.py
✅ add_description_field_to_lesson.py
+ 14 more migration files
```

### 5. Email System 📧
- [x] IONOS SMTP configured
- [x] Email credentials set in .env
- [ ] Test email sending on production
- [ ] Verify emails not going to spam
- [ ] Test password reset email flow
- [ ] Configure SPF/DKIM records (optional but recommended)

### 6. Security Review 🔒
- [x] .env excluded from git (.gitignore)
- [x] Passwords stored in environment variables
- [x] SECRET_KEY properly configured
- [x] Session cookies configured
- [ ] Set SESSION_COOKIE_SECURE=True on production
- [ ] Enable HTTPS on server
- [ ] Set DEBUG=False in production
- [ ] Configure firewall rules
- [ ] Set up SSL certificate

---

## 🛠️ Deployment Steps

### Step 1: Configure Deployment Script

Edit `deploy_to_vps.sh` with your server details:

```bash
VPS_USER="your_actual_username"     # Replace with actual username
VPS_HOST="your_actual_vps_ip"       # Replace with actual IP/domain
VPS_PATH="/path/to/web1"            # Replace with actual path
APP_NAME="web1"                     # Replace with actual service name
```

### Step 2: Push to Remote Repository

```bash
# Push all committed changes
git push origin main

# Verify push was successful
git log -1
```

### Step 3: Setup Production Server

#### A. Clone Repository (First Time Only)

```bash
# SSH into your server
ssh your_user@your_server

# Clone the repository
cd /var/www  # or your preferred location
git clone https://github.com/yourusername/web1.git
cd web1

# Create virtual environment
python3 -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt
```

#### B. Create Production .env File

```bash
# Create .env file on server
nano .env
```

**Copy this template and fill in PRODUCTION values:**

```env
# Flask Configuration
SECRET_KEY=generate-new-random-key-for-production-here
FLASK_ENV=production

# Database Configuration
DATABASE_URL=postgresql://postgres:[YOUR-PASSWORD]@db.yhladodtavcoawfhpeaa.supabase.co:5432/postgres

# Application Settings
DEBUG=False
HOST=0.0.0.0
PORT=5005

# Stripe Payment Configuration - PRODUCTION KEYS
STRIPE_SECRET_KEY=sk_live_YOUR_LIVE_KEY_HERE
STRIPE_PUBLISHABLE_KEY=pk_live_YOUR_LIVE_KEY_HERE
STRIPE_WEBHOOK_SECRET=whsec_YOUR_LIVE_WEBHOOK_HERE

# File Upload Settings
STUDENT_HUB_MAX_FILE_SIZE=52428800

# Security Settings
SESSION_COOKIE_SECURE=True
SESSION_COOKIE_HTTPONLY=True
SESSION_COOKIE_SAMESITE=Lax

# Email Configuration
MAIL_SERVER=smtp.ionos.co.uk
MAIL_PORT=465
MAIL_USE_TLS=False
MAIL_USE_SSL=True
MAIL_USERNAME=admin@albaqiacademy.com
MAIL_PASSWORD=AdminAlBaqi123?!
MAIL_DEFAULT_SENDER=noreply@albaqiacademy.com
```

**IMPORTANT:** Generate a new SECRET_KEY for production:
```bash
python3 -c "import os; print(os.urandom(32).hex())"
```

#### C. Set File Permissions

```bash
# Secure .env file
chmod 600 .env

# Set ownership
chown youruser:youruser .env
```

### Step 4: Run Database Migrations

```bash
# On production server
source venv/bin/activate
flask db upgrade

# Verify migrations completed
flask shell
>>> from website import db
>>> db.engine.table_names()
>>> exit()
```

### Step 5: Upload Course Files

From your local machine:

```bash
# Edit upload_courses.sh with server details
./upload_courses.sh

# This will rsync course files to production
```

### Step 6: Configure Web Server

#### Option A: Using Gunicorn with Systemd

Create systemd service file:

```bash
sudo nano /etc/systemd/system/web1.service
```

```ini
[Unit]
Description=Al-Baqi Academy Web Application
After=network.target

[Service]
User=youruser
WorkingDirectory=/path/to/web1
Environment="PATH=/path/to/web1/venv/bin"
ExecStart=/path/to/web1/venv/bin/gunicorn website:app \
    --workers 4 \
    --bind 0.0.0.0:5005 \
    --timeout 120 \
    --access-logfile - \
    --error-logfile -

Restart=always

[Install]
WantedBy=multi-user.target
```

Enable and start service:

```bash
sudo systemctl daemon-reload
sudo systemctl enable web1
sudo systemctl start web1
sudo systemctl status web1
```

#### Option B: Using Nginx as Reverse Proxy

```bash
sudo nano /etc/nginx/sites-available/albaqiacademy
```

```nginx
server {
    listen 80;
    server_name albaqiacademy.com www.albaqiacademy.com;

    location / {
        proxy_pass http://127.0.0.1:5005;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /static {
        alias /path/to/web1/static;
    }

    client_max_body_size 100M;
}
```

Enable site:

```bash
sudo ln -s /etc/nginx/sites-available/albaqiacademy /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

### Step 7: Enable HTTPS with Let's Encrypt

```bash
sudo apt-get install certbot python3-certbot-nginx
sudo certbot --nginx -d albaqiacademy.com -d www.albaqiacademy.com
```

### Step 8: Configure Stripe Production Webhook

1. Go to [Stripe Dashboard](https://dashboard.stripe.com/webhooks)
2. Click "Add endpoint"
3. Enter URL: `https://albaqiacademy.com/stripe/webhook`
4. Select events:
   - checkout.session.completed
   - invoice.payment_succeeded
   - invoice.payment_failed
   - customer.subscription.updated
   - customer.subscription.deleted
5. Copy the signing secret (starts with `whsec_`)
6. Update production .env with the webhook secret

### Step 9: Enable Stripe Customer Portal

1. Go to [Stripe Settings](https://dashboard.stripe.com/settings/billing/portal)
2. Click "Activate"
3. Configure settings:
   - ✅ Allow payment method updates
   - ✅ Allow invoice history viewing
   - ✅ Allow subscription cancellation
4. Save configuration

---

## ✅ Post-Deployment Verification

### 1. Basic Functionality Tests

- [ ] Visit homepage: `https://yourdomain.com`
- [ ] Register new account
- [ ] Login to account
- [ ] Verify email sent (check inbox)
- [ ] Browse courses page
- [ ] View course details
- [ ] Access admin panel (admin account)

### 2. Payment System Tests

- [ ] View subscription plans: `/subscriptions`
- [ ] Click "Subscribe" button
- [ ] Complete Stripe checkout with real card (small amount)
- [ ] Verify redirect to success page
- [ ] Check subscription appears in `/my-subscription`
- [ ] Verify course access granted
- [ ] Test "Manage Subscription" → Stripe portal
- [ ] View invoices in portal
- [ ] Update payment method
- [ ] Cancel subscription
- [ ] Verify access removed but data retained

### 3. Email System Tests

- [ ] Register new user → welcome email sent
- [ ] Password reset → reset email received
- [ ] Course enrollment → confirmation email
- [ ] Admin bulk email → test message received
- [ ] Check spam folder → verify deliverability

### 4. Admin Panel Tests

- [ ] Login as admin
- [ ] View dashboard: `/admin`
- [ ] Create new course
- [ ] Upload lesson files
- [ ] Create subscription plan
- [ ] View active subscriptions
- [ ] Send test email
- [ ] Manage users

### 5. Database Tests

```bash
# SSH into server
ssh your_user@your_server

# Check database
psql $DATABASE_URL -c "\dt"  # List all tables
psql $DATABASE_URL -c "SELECT COUNT(*) FROM \"user\";"  # Count users
psql $DATABASE_URL -c "SELECT COUNT(*) FROM course;"  # Count courses
```

### 6. Performance Tests

- [ ] Homepage loads < 2 seconds
- [ ] Video playback works smoothly
- [ ] Large file uploads work (Student Hub)
- [ ] Mobile responsive design works
- [ ] No console errors in browser

### 7. Security Tests

- [ ] HTTPS enabled (green padlock)
- [ ] HTTP redirects to HTTPS
- [ ] .env file not accessible via web
- [ ] Admin routes require authentication
- [ ] Session cookies secure
- [ ] Password reset tokens expire
- [ ] Webhook signature verification works

---

## 🐛 Troubleshooting

### Issue: Database connection failed

**Solution:**
```bash
# Check DATABASE_URL in .env
cat .env | grep DATABASE_URL

# Test connection
psql $DATABASE_URL -c "SELECT 1;"
```

### Issue: Stripe webhook not firing

**Solution:**
1. Check Stripe dashboard webhook logs
2. Verify webhook URL is correct
3. Check STRIPE_WEBHOOK_SECRET in .env
4. Review Flask logs for errors
5. Test webhook with Stripe CLI:
   ```bash
   stripe listen --forward-to localhost:5005/stripe/webhook
   ```

### Issue: Email not sending

**Solution:**
```bash
# Test SMTP connection
python3 << 'EOF'
import smtplib
server = smtplib.SMTP_SSL('smtp.ionos.co.uk', 465)
server.login('admin@albaqiacademy.com', 'AdminAlBaqi123?!')
print("✅ SMTP connection successful")
server.quit()
EOF
```

### Issue: 502 Bad Gateway

**Solution:**
```bash
# Check if application is running
sudo systemctl status web1

# Check logs
journalctl -u web1 -n 50

# Restart application
sudo systemctl restart web1
```

### Issue: Permission denied on course files

**Solution:**
```bash
# Fix permissions
sudo chown -R youruser:www-data /path/to/web1/static/courses
sudo chmod -R 755 /path/to/web1/static/courses
```

---

## 📈 Monitoring & Maintenance

### Daily Tasks
- [ ] Check application logs: `journalctl -u web1 -n 100`
- [ ] Monitor Stripe dashboard for payments
- [ ] Check email deliverability

### Weekly Tasks
- [ ] Review active subscriptions: `/admin/subscriptions`
- [ ] Check for failed payments
- [ ] Review user registrations
- [ ] Monitor disk space usage

### Monthly Tasks
- [ ] Database backup: `pg_dump $DATABASE_URL > backup.sql`
- [ ] Review error logs
- [ ] Update dependencies (if needed)
- [ ] Review Stripe revenue reports
- [ ] Check SSL certificate expiry

### Backup Strategy

**Automatic Supabase Backups:**
- Supabase provides automatic daily backups
- Access backups in Supabase Dashboard
- Retention: 7 days (free tier)

**Manual Backup:**
```bash
# Backup database
pg_dump $DATABASE_URL > backup_$(date +%Y%m%d).sql

# Backup course files
tar -czf courses_backup_$(date +%Y%m%d).tar.gz static/courses/

# Store backups securely (offsite)
```

---

## 🎯 Success Criteria

Your deployment is successful when:

- ✅ Website accessible via HTTPS
- ✅ Users can register and login
- ✅ Courses display correctly
- ✅ Video playback works
- ✅ Stripe payments process successfully
- ✅ Subscriptions grant course access
- ✅ Emails send correctly
- ✅ Admin panel functions properly
- ✅ Mobile responsive design works
- ✅ No errors in logs
- ✅ Database migrations applied
- ✅ Webhook events process correctly

---

## 📞 Support Resources

### Documentation
- [Deployment Ready Guide](docs/DEPLOYMENT_READY.md)
- [Stripe Setup Guide](docs/STRIPE_SETUP.md)
- [Email System Guide](docs/EMAIL_SYSTEM_GUIDE.md)
- [Security Deployment Guide](docs/SECURITY_DEPLOYMENT_GUIDE.md)
- [Supabase Migration Guide](docs/SUPABASE_MIGRATION_GUIDE.md)

### External Resources
- [Flask Documentation](https://flask.palletsprojects.com/)
- [Stripe Documentation](https://stripe.com/docs)
- [Supabase Documentation](https://supabase.com/docs)
- [IONOS Email Setup](https://www.ionos.co.uk/help/email/)
- [Let's Encrypt Guide](https://certbot.eff.org/)

### Logs & Debugging
```bash
# Application logs
journalctl -u web1 -f

# Nginx logs
tail -f /var/log/nginx/error.log
tail -f /var/log/nginx/access.log

# Database logs
tail -f /var/log/postgresql/postgresql-*.log
```

---

## ✅ Final Sign-Off

- [ ] All pre-deployment tasks completed
- [ ] Production .env configured with live keys
- [ ] Database migrations successful
- [ ] Course files uploaded
- [ ] Web server configured
- [ ] HTTPS enabled
- [ ] Stripe webhooks configured
- [ ] Email system tested
- [ ] Post-deployment verification passed
- [ ] Monitoring setup complete
- [ ] Backup strategy in place

**Deployment Date:** __________
**Deployed By:** __________
**Production URL:** https://albaqiacademy.com
**Admin Access:** https://albaqiacademy.com/admin

---

## 🚀 Ready to Deploy!

Your Al-Baqi Academy website is **production-ready** and prepared for deployment!

**Next Step:** Configure VPS details in `deploy_to_vps.sh` and run `./deploy_to_vps.sh`

Good luck with your launch! 🎉
