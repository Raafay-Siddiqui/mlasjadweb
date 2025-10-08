# 🚀 Quick Deployment to VPS

## Step-by-Step VPS Deployment

### 1️⃣ SSH to VPS
```bash
ssh your-user@your-vps-ip
cd /path/to/albaqiacademy
```

### 2️⃣ Pull Latest Code
```bash
git pull origin main
```

### 3️⃣ Update .env File
```bash
nano .env
```

**Change this line:**
```bash
DATABASE_URL=postgresql://postgres:AlBaqiAcademyGRE@db.yhladodtavcoawfhpeaa.supabase.co:5432/postgres
```

**Save:** `Ctrl+X`, then `Y`, then `Enter`

### 4️⃣ Install PostgreSQL Adapter
```bash
source venv/bin/activate  # or: ./venv/bin/activate
pip install psycopg2-binary
```

### 5️⃣ Restart App
```bash
# If using systemd:
sudo systemctl restart albaqiacademy

# If running manually:
pkill -f "flask run"
./venv/bin/flask run --host 0.0.0.0 --port 5005

# If using gunicorn:
pkill gunicorn
gunicorn -w 4 -b 0.0.0.0:5005 website:app
```

### 6️⃣ Verify
```bash
curl http://localhost:5005
# Should return HTML (your homepage)
```

---

## ✅ Checklist

- [ ] VPS .env has Supabase DATABASE_URL
- [ ] `psycopg2-binary` installed
- [ ] App restarted successfully
- [ ] Website loads in browser
- [ ] Can login with existing account
- [ ] Videos play with Plyr player
- [ ] Username watermark appears on videos

---

## 🆘 Troubleshooting

### App won't start
```bash
# Check logs
journalctl -u albaqiacademy -f  # If systemd
tail -f /var/log/albaqiacademy.log  # If logging to file
```

### Database connection error
```bash
# Verify DATABASE_URL
grep DATABASE_URL .env

# Test connection
./venv/bin/python -c "import psycopg2; conn = psycopg2.connect('postgresql://postgres:AlBaqiAcademyGRE@db.yhladodtavcoawfhpeaa.supabase.co:5432/postgres'); print('✅ Connected!')"
```

### Videos don't play
```bash
# Check video files exist
ls -lh static/courses/
```

---

## 🔐 Important Notes

1. **Both local & VPS use SAME database** (Supabase)
   - Changes sync automatically
   - No manual database migration needed

2. **Videos stay on VPS** (not in database)
   - 4.8GB video files in `static/courses/`
   - Keep backing these up separately

3. **No more .db files in git**
   - Database is cloud-based
   - No merge conflicts

4. **Free tier limits** (you're safe):
   - 500MB database (using 0.05%)
   - 50,000 monthly active users (have 12)
   - 5GB bandwidth/month

---

## 📞 Quick Commands

### Backup Database (manual)
```bash
PGPASSWORD="AlBaqiAcademyGRE" pg_dump \
  -h db.yhladodtavcoawfhpeaa.supabase.co \
  -p 5432 -U postgres -d postgres \
  > backup_$(date +%Y%m%d).sql
```

### Check App Status
```bash
# Systemd
sudo systemctl status albaqiacademy

# Manual
ps aux | grep flask
```

### View App Logs
```bash
# Systemd
journalctl -u albaqiacademy -n 100

# Manual
tail -100 /var/log/albaqiacademy.log
```

### Restart Everything
```bash
sudo systemctl restart albaqiacademy  # or your service name
sudo systemctl restart nginx  # if using nginx
```

---

## 🎯 After Deployment

1. **Test login**: Use admin credentials
2. **Test course access**: Verify videos play
3. **Check watermark**: Your username should appear on videos
4. **Verify Plyr**: Speed controls, quality settings work

**Done!** Your app is now using Supabase! 🎉

---

## 📋 Connection Details (Keep Secure!)

```
Database Host: db.yhladodtavcoawfhpeaa.supabase.co
Database Port: 5432
Database Name: postgres
Username: postgres
Password: AlBaqiAcademyGRE

Full Connection String:
postgresql://postgres:AlBaqiAcademyGRE@db.yhladodtavcoawfhpeaa.supabase.co:5432/postgres
```

⚠️ **Keep this secure!** Don't commit to git or share publicly.
