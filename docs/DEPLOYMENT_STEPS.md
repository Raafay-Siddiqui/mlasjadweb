# Complete Deployment Guide - Al-Baqi Academy
## Step-by-Step Instructions

---

## 📋 Overview

This guide walks you through deploying your Al-Baqi Academy website to your VPS server. You'll deploy:
- All code changes (Python, templates, CSS, etc.)
- New course: "Fiqh of Salah" (36MB of videos)
- Database migrations (if any)

**Your user data and existing VPS content will be 100% safe!**

---

## ⏱️ Time Required

- **First-time setup**: 10-15 minutes
- **Deployment (code)**: 5 minutes
- **Course upload (36MB)**: 2-5 minutes (depends on internet speed)

---

## 🔐 Prerequisites

Before starting, make sure you have:
- [ ] SSH access to your VPS (`ssh user@your_vps_ip` works)
- [ ] Your VPS IP address
- [ ] Your VPS username
- [ ] Path to your web1 directory on VPS (e.g., `/home/username/web1`)
- [ ] Git repository is accessible from VPS

---

## PART 1: ONE-TIME SETUP (First Deployment Only)

### Step 1: Configure Deployment Scripts

You need to edit two files with your VPS details:

#### A. Edit `deploy_to_vps.sh`

Open the file and update these lines (around line 15-18):

```bash
VPS_USER="your_actual_username"      # Example: "ubuntu" or "root"
VPS_HOST="your_vps_ip_address"       # Example: "123.45.67.89"
VPS_PATH="/path/to/web1"             # Example: "/home/ubuntu/web1"
APP_NAME="web1"                      # Your systemd service name (if using)
```

#### B. Edit `upload_courses.sh`

Open the file and update these lines (around line 15-17):

```bash
VPS_USER="your_actual_username"      # Same as above
VPS_HOST="your_vps_ip_address"       # Same as above
VPS_PATH="/path/to/web1"             # Same as above
```

**💡 Tip:** To find your VPS path, SSH into your VPS and run: `pwd` in your project directory

### Step 2: Verify SSH Access

Test that you can connect to your VPS without a password prompt:

```bash
ssh your_username@your_vps_ip "pwd"
```

**Expected output:** Should show the home directory path

**If it asks for a password every time:** You may want to set up SSH keys (optional but recommended):
```bash
ssh-copy-id your_username@your_vps_ip
```

### Step 3: Verify VPS Environment

SSH into your VPS and check:

```bash
ssh your_username@your_vps_ip

# Navigate to project
cd /path/to/web1

# Check git status
git status

# Check if virtual environment exists
ls -la venv/

# Check current branch
git branch

# Exit VPS
exit
```

---

## PART 2: DEPLOYING YOUR CODE

### Step 4: Review Local Changes

Before deploying, see what will be pushed:

```bash
# See all changes
git status

# See code modifications
git diff
```

