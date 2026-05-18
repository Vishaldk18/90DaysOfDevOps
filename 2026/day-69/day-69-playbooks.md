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


### Task 3: Learn the Essential Modules
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
```
What is the difference between command and shell? When should you use each?
In Ansible, the command module is used to execute simple commands directly on the managed node without invoking a shell, which makes it more secure and efficient. It does not support shell-specific features like pipes, redirection, or environment variables. On the other hand, the shell module executes commands through a shell, allowing the use of these advanced features. Therefore, command should be used for simple and secure operations, while shell should be used only when shell functionalities are required.
```

### Task 4: Handlers -- Restart Services Only When Needed
Handlers are tasks that run only when triggered by a `notify`. This avoids unnecessary service restarts.

Create `nginx-config.yml`:
```yaml
---
- name: Configure Nginx with a custom config
  hosts: web
  become: true

  tasks:
    - name: Install Nginx
      apt:
        name: nginx
        state: present

    - name: Deploy Nginx config
      copy:
        src: files/nginx.conf
        dest: /etc/nginx/nginx.conf
        owner: root
        mode: '0644'
      notify: Restart Nginx

    - name: Deploy custom index page
      copy:
        content: "<h1>Managed by Ansible</h1><p>Server: {{ inventory_hostname }}</p>"
        dest: /var/www/html/index.html

    - name: Ensure Nginx is running
      service:
        name: nginx
        state: started
        enabled: true

  handlers:
    - name: Restart Nginx
      service:
        name: nginx
        state: restarted
```
Create `files/nginx.conf` with a basic Nginx config.

Run the playbook:
- First run: handler triggers because the config file is new
- Second run: handler does NOT trigger because nothing changed


### Task 5: Dry Run, Diff, and Verbosity
Before running playbooks on production, always preview changes first.

1. **Dry run (check mode)** -- shows what would change without changing anything:
```bash
ansible-playbook install-nginx.yml --check
```

2. **Diff mode** -- shows the actual file differences:
```bash
ansible-playbook nginx-config.yml --check --diff
```

3. **Verbosity** -- increase output detail for debugging:
```bash
ansible-playbook install-nginx.yml -v       # verbose
ansible-playbook install-nginx.yml -vv      # more verbose
ansible-playbook install-nginx.yml -vvv     # connection debugging
```

4. **Limit to specific hosts:**
```bash
ansible-playbook install-nginx.yml --limit web-server
```

5. **List what would be affected without running:**
```bash
ansible-playbook install-nginx.yml --list-hosts
ansible-playbook install-nginx.yml --list-tasks
```

Why is `--check --diff` the most important flag combination for production use?
### ✅ Interview Answer (in lines)

The `--check --diff` flags are important for production use because they allow you to **preview changes before actually applying them**. The `--check` option runs the playbook in dry-run mode, meaning it shows what changes would be made without modifying the system. The `--diff` option complements this by displaying the exact differences between the current state and the proposed changes, such as changes in configuration files.

Using both together helps prevent accidental misconfigurations by giving full visibility into what Ansible is about to change. This is especially critical in production environments where unintended changes can cause downtime or service disruptions. It improves safety, confidence, and auditability by allowing engineers to verify changes before execution.

In simple terms, `--check --diff` helps you **validate and review changes safely before applying them in production systems**.

---

### Task 6: Multiple Plays in One Playbook
Write `multi-play.yml` with separate plays for each server group:

```yaml
---
- name: Configure web servers
  hosts: web
  become: true
  tasks:
    - name: Install Nginx
      yum:
        name: nginx
        state: present
    - name: Start Nginx
      service:
        name: nginx
        state: started
        enabled: true

- name: Configure app servers
  hosts: app
  become: true
  tasks:
    - name: Install Node.js dependencies
      yum:
        name:
          - gcc
          - make
        state: present
    - name: Create app directory
      file:
        path: /opt/app
        state: directory
        mode: '0755'

- name: Configure database servers
  hosts: db
  become: true
  tasks:
    - name: Install MySQL client
      yum:
        name: mysql
        state: present
    - name: Create data directory
      file:
        path: /var/lib/appdata
        state: directory
        mode: '0700'
```

Run it:
```bash
ansible-playbook multi-play.yml
```

Watch the output -- each play targets a different group, and tasks run only on the relevant hosts.
---
