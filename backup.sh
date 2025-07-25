#!/bin/bash

if [ $# -ne 4 ]; then
  echo "Usage: $0 <search_path> <file_extension> <backup_dir> <retention_days>"
  exit 1
fi

SEARCH_PATH=$1
FILE_EXT=$2
BACKUP_DIR=$3
RETENTION_DAYS=$4

mkdir -p "$BACKUP_DIR"

CONF_FILE="$BACKUP_DIR/backup_$(date +'%Y-%m-%d_%H-%M-%S').conf"

find "$SEARCH_PATH" -type f -name "*$FILE_EXT" > "$CONF_FILE"

if [ ! -s "$CONF_FILE" ]; then
  echo "No files found with extension $FILE_EXT in $SEARCH_PATH"
  exit 1
fi

BACKUP_FILE="$BACKUP_DIR/backup_$(date +'%Y-%m-%d_%H-%M-%S').tar.gz"

START_TIME=$(date +%s)

tar -czf "$BACKUP_FILE" -T "$CONF_FILE"

END_TIME=$(date +%s)

BACKUP_SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
DURATION=$((END_TIME - START_TIME))

LOG_FILE="$BACKUP_DIR/backup.log"

echo "$(date): SUCCESS - Backup $BACKUP_FILE created (Size: $BACKUP_SIZE, Duration: $DURATION seconds)" >> "$LOG_FILE"
