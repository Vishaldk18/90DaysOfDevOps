### Task 1: Variables in Playbooks
Create `variables-demo.yml`:

```yaml
---
- name: Variable demo
  hosts: all
  become: true

  vars:
    app_name: terraweek-app
    app_port: 8080
    app_dir: "/opt/{{ app_name }}"
    packages:
      - git
      - curl
      - wget

  tasks:
    - name: Print app details
      debug:
        msg: "Deploying {{ app_name }} on port {{ app_port }} to {{ app_dir }}"

    - name: Create application directory
      file:
        path: "{{ app_dir }}"
        state: directory
        mode: '0755'

    - name: Install required packages
      yum:
        name: "{{ packages }}"
        state: present
```

Run it and verify the variables resolve correctly.

Now, override a variable from the command line:
```bash
ansible-playbook variables-demo.yml -e "app_name=my-custom-app app_port=9090"
```

**Verify:** Does the CLI variable override the playbook variable?

---

### Task 3: Ansible Facts -- Gathering System Information
Ansible automatically collects "facts" about each managed node -- OS, IP, memory, CPU, disks, and hundreds more.

1. **See all facts for a host:**
```bash
ansible web-server -m setup
```

2. **Filter specific facts:**
```bash
ansible web-server -m setup -a "filter=ansible_os_family"
ansible web-server -m setup -a "filter=ansible_distribution*"
ansible web-server -m setup -a "filter=ansible_memtotal_mb"
ansible web-server -m setup -a "filter=ansible_default_ipv4"
```

3. **Use facts in a playbook** -- create `facts-demo.yml`:
```yaml
---
- name: Facts demo
  hosts: all
  tasks:
    - name: Show OS info
      debug:
        msg: >
          Hostname: {{ ansible_hostname }},
          OS: {{ ansible_distribution }} {{ ansible_distribution_version }},
          RAM: {{ ansible_memtotal_mb }}MB,
          IP: {{ ansible_default_ipv4.address }}

    - name: Show all network interfaces
      debug:
        var: ansible_interfaces
```

Run it and observe the facts printed for each host.

**Document:** Name five facts you would use in real playbooks and why.
### ✅ Five useful Ansible facts for real playbooks (with why)

1.  **`ansible_distribution` and `ansible_distribution_version`**  
    These help identify the operating system and version, which is useful for writing OS-specific tasks such as installing packages differently on Ubuntu vs CentOS.

2.  **`ansible_hostname`**  
    This provides the system hostname and is commonly used for logging, configuring host-specific settings, or dynamically naming files and services.

3.  **`ansible_default_ipv4.address`**  
    This gives the primary IP address of the host, which is useful when configuring services like web servers, load balancers, or firewall rules.

4.  **`ansible_memtotal_mb`**  
    This shows the total RAM available, which helps in tuning applications (like JVM, databases) or making decisions based on system capacity.

5.  **`ansible_processor_vcpus`**  
    This gives the number of CPU cores, which is useful for performance tuning, scaling services, or configuring worker processes (e.g., Nginx, Apache).

***

### ✅ Interview-style answer (in lines)

In real-world playbooks, facts such as the operating system, hostname, IP address, memory, and CPU details are commonly used to make automation dynamic and adaptable. These facts allow playbooks to adjust configurations based on the system environment, ensuring compatibility, performance optimization, and scalability across different servers.

---
