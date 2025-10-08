# 🚀 Password Reset - Quick Start Guide

Complete password reset setup in **5 minutes**!

---

## ⚡ Quick Setup (3 Steps)

### Step 1: Install Dependencies (30 seconds)

```bash
pip install -r requirements.txt
```

### Step 2: Run Database Migration (30 seconds)

**Option A: Using Flask-Migrate (Recommended)**
```bash
flask db migrate -m "Add password reset fields to User model"
flask db upgrade
```

**Option B: Using Manual Script**
```bash
python3 create_password_reset_migration.py
```

**Option C: Manual SQL (PostgreSQL)**
```sql
ALTER TABLE "user" ADD COLUMN reset_token VARCHAR(200);
ALTER TABLE "user" ADD COLUMN reset_token_expiry TIMESTAMP;
```

### Step 3: Configure Email (2 minutes)

Add to your `.env` file:

**IONOS Email (Recommended for Al-Baqi Academy):**
```env
MAIL_SERVER=smtp.ionos.co.uk
MAIL_PORT=587
MAIL_USE_TLS=True
MAIL_USE_SSL=False
MAIL_USERNAME=your-email@albaqiacademy.com
MAIL_PASSWORD=your-ionos-password
MAIL_DEFAULT_SENDER=Al-Baqi Academy <noreply@albaqiacademy.com>
```

📧 **See [IONOS_EMAIL_SETUP.md](IONOS_EMAIL_SETUP.md) for detailed IONOS configuration**

**Or Gmail (for testing):**
```env
MAIL_SERVER=smtp.gmail.com
MAIL_PORT=587
MAIL_USE_TLS=True
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-gmail-app-password
MAIL_DEFAULT_SENDER=noreply@albaqiacademy.com
```

**🔑 Gmail App Password Setup:**
1. Go to https://myaccount.google.com/apppasswords
2. Sign in to Google
3. Create app password for "Mail"
4. Copy the 16-character password
5. Paste in `MAIL_PASSWORD`

---

## ✅ Test It! (2 minutes)

### 1. Start Server
```bash
python3 website.py
```

### 2. Test Flow
1. Go to http://localhost:5005/login
2. Click **"Forgot password?"**
3. Enter your email address
4. Check your email inbox
5. Click the reset link
6. Enter new password
7. Login with new password

---

## 🎯 What You Get

### Routes Added
- `/forgot-password` - Request password reset
- `/reset-password/<token>` - Set new password

### Templates Added
- `templates/forgot_password.html` - Email entry form
- `templates/reset_password.html` - Password reset form

### Features
✅ Secure token-based authentication
✅ 1-hour token expiry
✅ One-time use tokens
✅ Professional email templates
✅ Password strength indicator
✅ Real-time validation
✅ Bcrypt password hashing
✅ Email enumeration protection

---

## 📧 Email Providers

### Development (Free)
- **Gmail** - 500 emails/day (use App Password)

### Production (Recommended)
- **SendGrid** - 100 emails/day free, then $15/mo
- **Mailgun** - 5,000 emails/month free
- **Amazon SES** - $0.10 per 1,000 emails

### SendGrid Setup (Production)
```env
MAIL_SERVER=smtp.sendgrid.net
MAIL_PORT=587
MAIL_USE_TLS=True
MAIL_USERNAME=apikey
MAIL_PASSWORD=your-sendgrid-api-key
MAIL_DEFAULT_SENDER=noreply@albaqiacademy.com
```

---

## 🐛 Quick Troubleshooting

### Email not sending?
1. Check `.env` has email settings
2. For Gmail: Use App Password (not regular password)
3. Check spam/junk folder
4. Check Flask logs for errors

### Migration failed?
```bash
# Try manual script
python3 create_password_reset_migration.py

# Or add columns manually (see Step 2, Option C)
```

### Token expired error?
- Tokens expire after 1 hour
- Request a new reset link

### Gmail authentication error?
1. Enable 2FA on Google account
2. Generate new App Password
3. Use full email in `MAIL_USERNAME`
4. Use 16-char password in `MAIL_PASSWORD`

---

## 📚 Full Documentation

See [PASSWORD_RESET_IMPLEMENTATION.md](PASSWORD_RESET_IMPLEMENTATION.md) for:
- Complete feature list
- Security details
- Advanced configuration
- Testing guide
- Production checklist

---

## 🎉 That's It!

Your password reset system is ready! Users can now:
1. Click "Forgot password?" on login
2. Receive reset email
3. Set new password
4. Login successfully

**Next:** Configure email and test the flow!

---

**Questions?** Check [PASSWORD_RESET_IMPLEMENTATION.md](PASSWORD_RESET_IMPLEMENTATION.md) for detailed help.
