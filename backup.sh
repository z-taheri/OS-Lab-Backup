#!/bin/bash
# Check arguments
if [ "$#" -lt 4 ]; then
    echo "Usage: $0 <search_path> <file_extension> <backup_dir> <retention_days>"
    exit 1
fi

SEARCH_PATH="$1"
FILE_EXT="$2"
BACKUP_DIR="$3"
RETENTION_DAYS="$4"

# Create backup directory if not exists
mkdir -p "$BACKUP_DIR"

# File names
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
CONF_FILE="$BACKUP_DIR/backup_$TIMESTAMP.conf"
BACKUP_FILE="$BACKUP_DIR/backup_$TIMESTAMP.tar.gz"
LOG_FILE="$BACKUP_DIR/backup.log"

# Start timer
START_TIME=$(date +%s)

# Find files and save to conf
find "$SEARCH_PATH" -type f -name "*$FILE_EXT" > "$CONF_FILE"

# Check if any files found
if [ ! -s "$CONF_FILE" ]; then
    echo "$(date): ERROR - No files with extension $FILE_EXT found." >> "$LOG_FILE"
    exit 1
fi

# Create compressed backup
tar -czf "$BACKUP_FILE" -T "$CONF_FILE"

# Calculate duration and size
END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))
FILE_SIZE=$(du -h "$BACKUP_FILE" | cut -f1)

# Log the result
echo "$(date): SUCCESS - Backup $BACKUP_FILE created (Size: $FILE_SIZE, Time: $DURATION seconds)" >> "$LOG_FILE"

# Remove old backups
find "$BACKUP_DIR" -name "*.tar.gz" -type f -mtime +$RETENTION_DAYS -exec rm {} \;
