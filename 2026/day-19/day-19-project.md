# Cron Jobs and Backup Rotation Script Notes

# Cron Commands

Cron is a time-based job scheduler in Linux used to automate repetitive tasks such as backups, monitoring, log cleanup, and report generation.

## Common Crontab Commands

### View Existing Cron Jobs

```bash id="jajwjf"
crontab -l
```

Displays all cron jobs configured for the current user.

---

### Edit Cron Jobs

```bash id="lbcmff"
crontab -e
```

Opens the user's crontab file in the default editor.

---

### Remove All Cron Jobs

```bash id="7w7q2w"
crontab -r
```

Deletes all cron jobs for the current user.

⚠️ Use carefully because all scheduled jobs will be removed.

---

### Edit Another User's Cron Jobs

```bash id="1aym2e"
sudo crontab -u username -e
```

Used by root to edit another user's crontab.

Example:

```bash id="8mpd1n"
sudo crontab -u vishal -e
```

---

## Cron Schedule Format

```text id="sah4wa"
* * * * * command
│ │ │ │ │
│ │ │ │ └── Day of Week (0-7)
│ │ │ └──── Month (1-12)
│ │ └────── Day of Month (1-31)
│ └──────── Hour (0-23)
└────────── Minute (0-59)
```

### Examples

Run every day at midnight:

```cron id="8ppfcd"
0 0 * * * /home/user/backup.sh
```

Run every 5 minutes:

```cron id="1l6xfh"
*/5 * * * * /home/user/monitor.sh
```

Run every Sunday at 2 AM:

```cron id="92t97l"
0 2 * * 0 /home/user/cleanup.sh
```

---

# Backup and Rotation Script

## Purpose

This script:

1. Creates a ZIP backup of a source directory.
2. Stores the backup in a backup directory.
3. Maintains only the latest 5 backups.
4. Automatically deletes older backups.

---

## Complete Script

```bash id="0zvhjz"
#!/bin/bash

<<readme
This is a backup and 5-day rotation script.

Usage:
./backup_rotation.sh <path_of_source> <path_of_backup>
readme

source_dir=$1
backup_dir=$2
timestamp=$(date +%Y-%m-%d-%H-%M-%S)

display_usage() {
    echo "Usage: ./backup_rotation.sh <path_of_source> <path_of_backup>"
}

if [ $# -eq 0 ]
then
    display_usage
    exit 1
fi

backup() {

    zip -r "${backup_dir}/backup_$timestamp.zip" "${source_dir}" > /dev/null

    if [ $? -eq 0 ]
    then
        echo "Backup created successfully"
    fi
}

backup

perform_rotation() {

    backup_list=($(ls -t ${backup_dir}/backup_*.zip 2>/dev/null))

    if [ "${#backup_list[@]}" -gt 5 ]
    then

        echo "Performing rotation"

        backups_to_remove=(${backup_list[@]:5})

        for file in ${backups_to_remove[@]}
        do
            rm -f "$file"
            echo "Deleted: $file"
        done

    fi
}

perform_rotation
```

---

# Script Explanation

## Step 1: Input Parameters

```bash id="ffj6r4"
source_dir=$1
backup_dir=$2
```

### Meaning

| Variable | Purpose                      |
| -------- | ---------------------------- |
| $1       | Source directory to back up  |
| $2       | Backup destination directory |

Example:

```bash id="z1e0kt"
./backup_rotation.sh /var/log /backup
```

---

## Step 2: Generate Timestamp

```bash id="eodw0j"
timestamp=$(date +%Y-%m-%d-%H-%M-%S)
```

Example:

```text id="q5jbqv"
2026-06-15-10-30-25
```

Used to create unique backup filenames.

---

## Step 3: Usage Function

```bash id="wszx6r"
display_usage() {
    echo "Usage: ./backup_rotation.sh <path_of_source> <path_of_backup>"
}
```

Displays usage instructions if parameters are missing.

---

## Step 4: Validate Arguments

```bash id="mx1s71"
if [ $# -eq 0 ]
then
    display_usage
fi
```

### Explanation

```bash id="tv6rmw"
$#
```

Returns the number of arguments passed.

Example:

```bash id="3gxu3f"
./backup_rotation.sh
```

Output:

```text id="7fd8jp"
Usage: ./backup_rotation.sh <path_of_source> <path_of_backup>
```

---

## Step 5: Create Backup

```bash id="q0hxrl"
zip -r "${backup_dir}/backup_$timestamp.zip" "${source_dir}"
```

### Options

| Option | Meaning                            |
| ------ | ---------------------------------- |
| zip    | Create ZIP archive                 |
| -r     | Recursive (include subdirectories) |

Example Output:

```text id="2v6sc1"
backup_2026-06-15-10-30-25.zip
```

---

## Step 6: Verify Backup Success

```bash id="duyl6m"
if [ $? -eq 0 ]
```

### Explanation

```bash id="6k26h3"
$?
```

Returns the exit status of the previous command.

| Exit Code | Meaning |
| --------- | ------- |
| 0         | Success |
| Non-zero  | Failure |

---

## Step 7: Backup Rotation Logic

### List Existing Backups

```bash id="2lw2kw"
backup_list=($(ls -t ${backup_dir}/backup_*.zip))
```

### Option

```bash id="y1cjk5"
-t
```

Sort files by modification time (newest first).

Example:

```text id="jlwmc0"
backup_6.zip
backup_5.zip
backup_4.zip
backup_3.zip
backup_2.zip
backup_1.zip
```

---

### Count Backups

```bash id="d34tp7"
${#backup_list[@]}
```

Returns the number of backup files.

---

### Keep Only Latest 5

```bash id="4h8i7e"
backups_to_remove=(${backup_list[@]:5})
```

### Explanation

Keeps:

```text id="t5l2w9"
backup_6.zip
backup_5.zip
backup_4.zip
backup_3.zip
backup_2.zip
```

Deletes:

```text id="9kxl43"
backup_1.zip
```

---

### Delete Old Backups

```bash id="5m09ps"
for file in ${backups_to_remove[@]}
do
    rm -f "$file"
done
```

### Options

| Option | Meaning        |
| ------ | -------------- |
| rm     | Remove file    |
| -f     | Force deletion |

---

# How to Schedule Using Cron

Edit crontab:

```bash id="o8jvry"
crontab -e
```

Run backup every day at 1 AM:

```cron id="8s54p8"
0 1 * * * /home/user/backup_rotation.sh /var/log /backup
```

---

# Example Execution

```bash id="a04cwb"
chmod +x backup_rotation.sh

./backup_rotation.sh /var/log /backup
```

Output:

```text id="28v5xa"
Backup created successfully
Performing rotation
Deleted: backup_2026-06-01-10-00-00.zip
```

---

# Real-World DevOps Use Cases

* Application log backups
* Database backup archives
* Configuration backups
* Automated server maintenance
* Retention and cleanup policies

---

# Key Learnings

1. Cron automates repetitive administrative tasks.
2. Backup rotation prevents storage from filling up with old backups.
3. Timestamps help create unique backup files.
4. Arrays and loops make it easy to manage multiple backup files.
5. Combining Bash scripts with Cron is a common DevOps automation practice.
