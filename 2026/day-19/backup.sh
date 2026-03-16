#!/bin/bashi
#set -euo pipefail
<<todo
Takes a source directory and backup destination as arguments
Creates a timestamped .tar.gz archive (e.g., backup-2026-02-08.tar.gz)
Verifies the archive was created successfully
Prints archive name and size
Deletes backups older than 14 days from the destination
Handles errors — exit if source doesn't exist

usage ./backup.sh <path of source dir> <path of backup dir>
todo

source_dir=$1
backup_dir=$2
timestamp=$(date +%Y-%m-%d)

display_usage(){
        echo "usage ./backup.sh <path of source dir> <path of backup dir>"

}

if [ $# -ne 0 ]
then
        display_usage
        exit 1
fi


if [ ! -d $source_dir ]
then
        echo "$source_dir does not exists..."
        exit 1
fi


if [ ! -d $backup_dir ]
then
        echo "$backup_dir does not exists..."
        exit 1
fi


archive_name="backup-$timestamp.tar.gz"
archive_files(){
        tar -czf "$backup_dir/$archive_name" "$source_dir"
}

if [ -f "$backup_dir/$archive_name" ]
then
     echo "Backup creeted successfully...."
else
     echo "Backup failed"
     exit 1
fi

echo "Archive name: $archive_name"
du -h "$backup_dir/$archive_name"

delete_older_backups(){
        find $backup_dir -name "backup-*.tar.gz" -mt +14 -delete
        echo Old backups older than 14 days deleted.."
}

archive_files
delete_older_backups
