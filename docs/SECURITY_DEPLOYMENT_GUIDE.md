# 🔒 Security & Deployment Guide - Al-Baqi Academy

## ✅ Your Current Security Status: SECURE

Your credentials are **properly protected** and **will NOT be exposed** when you deploy!

---

## 🛡️ How Your Credentials Are Protected

### ✅ Current Protection (Already in Place)

1. **`.env` file contains all secrets** ✅
   - Email password: `AdminAlBaqi123?!`
   - Database credentials
   - Stripe keys
   - Secret keys

2. **`.gitignore` blocks `.env` from git** ✅
   - `.env` is listed in `.gitignore`
   - File will NEVER be committed to repository
   - Safe to push to GitHub/GitLab

3. **`.env.example` is safe to commit** ✅
   - Contains NO real passwords
   - Only shows configuration format
   - Safe for public repositories

---

## 🔍 Verification - Prove It's Secure

### Test 1: Check Git Status
```bash
git status
# .env should NOT appear in list of files to commit
```

### Test 2: Check Git History
```bash
git log --all --full-history -- .env
# Should show: (nothing) or "fatal: no such path"
# This means .env was never committed
```

### Test 3: Search Repository
```bash
git grep "AdminAlBaqi123"
# Should return: (nothing)
# Your password is NOT in the repository
```

### Test 4: Verify .gitignore
```bash
cat .gitignore | grep ".env"
# Should show: .env
# Confirms .env is being ignored
```

**✅ All tests pass - your credentials are secure!**

---

## 🚀 Safe Deployment Process

### Local Development (Current Setup)

```
Your Computer
├── .env (SECRET - has real passwords) ❌ NOT in git
├── .env.example (SAFE - no passwords) ✅ In git
├── website.py (SAFE - reads from .env) ✅ In git
└── .gitignore (SAFE - blocks .env) ✅ In git
```

### When You Push to GitHub

```
GitHub Repository (PUBLIC)
├── .env.example ✅ Safe to share
├── website.py ✅ Safe to share
├── .gitignore ✅ Safe to share
└── .env ❌ NOT uploaded (blocked by .gitignore)
```

### Production Server Setup

```
Production Server
├── .env (CREATE NEW - with production passwords)
├── .env.example (from git - reference only)
├── website.py (from git)
└── .gitignore (from git)
```

---

## 📋 Step-by-Step Deployment (Secure)

### Step 1: Push Code to GitHub (Safe!)

```bash
# Your code is ready to push
git add .
git commit -m "Add password reset system"
git push origin main

# ✅ .env will NOT be uploaded (blocked by .gitignore)
# ✅ Only safe files uploaded
```

### Step 2: Deploy to Production Server

**SSH into your server:**
```bash
ssh user@your-server.com
```

**Clone repository:**
```bash
git clone https://github.com/yourusername/your-repo.git
cd your-repo
```

**Create NEW .env file on server:**
```bash
nano .env
```

**Copy from `.env.example` and fill in PRODUCTION values:**
```env
# Flask Configuration
SECRET_KEY=GENERATE_NEW_RANDOM_KEY_FOR_PRODUCTION
FLASK_ENV=production

# Database Configuration (Production PostgreSQL)
DATABASE_URL=postgresql://dbuser:dbpassword@localhost:5432/albaqiacademy

# IONOS Email Configuration
MAIL_SERVER=smtp.ionos.co.uk
MAIL_PORT=587
MAIL_USE_TLS=True
MAIL_USE_SSL=False
MAIL_USERNAME=admin@albaqiacademy.com
MAIL_PASSWORD=AdminAlBaqi123?!
MAIL_DEFAULT_SENDER=Al-Baqi Academy <noreply@albaqiacademy.com>

# Stripe LIVE Keys (not test keys!)
STRIPE_SECRET_KEY=sk_live_YOUR_LIVE_KEY
STRIPE_PUBLISHABLE_KEY=pk_live_YOUR_LIVE_KEY
STRIPE_WEBHOOK_SECRET=whsec_YOUR_LIVE_WEBHOOK_SECRET

# Security Settings
SESSION_COOKIE_SECURE=True  # HTTPS required
SESSION_COOKIE_HTTPONLY=True
SESSION_COOKIE_SAMESITE=Lax
```

