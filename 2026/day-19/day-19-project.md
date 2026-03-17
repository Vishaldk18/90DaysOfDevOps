cron commands

crontab -l - view cron jobs
crontan -e - edit crontab
crontab -r - remove all cron jobs
crontab -u username -e (edit another users cron (only root can do this))




#Backup & Rotation 

#!/bin/bash

<<readme
this is backup and 5 day rotation script

usage: ./backup_rotaion.sh <path of source> <path of backup>
readme

source_dir=$1
backup_dir=$2
timestamp=$(date +%Y-%m-%d-%H-%M-%S)

display_usage(){
        echo "usage: ./backup_rotaion.sh <path of source> <path of backup>"
}

if [ $# -eq 0 ]
then
        display_usage
fi


backup(){
   zip -r "${backup_dir}/backup_$timestamp.zip" "${source_dir}" > /dev/null
   if [ $? -eq 0 ]
   then
           echo "Backup created successfully"
   fi
}

backup

perform_rotation(){
        backup_list=($(ls -t ${backup_dir}/backup_*.zip)) 2> /dev/null
<<verification
        for zp in ${backup_list[@]}
        do
                echo $zp
        done
verification

        if [ "${#backup_list[@]}" -gt 5 ]
        then
                echo "Performing rotation"
                backups_to_remove=(${backup_list[@]:5})
                for file in ${backups_to_remove[@]}
                do
                        rm -f $file
                done
        fi


}


perform_rotation
