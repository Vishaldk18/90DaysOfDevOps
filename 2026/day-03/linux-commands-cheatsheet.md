Today’s goal is to build your Linux command confidence.

You will create a cheat sheet of commands focused on:

Process management
File system
Networking troubleshooting
This is the command toolkit you will reuse for years.



Guidelines
Follow these rules while creating your cheat sheet:

Include at least 20 commands with one‑line usage notes
Add 3 networking commands (ping, ip addr, dig, curl, etc.)
Group commands by category
Keep it concise and readable


commands relted to process management
ps(process status) - gives the snapshot of running processes
ps 

shows details like pid,terminal,cpu time,terminal

some important flags
ps -ef :detailed listing along with ppid,start time,uid
-e : select all processes
-f : full format listing

Shows all processes, including those without a terminal.
ps aux
a → processes from all users
u → user-oriented format
x → processes without terminals

ps -u username : processes for specific user

ps -p pid : Shows details for a specific process by PID.

ps -o (-eo): pid,cmdUsed to specify exactly which columns to show.

ps --forest : Shows hierarchical relationship (parent → child processes).

ps -l (long format)
Displays extra technical information (flags, priority, etc.)

ps -t <tty>
Shows all processes attached to a terminal.

ps -ef | grep <name>
Find a process by name.


top - gives information about processes in real time 
The top command is a built‑in Linux utility that shows real‑time system information, including CPU usage, memory usage, load average, running processes, etc.

top -u username : Show processes for a specific user
top -b : Batch mode (useful for logging)
top -d 2: Update interval (e.g., refresh every 2 sec)

htop - ehnhanced version of top human readable format 

htop is an improved, interactive, user‑friendly version of top.
htop -u username
top --sort-key=MEMORY: Sort by a column at startup


file system related:
cat,touch,mkdir,head,tail,rm,cp,mv,pwd,cd,ls,nano,vim

find : find files to locate by name,size,permisssions
locate: faster way to locate files uses databases 
grep : search inside files content

chmod: change permissions
chown: change owner,group


archiving and compressing 
tar,zip,unzip

stat: fiele info



Netowrk troubleshooting

ip addrs show : get information related to ip addresses, network interfaces
ip a           # show all interfaces
ip link        # show network links
ip addr show
ip route show  # routing table


ping google.come : used ping to check connectivity or Checks if a host is reachable.
ping -c 5 8.8.8.8   # send 5 packets


netstat or ss -tunlp : to get information about socket or ports 





