# 📧 IONOS Email Setup Guide - Al-Baqi Academy

Quick guide to configure your IONOS email for password reset functionality.

---

## ✅ IONOS Email Configuration

### Step 1: Add to Your `.env` File

```env
# IONOS Email Configuration
MAIL_SERVER=smtp.ionos.co.uk
MAIL_PORT=587
MAIL_USE_TLS=True
MAIL_USE_SSL=False
MAIL_USERNAME=your-email@albaqiacademy.com
MAIL_PASSWORD=your-ionos-password
MAIL_DEFAULT_SENDER=noreply@albaqiacademy.com
```

**Replace:**
- `your-email@albaqiacademy.com` - Your full IONOS email address
- `your-ionos-password` - Your regular IONOS email password
- `noreply@albaqiacademy.com` - Email address to appear as sender

---

## 🌍 IONOS SMTP Server by Region

### UK/Europe (Most Likely for Al-Baqi Academy)
```env
MAIL_SERVER=smtp.ionos.co.uk
```

### United States
```env
MAIL_SERVER=smtp.ionos.com
```

### Canada
```env
MAIL_SERVER=smtp.ionos.ca
```

### Spain
```env
MAIL_SERVER=smtp.ionos.es
```

### France
```env
MAIL_SERVER=smtp.ionos.fr
```

### Germany
```env
MAIL_SERVER=smtp.ionos.de
```

**Check your IONOS control panel** to confirm your specific server.

---

## 🔧 IONOS Port Options

### Port 587 (Recommended - TLS/STARTTLS)
```env
MAIL_SERVER=smtp.ionos.co.uk
MAIL_PORT=587
MAIL_USE_TLS=True
MAIL_USE_SSL=False
```
✅ **Recommended** - Most compatible, works with most firewalls

### Port 465 (Alternative - SSL)
```env
MAIL_SERVER=smtp.ionos.co.uk
MAIL_PORT=465
MAIL_USE_TLS=False
MAIL_USE_SSL=True
```
Use if port 587 is blocked

### Port 25 (Not Recommended)
❌ Often blocked by ISPs and hosting providers
❌ Not secure without TLS
❌ Avoid unless no other option

---

## 📋 Complete Configuration Example

### For Production (.env file)
```env
# Flask Configuration
SECRET_KEY=your-secret-key-here
FLASK_ENV=production
DATABASE_URL=postgresql://username:password@host:port/database

# IONOS Email Configuration
MAIL_SERVER=smtp.ionos.co.uk
MAIL_PORT=587
MAIL_USE_TLS=True
MAIL_USE_SSL=False
MAIL_USERNAME=admin@albaqiacademy.com
MAIL_PASSWORD=YourIonosPassword123!
MAIL_DEFAULT_SENDER=Al-Baqi Academy <noreply@albaqiacademy.com>

# Stripe Configuration
STRIPE_SECRET_KEY=sk_live_...
STRIPE_PUBLISHABLE_KEY=pk_live_...
STRIPE_WEBHOOK_SECRET=whsec_...
```

---

## ✨ IONOS Email Features

### Advantages
✅ **2GB Storage** - Plenty of space for password reset emails
✅ **No App Password Required** - Use your regular password
✅ **Excellent Deliverability** - Good reputation, especially in UK/EU
✅ **Professional** - Emails from your own domain
✅ **Reliable** - Enterprise-grade email infrastructure
✅ **No Daily Limits** - Unlike Gmail (500/day limit)
✅ **SPAM Protection** - Built-in spam filtering
✅ **SSL/TLS Support** - Secure email transmission

### Specifications
- **Storage:** 2GB mailbox
- **SMTP Authentication:** Required
- **IMAP/POP3:** Supported
- **Webmail:** Available
- **Spam Filter:** Included
- **Virus Scanner:** Included

---

## 🧪 Test Your IONOS Email Configuration

### Method 1: Using Flask Shell

```bash
# Start Flask shell
python3 -c "
from website import app, mail
from flask_mail import Message

with app.app_context():
    msg = Message(
        subject='Test Email - Password Reset System',
        recipients=['your-personal-email@example.com'],  # Your test email
        sender=app.config['MAIL_DEFAULT_SENDER']
    )
    msg.body = '''
This is a test email from Al-Baqi Academy password reset system.

If you received this, your IONOS email configuration is working correctly!

Test Details:
- SMTP Server: smtp.ionos.co.uk
- Port: 587
- TLS: Enabled
- Sender: noreply@albaqiacademy.com

Next Steps:
1. Test password reset flow at /forgot-password
2. Check email deliverability
3. Deploy to production

JazakAllahu Khayran,
Al-Baqi Academy Team
    '''

    try:
        mail.send(msg)
        print('✅ Test email sent successfully!')
        print('Check your inbox (and spam folder)')
    except Exception as e:
        print(f'❌ Error sending email: {e}')
"
```

