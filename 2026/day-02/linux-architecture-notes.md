Linux Fundamentals

Linux Architecure
the linux architecture consist of following components applications/user, shell, kernel, hardware

user,applications: users come in the topmost layer of linux, they perform different actions such as running scripts, development, administrative work using terminal like applications

shell: it is a medium using which users can do various actions like they utilize different resources 

kernel: it acts as a interface between shell and hardware, users can control hardware with the help of shell. 

init/systemd: when we start system/computer/laptop the first process which is started is called as systemd or init its process id is 1
systemd : d is for deamon 
systemctl: called as system controller used to manage processes in linux.

to see the running processes we can use commands like top,htop,ps 
ps gives the snapshot of active processes 
htop or top: shows processes in real time also shows cpu%, mem%, load% process id 

ps aux | grep nginx : ps with grep is great for debugging and finding particular process 

jouranalctl: shows logs for processes, important command for troubleshooting and debugging

5 commands
ls 
cp 
mv
touch
cat
top,htop,ps
ping


When a program runs, the OS tracks it as a process and assigns it a state depending on what it's currently doing
1. Running (R)
A process is in running state when:

It is currently executing on the CPU, or
It is ready to run, waiting in the CPU scheduler queue.

Example:
A program actively performing calculations.

🟡 2. Sleeping
There are two types:
a) Interruptible Sleep (S)
The process is waiting for some event, like:

User input
Disk I/O
Network response

It can be interrupted by signals.
b) Uninterruptible Sleep (D)
The process waits for a non-interruptible event, usually related to:

Disk operations
Hardware responses

It cannot be killed or interrupted until the operation finishes.
This is why kill -9 sometimes doesn’t work — the process is stuck in D-state.

🟣 3. Stopped (T)
A stopped process is paused.
This happens when:

The user presses Ctrl+Z
A debugger (like gdb) pauses a process

It can be resumed later.

⚫ 4. Zombie (Z)
A zombie process has:

Completed execution, but
Still has an entry in the process table because the parent has not read its exit status.

It does not consume CPU or memory — just a tiny table entry.
If the parent never cleans it up, it stays as a zombie.
Usually harmless but many zombies indicate a buggy parent process.

⚪ 5. Orphan Process
Not an official “state”, but a condition.
Occurs when:

A parent process ends before its child
The child is “orphaned” and gets adopted by PID 1 (init or systemd), which cleans it up properly


🔵 6. Idle / Kernel Threads
Special threads started by the kernel, e.g.:

Memory management
Background housekeeping

They often appear as <kworker/> or similar names in ps output.

🔴 7. Dead (X)
An internal kernel state.
You usually don’t see this in userspace — it means the process is about to be removed from the process table.
