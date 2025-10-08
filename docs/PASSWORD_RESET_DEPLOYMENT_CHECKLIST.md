# ✅ Password Reset - Deployment Checklist

Quick checklist to ensure your password reset system is deployed correctly.

---

## 📋 Pre-Deployment Checklist

### 1. Dependencies Installed ☐

```bash
pip install -r requirements.txt
```

**Verify:**
- [ ] `Flask-Mail==0.9.1` installed
- [ ] `itsdangerous==2.1.2` installed

```bash
# Check installed packages
pip list | grep -i flask-mail
pip list | grep -i itsdangerous
```

---

### 2. Database Migration Complete ☐

**Choose ONE method:**

**Method A: Flask-Migrate (Recommended)**
```bash
flask db migrate -m "Add password reset fields to User model"
flask db upgrade
```

**Method B: Manual Script**
```bash
python3 create_password_reset_migration.py
```

**Method C: Direct SQL**
```sql
-- PostgreSQL
ALTER TABLE "user" ADD COLUMN reset_token VARCHAR(200);
ALTER TABLE "user" ADD COLUMN reset_token_expiry TIMESTAMP;

-- SQLite
ALTER TABLE user ADD COLUMN reset_token VARCHAR(200);
ALTER TABLE user ADD COLUMN reset_token_expiry TIMESTAMP;
```

**Verify:**
- [ ] Migration ran without errors
- [ ] `reset_token` column exists in User table
- [ ] `reset_token_expiry` column exists in User table

```bash
# Verify columns exist (PostgreSQL)
psql -d your_database -c "\d user"

# Verify columns exist (SQLite)
sqlite3 site.db ".schema user"
```

---

### 3. Email Configuration Set ☐

**Add to `.env` file:**

```env
# Gmail (Development)
MAIL_SERVER=smtp.gmail.com
MAIL_PORT=587
MAIL_USE_TLS=True
MAIL_USE_SSL=False
MAIL_USERNAME=your-email@gmail.com
MAIL_PASSWORD=your-gmail-app-password
MAIL_DEFAULT_SENDER=noreply@albaqiacademy.com
```

**Gmail App Password Setup:**
1. [ ] Go to https://myaccount.google.com/apppasswords
2. [ ] Enable 2-Factor Authentication if not enabled
3. [ ] Generate App Password for "Mail"
4. [ ] Copy 16-character password (remove spaces)
5. [ ] Add to `.env` as `MAIL_PASSWORD`

**Verify:**
- [ ] `.env` file exists
- [ ] `MAIL_SERVER` is set
- [ ] `MAIL_USERNAME` is set
- [ ] `MAIL_PASSWORD` is set (App Password, not regular password)
- [ ] `MAIL_DEFAULT_SENDER` is set

---

### 4. Code Verification ☐

**Check routes exist:**
```bash
grep -n "forgot-password" website.py
grep -n "reset-password" website.py
```

**Verify:**
- [ ] `/forgot-password` route exists in website.py
- [ ] `/reset-password/<token>` route exists in website.py
- [ ] Flask-Mail imported: `from flask_mail import Mail, Message`
- [ ] itsdangerous imported: `from itsdangerous import URLSafeTimedSerializer`
- [ ] `mail = Mail(app)` initialized
- [ ] `serializer = URLSafeTimedSerializer(...)` initialized

---

### 5. Templates Exist ☐

```bash
ls -la templates/forgot_password.html
ls -la templates/reset_password.html
```

**Verify:**
- [ ] `templates/forgot_password.html` exists
- [ ] `templates/reset_password.html` exists
- [ ] `templates/log_in.html` has "Forgot password?" link

---

## 🧪 Testing Checklist

### Test 1: Basic Flow ☐

1. [ ] Start server: `python3 website.py`
2. [ ] Visit http://localhost:5005/login
3. [ ] Click "Forgot password?" link
4. [ ] Should see email input form

### Test 2: Email Sending ☐

1. [ ] Enter valid user email address
2. [ ] Click "Send Reset Link"
3. [ ] Should see success message
4. [ ] Check email inbox (may take 1-2 minutes)
5. [ ] Email should arrive with reset link

**If email doesn't arrive:**
- [ ] Check spam/junk folder
- [ ] Check Flask console for errors
- [ ] Verify email credentials in `.env`
- [ ] Test with different email address

### Test 3: Password Reset ☐

1. [ ] Click reset link in email
2. [ ] Should see password reset form
3. [ ] Enter new password (min 6 characters)
4. [ ] Confirm new password
5. [ ] Should see password strength indicator
6. [ ] Submit form
7. [ ] Should see success message
8. [ ] Redirected to login page

### Test 4: Login with New Password ☐

1. [ ] Enter username
2. [ ] Enter NEW password
3. [ ] Should successfully log in
4. [ ] Should see dashboard/home page

### Test 5: Security Tests ☐

**Token Expiry:**
1. [ ] Request reset link
2. [ ] Wait 1+ hour
3. [ ] Try to use link
4. [ ] Should see "expired" error

**Token Reuse:**
1. [ ] Request reset link
2. [ ] Use link once successfully
3. [ ] Try to use same link again
4. [ ] Should see "already used" error