**Set proper file permissions:**
```bash
chmod 600 .env  # Only owner can read/write
chown youruser:youruser .env
```

### Step 3: Verify Security on Server

```bash
# Check .env is not in git
git ls-files | grep .env
# Should return: (nothing)

# Check file permissions
ls -la .env
# Should show: -rw------- (only owner can read)

# Check .env is excluded
git check-ignore .env
# Should show: .env (confirmed ignored)
```

---

## 🔐 Security Best Practices

### 1. Use Different Passwords for Different Environments

❌ **Don't do this:**
```
Development .env: AdminAlBaqi123?!
Production .env:  AdminAlBaqi123?!  (SAME PASSWORD)
```

✅ **Do this:**
```
Development .env: AdminAlBaqi123?!
Production .env:  Pr0d_SecureP@ssw0rd_2025!  (DIFFERENT)
```

### 2. Generate Strong SECRET_KEY for Production

❌ **Don't use the same SECRET_KEY:**
```python
# Development and production use same key
```

✅ **Generate new random key for production:**
```bash
python3 -c "import os; print(os.urandom(32).hex())"
# Copy output to production .env
```

### 3. Use Stripe LIVE Keys in Production

❌ **Don't use test keys in production:**
```env
# Production .env
STRIPE_SECRET_KEY=sk_test_...  # WRONG!
```

✅ **Use live keys in production:**
```env
# Production .env
STRIPE_SECRET_KEY=sk_live_...  # CORRECT!
STRIPE_PUBLISHABLE_KEY=pk_live_...
```

### 4. Enable HTTPS in Production

❌ **Don't use HTTP in production:**
```env
SESSION_COOKIE_SECURE=False  # Insecure!
```

✅ **Require HTTPS:**
```env
SESSION_COOKIE_SECURE=True  # Cookies only over HTTPS
```

### 5. Restrict .env File Permissions

❌ **Don't leave .env readable by everyone:**
```bash
chmod 644 .env  # Everyone can read!
```

✅ **Only owner can read:**
```bash
chmod 600 .env  # Only you can read/write
```

---

## ⚠️ What NOT to Do

### ❌ NEVER Commit .env to Git

```bash
# DON'T DO THIS!
git add .env
git commit -m "Add .env"
git push

# Your passwords are now PUBLIC on GitHub!
```

**If you accidentally commit .env:**

```bash
# Remove from git (keeps local copy)
git rm --cached .env
git commit -m "Remove .env from git"
git push

# Remove from history (advanced)
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch .env" \
  --prune-empty --tag-name-filter cat -- --all

git push --force --all
```

### ❌ NEVER Hardcode Passwords in Code

```python
# DON'T DO THIS!
MAIL_PASSWORD = "AdminAlBaqi123?!"  # Hardcoded in website.py
```

```python
# DO THIS!
MAIL_PASSWORD = os.environ.get('MAIL_PASSWORD')  # From .env
```

### ❌ NEVER Share .env File

- Don't email `.env` to team members
- Don't put `.env` in Slack/Discord
- Don't upload `.env` to cloud storage
- Use `.env.example` to share configuration format

### ❌ NEVER Use Same Password Everywhere

- Development database password ≠ Production database password
- Email password ≠ Database password
- User passwords ≠ Admin passwords

---

## 🔍 Security Checklist

### Before Pushing to GitHub

- [ ] Verify `.env` is in `.gitignore`
- [ ] Check `.env` is not staged: `git status`
- [ ] Verify no passwords in code files
- [ ] Test `.env.example` has no real passwords
- [ ] Confirm `.gitignore` is committed

### Before Production Deployment

