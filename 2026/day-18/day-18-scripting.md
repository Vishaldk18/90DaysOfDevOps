# Bash Scripting Notes

## Functions with Arguments

### Example 1: Greeting and Sum Function

```bash
#!/bin/bash

greet(){
  echo "Hello, $1"
}

sum(){
  echo "sum is: $(( $1 + $2 ))"
}

greet vishal
sum 10 20
```

### Explanation

* `$1`, `$2` represent positional arguments passed to a function.
* `greet vishal` passes `vishal` as the first argument.
* `sum 10 20` passes `10` and `20` as arguments.
* Arithmetic operations can be performed using `$(( ))`.

### Output

```text
Hello, vishal
sum is: 30
```

---

# System Information Functions

## Example 2: Disk and Memory Check

```bash
#!/bin/bash

check_disk(){

    used_disk=$(df -h / | awk 'NR==2 {print $2}')
    echo "Used disk: $used_disk"
}

check_memory(){

    available_memory=$(free -h | awk 'NR==2 {print $4}')
    echo "Available memory: $available_memory"
}

check_memory
check_disk
```

### Explanation

#### Disk Usage

```bash
df -h /
```

Shows filesystem usage for root (`/`).

```bash
awk 'NR==2 {print $2}'
```

Prints the second column from the second row.

#### Memory Usage

```bash
free -h
```

Displays memory usage in human-readable format.

```bash
awk 'NR==2 {print $4}'
```

Extracts available memory.

---

# Bash Strict Mode

## Example 3: Safe Bash Scripting

```bash
#!/bin/bash

set -euo pipefail
```

### Meaning

#### `-e`

Exit immediately if any command returns a non-zero status.

```bash
cd non_existing_directory
echo "This line won't execute"
```

---

#### `-u`

Treat unset variables as errors.

```bash
echo $name
```

Produces:

```text
bash: name: unbound variable
```

---

#### `pipefail`

Makes the entire pipeline fail if any command in the pipeline fails.

Example:

```bash
false | true
```

Without pipefail:

```text
Exit status = 0
```

With pipefail:

```text
Exit status = 1
```

### Why Use It?

By default, Bash returns the exit code of the last command in a pipeline, which can hide failures earlier in the pipeline.

---

# Local Variables in Functions

## Example 4: Local Scope

```bash
#!/bin/bash

demo_function() {
    local name="Vishal"
    echo "Inside function: $name"
}

demo_function

echo "Outside function: $name"
```

### Output

```text
Inside function: Vishal
Outside function:
```

### Explanation

* `local` limits the variable scope to the function.
* Outside the function, the variable is unavailable.

---

# Global Variables in Functions

## Example 5: Global Scope

```bash
#!/bin/bash

demo_function() {
    name="Vishal"
    echo "Inside function: $name"
}

demo_function

echo "Outside function: $name"
```

### Output

```text
Inside function: Vishal
Outside function: Vishal
```

### Explanation

Without `local`, variables become global and remain accessible after the function completes.

---

# Hostname and OS Information Commands

## hostname

```bash
hostname
```

Displays only the hostname.

---

## uname

```bash
uname
```

Displays kernel name.

---

## uname -n

```bash
uname -n
```

Displays hostname.

---

## uname -a

```bash
uname -a
```

Displays:

* Kernel version
* Hostname
* Architecture
* Operating system information

---

## /etc/os-release

```bash
cat /etc/os-release
```

Displays Linux distribution-specific details.

---

## hostnamectl

```bash
hostnamectl
```

Displays:

* Hostname
* Operating System
* Kernel Version
* Architecture

---

# Top CPU Consuming Processes

## Command

```bash
ps aux --sort=-%cpu | head -n 6
```

### Purpose

Shows the top 5 CPU-consuming processes.

---

## Breakdown

### 1. ps

```bash
ps
```

Process Status command.

Displays running processes.

---

### 2. a

Shows processes of all users attached to terminals.

---

### 3. u

Displays detailed user-oriented output.

Includes:

* USER
* PID
* %CPU
* %MEM
* VSZ
* RSS
* START
* TIME
* COMMAND

---

### 4. x

Shows processes without terminals.

Examples:

* systemd
* sshd
* cron

---

### 5. --sort=-%cpu

Sorts output by CPU usage.

```text
- = descending order
%cpu = CPU utilization column
```

Highest CPU-consuming process appears first.

---

### 6. Pipe (`|`)

Sends output from one command to another.

---

### 7. head -n 6

Shows:

```text
1 Header line
5 Process lines
```

Total: 6 lines

---

# System Health Monitoring Script

## Requirement

Create:

* Hostname and OS Information
* Uptime
* Disk Usage
* Memory Usage
* Top 5 CPU-consuming Processes

Use:

```bash
set -euo pipefail
```

---

## Complete Script

```bash
#!/bin/bash

set -euo pipefail

sys_info(){
  echo "***********Hostname and OS information************"
  hostnamectl
  echo -e "**************************************************\n"
}

sys_uptime(){
  echo "***********Uptime************"
  uptime
  echo -e "**************************************************\n"
}

disk_usage(){
  echo "Disk Usage for particular directory"
  sudo du -h --max-depth=1 /var 2>/dev/null | sort -hr | head -5
}

memory_usage(){
  echo "Memory Usage"
  free -h
}

top_heavy_processes(){
  echo "Top 5 CPU consuming processes"
  ps aux --sort=-%cpu | head -n 6
}

main(){
  sys_info
  sys_uptime
  disk_usage
  memory_usage
  top_heavy_processes
}

main
```

---

# Key Learnings

1. Functions improve script reusability and organization.
2. `set -euo pipefail` makes Bash scripts safer and easier to debug.
3. `local` variables prevent accidental modification of global variables.
4. System monitoring can be automated using Bash functions.
5. Commands such as `hostnamectl`, `uptime`, `free`, `du`, and `ps` are commonly used in Linux administration and DevOps troubleshooting.
