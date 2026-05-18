### Task 1: Your First Playbook
Create `install-nginx.yml`:

```yaml
---
- name: Install and start Nginx on web servers
  hosts: web
  become: true

  tasks:
    - name: Install Nginx
      yum:
        name: nginx
        state: present

    - name: Start and enable Nginx
      service:
        name: nginx
        state: started
        enabled: true

    - name: Create a custom index page
      copy:
        content: "<h1>Deployed by Ansible - TerraWeek Server</h1>"
        dest: /usr/share/nginx/html/index.html # for amazon linux
         # /var/www/html/index.html for ubuntu 
```

(Use `apt` instead of `yum` if your instances run Ubuntu)

Run it:
```bash
ansible-playbook install-nginx.yml
```
---

### Task 2: Understand the Playbook Structure
Open your playbook and annotate each part in your notes:

```yaml
---                                    # YAML document start
- name: Play name                      # PLAY -- targets a group of hosts
  hosts: web                           # Which inventory group to run on
  become: true                         # Run tasks as root (sudo)

  tasks:                               # List of TASKS in this play
    - name: Task name                  # TASK -- one unit of work
      module_name:                     # MODULE -- what Ansible does
        key: value                     # Module arguments
```

### ✅ 1. Difference between a *Play* and a *Task*

A **play** is a higher-level unit in Ansible that defines **which hosts to target and what overall actions to perform** on them. It groups multiple tasks together and applies them to a specific inventory group.

A **task**, on the other hand, is a **single unit of work** inside a play. It uses a module to perform one specific action, such as installing a package, copying a file, or starting a service.

👉 In simple terms:  
A play = **plan for a group of servers**  
A task = **individual step inside that plan**

***

### ✅ 2. Can you have multiple plays in one playbook?

Yes, you can have **multiple plays in a single playbook**.

Each play can target **different groups of hosts** and define different sets of tasks.

For example:

*   One play can configure web servers
*   Another play can configure database servers

👉 This allows you to manage **different roles or layers of infrastructure in one file**.

***

### ✅ 3. What does `become: true` do at play level vs task level?

When `become: true` is defined at the **play level**, it means **all tasks in that play will run with elevated (sudo/root) privileges**.

When `become: true` is defined at the **task level**, only that specific task will run with elevated privileges, while other tasks will run as the normal user.

👉 So:

*   Play level → applies to all tasks
*   Task level → applies only to that one task

***

### ✅ 4. What happens if a task fails?

By default, if a task fails on a host, Ansible **stops executing the remaining tasks for that particular host**, but it continues running on other hosts.

So:

*   Failed host → remaining tasks are skipped ❌
*   Other hosts → continue execution ✅

👉 However, this behavior can be modified using options like `ignore_errors`, `rescue`, or `max_fail_percentage`.

***

## ✅ Interview-style final answer (short combined)

A play defines a set of tasks to be executed on a group of hosts, while a task represents a single action performed using an Ansible module. A playbook can contain multiple plays, allowing different configurations for different host groups. The `become: true` directive enables privilege escalation, where at the play level it applies to all tasks, and at the task level it applies only to specific tasks. If a task fails, Ansible stops executing further tasks on that host but continues execution on other hosts unless configured otherwise.


---


### Task 1: Your First Playbook
```yaml
- name: install essential-modules
  hosts: web
  become: true
  tasks:
   - name: install multiple packages
     apt:
       name:
         - git
         - curl
         - wget
         
       state: present
   - name: Ensure Nginx is running
     service:
       name: nginx
       state: started
       enabled: true
   - name: Copy config file
     copy:
       src: files/app.conf
       dest: /etc/app.conf
       owner: root
       group: root
       mode: '0644'
   - name: Create application directory
     file:
       path: /opt/myapp
       state: directory
       owner: ubuntu
       mode: '0755'
   - name: check disk space
     command: df -h
     register: disk_output
   - name: print disk space
     debug:
       var: disk_output.stdout_lines

   - name: count running processes
     shell: ps aux | wc -l
     register: process_count
   - name: show process count
     debug:
       msg: "Total processes: {{ process_count.stdout}}"
   - name: Set timezone in environment
     lineinfile:
       path: /etc/enviorment
       line: 'TZ=Asia/Kolkata'
       create: true
```

---
What is the difference between command and shell? When should you use each?
In Ansible, the command module is used to execute simple commands directly on the managed node without invoking a shell, which makes it more secure and efficient. It does not support shell-specific features like pipes, redirection, or environment variables. On the other hand, the shell module executes commands through a shell, allowing the use of these advanced features. Therefore, command should be used for simple and secure operations, while shell should be used only when shell functionalities are required.
---
