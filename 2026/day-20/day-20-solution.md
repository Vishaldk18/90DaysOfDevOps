# Log Analysis Script Challenge

## Objective

Create a Bash script that:

* Accepts a log file as input.
* Validates the input file.
* Counts errors.
* Displays critical events with line numbers.
* Identifies top error messages.
* Generates a summary report.
* Archives processed logs.

---

# Script

```bash
#!/bin/bash

set -euo pipefail

log_file_path=$1
DATE=$(date +%Y-%m-%d)
REPORT="log_report_$DATE.txt"

# Input Validation

if [ $# -eq 0 ]
then
    echo "Provide the log file path..."
    exit 1
fi

if [ -f "$log_file_path" ]
then
    echo "Checking the log file..."
else
    echo "File does not exist"
    exit 1
fi

# Count Errors

error_count(){
    awk '/ERROR/' "$log_file_path" | wc -l
}

# Critical Events

critical_events(){
    awk '/CRITICAL/ {print "Line " NR ": " $0}' "$log_file_path"
}

# Top Error Messages

top_error_msg(){
    awk '/ERROR/ {print $4,$5,$6}' "$log_file_path" \
    | sort \
    | uniq -c \
    | sort -nr \
    | head -5
}

# Archive Log File

archive_logfile(){
    mkdir -p archive
    mv "$log_file_path" archive/
    echo "Log file moved to archive"
}

# Main Function

main(){

    echo "Generating Report..."

    echo "Date of Analysis: $(date)" > "$REPORT"

    echo "Log File: $log_file_path" >> "$REPORT"

    echo "Total Lines Processed: $(wc -l < "$log_file_path")" >> "$REPORT"

    echo "Total Error Count: $(error_count)" >> "$REPORT"

    echo "" >> "$REPORT"

    echo "Top 5 Error Messages" >> "$REPORT"
    echo "--------------------" >> "$REPORT"
    top_error_msg >> "$REPORT"

    echo "" >> "$REPORT"

    echo "Critical Events" >> "$REPORT"
    echo "---------------" >> "$REPORT"
    critical_events >> "$REPORT"

    archive_logfile
}

main "$@"
```

---

# Task 1: Input Validation

### Requirements

* Accept log file path as argument.
* Exit if no argument is supplied.
* Exit if file does not exist.

### Example

```bash
./log_analyzer.sh app.log
```

If file does not exist:

```text
File does not exist
```

---

# Task 2: Error Count

### Function

```bash
error_count(){
    awk '/ERROR/' "$log_file_path" | wc -l
}
```

### Purpose

Counts all lines containing:

```text
ERROR
```

### Sample Result

From the provided log:

```text
Total ERROR entries = 18
```

---

# Task 3: Critical Events

### Function

```bash
critical_events(){
    awk '/CRITICAL/ {print "Line " NR ": " $0}' "$log_file_path"
}
```

### Sample Output

```text
Line 3: 2026-03-16 09:10:34 [CRITICAL] - 3264
Line 6: 2026-03-16 09:10:34 [CRITICAL] - 25368
Line 10: 2026-03-16 09:10:34 [CRITICAL] - 11779
...
```

---

# Task 4: Top Error Messages

### Function

```bash
top_error_msg(){
    awk '/ERROR/ {print $4,$5,$6}' "$log_file_path" \
    | sort \
    | uniq -c \
    | sort -nr \
    | head -5
}
```

### Output from Sample Log

```text
7 Out of memory -
6 Failed to connect
4 Segmentation fault -
3 Invalid input -
2 Disk full -
```

---

# Task 5: Report Generation

Generated Report:

```text
log_report_2026-06-15.txt
```

### Example Content

```text
Date of Analysis: Sun Jun 15 10:30:00 UTC 2026

Log File: sample.log

Total Lines Processed: 100

Total Error Count: 22

Top 5 Error Messages
--------------------
7 Out of memory -
6 Failed to connect
4 Segmentation fault -
3 Invalid input -
2 Disk full -

Critical Events
---------------
Line 3: 2026-03-16 09:10:34 [CRITICAL] - 3264
Line 6: 2026-03-16 09:10:34 [CRITICAL] - 25368
...
```

---

# Task 6: Archive Processed Logs

### Function

```bash
archive_logfile(){
    mkdir -p archive
    mv "$log_file_path" archive/
    echo "Log file moved to archive"
}
```

### Result

```text
archive/
└── sample.log
```

---

# Issues Found in Original Script

### 1. Argument Validation

Current:

```bash
if [ $# -eq 0 ]
```

Problem:

```bash
log_file_path=$1
```

is executed before validation.

Better:

```bash
if [ $# -ne 1 ]
then
    echo "Usage: ./script.sh <logfile>"
    exit 1
fi

log_file_path=$1
```

---

### 2. Missing Exit When File Doesn't Exist

Current:

```bash
echo "file does not exist"
```

Should be:

```bash
echo "file does not exist"
exit 1
```

---

### 3. Top Error Messages

Current:

```bash
head -3
```

Requirement:

```text
Top 5 Error Messages
```

Use:

```bash
head -5
```

---

# Commands Used

```bash
awk
wc
sort
uniq
head
mkdir
mv
date
```
