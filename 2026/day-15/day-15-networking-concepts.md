Task 1: DNS – How Names Become IPs
Explain in 3–4 lines: what happens when you type google.com in a browser?
When you type a URL like google.com in the browser: The browser checks its cache for the IP address. If not found, the OS cache is checked. If still not found, a DNS query is sent to the DNS resolver (like ISP DNS or Google DNS 8.8.8.8). The DNS resolver performs a lookup by contacting: Root DNS server TLD DNS server (.com) Authoritative DNS server Then it returns the IP address of the server. The browser uses that IP to establish a TCP connection with the server. If it is HTTPS, a TLS/SSL handshake happens for a secure connection. The browser sends an HTTP request to the server. The server responds with HTML, CSS, and JavaScript, and the browser renders the webpage.

✅ Short interview answer: The browser first checks cache. If the IP is not found, it queries a DNS resolver which contacts root, TLD, and authoritative DNS servers to get the server’s IP address. Then the browser establishes a TCP/HTTPS connection, sends an HTTP request, and the server returns the webpage which the browser renders.


What are these record types? Write one line each:
A, AAAA, CNAME, MX, NS
A record maps a domain to an IPv4 address, 
AAAA maps to IPv6, 
CNAME creates an alias for another domain, 
MX defines the mail server for a domain, 
and NS specifies the DNS servers responsible for that domain.
Run: dig google.com — identify the A record and TTL from the output


Task 2: IP Addressing
What is an IPv4 address? How is it structured? (e.g., 192.168.1.10)
An IPv4 address is a 32-bit numerical address used to identify devices on a network. It is written in dotted decimal format consisting of four octets, each ranging from 0–255.

Difference between public and private IPs — give one example of each
A public IP is globally unique and reachable on the internet, while a private IP is used inside internal networks like homes, offices, or cloud VPCs and is not directly accessible from the internet.
| Type           | Description                  | Example        |
| -------------- | ---------------------------- | -------------- |
| **Public IP**  | Accessible over the internet | `8.8.8.8`      |
| **Private IP** | Used inside local networks   | `192.168.1.10` |


What are the private IP ranges?
10.x.x.x, 172.16.x.x – 172.31.x.x, 192.168.x.x
10.0.0.0/8, 172.16.0.0–172.31.255.255, and 192.168.0.0/16.
Run: ip addr show — identify which of your IPs are private

Task 3: CIDR & Subnetting
What does /24 mean in 192.168.1.0/24?
/24 is the CIDR prefix that indicates how many bits are used for the network part of the IP address.
/24 → 24 bits for network
     8 bits for hosts
     
How many usable hosts in a /24? A /16? A /28?
2^8 = 256 -2 = 254
2^16 = 65536 -2 = 65534
2^4 = 16 - 2 = 14


Explain in your own words: why do we subnet?
Subnetting divides a large network into smaller networks to improve network management, security, and efficient IP usage.

Benefits:
Better network organization
Reduced broadcast traffic
Improved security and isolation
Efficient IP address allocation

Example in cloud:
Public subnet
Private subnet
Database subnet

Quick exercise — fill in:
| CIDR | Subnet Mask     | Total IPs | Usable Hosts |
| ---- | --------------- | --------- | ------------ |
| /24  | 255.255.255.0   | 256       | 254          |
| /16  | 255.255.0.0     | 65536     | 65534        |
| /28  | 255.255.255.240 | 16        | 14           |


Task 4: Ports – The Doors to Services
What is a port? Why do we need them?
A port is a logical communication endpoint on a device used by applications to send and receive network traffic.
Since one server can run multiple services at the same time, ports help the operating system direct traffic to the correct service.

Example:
A server may run SSH, a web server, and a database simultaneously. Each service listens on a different port.

| Port  | Service                    |
| ----- | -------------------------- |
| 22    | SSH (Secure Shell)         |
| 80    | HTTP (Web traffic)         |
| 443   | HTTPS (Secure web traffic) |
| 53    | DNS (Domain Name System)   |
| 3306  | MySQL Database             |
| 6379  | Redis                      |
| 27017 | MongoDB                    |

Run ss -tulpn 

A port is a logical communication endpoint that allows multiple services to run on the same machine. Each service listens on a specific port, such as SSH on port 22 and HTTP on port 80.

Task 5: Putting It Together
Answer in 2–3 lines each:

**1️⃣ You run `curl http://myapp.com:8080` — what networking concepts are involved?**
DNS resolves **myapp.com** to an IP address, then a **TCP connection** is established to **port 8080** on that server. After the connection, an **HTTP request** is sent and the server returns the response.

---

**2️⃣ Your app can't reach a database at `10.0.1.50:3306` — what would you check first?**
First check **network connectivity and port reachability** (ping or `nc -zv 10.0.1.50 3306`). Then verify the **database service is running and listening on port 3306** and ensure **firewall/security group rules allow the connection**.

