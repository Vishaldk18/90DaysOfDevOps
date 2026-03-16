#!/bin/bash

greet(){
  #read -p "Enter your name:" name
  echo "Hello, $1"
}



sum(){
  #read -p "Enter num1:" num1
  #read -p "Enter num2:" num2

  echo "sum is: $(( $1 + $2 ))"
}

greet vishal
sum 10 20




#!/bin/bash

check_disk(){
 
        used_disk=$(df -h / | awk 'NR==2 {print $2}' )
        echo "Used disk: $used_disk"
}


check_memory(){
        available_memory=$(free -h | awk 'NR==2 {print $4}')
        echo "Avaialble memory: $available_memory"
}



check_memory
check_disk


#!/bin/bash
set -euo pipefail

#set -u
#echo $name

#set -e
#cd kmmm
#echo "welcome tho devops"

#set -o pipefail
#false | true
#echo $?
~          
-e → exit on error
-u → error on unset variables
pipefail → pipelines fail correctly
By default, Bash sets a pipeline’s exit status to the exit status of the last command only.
This can hide failures earlier in the pipeline.


#!/bin/bash
 
demo_function() {
    local name="Vishal"
    echo "Inside function: $name"
}
 
demo_function
 
echo "Outside function: $name"


#!/bin/bash
 
demo_function() {
    name="Vishal"
    echo "Inside function: $name"
}
 
demo_function
 
echo "Outside function: $name"


many commands to get hostname and os info
hostname - get hosname only
uname - get kernel name
uname -n - get hostname
uname -a : get kernel,os,architecture,hostname and system info
cat /etc/os-release: to info specific to os
hostnamectl : shows hostname + os + kernel + architecutre


ps aux --sort=-%cpu | head -n 6
 
This command shows the top 5 CPU consuming processes in Linux.
 
 
---
 
1️⃣ ps
 
ps = Process Status
 
It displays information about running processes in the system.
 
 
---
 
2️⃣ a
 
Shows processes of all users that are attached to a terminal.
 
 
---
 
3️⃣ u
 
Displays output in user-oriented format with detailed columns like:
 
USER
 
PID
 
%CPU
 
%MEM
 
VSZ
 
RSS
 
START
 
TIME
 
COMMAND
 
 
 
---
 
4️⃣ x
 
Includes processes without a terminal (TTY) such as:
 
system services
 
daemons
Example: sshd, systemd, cron
 
 
So ps aux shows almost all processes in the system.
 
 
---
 
5️⃣ --sort=-%cpu
 
Sorts the output based on CPU usage.
 
%cpu → CPU utilization column
 
- → descending order (highest first)
 
 
So the process using maximum CPU appears at the top.
 
 
---
 
6️⃣ |
 
This is a pipe.
 
It sends the output of the first command (ps aux) to the next command (head).
 
 
---
 
7️⃣ head -n 6
 
Displays the first 6 lines.
 
Why 6?
 
1 line = header
 
5 lines = top 5 processes



 
#!/bin/bash

<<todo
A function to print hostname and OS info
A function to print uptime
A function to print disk usage (top 5 by size)
A function to print memory usage
A function to print top 5 CPU-consuming processes
A main function that calls all of the above with section headers
Use set -euo pipefail at the top
todo

set -euo pipefail

sys_info(){
  echo "***********Hostname and OS information************"
  echo "$(hostnamectl)"
  echo -e "**************************************************\n"
}

 
sys_uptime(){
  echo "***********Uptime************"
  echo "$(uptime)"
  echo -e "**************************************************\n"
}


disk_usage(){

        echo "Disk Usage for particualr directory"
        echo "$(sudo du -h --max-depth=1 /var | sort -hr | head -5 2>/dev/null)"
}

memory_usage(){
    echo "Memory Usage"
    echo "$(free -h)" 
}

top_heavy_processes(){
        echo "top 5 cpu consuming processes"
        echo "$(ps aux --sort=-%cpu | head -n 6)"
}

main(){
sys_info
sys_uptime
disk_usage
memory_usage
top_heavy_processes
}

main 





                                                                                                                                             
                                                                                                                                             
                                                                                                                                             
