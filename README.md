# 🎓 Al-Baqi Academy - Islamic Learning Platform

A comprehensive online learning management system for Islamic education, featuring course management, video streaming, subscriptions, payments, and student engagement tools.

---

## 🚀 Quick Start

### Is This Ready for Deployment?

**YES!** ✅ This website is production-ready and fully functional.

See [DEPLOYMENT_SUMMARY.md](DEPLOYMENT_SUMMARY.md) for a quick overview or [DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md) for detailed deployment instructions.

### Quick Deployment

```bash
# 1. Configure your VPS details
nano deploy_to_vps.sh

# 2. Deploy
./deploy_to_vps.sh

# 3. Upload courses
./upload_courses.sh
```

---

## ✨ Features

### For Students
- 📚 Browse and enroll in Islamic courses
- 🎥 Stream video lessons
- 📝 Take quizzes and exams
- 💬 Ask questions and get AI-powered answers
- 💳 Subscribe to course bundles
- 📊 Track learning progress
- 📁 Access student hub resources
- 🔐 Secure authentication

### For Instructors/Admins
- 📖 Create and manage courses
- 🎬 Upload lessons (video, PDF, PPTX)
- ✏️ Create quizzes and exams
- 👥 Manage students
- 💰 Manage subscriptions and payments
- 📧 Send bulk emails
- 📊 View analytics
- ⚙️ Configure site settings

---

## 🛠️ Technology Stack

### Backend
- **Flask** - Python web framework
- **SQLAlchemy** - ORM for database operations
- **PostgreSQL** - Production database (Supabase)
- **Gunicorn** - WSGI HTTP server
- **Flask-Migrate** - Database migrations
- **Flask-Mail** - Email integration

### Frontend
- **HTML5/CSS3** - Modern web standards
- **JavaScript** - Interactive features
- **Responsive Design** - Mobile-friendly
- **Bootstrap** - UI components (implied)

### Integrations
- **Stripe** - Payment processing & subscriptions
- **IONOS SMTP** - Email delivery
- **Supabase** - Cloud PostgreSQL database
- **AI Integration** - Q&A system

---

## 📋 System Requirements

### Development
- Python 3.8+
- PostgreSQL 12+ (or Supabase account)
- Git
- pip / virtualenv

