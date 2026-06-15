# Backup Script Using tar.gz with 14-Day Rotation

## Objective

Create a Bash script that:

* Takes a source directory and backup directory as arguments.
* Creates a timestamped `.tar.gz` archive.
* Verifies backup creation.
* Displays archive name and size.
* Deletes backups older than 14 days.
* Handles invalid inputs and missing directories.

```bash
#!/bin/bash

set -euo pipefail

source_dir=$1
backup_dir=$2
timestamp=$(date +%Y-%m-%d)

display_usage() {
    echo "Usage: ./backup.sh <path_of_source_dir> <path_of_backup_dir>"
}

if [ $# -ne 2 ]
then
    display_usage
    exit 1
fi

if [ ! -d "$source_dir" ]
then
    echo "Source directory does not exist: $source_dir"
    exit 1
fi

if [ ! -d "$backup_dir" ]
then
    echo "Backup directory does not exist: $backup_dir"
    exit 1
fi

archive_name="backup-$timestamp.tar.gz"

archive_files() {

    tar -czf "$backup_dir/$archive_name" "$source_dir"

    if [ -f "$backup_dir/$archive_name" ]
    then
        echo "Backup created successfully"
    else
        echo "Backup failed"
        exit 1
    fi
}

delete_older_backups() {

    find "$backup_dir" \
         -name "backup-*.tar.gz" \
         -mtime +14 \
         -delete

    echo "Old backups older than 14 days deleted"
}

archive_files

echo "Archive Name: $archive_name"

du -h "$backup_dir/$archive_name"

delete_older_backups
```

---

# Command Explanation

## tar

```bash
tar -czf backup.tar.gz source_dir
```

### Options

| Option | Meaning             |
| ------ | ------------------- |
| -c     | Create archive      |
| -z     | Compress using gzip |
| -f     | Specify filename    |

---

## du

```bash
du -h backup.tar.gz
```

Displays archive size in human-readable format.

Example:

```text
12M backup-2026-06-15.tar.gz
```

---

## find

```bash
find backup_dir -name "backup-*.tar.gz" -mtime +14
```

Finds backups older than 14 days.

### Options

| Option     | Meaning                |
| ---------- | ---------------------- |
| -name      | Match filename pattern |
| -mtime +14 | Older than 14 days     |
| -delete    | Remove file            |

---

# Example Usage

```bash
chmod +x backup.sh

./backup.sh /var/log /backup
```

Example Output:

```text
Backup created successfully

Archive Name: backup-2026-06-15.tar.gz

15M /backup/backup-2026-06-15.tar.gz

Old backups older than 14 days deleted
```

---

# Real-World DevOps Use Cases

* Application log backups
* Database dump backups
* Configuration backups
* Server migration backups
* Disaster recovery planning

---

# Key Learnings

1. `tar -czf` is commonly used to create compressed Linux backups.
2. `find -mtime` helps implement backup retention policies.
3. Always validate user inputs before processing.
4. Use `set -euo pipefail` for safer Bash scripts.
5. Backup rotation prevents storage from filling with old archives.
