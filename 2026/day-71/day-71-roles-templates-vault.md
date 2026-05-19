### Task 1: Jinja2 Templates
Templates let you generate config files dynamically using variables and facts.

1. Create `templates/nginx-vhost.conf.j2`:
```jinja2
# Managed by Ansible -- do not edit manually
server {
    listen {{ http_port | default(80) }};
    server_name {{ ansible_hostname }};

    root /var/www/{{ app_name }};
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }

    access_log /var/log/nginx/{{ app_name }}_access.log;
    error_log /var/log/nginx/{{ app_name }}_error.log;
}
```

2. Create a playbook `template-demo.yml`:
```yaml
---
- name: Deploy Nginx with template
  hosts: web
  become: true
  vars:
    app_name: terraweek-app
    http_port: 80

  tasks:
    - name: Install Nginx
      yum:
        name: nginx
        state: present

    - name: Create web root
      file:
        path: "/var/www/{{ app_name }}"
        state: directory
        mode: '0755'

    - name: Deploy vhost config from template
      template:
        src: templates/nginx-vhost.conf.j2
        dest: "/etc/nginx/conf.d/{{ app_name }}.conf"
        owner: root
        mode: '0644'
      notify: Restart Nginx

    - name: Deploy index page
      copy:
        content: "<h1>{{ app_name }}</h1><p>Host: {{ ansible_hostname }} | IP: {{ ansible_default_ipv4.address }}</p>"
        dest: "/var/www/{{ app_name }}/index.html"

  handlers:
    - name: Restart Nginx
      service:
        name: nginx
        state: restarted
```

Run it with `--diff` to see the rendered template:
```bash
ansible-playbook template-demo.yml --diff
```

**Verify:** SSH into the web server and read the generated config. Are the variables replaced with actual values?

---

### Task 2: Understand the Role Structure
An Ansible role has a fixed directory structure. Each directory has a specific purpose:

```
roles/
  webserver/
    tasks/
      main.yml         # The main task list
    handlers/
      main.yml         # Handlers (restart services, etc.)
    templates/
      nginx.conf.j2    # Jinja2 templates
    files/
      index.html       # Static files to copy
    vars/
      main.yml         # Role variables (high priority)
    defaults/
      main.yml         # Default variables (low priority, easily overridden)
    meta/
      main.yml         # Role metadata and dependencies
```

Every directory contains a `main.yml` that Ansible loads automatically. You only create the directories you need.

Generate a skeleton with:
```bash
ansible-galaxy init roles/webserver
```

Explore the generated directory. Read the README.md that Galaxy creates.

**Document:** What is the difference between `vars/main.yml` and `defaults/main.yml`?
Here’s a **crisp interview-ready answer**:

***

In Ansible roles, both `defaults/main.yml` and `vars/main.yml` are used to define variables, but they differ mainly in **precedence and purpose**.

*   **`defaults/main.yml`** contains variables with the **lowest precedence**. These are meant to provide **default values** that users can easily override from inventory, playbooks, or extra vars. It is best used for **configurable parameters**.

*   **`vars/main.yml`** contains variables with a **higher precedence**. These are harder to override and are typically used for **internal role variables** that should remain constant.

✅ **In short:**

*   `defaults` → flexible, user-overridable
*   `vars` → strict, internal use, harder to override

***

👉 **Best practice:** Use `defaults/main.yml` in most cases, and only use `vars/main.yml` when you don’t want the value to be changed.

***

If you want a one-liner:

> “Defaults are user-configurable with lowest priority, while vars are fixed role variables with higher priority.”

---
