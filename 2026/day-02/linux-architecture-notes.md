# Linux Fundamentals

## Linux Architecture

The Linux architecture consists of the following components: **Applications/User, Shell, Kernel, Hardware**.

- **User/Applications**: Users come in the topmost layer of Linux. They perform different actions such as running scripts, development, and administrative work using terminal-like applications.
- **Shell**: It is a medium using which users can perform various actions, such as utilizing different resources.
- **Kernel**: It acts as an interface between the shell and hardware. Users can control hardware with the help of the shell.

## init/systemd

When we start the system/computer/laptop, the first process that is started is called `systemd` or `init`. Its process ID is **1**.

- **systemd**: "d" stands for daemon.
- **systemctl**: Called "System Controller", used to manage processes in Linux.

## Viewing Processes

To see running processes, we can use commands like `top`, `htop`, `ps`.

- **ps**: Gives a snapshot of active processes.
- **htop/top**: Shows processes in real time, also shows CPU%, MEM%, load%, process ID.
- **ps aux | grep nginx**: `ps` with `grep` is great for debugging and finding a particular process.
- **journalctl**: Shows logs for processes; important command for troubleshooting and debugging.

## 5 Commands

- `ls`
- `cp`
- `mv`
- `touch`
- `cat`
- `top`, `htop`, `ps`
- `ping`

## Process States

When a program runs, the OS tracks it as a process and assigns it a state depending on what it's currently doing.

### 1. Running (R)

A process is in running state when:
- It is currently executing on the CPU, or
- It is ready to run, waiting in the CPU scheduler queue.

**Example**: A program actively performing calculations.

### 🟡 2. Sleeping

There are two types:

**a) Interruptible Sleep (S)**
The process is waiting for some event, like:
- User input
- Disk I/O
- Network response

It can be interrupted by signals.

**b) Uninterruptible Sleep (D)**
The process waits for a non-interruptible event, usually related to:
- Disk operations
- Hardware responses

It cannot be killed or interrupted until the operation finishes. This is why `kill -9` sometimes doesn't work — the process is stuck in D-state.

### 🟣 3. Stopped (T)

A stopped process is paused. This happens when:
- The user presses `Ctrl+Z`
- A debugger (like `gdb`) pauses a process

It can be resumed later.

### ⚫ 4. Zombie (Z)

A zombie process has:
- Completed execution, but
- Still has an entry in the process table because the parent has not read its exit status.

It does not consume CPU or memory — just a tiny table entry. If the parent never cleans it up, it stays as a zombie. Usually harmless, but many zombies indicate a buggy parent process.

### ⚪ 5. Orphan Process

Not an official "state", but a condition. Occurs when:
- A parent process ends before its child
- The child is "orphaned" and gets adopted by PID 1 (init/systemd), which cleans it up properly.

### 🔵 6. Idle / Kernel Threads

Special threads started by the kernel, e.g.:
- Memory management
- Background housekeeping

They often appear as `<kworker/>` or similar names in `ps` output.

### 🔴 7. Dead (X)

An internal kernel state. You usually don't see this in userspace — it means the process is about to be removed from the process table.
