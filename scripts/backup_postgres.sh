#!/usr/bin/env bash
# Backup the PostgreSQL database defined by DATABASE_URL.
# Outputs compressed custom-format dumps and prunes old files.

set -euo pipefail

# Configuration --------------------------------------------------------------
BACKUP_DIR=${BACKUP_DIR:-"$(pwd)/backups/postgres"}
MAX_BACKUPS=${MAX_BACKUPS:-14}

if [[ -z "${DATABASE_URL:-}" ]]; then
  echo "ERROR: DATABASE_URL is not set." >&2
  exit 1
fi

# Normalize SQLAlchemy-style URL to a libpq URL for pg_dump
PG_URL=${DATABASE_URL/postgresql+psycopg2:/postgresql:}

mkdir -p "$BACKUP_DIR"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
OUT_FILE="$BACKUP_DIR/mlasjad_${TIMESTAMP}.dump"

echo "Creating backup: $OUT_FILE"
pg_dump -Fc "$PG_URL" > "$OUT_FILE"

echo "Backup complete ($(du -h "$OUT_FILE" | cut -f1))"

echo "Pruning old backups (keeping $MAX_BACKUPS)"
mapfile -t FILES < <(ls -1t "$BACKUP_DIR"/mlasjad_*.dump 2>/dev/null)
if (( ${#FILES[@]} > MAX_BACKUPS )); then
  for file in "${FILES[@]:MAX_BACKUPS}"; do
    echo "Deleting $file"
    rm -f -- "$file"
  done
fi

echo "Current backups:"
ls -lh "$BACKUP_DIR"