### Method 2: Quick Python Test

Create a file `test_ionos_email.py`:

```python
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart

# IONOS Configuration
SMTP_SERVER = 'smtp.ionos.co.uk'
SMTP_PORT = 587
EMAIL_ADDRESS = 'your-email@albaqiacademy.com'
EMAIL_PASSWORD = 'your-password'
TO_EMAIL = 'test@example.com'

# Create message
msg = MIMEMultipart()
msg['From'] = EMAIL_ADDRESS
msg['To'] = TO_EMAIL
msg['Subject'] = 'IONOS Test Email'

body = 'This is a test email from IONOS SMTP server.'
msg.attach(MIMEText(body, 'plain'))

# Send email
try:
    server = smtplib.SMTP(SMTP_SERVER, SMTP_PORT)
    server.starttls()
    server.login(EMAIL_ADDRESS, EMAIL_PASSWORD)
    server.send_message(msg)
    server.quit()
    print('✅ Test email sent successfully!')
except Exception as e:
    print(f'❌ Error: {e}')
```

Run it:
```bash
python3 test_ionos_email.py
```

---

## 🔒 IONOS Email Security Best Practices

### 1. Use Strong Password
- Minimum 12 characters
- Mix of uppercase, lowercase, numbers, symbols
- Don't reuse passwords from other services

### 2. Enable Two-Factor Authentication (If Available)
- Check IONOS control panel for 2FA settings
- Adds extra security layer

### 3. Use Dedicated Email for Sending
```env
# Don't use your personal admin email for automated emails
# Create a dedicated email like:
MAIL_USERNAME=noreply@albaqiacademy.com
# or
MAIL_USERNAME=system@albaqiacademy.com
```

### 4. Monitor Email Logs
- Check IONOS webmail sent folder
- Monitor for suspicious activity
- Review bounce/failure emails

### 5. SPF/DKIM/DMARC Records
Ensure these are configured in your domain DNS (usually done automatically by IONOS):

**SPF Record:**
```
v=spf1 include:_spf.ionos.com ~all
```

**DKIM:** Usually auto-configured by IONOS

**DMARC:** Add if not present
```
v=DMARC1; p=quarantine; rua=mailto:postmaster@albaqiacademy.com
```

Check with IONOS support if you need help configuring these.

---

## 🐛 Troubleshooting IONOS Email Issues

### Issue: "Authentication failed"

**Causes:**
- Wrong email address or password
- Email address not fully qualified
- Wrong SMTP server

**Solutions:**
1. Verify email and password in IONOS webmail
2. Use FULL email address: `user@domain.com` (not just `user`)
3. Check SMTP server matches your region
4. Test login at https://mail.ionos.co.uk/

### Issue: "Connection timed out"

**Causes:**
- Firewall blocking port 587
- Wrong SMTP server
- Server/network issues

**Solutions:**
1. Try port 465 with SSL instead:
   ```env
   MAIL_PORT=465
   MAIL_USE_SSL=True
   MAIL_USE_TLS=False
   ```
2. Check firewall/hosting provider allows outbound SMTP
3. Test from command line:
   ```bash
   telnet smtp.ionos.co.uk 587
   # Should connect, press Ctrl+] then type 'quit'
   ```

### Issue: "SSL/TLS handshake failed"

**Causes:**
- Wrong TLS/SSL settings
- Outdated SSL certificates

**Solutions:**
1. Verify TLS/SSL settings match port:
   - Port 587 → `MAIL_USE_TLS=True`, `MAIL_USE_SSL=False`
   - Port 465 → `MAIL_USE_TLS=False`, `MAIL_USE_SSL=True`
2. Update Python SSL certificates:
   ```bash
   pip install --upgrade certifi
   ```

### Issue: "Email sent but not received"

**Causes:**
- Email in spam folder
- SPF/DKIM not configured
- Recipient blocking sender

**Solutions:**
1. Check spam/junk folder
2. Send test to different email providers (Gmail, Outlook, etc.)
3. Verify SPF/DKIM records in DNS
4. Check IONOS webmail sent folder to confirm sending
5. Review bounce messages in IONOS webmail

### Issue: "Relay access denied"

**Causes:**
- SMTP authentication not enabled
- Wrong username

**Solutions:**
1. Ensure `MAIL_USERNAME` is set
2. Use full email address
3. Verify password is correct

---

## 📊 IONOS Email Limits & Quotas

### Storage
- **Mailbox Size:** 2GB
- **Recommendation:** Regularly clean sent folder
- **Auto-delete:** Consider auto-deleting password reset emails after 7 days

