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
### Task 3: Build a Custom Webserver Role
Build a complete `webserver` role from scratch:

**`roles/webserver/defaults/main.yml`:**
```yaml
---
http_port: 80
app_name: myapp
max_connections: 512
```

**`roles/webserver/tasks/main.yml`:**
```yaml
---
- name: Install Nginx
  yum:
    name: nginx
    state: present

- name: Deploy Nginx config
  template:
    src: nginx.conf.j2
    dest: /etc/nginx/nginx.conf
    owner: root
    mode: '0644'
  notify: Restart Nginx

- name: Deploy vhost config
  template:
    src: vhost.conf.j2
    dest: "/etc/nginx/conf.d/{{ app_name }}.conf"
    owner: root
    mode: '0644'
  notify: Restart Nginx

- name: Create web root
  file:
    path: "/var/www/{{ app_name }}"
    state: directory
    mode: '0755'

- name: Deploy index page
  template:
    src: index.html.j2
    dest: "/var/www/{{ app_name }}/index.html"
    mode: '0644'

- name: Start and enable Nginx
  service:
    name: nginx
    state: started
    enabled: true
```

**`roles/webserver/handlers/main.yml`:**
```yaml
---
- name: Restart Nginx
  service:
    name: nginx
    state: restarted
```

**`roles/webserver/templates/index.html.j2`:**
```html
<h1>{{ app_name }}</h1>
<p>Server: {{ ansible_hostname }}</p>
<p>IP: {{ ansible_default_ipv4.address }}</p>
<p>Environment: {{ app_env | default('development') }}</p>
<p>Managed by Ansible</p>
```

Create the `vhost.conf.j2` and `nginx.conf.j2` templates yourself based on what you learned in Task 1.
`vhost.conf.j2`
```yaml
server {
    listen {{ http_port }};
    server_name localhost;

    root /var/www/{{ app_name }};
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }

    error_page 404 /404.html;

    location = /404.html {
        internal;
    }
}
```

`nginx.conf.j2`
```yaml
user nginx;
worker_processes auto;

events {
    worker_connections {{ max_connections }};
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    sendfile        on;
    keepalive_timeout 65;

    # Logging
    access_log  /var/log/nginx/access.log;
    error_log   /var/log/nginx/error.log;

    # Include all vhost configs
    include /etc/nginx/conf.d/*.conf;
}
```


Now call the role from a playbook `site.yml`:
```yaml
---
- name: Configure web servers
  hosts: web
  become: true
  roles:
    - role: webserver
      vars:
        app_name: terraweek
        http_port: 80
```

Run it:
```bash
ansible-playbook site.yml
```

**Verify:** Curl the web server. Does the custom page load?

---

### Task 4: Ansible Galaxy -- Use Community Roles
Ansible Galaxy is a marketplace of pre-built roles.

1. **Search for roles:**
```bash
ansible-galaxy search nginx --platforms EL
ansible-galaxy search mysql
```

2. **Install a role from Galaxy:**
```bash
ansible-galaxy install geerlingguy.docker
```

3. **Check where it was installed:**
```bash
ansible-galaxy list
```

4. **Use the installed role** -- create `docker-setup.yml`:
```yaml
---
- name: Install Docker using Galaxy role
  hosts: app
  become: true
  roles:
    - geerlingguy.docker
```

Run it -- Docker gets installed with a single role call.

5. **Use a requirements file** for managing multiple roles. Create `requirements.yml`:
```yaml
---
roles:
  - name: geerlingguy.docker
    version: "7.4.1"
  - name: geerlingguy.ntp
```

Install all at once:
```bash
ansible-galaxy install -r requirements.yml
```

**Document:** Why use a `requirements.yml` instead of installing roles manually?
requirements.yml is used to manage and version-control role dependencies, ensuring consistent and automated setup across environments, unlike manual installation which is error-prone and not reproducible.
---
