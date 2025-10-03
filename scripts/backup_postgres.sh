#!/usr/bin/env bash
# Backup the PostgreSQL database defined by DATABASE_URL.
# Outputs compressed custom-format dumps and prunes old files.

set -euo pipefail

# Configuration --------------------------------------------------------------
BINDIR_CANDIDATES=(
  "${PG_DUMP_BIN:-}"
  "$(command -v pg_dump 2>/dev/null || true)"
  "/opt/homebrew/opt/postgresql@15/bin/pg_dump"
  "/usr/lib/postgresql/15/bin/pg_dump"
  "/usr/lib/postgresql/14/bin/pg_dump"
  "/usr/bin/pg_dump"
)

PG_DUMP_BIN=""
for candidate in "${BINDIR_CANDIDATES[@]}"; do
  if [[ -n "$candidate" && -x "$candidate" ]]; then
    PG_DUMP_BIN="$candidate"
    break
  fi
done

if [[ -z "$PG_DUMP_BIN" ]]; then
  echo "ERROR: Could not locate pg_dump. Set PG_DUMP_BIN or ensure it is on PATH." >&2
  exit 1
fi

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

echo "Creating backup: $OUT_FILE (using $PG_DUMP_BIN)"
"$PG_DUMP_BIN" -Fc "$PG_URL" > "$OUT_FILE"

echo "Backup complete ($(du -h "$OUT_FILE" | cut -f1))"

echo "Pruning old backups (keeping $MAX_BACKUPS)"

# Use mapfile when available (bash 4+); fall back to simple iteration
shopt -s nullglob
FILES=("$BACKUP_DIR"/mlasjad_*.dump)
IFS=$'\n' FILES=($(printf '%s\n' "${FILES[@]}" | sort -r))
shopt -u nullglob
COUNT=${#FILES[@]}

if (( COUNT > MAX_BACKUPS )); then
  for file in "${FILES[@]:MAX_BACKUPS}"; do
    echo "Deleting $file"
    rm -f -- "$file"
  done
fi

echo "Current backups:"
ls -lh "$BACKUP_DIR"
