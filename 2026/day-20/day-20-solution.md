#!/bin/bash

<<TASK1
Task 1: Input and Validation
Your script should:

Accept the path to a log file as a command-line argument
Exit with a clear error message if no argument is provided
Exit with a clear error message if the file doesn't exist
TASK1

set -euo pipefail
log_file_path=$1
DATE=$(date +%Y-%m-%d)
REPORT="log_report_$DATE.txt"

if [ $# -eq 0 ]
then
        echo "Provide the log file path......"
        exit 1
fi

if [ -f $log_file_path ]
then
        echo "checking the log file...."
else
        echo "file does not exist"
fi

<<TASK2
Task 2: Error Count
Count the total number of lines containing the keyword ERROR or Failed
Print the total error count to the console

TASK2
error_count(){
   awk '/ERROR/' $log_file_path | wc -l
}
<<TASK3
Task 3: Critical Events
Search for lines containing the keyword CRITICAL
Print those lines along with their line number
Line 84: 2025-07-29 10:15:23 CRITICAL Disk space below threshold
Line 217: 2025-07-29 14:32:01 CRITICAL Database connection lost
TASK3

critical_events(){
 awk '/CRITICAL/ {print "Line" NR ": " $0}' $log_file_path
}
<<TASK4
Extract all lines containing ERROR
Identify the top 5 most common error messages
Display them with their occurrence count, sorted in descending order
--- Top 5 Error Messages ---
45 Connection timed out
32 File not found
28 Permission denied
15 Disk I/O error
9  Out of memory
TASK4
top_error_msg(){
awk '/ERROR/ {print $4,$5,$6}' $log_file_path | sort | uniq -c | sort -nr | head -3
}
<<TASK5
Generate a summary report to a text file named log_report_<date>.txt (e.g., log_report_2026-02-11.txt). The report should include:

Date of analysis
Log file name
Total lines processed
Total error count
Top 5 error messages with their occurrence count
List of critical events with line numbers

TASK5


<<TASK6
Task 6 (Optional): Archive Processed Logs
Add a feature to:

Create an archive/ directory if it doesn't exist
Move the processed log file into archive/ after analysis
Print a confirmation message

TASK6

archive_logfile(){
 mkdir -p archive
 mv $log_file_path archive/
 echo "Log file moved to archive"
}

main(){
 echo -e "Generating Report................"
 echo -e "--------------------------Date:$(date)--------------------------------\n" > $REPORT
 echo -e "--------------------------File Name:$0--------------------------------\n" >> $REPORT
 echo -e "-----------------------Total error count:$(error_count)---------------\n" >> $REPORT
 echo -e "------List of citical events with line numbers------------------------\n$(critical_events)" >> $REPORT
 echo -e "--------------------------Top 3 Error Messages------------------------\n$(top_error_msg)" >> $REPORT 
 archive_logfile
}

main "[$@]"
















sample log

2026-03-16 09:10:34 [WARNING]  - 22814
2026-03-16 09:10:34 [DEBUG]  - 3095
2026-03-16 09:10:34 [CRITICAL]  - 3264
2026-03-16 09:10:34 [WARNING]  - 20283
2026-03-16 09:10:34 [WARNING]  - 16699
2026-03-16 09:10:34 [CRITICAL]  - 25368
2026-03-16 09:10:34 [DEBUG]  - 14437
2026-03-16 09:10:34 [WARNING]  - 9105
2026-03-16 09:10:34 [WARNING]  - 13210
2026-03-16 09:10:34 [CRITICAL]  - 11779
2026-03-16 09:10:34 [INFO]  - 32462
2026-03-16 09:10:34 [INFO]  - 7597
2026-03-16 09:10:34 [CRITICAL]  - 27573
2026-03-16 09:10:34 [INFO]  - 3307
2026-03-16 09:10:34 [CRITICAL]  - 26552
2026-03-16 09:10:34 [ERROR] Segmentation fault - 16011
2026-03-16 09:10:34 [INFO]  - 2438
2026-03-16 09:10:34 [DEBUG]  - 20863
2026-03-16 09:10:34 [DEBUG]  - 23540
2026-03-16 09:10:34 [ERROR] Out of memory - 16606
2026-03-16 09:10:34 [CRITICAL]  - 18352
2026-03-16 09:10:34 [ERROR] Failed to connect - 20563
2026-03-16 09:10:34 [WARNING]  - 24342
2026-03-16 09:10:34 [ERROR] Invalid input - 32441
2026-03-16 09:10:34 [DEBUG]  - 2773
2026-03-16 09:10:34 [INFO]  - 5077
2026-03-16 09:10:34 [WARNING]  - 22746
2026-03-16 09:10:34 [ERROR] Out of memory - 12763
2026-03-16 09:10:34 [ERROR] Out of memory - 12783
2026-03-16 09:10:34 [ERROR] Segmentation fault - 26185
2026-03-16 09:10:34 [WARNING]  - 27857
2026-03-16 09:10:34 [CRITICAL]  - 29015
2026-03-16 09:10:34 [INFO]  - 21759
2026-03-16 09:10:34 [ERROR] Out of memory - 19557
2026-03-16 09:10:34 [CRITICAL]  - 29098
2026-03-16 09:10:34 [WARNING]  - 20546
2026-03-16 09:10:34 [INFO]  - 25716
2026-03-16 09:10:34 [INFO]  - 11778
2026-03-16 09:10:34 [ERROR] Segmentation fault - 2846
2026-03-16 09:10:34 [DEBUG]  - 11810
2026-03-16 09:10:34 [INFO]  - 16994
2026-03-16 09:10:34 [DEBUG]  - 32524
2026-03-16 09:10:34 [ERROR] Invalid input - 1164
2026-03-16 09:10:34 [CRITICAL]  - 8863
2026-03-16 09:10:34 [ERROR] Failed to connect - 13742
2026-03-16 09:10:34 [WARNING]  - 12035
2026-03-16 09:10:34 [WARNING]  - 29633
2026-03-16 09:10:34 [CRITICAL]  - 6593
2026-03-16 09:10:34 [ERROR] Out of memory - 1973
2026-03-16 09:10:34 [ERROR] Out of memory - 24665
2026-03-16 09:10:34 [INFO]  - 24639
2026-03-16 09:10:34 [ERROR] Disk full - 16116
2026-03-16 09:10:34 [WARNING]  - 30574
2026-03-16 09:10:34 [WARNING]  - 15853
2026-03-16 09:10:34 [DEBUG]  - 18653
2026-03-16 09:10:34 [INFO]  - 28234
2026-03-16 09:10:34 [INFO]  - 14881
2026-03-16 09:10:34 [WARNING]  - 27743
2026-03-16 09:10:34 [CRITICAL]  - 19556
2026-03-16 09:10:34 [INFO]  - 21203
2026-03-16 09:10:34 [ERROR] Failed to connect - 5430
2026-03-16 09:10:34 [WARNING]  - 32641
2026-03-16 09:10:34 [WARNING]  - 24871
2026-03-16 09:10:34 [CRITICAL]  - 10341
2026-03-16 09:10:34 [CRITICAL]  - 5531
2026-03-16 09:10:34 [ERROR] Out of memory - 9770
2026-03-16 09:10:34 [DEBUG]  - 25408
2026-03-16 09:10:34 [ERROR] Out of memory - 5778
2026-03-16 09:10:34 [DEBUG]  - 396
2026-03-16 09:10:34 [ERROR] Disk full - 2975
2026-03-16 09:10:34 [INFO]  - 12508
2026-03-16 09:10:34 [INFO]  - 28713
2026-03-16 09:10:34 [WARNING]  - 9289
2026-03-16 09:10:34 [INFO]  - 10294
2026-03-16 09:10:34 [CRITICAL]  - 9038
2026-03-16 09:10:34 [CRITICAL]  - 29264
2026-03-16 09:10:34 [CRITICAL]  - 2403
2026-03-16 09:10:34 [ERROR] Failed to connect - 14321
2026-03-16 09:10:34 [DEBUG]  - 29507
2026-03-16 09:10:34 [ERROR] Invalid input - 2096
2026-03-16 09:10:34 [WARNING]  - 19478
2026-03-16 09:10:34 [DEBUG]  - 21756
2026-03-16 09:10:34 [WARNING]  - 19711
2026-03-16 09:10:34 [WARNING]  - 12127
2026-03-16 09:10:34 [WARNING]  - 14984
2026-03-16 09:10:34 [ERROR] Failed to connect - 17880
2026-03-16 09:10:34 [ERROR] Failed to connect - 14743
2026-03-16 09:10:34 [WARNING]  - 16511
2026-03-16 09:10:34 [ERROR] Segmentation fault - 16484
2026-03-16 09:10:34 [ERROR] Segmentation fault - 24822
2026-03-16 09:10:34 [INFO]  - 16296
2026-03-16 09:10:34 [CRITICAL]  - 20519
2026-03-16 09:10:34 [CRITICAL]  - 28582
2026-03-16 09:10:34 [INFO]  - 15060
2026-03-16 09:10:34 [WARNING]  - 25906
2026-03-16 09:10:34 [INFO]  - 9887
2026-03-16 09:10:34 [WARNING]  - 15791
2026-03-16 09:10:34 [CRITICAL]  - 2240
2026-03-16 09:10:34 [WARNING]  - 2247
2026-03-16 09:10:34 [INFO]  - 29558