### Sending Limits
- **IONOS typically has generous limits**
- No specific daily limit for business accounts
- Fair use policy applies

### Email Size
- **Max attachment size:** 50MB (per email)
- **Password reset emails:** ~20-30KB (very small)
- **Daily emails:** Thousands possible without issue

---

## ✅ Quick Setup Checklist

- [ ] Get IONOS email credentials from control panel
- [ ] Confirm SMTP server (usually `smtp.ionos.co.uk` for UK)
- [ ] Add configuration to `.env` file
- [ ] Use full email address as `MAIL_USERNAME`
- [ ] Use regular password (no App Password needed)
- [ ] Set port to 587 with TLS
- [ ] Test with Flask shell script above
- [ ] Check test email arrives (check spam folder)
- [ ] Test password reset flow
- [ ] Verify emails not going to spam
- [ ] Configure SPF/DKIM if needed
- [ ] Monitor for 24 hours

---

## 📧 Example IONOS Configuration for Al-Baqi Academy

### Scenario 1: Using Main Domain Email
```env
MAIL_SERVER=smtp.ionos.co.uk
MAIL_PORT=587
MAIL_USE_TLS=True
MAIL_USE_SSL=False
MAIL_USERNAME=admin@albaqiacademy.com
MAIL_PASSWORD=YourStrongPassword123!
MAIL_DEFAULT_SENDER=Al-Baqi Academy <admin@albaqiacademy.com>
```

### Scenario 2: Using Dedicated No-Reply Email (Recommended)
```env
MAIL_SERVER=smtp.ionos.co.uk
MAIL_PORT=587
MAIL_USE_TLS=True
MAIL_USE_SSL=False
MAIL_USERNAME=noreply@albaqiacademy.com
MAIL_PASSWORD=YourStrongPassword123!
MAIL_DEFAULT_SENDER=Al-Baqi Academy <noreply@albaqiacademy.com>
```

### Scenario 3: Using Subdomain Email
```env
MAIL_SERVER=smtp.ionos.co.uk
MAIL_PORT=587
MAIL_USE_TLS=True
MAIL_USE_SSL=False
MAIL_USERNAME=system@albaqiacademy.com
MAIL_PASSWORD=YourStrongPassword123!
MAIL_DEFAULT_SENDER=Al-Baqi Academy Platform <system@albaqiacademy.com>
```

---

## 🚀 Production Deployment with IONOS

### Before Going Live

1. **Create dedicated email account** in IONOS:
   - Go to IONOS control panel
   - Navigate to Email section
   - Create new mailbox: `noreply@albaqiacademy.com`
   - Set strong password

2. **Test in staging/development first:**
   ```bash
   # Set FLASK_ENV=development in .env
   # Test password reset flow
   # Send to multiple email providers (Gmail, Outlook, Yahoo)
   # Check deliverability
   ```

3. **Configure DNS records** (if not done):
   - SPF: `v=spf1 include:_spf.ionos.com ~all`
   - DKIM: Contact IONOS support
   - DMARC: `v=DMARC1; p=quarantine;`

4. **Monitor first 100 emails:**
   - Check delivery success rate
   - Monitor bounce rates
   - Check spam reports
   - Review user feedback

---

## 📞 IONOS Support

If you need help:

**IONOS UK Support:**
- Phone: 0330 122 6000
- Web: https://www.ionos.co.uk/help
- Live Chat: Available in control panel
- Email: support@ionos.co.uk

**Common Support Requests:**
- "I need help configuring SMTP for my application"
- "Can you verify my SPF/DKIM records?"
- "What are my SMTP server settings?"
- "I'm getting authentication errors with SMTP"

---

## ✨ Summary

Your IONOS email is **perfect** for password reset functionality because:

✅ **Professional** - Emails from your own domain
✅ **Reliable** - Enterprise infrastructure
✅ **Simple** - No App Password needed
✅ **Generous** - 2GB storage, high sending limits
✅ **Secure** - TLS/SSL encryption
✅ **Deliverable** - Good reputation with ISPs

**Configuration is simple:**
```env
MAIL_SERVER=smtp.ionos.co.uk
MAIL_PORT=587
MAIL_USE_TLS=True
MAIL_USERNAME=your-email@albaqiacademy.com
MAIL_PASSWORD=your-password
```

Test it, and you're ready to go! 🚀

---

**Need more help?** See:
- [PASSWORD_RESET_QUICKSTART.md](PASSWORD_RESET_QUICKSTART.md) - Main setup guide
- [PASSWORD_RESET_IMPLEMENTATION.md](PASSWORD_RESET_IMPLEMENTATION.md) - Technical details
- [PASSWORD_RESET_DEPLOYMENT_CHECKLIST.md](PASSWORD_RESET_DEPLOYMENT_CHECKLIST.md) - Deployment steps
