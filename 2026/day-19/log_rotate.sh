#!/bin/bash

log_directory=$1

<<readme
usage ./log_rotate.sh <path of log directory>
readme

set -euo pipefail

display_usage(){
        echo "usage ./log_rotate.sh <path of log directory>"
}

if [ $# -eq 0 ]
then
        display_usage

fi


directory_existence_check(){
        if [ -d $log_directory ]
        then
                echo "Log rotation started"
        else
                echo "$log_directory does not exist...."
                exit 1
        fi
}
directory_existence_check

compress_older_log_files(){
 compressed=$(find $log_directory -name "*.log" -mtime +7 | wc -l)
 find $log_directory -name "*.log" -mtime +0 -exec gzip {} \;
}
