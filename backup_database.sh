#!/bin/bash

# SQLite Database Backup Script
# Works on both Mac (dev) and Ubuntu VPS (production)
# Backs up the database every 3 hours and keeps only the 20 most recent backups

# Determine the script directory (works on both Mac and Linux)
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Database and backup configuration
DB_FILE="$SCRIPT_DIR/instance/site.db"
BACKUP_DIR="$SCRIPT_DIR/backups"
MAX_BACKUPS=20

# Create backups directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Check if database exists
if [ ! -f "$DB_FILE" ]; then
    echo "ERROR: Database file not found at $DB_FILE"
    exit 1
fi

# Generate timestamp for backup filename
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="$BACKUP_DIR/site_db_$TIMESTAMP.db"

# Create backup using SQLite's backup command for safe backup
# This is safer than cp because it handles database locks properly
if command -v sqlite3 &> /dev/null; then
    # Use SQLite's backup command (preferred method)
    sqlite3 "$DB_FILE" ".backup '$BACKUP_FILE'"
    BACKUP_STATUS=$?
else
    # Fallback to cp if sqlite3 command not available
    cp "$DB_FILE" "$BACKUP_FILE"
    BACKUP_STATUS=$?
fi

if [ $BACKUP_STATUS -eq 0 ]; then
    echo "✅ Backup created successfully: $BACKUP_FILE"

    # Get backup file size
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # Mac
        SIZE=$(stat -f%z "$BACKUP_FILE")
    else
        # Linux
        SIZE=$(stat -c%s "$BACKUP_FILE")
    fi
    echo "   Size: $(numfmt --to=iec-i --suffix=B $SIZE 2>/dev/null || echo "${SIZE} bytes")"
else
    echo "❌ Backup failed!"
    exit 1
fi

# Clean up old backups - keep only the most recent MAX_BACKUPS
# Count current backups
BACKUP_COUNT=$(ls -1 "$BACKUP_DIR"/site_db_*.db 2>/dev/null | wc -l | tr -d ' ')

if [ "$BACKUP_COUNT" -gt "$MAX_BACKUPS" ]; then
    echo "🗑  Cleaning up old backups (keeping $MAX_BACKUPS most recent)..."

    # Remove oldest backups
    ls -t "$BACKUP_DIR"/site_db_*.db | tail -n +$((MAX_BACKUPS + 1)) | while read -r file; do
        rm -f "$file"
        echo "   Deleted: $(basename "$file")"
    done
fi

# Show current backup status
TOTAL_BACKUPS=$(ls -1 "$BACKUP_DIR"/site_db_*.db 2>/dev/null | wc -l | tr -d ' ')
echo "📊 Total backups: $TOTAL_BACKUPS/$MAX_BACKUPS"

exit 0
