# Networking Fundamentals – DNS, IP Addressing, CIDR & Ports
# Task 1: DNS – How Names Become IPs

## What Happens When You Type google.com in a Browser?

When you type a URL such as **google.com**, the browser first checks its local cache for the IP address. If not found, the operating system cache is checked. If the address is still not available, a DNS query is sent to a DNS resolver (such as Google DNS 8.8.8.8 or an ISP DNS server).

The DNS resolver contacts:

1. Root DNS Server
2. TLD DNS Server (.com)
3. Authoritative DNS Server

The resolver returns the IP address. The browser then establishes a TCP connection to the server, performs a TLS/SSL handshake if HTTPS is used, sends an HTTP request, and receives the webpage content.

### Interview Answer

> The browser first checks cache. If the IP is not found, it queries a DNS resolver which contacts root, TLD, and authoritative DNS servers to get the server's IP address. Then the browser establishes a TCP/HTTPS connection, sends an HTTP request, and the server returns the webpage which the browser renders.

---

## DNS Record Types

| Record Type | Description                                                |
| ----------- | ---------------------------------------------------------- |
| A           | Maps a domain name to an IPv4 address                      |
| AAAA        | Maps a domain name to an IPv6 address                      |
| CNAME       | Creates an alias pointing to another domain name           |
| MX          | Specifies the mail server responsible for receiving emails |
| NS          | Specifies the authoritative DNS servers for a domain       |

### Example

```bash
dig google.com
```

### Sample Output

```text
google.com.     300     IN      A       142.250.183.14
```

* **A Record:** 142.250.183.14
* **TTL:** 300 seconds

---

# Task 2: IP Addressing

## What is an IPv4 Address?

An IPv4 address is a 32-bit numerical address used to identify devices on a network.

Example:

```text
192.168.1.10
```

It consists of four octets separated by dots, where each octet ranges from 0–255.

---

## Public vs Private IP Address

A public IP is globally unique and reachable over the Internet, while a private IP is used within internal networks and is not directly accessible from the Internet.

| Type       | Description                  | Example      |
| ---------- | ---------------------------- | ------------ |
| Public IP  | Accessible over the Internet | 8.8.8.8      |
| Private IP | Used inside local networks   | 192.168.1.10 |

---

## Private IP Address Ranges

```text
10.0.0.0/8
172.16.0.0 – 172.31.255.255
192.168.0.0/16
```

Equivalent shorthand:

```text
10.x.x.x
172.16.x.x – 172.31.x.x
192.168.x.x
```

---

## Check Your IP Addresses

```bash
ip addr show
```

### Observation

Private IPs generally fall into:

* 10.x.x.x
* 172.16.x.x – 172.31.x.x
* 192.168.x.x

---

# Task 3: CIDR & Subnetting

## What Does /24 Mean?

Example:

```text
192.168.1.0/24
```

The `/24` indicates that the first 24 bits are used for the network portion of the address.

```text
24 bits = Network
8 bits  = Host
```

---

## Usable Hosts Calculation

### /24 Network

```text
2^8 = 256
256 - 2 = 254 usable hosts
```

### /16 Network

```text
2^16 = 65536
65536 - 2 = 65534 usable hosts
```

### /28 Network

```text
2^4 = 16
16 - 2 = 14 usable hosts
```

---

## Why Do We Subnet?

Subnetting divides a large network into smaller, manageable networks.

### Benefits

* Better network organization
* Reduced broadcast traffic
* Improved security and isolation
* Efficient IP address allocation

### Cloud Example

* Public Subnet
* Private Subnet
* Database Subnet

---

## CIDR Reference Table

| CIDR | Subnet Mask     | Total IPs | Usable Hosts |
| ---- | --------------- | --------- | ------------ |
| /24  | 255.255.255.0   | 256       | 254          |
| /16  | 255.255.0.0     | 65536     | 65534        |
| /28  | 255.255.255.240 | 16        | 14           |

---

# Task 4: Ports – The Doors to Services

## What is a Port?

A port is a logical communication endpoint used by applications to send and receive network traffic.

Ports allow multiple services to run on the same machine simultaneously.

### Example

A server can run:

* SSH
* Web Server
* Database

Each service listens on a different port.

---

## Common Ports

| Port  | Service |
| ----- | ------- |
| 22    | SSH     |
| 80    | HTTP    |
| 443   | HTTPS   |
| 53    | DNS     |
| 3306  | MySQL   |
| 6379  | Redis   |
| 27017 | MongoDB |

---

## Check Listening Ports

```bash
ss -tulpn
```

### Purpose

* Show listening services
* Display ports in use
* Identify processes bound to ports

### Example Output

```text
tcp LISTEN 0 128 0.0.0.0:22
```

This indicates SSH is listening on port 22.

---

## Interview Answer

> A port is a logical communication endpoint that allows multiple services to run on the same machine. Each service listens on a specific port, such as SSH on port 22 and HTTP on port 80.

---

# Task 5: Putting It Together

## 1. You Run curl http://myapp.com:8080 — What Networking Concepts Are Involved?

DNS first resolves **myapp.com** to an IP address. A TCP connection is then established to **port 8080** on the target server. Once connected, an HTTP request is sent and the application returns a response.

---

## 2. Your App Cannot Reach a Database at 10.0.1.50:3306 — What Would You Check First?

First verify network connectivity and port reachability:

```bash
nc -zv 10.0.1.50 3306
```

Then check:

* Whether the database service is running
* Whether it is listening on port 3306
* Firewall rules
* Security group rules
* Network ACLs

---

# Key Takeaways

1. DNS translates domain names into IP addresses.
2. CIDR notation determines network and host allocation.
3. Ports allow multiple services to communicate on the same server.
4. Troubleshooting usually starts with DNS, connectivity, ports, and application checks.
5. Commands such as `dig`, `ip addr`, `ss`, `ping`, `curl`, and `nc` are essential networking tools for DevOps engineers.
