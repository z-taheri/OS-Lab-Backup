#!/bin/bash

if [ $# -ne 4 ]; then
  echo "Usage: $0 <search_path> <file_extension> <backup_dir> <retention_days>"
  exit 1
fi

SEARCH_PATH=$1
FILE_EXT=$2
BACKUP_DIR=$3
RETENTION_DAYS=$4
