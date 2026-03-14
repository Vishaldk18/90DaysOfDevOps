Quick Concepts (write 1–2 bullets each)
OSI layers (L1–L7) vs TCP/IP stack (Link, Internet, Transport, Application)
Where IP, TCP/UDP, HTTP/HTTPS, DNS sit in the stack
OSI layer           TCP IP 
Application         
presentation        Application  (HTTP/HTTPS)
Session
Transport           Transport    (TCP/UDP)
Network             Internet     (IP/DNS)
Data Link           Link
Physical            


curl command: 
It is commonly used to send HTTP/HTTPS requests from the command line.
curl is a command-line tool used to make API calls, download files, and interact with web services.
curl is often used to test services inside clusters.
curl http://localhost:8080 (Used to check if your pod/service is responding.)
curl -I
DevOps engineers use it to quickly check:
If a website or API is reachable
HTTP status code (200, 404, 500, etc.)
Server headers
Redirect behavior


Hands-on Checklist (run these; add 1–2 line observations)
Identity: hostname -I (or ip addr show) — note your IP.
The hostname -I command is used to display the IP address(es) of the current machine.
Shows all network interface IP addresses assigned to the system.
Displays local/private IPs (not the public internet IP).

ip addr show
Shows full network interface details along with private ips


curl ifconfig.me: ifconfig.me is a web service used to check your public IP address from the terminal or browser.

ping: ping is a network troubleshooting command used to check if a host is reachable and measure network latency.
The ping command is used to test connectivity between your machine and another host (server, website, or IP address).
It checks whether the destination is reachable over the network.



Path: traceroute <target> (or tracepath) — note any long hops/timeouts.
The traceroute command is used to trace the path that packets take from your machine to a destination server.
It shows all the intermediate routers (hops) between the source and the destination.
Each line shows:
Hop number
Router IP
Latency time

Ports: ss -tulpn (or netstat -tulpn) — list one listening service and its port.
netstat -tulpn → shows listening ports and services
netstat -an | head -n 20 : is used to display the first few lines of network connections.
| Option | Meaning                                             |
| ------ | --------------------------------------------------- |
| `-a`   | Show all connections (listening + non-listening)    |
| `-n`   | Show numeric IP addresses and ports (no DNS lookup) |


ss -tulpn → modern faster alternative for the same task
Very common debugging step:
ss -tulpn | grep <port>
Used to check which process is using a port.

Name resolution: dig <domain> or nslookup <domain> — record the resolved IP.
Both dig and nslookup are DNS lookup tools used to check how a domain name resolves to an IP address.
They help troubleshoot DNS issues.
dig → advanced DNS debugging tool
nslookup → simple DNS query tool
Both help convert domain names to IP addresses.


When you type a URL like google.com in the browser:
The browser checks its cache for the IP address.
If not found, the OS cache is checked.
If still not found, a DNS query is sent to the DNS resolver (like ISP DNS or Google DNS 8.8.8.8).
The DNS resolver performs a lookup by contacting:
Root DNS server
TLD DNS server (.com)
Authoritative DNS server
Then it returns the IP address of the server.
The browser uses that IP to establish a TCP connection with the server.
If it is HTTPS, a TLS/SSL handshake happens for a secure connection.
The browser sends an HTTP request to the server.
The server responds with HTML, CSS, and JavaScript, and the browser renders the webpage.

✅ Short interview answer:
The browser first checks cache. If the IP is not found, it queries a DNS resolver which contacts root, TLD, and authoritative DNS servers to get the server’s IP address. Then the browser establishes a TCP/HTTPS connection, sends an HTTP request, and the server returns the webpage which the browser renders.


nc -zv localhost <port>
nc (netcat) command, the options -zv are used together to scan/check if a port is open.
| Option | Meaning                                            |
| ------ | -------------------------------------------------- |
| `-z`   | Zero-I/O mode (scan the port without sending data) |
| `-v`   | Verbose mode (show detailed output)                |


### One-line check

**Use `ping <host>`** → If reachable, host is up. If not reachable, next check **service status and firewall/security rules**.

---

# Reflection

### 1️⃣ Which command gives the fastest signal when something is broken?

**`curl -I <url>`**

It quickly shows:

* HTTP status
* Server response
* If the application is reachable

Example:

```bash
curl -I http://example.com
```

---

### 2️⃣ What layer would you inspect next?

| Issue          | Layer to Inspect                       |
| -------------- | -------------------------------------- |
| DNS fails      | **Application layer (DNS)**            |
| HTTP 500 error | **Application layer (Web/App server)** |

Explanation:

* **DNS failure** → problem in DNS resolution system
* **HTTP 500** → application/server error (backend issue)

---

### 3️⃣ Two follow-up checks in a real incident

**1️⃣ Check service status**

```bash
systemctl status nginx
```

**2️⃣ Check listening ports**

```bash
ss -tulpn
```

Other useful checks:

```bash
dig domain.com
nc -zv host 80
```

---

✅ **Simple troubleshooting flow (DevOps)**

```
ping → DNS check (dig) → port check (nc) → HTTP check (curl)
```

This helps quickly identify if the issue is **network, DNS, port, or application.**