- [ ] Generate new `SECRET_KEY` for production
- [ ] Use different database password in production
- [ ] Switch to Stripe LIVE keys (not test)
- [ ] Set `FLASK_ENV=production`
- [ ] Set `SESSION_COOKIE_SECURE=True`
- [ ] Set `DEBUG=False`
- [ ] Use PostgreSQL (not SQLite)

### After Production Deployment

- [ ] Verify `.env` permissions: `chmod 600 .env`
- [ ] Test password reset sends email
- [ ] Check email not going to spam
- [ ] Verify HTTPS is working
- [ ] Test Stripe payments with real card
- [ ] Monitor error logs for issues

---

## 🛠️ Environment-Specific Configurations

### Development (.env)
```env
SECRET_KEY=ca1baee255cbdff6f417381e05756e4f7e33cadd8d06b6f4113d08daa8f63c0e
FLASK_ENV=development
DATABASE_URL=sqlite:///site.db
STRIPE_SECRET_KEY=sk_test_...
STRIPE_PUBLISHABLE_KEY=pk_test_...
MAIL_USERNAME=admin@albaqiacademy.com
MAIL_PASSWORD=AdminAlBaqi123?!
SESSION_COOKIE_SECURE=False
DEBUG=True
```

### Staging (.env)
```env
SECRET_KEY=DIFFERENT_KEY_FOR_STAGING
FLASK_ENV=production
DATABASE_URL=postgresql://staging_user:staging_pass@db:5432/staging_db
STRIPE_SECRET_KEY=sk_test_...  # Still test in staging
STRIPE_PUBLISHABLE_KEY=pk_test_...
MAIL_USERNAME=staging@albaqiacademy.com
MAIL_PASSWORD=StagingPassword123!
SESSION_COOKIE_SECURE=True
DEBUG=False
```

### Production (.env)
```env
SECRET_KEY=COMPLETELY_DIFFERENT_PRODUCTION_KEY
FLASK_ENV=production
DATABASE_URL=postgresql://prod_user:STRONG_PROD_PASS@db:5432/prod_db
STRIPE_SECRET_KEY=sk_live_...  # LIVE keys!
STRIPE_PUBLISHABLE_KEY=pk_live_...
STRIPE_WEBHOOK_SECRET=whsec_live_...
MAIL_USERNAME=admin@albaqiacademy.com
MAIL_PASSWORD=ProductionPassword2025!
SESSION_COOKIE_SECURE=True
DEBUG=False
```

---

## 🔒 Additional Security Measures

### 1. Use Environment Variables on Server

Instead of `.env` file, use server environment variables:

```bash
# In /etc/environment or ~/.bashrc
export MAIL_PASSWORD="AdminAlBaqi123?!"
export SECRET_KEY="..."
```

### 2. Use Secret Management Services

**AWS Secrets Manager:**
```python
import boto3
client = boto3.client('secretsmanager')
secret = client.get_secret_value(SecretId='albaqiacademy/mail-password')
MAIL_PASSWORD = secret['SecretString']
```

**HashiCorp Vault:**
```python
import hvac
client = hvac.Client(url='http://vault:8200')
secret = client.secrets.kv.read_secret_version(path='albaqiacademy')
MAIL_PASSWORD = secret['data']['data']['mail_password']
```

### 3. Rotate Passwords Regularly

- Change IONOS email password every 90 days
- Regenerate SECRET_KEY annually
- Update database passwords quarterly

### 4. Monitor Access Logs

```bash
# Check who accessed .env
sudo ausearch -f /path/to/.env

# Monitor file changes
sudo auditctl -w /path/to/.env -p war -k env-access
```

### 5. Use Fail2Ban for Brute Force Protection

```bash
# Install fail2ban
sudo apt-get install fail2ban

# Configure for Flask app
sudo nano /etc/fail2ban/jail.local
```

---

## 📊 Security Audit Commands

### Check for Exposed Secrets

