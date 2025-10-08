# Al-Baqi Academy Email System - Complete Guide

## Overview
This Flask application now includes a fully integrated email system with IonOS SMTP support, reusable utilities, consistent templates, and admin bulk-sending capabilities.

## Features
- ✅ Automated welcome emails on user registration
- ✅ Password reset emails with secure token links
- ✅ Course enrollment confirmations after Stripe payments
- ✅ Subscription renewal reminders
- ✅ Admin bulk email tool for sending to users or course groups
- ✅ Email logging in database (SentEmail model)
- ✅ Asynchronous email sending (non-blocking)
- ✅ Consistent branded email templates
- ✅ HTML and plaintext email support

## Configuration

### 1. Environment Variables
Add these to your `.env` file:

```bash
# IonOS SMTP Configuration (Port 465 with SSL)
MAIL_SERVER=smtp.ionos.co.uk
MAIL_PORT=465
MAIL_USE_SSL=True
MAIL_USE_TLS=False
MAIL_USERNAME=your-email@albaqiacademy.com
MAIL_PASSWORD=your-ionos-password
MAIL_DEFAULT_SENDER=noreply@albaqiacademy.com
```

**Alternative: Port 587 with TLS**
```bash
MAIL_SERVER=smtp.ionos.co.uk
MAIL_PORT=587
MAIL_USE_SSL=False
MAIL_USE_TLS=True
```

### 2. Database Migration
Run the migration to create the `sent_email` table:

```bash
flask db migrate -m "Add SentEmail model"
flask db upgrade
```

Or manually:
```bash
python3 -c "from website import app, db; app.app_context().push(); db.create_all()"
```

## File Structure

```
/web1/
├── email_utils.py              # Core email sending utility
├── config.py                   # Email configuration (updated)
├── website.py                  # Routes updated with email triggers
├── templates/
│   ├── emails/
│   │   ├── base_email.html     # Base template for all emails
│   │   ├── welcome.html        # Welcome email
│   │   ├── welcome.txt         # Welcome plaintext
│   │   ├── reset_password.html # Password reset email
│   │   ├── reset_password.txt  # Password reset plaintext
│   │   ├── course_enrolled.html # Course confirmation
│   │   ├── course_enrolled.txt
│   │   ├── subscription_renewal.html
│   │   └── subscription_renewal.txt
│   ├── admin_email.html        # Bulk email interface
│   └── admin_test_email.html   # Test email tool
└── .env.example                # Updated with email vars
```

## Email Utility Functions

### `email_utils.py` Functions

**Core Function:**
```python
send_email(to, subject, html_body, text_body=None, attachments=None, user_id=None, async_send=True)
```
- Sends HTML email with plaintext fallback
- Automatic threading for async sending
- Logs to database (SentEmail table)

**Helper Functions:**
```python
send_welcome_email(user)
send_password_reset_email(user, token)
send_course_enrollment_email(user, course_name, payment_amount=None)
send_subscription_renewal_email(user, renewal_date, plan_name)
send_bulk_email(recipients, subject, html_body, text_body=None)
```

## Routes Updated

### Registration Route (`/register`)
- Automatically sends welcome email after successful registration
- Non-blocking (uses threading)

### Password Reset Route (`/forgot-password`)
- Now uses `send_password_reset_email()` utility
- Cleaner code, consistent with other emails

### Stripe Webhook (`/stripe/webhook`)
- Sends course enrollment email after successful payment
- Includes payment amount in confirmation

## Admin Tools

### 1. Bulk Email Tool (`/admin/email`)
Accessible only to admin users. Features:
- Send to selected users individually
- Send to all users in a specific course
- Send to all users
- HTML message support
- Real-time recipient selection

**Usage:**
1. Navigate to `/admin/email`
2. Compose subject and message (HTML supported)
3. Select recipients (individual, course, or all)
4. Click "Send Email"

### 2. Test Email Tool (`/admin/test-email`)
Test your email configuration:
1. Navigate to `/admin/test-email`
2. Enter recipient email
3. Send test email
4. Verify delivery

## Email Templates

### Base Template (`base_email.html`)
All emails extend this template with:
- Al-Baqi Academy branding
- Consistent header with logo
- Professional styling
- Footer with contact info
- Mobile responsive

