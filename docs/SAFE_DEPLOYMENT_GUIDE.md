# Safe Deployment Guide - Al-Baqi Academy

## 🔒 Your Data is Safe!

**Important:** Git and deployment scripts NEVER touch your database or user data. Here's why:

- Database files (`.db`, `.sqlite`) are in `.gitignore` - never synced
- User data lives in the database - completely separate from code
- Course files are uploaded separately - existing files are preserved

---

## 🚀 Quick Deployment Steps

### 1. Setup (First Time Only)

Edit the configuration in both scripts:

**deploy_to_vps.sh:**
```bash
VPS_USER="your_username"       # Your VPS username
VPS_HOST="your_vps_ip"         # Your VPS IP address
VPS_PATH="/path/to/web1"       # Path to your app on VPS
APP_NAME="web1"                # Your systemd service name
```

**upload_courses.sh:**
```bash
VPS_USER="your_username"
VPS_HOST="your_vps_ip"
VPS_PATH="/path/to/web1"
```

Then make scripts executable:
```bash
chmod +x deploy_to_vps.sh upload_courses.sh
```

### 2. Deploy Code Changes

```bash
./deploy_to_vps.sh
```

This will:
- ✓ Commit and push your code changes
- ✓ Pull changes on VPS
- ✓ Install dependencies
- ✓ Run database migrations (adds new columns/tables, preserves data)
- ✓ Restart the application
- ✗ Does NOT touch user data
- ✗ Does NOT delete existing courses

### 3. Upload New Courses (Optional)

```bash
./upload_courses.sh
```

This will:
- ✓ Upload new course files from `static/courses/`
- ✓ Preserve all existing courses
- ✓ Use rsync to only upload what's new/changed

---

## 📋 What Gets Updated vs What's Preserved

### ✅ Updated (Safe):
- Python code (`*.py`)
- Templates (`*.html`)
- CSS/JavaScript files
- Configuration files
- Database schema (migrations)

### 🔒 Preserved (Never Touched):
- User accounts and data
- Student enrollments
- Course progress
- Existing course files
- Any uploaded content
- Database records

---

## 🛡️ Safety Features

1. **Backup Creation**: `deploy_to_vps.sh` creates a timestamped backup before deployment
2. **Confirmation Prompts**: Scripts ask before making changes
3. **Error Handling**: Scripts stop if any command fails
4. **Separate Concerns**: Code and content are deployed independently

---

## 📝 Manual Deployment (Alternative)

If you prefer to do it manually:

### On Your Local Machine:
```bash
# 1. Commit and push changes
git add .
git commit -m "Your commit message"
git push origin main
```

### On Your VPS:
```bash
# 2. SSH into VPS
ssh your_user@your_vps_ip

# 3. Navigate to project
cd /path/to/web1

# 4. Pull changes
git pull origin main

# 5. Update dependencies
source venv/bin/activate
pip install -r requirements.txt

# 6. Run migrations
flask db upgrade

# 7. Restart app
sudo systemctl restart web1  # or your service name
```

### Upload Courses Manually:
```bash
# From your local machine
scp -r static/courses/Fiqh\ of\ Salah/ user@vps:/path/to/web1/static/courses/
```

---

## ⚠️ Common Questions

**Q: Will my users lose their accounts?**
A: No! User data is in the database, which is never synced with git.

**Q: Will existing courses be deleted?**
A: No! Course files are uploaded separately and only new files are added.

**Q: What if I have new users on VPS and new courses locally?**
A: Perfect! Deploy code first, then upload courses. Users remain, courses are added.

**Q: What about large video files (5-6GB)?**
A: Course files are now excluded from git (in `.gitignore`). They're uploaded separately via `rsync`, which is designed for large files. Only changed files are transferred.

**Q: Can I deploy multiple times without losing data?**
A: Absolutely! Each deployment cycle:
  - Deploy #1: Push code → VPS gets 10 new users
  - Deploy #2: Push updated code → All 10 users preserved + new ones
  - Deploy #3: Push more code → All previous users still there
  - Database is NEVER touched by git!

**Q: Do course videos go through git?**
A: No! Videos are in `.gitignore` and uploaded via `rsync` separately. Git only handles code.

**Q: Can I test this safely?**
A: Yes! The script creates a backup before deployment. You can also test on a staging server first.

---

## 🆘 Troubleshooting

### If deployment fails:
1. Check SSH connection: `ssh user@vps_ip`
2. Check git status on VPS: `git status`
3. Restore from backup: `cp -r ../web1_backup_TIMESTAMP/* .`

### If courses don't appear:
1. Check file permissions: `ls -la static/courses/`
2. Verify upload: `ssh user@vps "ls -la /path/to/web1/static/courses/"`
3. Check application logs

---

## 📚 Directory Structure

```
Local:                          VPS:
web1/                          web1/
├── website.py       ──────→   ├── website.py (updated)
├── templates/       ──────→   ├── templates/ (updated)
├── static/courses/  ──rsync→  ├── static/courses/ (courses added)
├── site.db          ✗         ├── site.db (NEVER touched)
└── venv/           ✗          └── venv/ (rebuilt from requirements.txt)
```

---

## ✨ Best Practices

1. **Always test locally first** before deploying
2. **Backup database before migrations**: `cp site.db site.db.backup`
3. **Deploy during low-traffic times** if possible
4. **Monitor logs after deployment**: `tail -f /var/log/your_app.log`
5. **Keep local and VPS .env files synced** (manually - they're not in git)

---

*Remember: Your user data and existing content are completely safe. Git only manages code, not data!*
