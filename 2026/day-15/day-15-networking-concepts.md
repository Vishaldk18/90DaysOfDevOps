Task 1: DNS – How Names Become IPs
Explain in 3–4 lines: what happens when you type google.com in a browser?



What are these record types? Write one line each:
A, AAAA, CNAME, MX, NS
Run: dig google.com — identify the A record and TTL from the output
Task 2: IP Addressing
What is an IPv4 address? How is it structured? (e.g., 192.168.1.10)
Difference between public and private IPs — give one example of each
What are the private IP ranges?
10.x.x.x, 172.16.x.x – 172.31.x.x, 192.168.x.x
Run: ip addr show — identify which of your IPs are private
Task 3: CIDR & Subnetting
What does /24 mean in 192.168.1.0/24?
How many usable hosts in a /24? A /16? A /28?
Explain in your own words: why do we subnet?
Quick exercise — fill in:
CIDR	Subnet Mask	Total IPs	Usable Hosts
/24	?	?	?
/16	?	?	?
/28	?	?	?
Task 4: Ports – The Doors to Services
What is a port? Why do we need them?
Document these common ports:
Port	Service
22	?
80	?
443	?
53	?
3306	?
6379	?
27017	?
Run ss -tulpn — match at least 2 listening ports to their services
Task 5: Putting It Together
Answer in 2–3 lines each:

You run curl http://myapp.com:8080 — what networking concepts from today are involved?
Your app can't reach a database at 10.0.1.50:3306 — what would you check first?
