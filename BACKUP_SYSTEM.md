# 🔄 Automatic Database Backup System

✅ **Status**: Active and configured
📅 **Schedule**: Every 3 hours (00:00, 03:00, 06:00, 09:00, 12:00, 15:00, 18:00, 21:00)
💾 **Retention**: 20 most recent backups
📁 **Location**: `backups/`

---

## 📋 Quick Reference

### Check Backup Status
```bash
# List all backups
ls -lh backups/*.db

# Count backups
ls -1 backups/*.db | wc -l

# Check most recent backup
ls -lt backups/*.db | head -1

# Check backup logs
tail -f backups/backup.log
```

### Manual Backup
```bash
./backup_database.sh
```

### Verify Cron Job
```bash
# List cron jobs
crontab -l

# Check specific backup job
crontab -l | grep backup_database
```

### Restore from Backup
```bash
# 1. STOP Flask app first!

# 2. Backup current database (safety)
cp instance/site.db instance/site.db.before-restore

# 3. List available backups
ls -lt backups/*.db

# 4. Restore (replace timestamp with your chosen backup)
cp backups/site_db_2025-10-01_15-43-28.db instance/site.db

# 5. Restart Flask app
```

---

## 🚀 Setup on New Server (Ubuntu VPS)

When deploying to your IONOS VPS, run these commands:

```bash
# 1. Navigate to project directory
cd /root/mlasjadweb/web1

# 2. Create backups directory
mkdir -p backups

# 3. Make scripts executable
chmod +x backup_database.sh setup_backup_cron.sh

# 4. Test backup manually
./backup_database.sh

# 5. Setup cron job
./setup_backup_cron.sh

# 6. Verify cron is installed
crontab -l | grep backup_database
```

---

## 🔍 Troubleshooting

### Cron job not running?

**Mac:**
```bash
# Check if cron has Full Disk Access
# System Preferences > Security & Privacy > Privacy > Full Disk Access
# Add /usr/sbin/cron

# Check cron logs
log show --predicate 'process == "cron"' --last 1h --info
```

**Ubuntu:**
```bash
# Check cron service status
systemctl status cron

# Check cron logs
grep CRON /var/log/syslog | tail -20

# Restart cron service
sudo systemctl restart cron
```

### Permission issues?
```bash
chmod +x backup_database.sh
chmod 755 backups/
```

### Test cron timing
```bash
# Add a test job that runs every minute
crontab -e
# Add: * * * * * echo "Test $(date)" >> /tmp/crontest.log

# Wait 1-2 minutes then check
cat /tmp/crontest.log

# Remove test job after verification
crontab -e
```

---

## 📊 Backup Details

### File Naming Convention
`site_db_YYYY-MM-DD_HH-MM-SS.db`

Example: `site_db_2025-10-01_15-43-28.db`

### Backup Method
Uses SQLite's `.backup` command which:
- ✅ Handles database locks safely
- ✅ Creates consistent snapshots
- ✅ Works even if app is running
- ✅ Better than simple `cp` command

### Storage
- Each backup: ~100-200KB
- 20 backups: ~2-4MB total
- Minimal disk space usage

### Retention Policy
- Keeps 20 most recent backups
- Automatically deletes older backups
- FIFO (First In, First Out) rotation

---

## 🔐 Important Notes

1. **Before Restoring**: Always stop the Flask app first
2. **Test Restores**: Periodically test that backups can be restored
3. **Monitor Disk Space**: Check `du -sh backups/` occasionally
4. **Backup the Backups**: Consider backing up the `backups/` folder to cloud storage
5. **Log Rotation**: The `backup.log` file will grow over time - consider rotating it

---

## 📱 Monitoring

### Check Last Backup
```bash
# Last successful backup timestamp
ls -lt backups/*.db | head -1 | awk '{print $6, $7, $8}'
```

### Check Backup Health
```bash
# Verify newest backup is readable
sqlite3 "$(ls -t backups/*.db | head -1)" "SELECT COUNT(*) FROM user;"
```

### Disk Usage
```bash
du -sh backups/
```

---

## 🛠 Advanced Configuration

### Change Backup Frequency

Edit cron job:
```bash
crontab -e
```

Common schedules:
- Every hour: `0 * * * *`
- Every 3 hours: `0 */3 * * *` ← Current
- Every 6 hours: `0 */6 * * *`
- Daily at 2am: `0 2 * * *`

### Change Retention Period

Edit `backup_database.sh`:
```bash
MAX_BACKUPS=20  # Change to desired number
```

Then:
```bash
./backup_database.sh  # Run to apply new setting
```

---

## ✅ Verification Checklist

- [x] Backups directory exists
- [x] Backup script is executable
- [x] Cron job is installed
- [x] Manual backup works
- [x] Cleanup works (keeps only 20)
- [x] Logs are being written

**Next cron run**: Check with `date` and wait for next :00 hour divisible by 3

---

## 📞 Support

If backups fail:
1. Check logs: `tail -20 backups/backup.log`
2. Test manually: `./backup_database.sh`
3. Verify permissions: `ls -la backup_database.sh`
4. Check cron: `crontab -l`
5. Check disk space: `df -h`