### Creating New Email Templates

**HTML Template Example:**
```html
{% extends "emails/base_email.html" %}

{% block title %}Your Email Title{% endblock %}

{% block content %}
<h2>Email Heading</h2>
<p>Email content here...</p>
<p style="text-align: center;">
    <a href="{{ url_for('route_name', _external=True) }}" class="button">Call to Action</a>
</p>
{% endblock %}
```

**Plaintext Template Example:**
```
Your Email Title

Email content here...

Call to action: {{ url_for('route_name', _external=True) }}

---
Al-Baqi Academy
support@albaqiacademy.com
```

## Testing

### Local Testing
1. Set up email credentials in `.env`
2. Start Flask app: `flask run` or `python3 website.py`
3. Navigate to `/admin/test-email`
4. Send test email to your address

### Production Testing
1. Verify IonOS credentials are correct
2. Check firewall allows port 465 (SSL) or 587 (TLS)
3. Send test email from admin panel
4. Monitor server logs for errors

## Troubleshooting

### Common Issues

**1. SMTPAuthenticationError**
- Verify MAIL_USERNAME is your full email address
- Verify MAIL_PASSWORD is correct
- For IonOS, use regular password (not App Password)

**2. Connection Timeout**
- Check MAIL_SERVER is correct (`smtp.ionos.co.uk` for UK)
- Verify firewall allows outbound connections on port 465/587
- Try alternate port (587 with TLS instead of 465 with SSL)

**3. Emails Not Sending**
- Check server logs for error messages
- Verify `mail = Mail(app)` is initialized in `website.py`
- Ensure email_utils.py is in correct directory
- Check SentEmail logs in database

**4. Threading Issues**
- If async sending fails, set `async_send=False` in send_email()
- Consider using Celery for production async tasks (future upgrade)

### Logging
Email sending is logged automatically:
- Success/failure logged to console
- Database table `sent_email` tracks all sent emails
- Check logs: `tail -f /path/to/logs/app.log`

## Database Model

**SentEmail Model:**
```python
class SentEmail(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=True)
    subject = db.Column(db.String(200), nullable=False)
    sent_at = db.Column(db.DateTime, default=utcnow)
    status = db.Column(db.String(20), default='sent')  # sent, failed
```

Query email logs:
```python
# Get all emails sent to a user
user_emails = SentEmail.query.filter_by(user_id=user.id).all()

# Get failed emails
failed_emails = SentEmail.query.filter_by(status='failed').all()
```

## Production Deployment

### Pre-deployment Checklist
- [ ] Update `.env` with production IonOS credentials
- [ ] Run database migrations: `flask db upgrade`
- [ ] Test email sending with `/admin/test-email`
- [ ] Verify email templates render correctly
- [ ] Check email deliverability (not in spam)
- [ ] Monitor initial email sending for errors

### IonOS Production Setup
1. Log in to IonOS Control Panel
2. Navigate to Email settings
3. Verify SMTP access is enabled
4. Use settings:
   - Server: `smtp.ionos.co.uk`
   - Port: `465` (SSL) recommended
   - Username: Your full email address
   - Password: Your email password

### Performance Considerations
- Emails are sent asynchronously (non-blocking)
- Each email spawns a new thread
- For high-volume sending (1000+ emails), consider Celery
- Current implementation suitable for <100 emails at once

## Future Enhancements (Optional)

1. **Email Queue System**
   - Implement Celery for better async handling
   - Redis backend for task queue

2. **Email Analytics**
   - Track open rates (requires tracking pixels)
   - Track click-through rates

3. **Scheduled Emails**
   - Cron jobs for subscription renewal reminders
   - Weekly digest emails

4. **Rich Text Editor**
   - Add WYSIWYG editor to admin bulk email tool
   - Currently supports raw HTML input

5. **Email Attachments**
   - Currently not implemented
   - Add support in `send_email()` function

## Support
For issues or questions:
- Check server logs first
- Test with `/admin/test-email`
- Verify environment variables are set
- Contact: support@albaqiacademy.com

---

**System Ready for Production Use on IonOS** ✅