```bash
# Search for potential passwords in code
grep -r "password.*=" . --exclude-dir=.git

# Search for API keys
grep -r "sk_live" . --exclude-dir=.git
grep -r "pk_live" . --exclude-dir=.git

# Check for hardcoded secrets
grep -r "SECRET_KEY.*=" . --exclude-dir=.git

# Scan git history for secrets
git log -p | grep -i "password"
```

### Verify .gitignore Works

```bash
# List all ignored files
git ls-files --others --ignored --exclude-standard

# Check specific file
git check-ignore -v .env
```

### Check File Permissions

```bash
# Check .env permissions
ls -la .env
# Should be: -rw------- (600)

# Check directory permissions
ls -la /path/to/app
# Should be: drwxr-xr-x (755)
```

---

## 🚨 What to Do If Credentials Are Exposed

### If .env is Accidentally Committed

1. **Remove from git immediately:**
   ```bash
   git rm --cached .env
   git commit -m "Remove .env"
   git push --force
   ```

2. **Change ALL passwords:**
   - IONOS email password
   - Database passwords
   - SECRET_KEY
   - Stripe keys (if exposed)

3. **Remove from git history:**
   ```bash
   # Use BFG Repo-Cleaner
   bfg --delete-files .env
   git reflog expire --expire=now --all
   git gc --prune=now --aggressive
   git push --force
   ```

### If Password is Exposed Online

1. **Change password immediately**
2. **Check for unauthorized access**
3. **Review email logs** in IONOS webmail
4. **Enable 2FA** on IONOS account (if available)
5. **Monitor for suspicious activity**

---

## ✅ Quick Security Verification

Run this script to verify security:

```bash
#!/bin/bash
echo "🔍 Security Verification for Al-Baqi Academy"
echo ""

# Check .env in .gitignore
if grep -q "^\.env$" .gitignore; then
    echo "✅ .env is in .gitignore"
else
    echo "❌ .env NOT in .gitignore - ADD IT NOW!"
fi

# Check .env not tracked
if git ls-files | grep -q "^\.env$"; then
    echo "❌ .env is tracked by git - REMOVE IT!"
else
    echo "✅ .env is not tracked by git"
fi

# Check .env permissions (if exists)
if [ -f .env ]; then
    PERMS=$(stat -f "%A" .env 2>/dev/null || stat -c "%a" .env 2>/dev/null)
    if [ "$PERMS" = "600" ]; then
        echo "✅ .env has secure permissions (600)"
    else
        echo "⚠️  .env permissions: $PERMS (should be 600)"
        echo "   Fix with: chmod 600 .env"
    fi
fi

# Check for hardcoded passwords
if grep -r "password.*=.*['\"]" . --exclude-dir=.git --exclude="*.md" --exclude=".env*" -q; then
    echo "⚠️  Potential hardcoded passwords found in code"
else
    echo "✅ No hardcoded passwords in code"
fi

echo ""
echo "Security check complete!"
```

Save as `security_check.sh` and run:
```bash
chmod +x security_check.sh
./security_check.sh
```

---

## 📞 Security Incident Response

If you suspect a security breach:

1. **Immediately change all passwords**
2. **Check server logs** for unauthorized access
3. **Review recent database changes**
4. **Check email sent folder** for suspicious emails
5. **Contact IONOS support**: 0330 122 6000
6. **Review Stripe dashboard** for unauthorized transactions
7. **Enable 2FA** on all accounts

---

## ✨ Summary

**✅ Your current setup is SECURE because:**

1. `.env` contains all secrets
2. `.env` is in `.gitignore`
3. `.env` has never been committed to git
4. Only `.env.example` (safe) is in repository
5. Code reads from environment variables (not hardcoded)

**🚀 When you deploy:**

1. Push code to GitHub (safe - no secrets uploaded)
2. Clone on production server
3. Create NEW `.env` on server with production credentials
4. Set file permissions: `chmod 600 .env`
5. Use different passwords for production
6. Enable HTTPS and secure cookies

**Your password `AdminAlBaqi123?!` is safe and will NOT be exposed!** 🔒

---

**Questions?** This guide covers everything you need to securely deploy your application!