**Invalid Token:**
1. [ ] Manually modify token in URL
2. [ ] Try to access
3. [ ] Should see "invalid" error

**Email Enumeration:**
1. [ ] Request reset for non-existent email
2. [ ] Should see same success message (no "email not found")

**Password Validation:**
1. [ ] Try password under 6 characters
2. [ ] Should see error
3. [ ] Try mismatched passwords
4. [ ] Should see error

---

## 🚀 Production Deployment Checklist

### Pre-Production ☐

- [ ] All tests passed in development
- [ ] Database migration tested
- [ ] Email sending tested
- [ ] Security tests passed

### Production Email Setup ☐

**Option A: SendGrid (Recommended)**
```env
MAIL_SERVER=smtp.sendgrid.net
MAIL_PORT=587
MAIL_USE_TLS=True
MAIL_USERNAME=apikey
MAIL_PASSWORD=your-sendgrid-api-key
MAIL_DEFAULT_SENDER=noreply@yourdomain.com
```

1. [ ] Sign up at https://sendgrid.com
2. [ ] Verify your domain
3. [ ] Create API key
4. [ ] Update production `.env`
5. [ ] Test email delivery

**Option B: Mailgun**
1. [ ] Sign up at https://mailgun.com
2. [ ] Verify your domain
3. [ ] Get SMTP credentials
4. [ ] Update production `.env`
5. [ ] Test email delivery

### Production Database ☐

1. [ ] Backup database before migration
2. [ ] Run migration on production:
   ```bash
   flask db upgrade
   ```
3. [ ] Verify columns added:
   ```sql
   SELECT column_name FROM information_schema.columns
   WHERE table_name = 'user';
   ```

### Production Environment ☐

- [ ] `SECRET_KEY` is strong and unique (not default)
- [ ] `SESSION_COOKIE_SECURE=True` (HTTPS only)
- [ ] `MAIL_DEFAULT_SENDER` uses your domain
- [ ] Production email service configured
- [ ] HTTPS enabled on server
- [ ] Email deliverability tested

### Monitoring Setup ☐

- [ ] Email delivery monitoring enabled
- [ ] Error logging configured
- [ ] Password reset usage tracked
- [ ] Failed token attempts logged

### Documentation ☐

- [ ] User guide created/updated
- [ ] Support team trained
- [ ] Troubleshooting guide available
- [ ] Email templates reviewed

---

## 📊 Post-Deployment Verification

### Day 1 ☐
- [ ] Monitor first password resets
- [ ] Check email delivery success rate
- [ ] Verify no errors in logs
- [ ] Test flow from production URL

### Week 1 ☐
- [ ] Review password reset usage metrics
- [ ] Check for any failed token attempts
- [ ] Verify email deliverability (not in spam)
- [ ] Gather user feedback

### Month 1 ☐
- [ ] Analyze password reset patterns
- [ ] Review security logs
- [ ] Optimize email templates if needed
- [ ] Consider adding rate limiting

---

## 🐛 Common Issues & Quick Fixes

### Issue: Migration fails
**Fix:**
```bash
# Use manual migration script
python3 create_password_reset_migration.py
```

### Issue: Email not sending
**Fix:**
```bash
# Test email configuration
python3 -c "
from website import mail, Message
msg = Message('Test', recipients=['your-email@example.com'])
msg.body = 'Test email'
mail.send(msg)
"
```

### Issue: Gmail authentication error
**Fix:**
1. Enable 2FA on Google account
2. Generate new App Password
3. Use App Password (not regular password)

### Issue: Token expired immediately
**Fix:**
```python
# Check server timezone
import datetime
print(datetime.datetime.now(datetime.timezone.utc))

# Should show UTC time
```

---

## ✅ Final Sign-Off

**Development Environment:**
- [ ] All dependencies installed
- [ ] Database migration complete
- [ ] Email sending tested
- [ ] All tests passed
- [ ] Documentation reviewed

**Production Environment:**
- [ ] Production email service configured
- [ ] Database migration complete on production
- [ ] HTTPS enabled
- [ ] Security settings verified
- [ ] Monitoring enabled

**Team Readiness:**
- [ ] Support team trained
- [ ] User documentation available
- [ ] Troubleshooting guide ready
- [ ] Escalation process defined

---

## 🎉 Deployment Complete!

Once all checkboxes are ✅, your password reset system is **ready for production**!

**Next Steps:**
1. Monitor first password resets
2. Gather user feedback
3. Optimize as needed
4. Consider advanced features (rate limiting, 2FA, etc.)

---

**Deployment Date:** __________
**Deployed By:** __________
**Environment:** ☐ Development  ☐ Staging  ☐ Production

**Sign-off:**
- Developer: __________ Date: __________
- QA: __________ Date: __________
- Product Owner: __________ Date: __________

---

**Questions?** See:
- Quick Start: [PASSWORD_RESET_QUICKSTART.md](PASSWORD_RESET_QUICKSTART.md)
- Full Guide: [PASSWORD_RESET_IMPLEMENTATION.md](PASSWORD_RESET_IMPLEMENTATION.md)
- Summary: [PASSWORD_RESET_SUMMARY.md](PASSWORD_RESET_SUMMARY.md)
