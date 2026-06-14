# Linux Networking Fundamentals Notes

## OSI Layers vs TCP/IP Stack

| OSI Model    | TCP/IP Model | Common Protocols            |
| ------------ | ------------ | --------------------------- |
| Application  | Application  | HTTP, HTTPS, DNS, FTP, SMTP |
| Presentation | Application  | SSL/TLS, Encryption         |
| Session      | Application  | Session Management          |
| Transport    | Transport    | TCP, UDP                    |
| Network      | Internet     | IP, ICMP                    |
| Data Link    | Link         | Ethernet, MAC               |
| Physical     | Link         | Cables, Switch Ports        |

### Quick Concepts

* **OSI Model** has 7 layers and is mainly used for learning and troubleshooting.
* **TCP/IP Model** has 4 layers and is the practical networking model used on the Internet.

### Protocol Placement

| Protocol       | Layer            |
| -------------- | ---------------- |
| HTTP/HTTPS     | Application      |
| DNS            | Application      |
| TCP/UDP        | Transport        |
| IP             | Internet/Network |
| Ethernet       | Data Link        |
| Physical Media | Physical         |

---

# curl Command

## What is curl?

`curl` is a command-line tool used to:

* Send HTTP/HTTPS requests
* Make API calls
* Download files
* Test web services
* Troubleshoot applications

### Examples

Check if a service is responding:

```bash
curl http://localhost:8080
```

Display HTTP headers only:

```bash
curl -I https://example.com
```

### Why DevOps Engineers Use curl

* Verify website availability
* Check API responses
* View HTTP status codes
* Inspect server headers
* Test redirects

---

# Hands-on Checklist

## 1. Identity Check

### Command

```bash
hostname -I
```

### Observation

* Displays all IP addresses assigned to the host.
* Shows private/local IP addresses.

### Alternative

```bash
ip addr show
```

### Observation

* Shows network interfaces.
* Displays detailed IP configuration.

---

## 2. Public IP Check

### Command

```bash
curl ifconfig.me
```

### Observation

* Returns the public IP address visible on the Internet.

---

## 3. Connectivity Check

### Command

```bash
ping google.com
```

### Observation

* Verifies host reachability.
* Measures latency and packet loss.

### Purpose

* Check whether a remote system is reachable.

---

## 4. Trace Network Path

### Command

```bash
traceroute google.com
```

or

```bash
tracepath google.com
```

### Observation

Shows:

* Hop number
* Router IP
* Latency per hop

### Purpose

* Identify network delays and routing issues.

---

## 5. Check Open Ports

### Modern Command

```bash
ss -tulpn
```

### Legacy Command

```bash
netstat -tulpn
```

### Purpose

* View listening ports
* Identify services bound to ports
* Determine which process owns a port

### Check Specific Port

```bash
ss -tulpn | grep 8080
```

### netstat Example

```bash
netstat -an | head -n 20
```

#### Options

| Option | Meaning                          |
| ------ | -------------------------------- |
| -a     | Show all connections             |
| -n     | Show numeric addresses and ports |

---

## 6. DNS Resolution

### Using dig

```bash
dig google.com
```

### Using nslookup

```bash
nslookup google.com
```

### Observation

* Converts domain names into IP addresses.
* Useful for troubleshooting DNS issues.

### Tools Comparison

| Tool     | Purpose                |
| -------- | ---------------------- |
| dig      | Advanced DNS debugging |
| nslookup | Simple DNS queries     |

---

# What Happens When You Open google.com?

1. Browser checks local cache.
2. Operating system checks DNS cache.
3. DNS request is sent to a DNS resolver.
4. Resolver contacts:

   * Root DNS Server
   * TLD DNS Server (.com)
   * Authoritative DNS Server
5. IP address is returned.
6. Browser establishes a TCP connection.
7. HTTPS performs TLS/SSL handshake.
8. Browser sends HTTP request.
9. Server responds with HTML/CSS/JavaScript.
10. Browser renders the webpage.

### Interview Answer

> The browser first checks cache. If the IP is not found, it queries a DNS resolver which contacts root, TLD, and authoritative DNS servers to get the server's IP address. Then the browser establishes a TCP/HTTPS connection, sends an HTTP request, and the server returns the webpage which the browser renders.

---

# Port Connectivity Check

## netcat (nc)

### Command

```bash
nc -zv localhost 80
```

### Options

| Option | Meaning                        |
| ------ | ------------------------------ |
| -z     | Scan port without sending data |
| -v     | Verbose output                 |

### Purpose

* Verify whether a port is open.
* Check application accessibility.

---

# One-Line Health Check

```bash
ping <host>
```

### Interpretation

* Reachable → Host is up.
* Not reachable → Check service status, firewall, security groups, or routing.

---

# Reflection

## 1. Which Command Gives the Fastest Signal When Something Is Broken?

### Answer

```bash
curl -I <url>
```

### Why?

Quickly shows:

* HTTP status code
* Server response
* Application availability

### Example

```bash
curl -I https://example.com
```

---

## 2. What Layer Would You Inspect Next?

| Issue          | Layer                                      |
| -------------- | ------------------------------------------ |
| DNS failure    | Application Layer (DNS)                    |
| HTTP 500 error | Application Layer (Web/Application Server) |

### Explanation

#### DNS Failure

* Domain cannot resolve to an IP.
* Investigate DNS servers and records.

#### HTTP 500 Error

* Indicates application/backend failure.
* Investigate application logs and server health.

---

## 3. Two Follow-Up Checks During an Incident

### Check Service Status

```bash
systemctl status nginx
```

### Check Listening Ports

```bash
ss -tulpn
```

### Additional Useful Checks

```bash
dig domain.com

nc -zv host 80
```

---

# DevOps Troubleshooting Flow

```text
ping
  ↓
DNS Check (dig/nslookup)
  ↓
Port Check (nc)
  ↓
HTTP Check (curl)
```

### Purpose

This workflow quickly helps determine whether the problem is related to:

* Network Connectivity
* DNS Resolution
* Port Availability
* Application Health

---

# Key Takeaways

1. OSI and TCP/IP models help identify where networking issues occur.
2. Tools like `ping`, `curl`, `dig`, `ss`, and `nc` are essential for troubleshooting.
3. A structured troubleshooting approach saves time during production incidents.