**What you'll see:**
- Modified files: templates, website.py, config.py, etc.
- Deleted files: Old course files (from git tracking - they're not actually deleted locally!)
- New files: Deployment scripts, documentation

**⚠️ IMPORTANT:** The "deleted" course files are just being removed from git tracking. Your local files are safe!

### Step 5: Commit Changes

Create a commit with all your changes:

```bash
# Stage all changes
git add .

# Create commit
git commit -m "Update website with new features and remove course files from git tracking"
```

**What this does:**
- ✅ Stages your code changes
- ✅ Removes old course files from git (but keeps them locally!)
- ✅ Adds .gitignore changes to exclude courses from future commits

### Step 6: Push to GitHub

```bash
git push origin main
```

**Expected output:**
```
Enumerating objects: XX, done.
Counting objects: 100% (XX/XX), done.
...
To https://github.com/Raafay-Siddiqui/mlasjadweb.git
   a844fac..xxxxxxx  main -> main
```

**✅ Checkpoint:** Your code is now on GitHub!

### Step 7: Deploy to VPS (Automated)

Now run the deployment script:

```bash
./deploy_to_vps.sh
```

**The script will:**
1. Ask for confirmation
2. SSH into your VPS
3. Create a backup of current code
4. Pull latest changes from GitHub
5. Install/update Python dependencies
6. Run database migrations
7. Restart your application

**Follow the prompts:**
- When asked "Continue? (y/n)" → Type `y`
- Watch the deployment progress

**Expected output:**
```
=== Al-Baqi Academy - Safe Deployment ===

⚠️  IMPORTANT: This script will:
   ✓ Push code changes to VPS
   ✓ Preserve all database data
   ✓ Preserve existing course files
   ✓ Run database migrations safely

Continue? (y/n) y

Step 1: Committing local changes
Already up to date!

Step 2: Pushing to repository
Already up to date!

Step 3: Deploying to VPS
→ Backing up current code...
→ Pulling latest changes...
→ Activating virtual environment...
→ Installing/updating dependencies...
→ Running database migrations...
→ Restarting application...
✓ Deployment complete!

✓ Deployment successful!
Note: New course files must be uploaded separately (see upload_courses.sh)
```

**✅ Checkpoint:** Your code is now live on VPS!

### Step 8: Verify Code Deployment

SSH into your VPS and verify:

```bash
ssh your_username@your_vps_ip

# Navigate to project
cd /path/to/web1

# Check git log
git log --oneline -3

# Check if app is running
sudo systemctl status web1
# OR if using pm2/supervisor:
# pm2 status
# supervisorctl status

# Test the website
curl http://localhost:5005
# or visit: http://your_vps_ip:5005

exit
```

---

## PART 3: UPLOADING COURSE FILES

### Step 9: Upload New Courses

Now upload your "Fiqh of Salah" course (36MB):

```bash
./upload_courses.sh
```

**The script will:**
1. Show you what courses will be uploaded
2. Display total size (36MB)
3. Offer a dry-run (recommended for first time!)
4. Upload files via rsync

**Follow the prompts:**

```
=== Upload Course Files to VPS ===

Local courses to upload:
  → Fiqh of Salah (36M)

Total size: 36M

⚠️  This will:
   ✓ Upload all courses to VPS
   ✓ Preserve existing courses on VPS
   ✓ Skip unchanged files (faster)
   ✓ Not affect database or user data

Do dry-run first to see what will be uploaded? (y/n) y
```

**💡 Tip:** Type `y` for dry-run first to see what will happen without actually uploading

**Dry-run output:**
```
Dry run (no files will be transferred):
sending incremental file list
Fiqh of Salah/
Fiqh of Salah/year1/
Fiqh of Salah/year1/lesson1.mp4
Fiqh of Salah/year1/lesson1.pptx
...

sent 1,234 bytes  received 56 bytes  2,580.00 bytes/sec
```

**Then continue:**
```
Proceed with actual upload? (y/n) y

Uploading course files...
sending incremental file list
Fiqh of Salah/year1/lesson1.mp4
     12,345,678 100%   15.23MB/s    0:00:00 (xfr#1, to-chk=3/5)
...

✓ Upload complete!
Summary:
   • Courses uploaded: 1
   • Total size: 36M
   • Existing courses: preserved
   • User data: unaffected
```

**⏱️ Upload time:** ~2-5 minutes depending on your internet speed

**✅ Checkpoint:** Course files are now on VPS!

### Step 10: Verify Course Upload

SSH into VPS and check:

```bash
ssh your_username@your_vps_ip

# Check courses directory
ls -lh /path/to/web1/static/courses/

# Check "Fiqh of Salah" course
ls -lh /path/to/web1/static/courses/Fiqh\ of\ Salah/

# Check total size
du -sh /path/to/web1/static/courses/

exit
```

**Expected output:**
```
drwxr-xr-x  3 user user 4.0K Oct  5 12:00 Fiqh of Salah
[other existing courses...]

36M    /path/to/web1/static/courses/
```

---

## PART 4: POST-DEPLOYMENT VERIFICATION

### Step 11: Test the Website

1. **Visit your website:**
   - Go to: `http://your_vps_ip:5005` or `https://yourdomain.com`

2. **Check key functionality:**
   - [ ] Homepage loads correctly
   - [ ] Login/Registration works
   - [ ] Existing users can still log in
   - [ ] Course page shows all courses (including "Fiqh of Salah")
   - [ ] Admin panel accessible

3. **Check database:**
   - [ ] Existing users are still there
   - [ ] Course enrollments preserved
   - [ ] No data lost

### Step 12: Check Application Logs

If anything doesn't work, check logs:

```bash
ssh your_username@your_vps_ip

# Check application logs
tail -50 /var/log/web1/app.log
# OR
journalctl -u web1 -n 50

# Check for errors
grep ERROR /var/log/web1/app.log
```

---

## PART 5: ENVIRONMENT VARIABLES (If Needed)

### Step 13: Update VPS Environment Variables

If you added new environment variables locally, you need to update them on VPS:

```bash
ssh your_username@your_vps_ip

# Navigate to project
cd /path/to/web1

# Edit .env file
nano .env

# Add any new variables from your local .env.example
# Example:
# STRIPE_SECRET_KEY=sk_live_your_key
# MAIL_USERNAME=noreply@albaqiacademy.com
# etc.

# Save and exit (Ctrl+X, then Y, then Enter)

# Restart application to load new env vars
sudo systemctl restart web1

exit
```

**Variables to check:**
- `SECRET_KEY` - Should be set in production
- `DATABASE_URL` - Should point to PostgreSQL (not SQLite) in production
- `STRIPE_*` - Your Stripe keys
- `MAIL_*` - Email configuration
- `SESSION_COOKIE_SECURE` - Should be `True` if using HTTPS

---

## 🎉 DEPLOYMENT COMPLETE!

Your website is now live with:
- ✅ All code changes deployed
- ✅ New "Fiqh of Salah" course uploaded
- ✅ Database migrations applied
- ✅ All existing users and data preserved
- ✅ Existing courses intact

---

## 📊 SUMMARY - What Happened

### Code Deployment:
```
Local (Git) → GitHub → VPS
├── Python files ✓
├── Templates ✓
├── CSS/JS ✓
├── Config ✓
└── Migrations ✓
```

### Course Upload:
```
Local (rsync) → VPS
└── static/courses/
    └── Fiqh of Salah/ (36MB) ✓
```

### Data Preservation:
```
VPS Database (UNTOUCHED)
├── Users ✓
├── Enrollments ✓
├── Progress ✓
└── Subscriptions ✓
```

---

## 🔄 FUTURE DEPLOYMENTS

For your next deployment (when you make more changes):

1. **Make your code changes locally**
2. **Test locally**
3. **Run deployment:**
   ```bash
   ./deploy_to_vps.sh
   ```
4. **If you added new courses:**
   ```bash
   ./upload_courses.sh
   ```

That's it! The scripts handle everything automatically.

---

## ❓ TROUBLESHOOTING

### Issue: "Permission denied" when running scripts

**Solution:**
```bash
chmod +x deploy_to_vps.sh upload_courses.sh
```

### Issue: SSH asks for password every time

**Solution:** Set up SSH keys
```bash
ssh-copy-id your_username@your_vps_ip
```

### Issue: Git pull fails on VPS

**Possible causes:**
- Uncommitted changes on VPS
- Merge conflicts

**Solution:**
```bash
ssh your_username@your_vps_ip
cd /path/to/web1
git status
git stash  # Save any local changes
git pull origin main
```

### Issue: Application won't start after deployment

**Check:**
1. Dependencies installed: `pip list`
2. Database migrated: `flask db upgrade`
3. Environment variables set: `cat .env`
4. Logs for errors: `tail -f /var/log/web1/app.log`

### Issue: Courses not showing on website

**Check:**
1. Files uploaded: `ls -la static/courses/`
2. File permissions: `chmod -R 755 static/courses/`
3. Application restarted: `sudo systemctl restart web1`

### Issue: rsync takes forever

**Reasons:**
- Large files (36MB is fine, but if you add bigger files)
- Slow internet connection

**Solution:** Run upload script with compression:
```bash
# Already included in script with -z flag
rsync -avz ...
```

### Issue: Database migration fails

**Check migration status:**
```bash
flask db current
flask db history
```

**If stuck:**
```bash
flask db stamp head  # Mark as up-to-date
flask db upgrade     # Try again
```

### Issue: Lost SSH connection during deployment

**Don't worry!** The deployment script uses `&&` to chain commands, so if SSH drops, nothing is left in a broken state.

**Solution:** Just run the script again:
```bash
./deploy_to_vps.sh
```

---

## 🔒 SECURITY NOTES

1. **Never commit sensitive data:**
   - `.env` file is in `.gitignore` ✓
   - Database is in `.gitignore` ✓
   - Course files are in `.gitignore` ✓

2. **Production checklist:**
   - [ ] `SECRET_KEY` is set and strong
   - [ ] `DEBUG=False` in production
   - [ ] Using PostgreSQL (not SQLite)
   - [ ] HTTPS enabled (`SESSION_COOKIE_SECURE=True`)
   - [ ] Stripe live keys (not test keys)
   - [ ] Email credentials secured

3. **Backup your VPS database regularly:**
   ```bash
   # Already have backup_database.sh script!
   ./backup_database.sh
   ```

---

## 📞 NEED HELP?

If you run into issues:

1. **Check logs first:**
   ```bash
   tail -50 /var/log/web1/app.log
   ```

2. **Verify environment:**
   ```bash
   flask --version
   python --version
   pip list | grep Flask
   ```

3. **Restore from backup:**
   ```bash
   cd /path/to/web1
   cp -r ../web1_backup_YYYYMMDD_HHMMSS/* .
   sudo systemctl restart web1
   ```

4. **Check this guide:** `SAFE_DEPLOYMENT_GUIDE.md`

---

## ✨ TIPS FOR SMOOTH DEPLOYMENTS

1. **Always test locally first** before deploying
2. **Deploy during low-traffic hours** (early morning/late night)
3. **Keep a terminal open to VPS** while deploying to monitor
4. **Check website immediately** after deployment
5. **Have backups ready** just in case

---

**🎊 Congratulations! You've successfully deployed your Al-Baqi Academy website!**

*Your users can now access all the new features and the "Fiqh of Salah" course!*
