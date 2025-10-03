#!/bin/bash

# Setup Cron Job for Database Backups
# This script adds a cron job to run database backups every 3 hours

# Determine the script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BACKUP_SCRIPT="$SCRIPT_DIR/backup_database.sh"
LOG_FILE="$SCRIPT_DIR/backups/backup.log"

# Ensure backup script exists and is executable
if [ ! -f "$BACKUP_SCRIPT" ]; then
    echo "❌ Error: Backup script not found at $BACKUP_SCRIPT"
    exit 1
fi

chmod +x "$BACKUP_SCRIPT"

# Create the cron job entry
CRON_JOB="0 */3 * * * $BACKUP_SCRIPT >> $LOG_FILE 2>&1"

echo "📋 Setting up automatic database backups..."
echo ""
echo "Cron job to add:"
echo "$CRON_JOB"
echo ""

# Check if cron job already exists
if crontab -l 2>/dev/null | grep -q "$BACKUP_SCRIPT"; then
    echo "⚠️  Cron job already exists for this backup script."
    echo ""
    echo "Current cron jobs:"
    crontab -l | grep "$BACKUP_SCRIPT"
    echo ""
    read -p "Do you want to remove and re-add it? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # Remove old entry
        crontab -l 2>/dev/null | grep -v "$BACKUP_SCRIPT" | crontab -
        echo "✅ Removed old cron job"
    else
        echo "ℹ️  Keeping existing cron job. Exiting."
        exit 0
    fi
fi

# Add new cron job
(crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -

if [ $? -eq 0 ]; then
    echo "✅ Cron job added successfully!"
    echo ""
    echo "Backup schedule: Every 3 hours (at :00 minutes)"
    echo "Next backups will run at: 00:00, 03:00, 06:00, 09:00, 12:00, 15:00, 18:00, 21:00"
    echo ""
    echo "📝 Logs will be written to: $LOG_FILE"
    echo ""
    echo "To verify cron job is installed:"
    echo "  crontab -l | grep backup_database"
    echo ""
    echo "To check backup logs:"
    echo "  tail -f $LOG_FILE"
    echo ""

    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "⚠️  NOTE (Mac): You may need to give cron Full Disk Access in System Preferences > Security & Privacy > Privacy"
    fi
else
    echo "❌ Failed to add cron job"
    exit 1
fi