### Production
- Linux VPS (Ubuntu 20.04+ recommended)
- Python 3.8+
- Nginx or Apache
- SSL certificate (Let's Encrypt)
- Domain name
- Stripe account
- IONOS email account
- Supabase account (free tier available)

---

## 🔧 Installation & Setup

### Local Development

```bash
# 1. Clone repository
git clone https://github.com/yourusername/web1.git
cd web1

# 2. Create virtual environment
python3 -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# 3. Install dependencies
pip install -r requirements.txt

# 4. Create .env file
cp .env.example .env
nano .env  # Configure your environment variables

# 5. Run database migrations
flask db upgrade

# 6. Create admin user (optional)
python3
>>> from website import app, db, User, bcrypt
>>> with app.app_context():
...     admin = User(
...         username='admin',
...         email='admin@example.com',
...         password=bcrypt.generate_password_hash('password').decode('utf-8'),
...         role='admin'
...     )
...     db.session.add(admin)
...     db.session.commit()
>>> exit()

# 7. Run application
python3 website.py

# Visit http://localhost:5005
```

### Production Deployment

See [DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md) for complete step-by-step instructions.

---

## 📁 Project Structure

```
web1/
├── website.py              # Main application file (5,274 lines)
├── config.py               # Configuration management
├── wsgi.py                 # Production WSGI entry point
├── requirements.txt        # Python dependencies
├── Procfile               # Gunicorn configuration
├── .env.example           # Environment variables template
├── .gitignore             # Git ignore rules
│
├── templates/             # HTML templates
│   ├── base.html         # Base template
│   ├── index.html        # Homepage
│   ├── courses.html      # Course listing
│   ├── admin_*.html      # Admin templates
│   └── ...
│
├── static/               # Static files
│   ├── css/             # Stylesheets
│   ├── js/              # JavaScript
│   ├── images/          # Images
│   └── courses/         # Course files (videos, PDFs, etc.)
│
├── migrations/           # Database migrations
│   └── versions/        # Migration files (18 files)
│
├── docs/                # Documentation
│   ├── DEPLOYMENT_READY.md
│   ├── STRIPE_SETUP.md
│   ├── EMAIL_SYSTEM_GUIDE.md
│   ├── SECURITY_DEPLOYMENT_GUIDE.md
│   └── ...
│
├── deploy_to_vps.sh     # Automated deployment script
├── upload_courses.sh    # Course upload script
├── verify_security.sh   # Security verification
│
├── DEPLOYMENT_CHECKLIST.md  # Complete deployment guide
├── DEPLOYMENT_SUMMARY.md    # Quick overview
└── README.md               # This file
```

---

## 🗄️ Database Schema

The application uses 21 database models:

### Core Models
- **User** - Student and admin accounts
- **Course** - Course information
- **Lesson** - Individual lessons
- **CourseAccess** - User access to courses

### Assessment Models
- **Quiz** - Quiz questions
- **QuizAttempt** - Student quiz submissions
- **Exam** - Exam information
- **ExamQuestion** - Exam questions
- **ExamAttempt** - Student exam submissions
- **ExamAnswer** - Individual answers

### Payment Models
- **SubscriptionPlan** - Subscription offerings
- **UserSubscription** - Active subscriptions

### Engagement Models
- **Question** - Student questions
- **Message** - Q&A messages
- **UserCourseProgress** - Progress tracking
- **StudentHubFile** - Shared files
- **CourseAgreement** - Course terms
- **Testimonial** - Student reviews

### System Models
- **SentEmail** - Email history
- **SiteSetting** - Site configuration

---

## 🔐 Environment Variables

Required environment variables (see `.env.example` for full list):

```env
# Flask
SECRET_KEY=your-secret-key
FLASK_ENV=production

# Database
DATABASE_URL=postgresql://user:pass@host:5432/db

# Stripe
STRIPE_SECRET_KEY=sk_live_...
STRIPE_PUBLISHABLE_KEY=pk_live_...
STRIPE_WEBHOOK_SECRET=whsec_...

# Email
MAIL_SERVER=smtp.ionos.co.uk
MAIL_PORT=465
MAIL_USERNAME=admin@yourdomain.com
MAIL_PASSWORD=your-password

# Security
SESSION_COOKIE_SECURE=True
DEBUG=False
```

---

## 🚦 API Endpoints

### Public Routes
- `GET /` - Homepage
- `GET /courses` - Course listing
- `GET /course/<id>` - Course details
- `POST /registration` - Register account
- `POST /log_in` - Login

### Student Routes (Login Required)
- `GET /courses_dashboard` - Student dashboard
- `GET /course/<id>/video/<lesson_id>` - Watch lesson
- `POST /question` - Ask question
- `GET /my-subscription` - Subscription management

### Admin Routes (Admin Only)
- `GET /admin` - Admin dashboard
- `GET /admin/courses` - Manage courses
- `GET /admin/users` - Manage users
- `GET /admin/subscriptions` - Manage subscriptions
- `POST /admin/email` - Send bulk email

### Payment Routes
- `POST /subscribe/<plan_id>` - Subscribe to plan
- `POST /stripe/webhook` - Stripe webhook handler

---

## 💳 Payment Integration

### Stripe Configuration

1. **Get API Keys**
   - Visit [Stripe Dashboard](https://dashboard.stripe.com/test/apikeys)
   - Copy Secret Key and Publishable Key
   - For testing: use test keys (sk_test_...)
   - For production: use live keys (sk_live_...)

2. **Configure Webhook**
   - Visit [Webhooks](https://dashboard.stripe.com/test/webhooks)
   - Add endpoint: `https://yourdomain.com/stripe/webhook`
   - Select events:
     - checkout.session.completed
     - invoice.payment_succeeded
     - invoice.payment_failed
     - customer.subscription.updated
     - customer.subscription.deleted

3. **Enable Customer Portal**
   - Visit [Billing Settings](https://dashboard.stripe.com/settings/billing/portal)
   - Enable customer portal
   - Configure cancellation and update settings

See [docs/STRIPE_SETUP.md](docs/STRIPE_SETUP.md) for detailed instructions.

---

## 📧 Email Configuration

### IONOS SMTP Setup

```env
MAIL_SERVER=smtp.ionos.co.uk
MAIL_PORT=465
MAIL_USE_SSL=True
MAIL_USE_TLS=False
MAIL_USERNAME=admin@yourdomain.com
MAIL_PASSWORD=your-password
```

### Email Features
- Welcome emails on registration
- Password reset emails
- Course enrollment confirmations
- Subscription notifications
- Admin bulk email tool

See [docs/EMAIL_SYSTEM_GUIDE.md](docs/EMAIL_SYSTEM_GUIDE.md) for complete setup.

---

## 🔒 Security Features

- ✅ Password hashing (bcrypt)
- ✅ Session management
- ✅ CSRF protection
- ✅ Environment variable protection
- ✅ SQL injection prevention (SQLAlchemy ORM)
- ✅ Secure cookie configuration
- ✅ Webhook signature verification
- ✅ Role-based access control
- ✅ Password reset tokens with expiration
- ✅ HTTPS enforced in production

---

## 🧪 Testing

### Manual Testing

```bash
# Test registration
curl -X POST http://localhost:5005/registration \
  -d "username=test&email=test@example.com&password=password"

# Test login
curl -X POST http://localhost:5005/log_in \
  -d "email=test@example.com&password=password"

# Test Stripe webhook
stripe listen --forward-to localhost:5005/stripe/webhook
```

### Security Verification

```bash
# Run security checks
./verify_security.sh

# Check for exposed secrets
git log -p | grep -i "password"
```

---

## 📊 Monitoring & Logs

### Application Logs

```bash
# View application logs
journalctl -u web1 -f

# Check specific date
journalctl -u web1 --since "2025-10-08"

# Check errors only
journalctl -u web1 -p err
```

### Database Queries

```bash
# Connect to database
psql $DATABASE_URL

# Check active users
SELECT COUNT(*) FROM "user" WHERE role = 'student';

# Check subscriptions
SELECT COUNT(*) FROM user_subscription WHERE status = 'active';

# Check revenue
SELECT SUM(price) FROM subscription_plan
JOIN user_subscription ON subscription_plan.id = user_subscription.plan_id
WHERE user_subscription.status = 'active';
```

---

## 🐛 Troubleshooting

### Common Issues

1. **Database Connection Error**
   ```bash
   # Check DATABASE_URL
   echo $DATABASE_URL

   # Test connection
   psql $DATABASE_URL -c "SELECT 1;"
   ```

2. **Stripe Webhook Not Working**
   - Check webhook URL is publicly accessible
   - Verify STRIPE_WEBHOOK_SECRET is correct
   - Review Stripe dashboard webhook logs
   - Check Flask logs for errors

3. **Email Not Sending**
   ```python
   # Test SMTP connection
   python3 << 'EOF'
   import smtplib
   server = smtplib.SMTP_SSL('smtp.ionos.co.uk', 465)
   server.login('admin@yourdomain.com', 'password')
   print("✅ Connection successful")
   server.quit()
   EOF
   ```

4. **502 Bad Gateway**
   - Check if gunicorn is running: `ps aux | grep gunicorn`
   - Restart service: `sudo systemctl restart web1`
   - Check logs: `journalctl -u web1 -n 50`

---

## 📚 Documentation

Comprehensive documentation is available in the [docs/](docs/) folder:

- [DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md) - Complete deployment guide
- [DEPLOYMENT_SUMMARY.md](DEPLOYMENT_SUMMARY.md) - Quick overview
- [docs/DEPLOYMENT_READY.md](docs/DEPLOYMENT_READY.md) - Subscription system
- [docs/STRIPE_SETUP.md](docs/STRIPE_SETUP.md) - Payment configuration
- [docs/EMAIL_SYSTEM_GUIDE.md](docs/EMAIL_SYSTEM_GUIDE.md) - Email setup
- [docs/SECURITY_DEPLOYMENT_GUIDE.md](docs/SECURITY_DEPLOYMENT_GUIDE.md) - Security best practices
- [docs/SAFE_DEPLOYMENT_GUIDE.md](docs/SAFE_DEPLOYMENT_GUIDE.md) - Safe deployment
- [docs/SUPABASE_MIGRATION_GUIDE.md](docs/SUPABASE_MIGRATION_GUIDE.md) - Database setup

---

## 🤝 Contributing

This is a private project for Al-Baqi Academy. For internal contributions:

1. Create a feature branch
2. Make your changes
3. Test thoroughly
4. Submit for review
5. Merge to main after approval

---

## 📝 License

Proprietary - Al-Baqi Academy © 2025

---

## 👥 Support

For technical support or questions:
- Review documentation in [docs/](docs/) folder
- Check [DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md)
- Review application logs
- Contact system administrator

---

## 🎯 Project Status

- **Version:** 1.0.0
- **Status:** Production Ready ✅
- **Last Updated:** October 8, 2025
- **Lines of Code:** ~5,274 (main application)
- **Database Models:** 21
- **Migrations:** 18
- **Routes:** 50+
- **Templates:** 20+

---

## 🚀 Next Steps

1. **Configure Deployment**
   - Edit `deploy_to_vps.sh` with VPS details
   - Create production `.env` with live keys

2. **Deploy to Production**
   - Run `./deploy_to_vps.sh`
   - Configure web server (Nginx)
   - Enable HTTPS (Let's Encrypt)
   - Test all features

3. **Go Live!**
   - Upload courses via `./upload_courses.sh`
   - Create admin account
   - Add initial content
   - Announce to students

---

**Ready to deploy?** See [DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md) to get started! 🚀
