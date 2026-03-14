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
Name resolution: dig <domain> or nslookup <domain> — record the resolved IP.
HTTP check: curl -I <http/https-url> — note the HTTP status code.
Connections snapshot: netstat -an | head — count ESTABLISHED vs LISTEN (rough).
Pick one target service/host (e.g., google.com, your lab server, or a local service) and stick to it for ping/traceroute/curl where possible.

Mini Task: Port Probe & Interpret
Identify one listening port from ss -tulpn (e.g., SSH on 22 or a local web app).
From the same machine, test it: nc -zv localhost <port> (or curl -I http://localhost:<port>).
Write one line: is it reachable? If not, what’s the next check? (e.g., service status, firewall).
Reflection (add to your markdown)
Which command gives you the fastest signal when something is broken?
What layer (OSI/TCP-IP) would you inspect next if DNS fails? If HTTP 500 shows up?
Two follow-up checks you’d run in a real incident.
