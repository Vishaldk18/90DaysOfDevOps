Today’s goal is to run a focused troubleshooting drill.

You will pick a running process/service on your system and:

Capture a quick health snapshot (CPU, memory, disk, network)
Trace logs for that service
Write a mini runbook describing what you did and what you’d do next if things were worse
This turns yesterday’s practice into a repeatable troubleshooting routine.

What’s a runbook?
A runbook is a short, repeatable checklist you follow during an incident: the exact commands you run, what you observed, and the next actions if the issue persists. Keep it concise so you can reuse it under pressure.


Run and record output for at least 8 commands (save snippets in your runbook)
Environment basics (2): uname -a, lsb_release -a (or cat /etc/os-release)
Filesystem sanity (2): create a throwaway folder and file, e.g., mkdir /tmp/runbook-demo, cp /etc/hosts /tmp/runbook-demo/hosts-copy && ls -l /tmp/runbook-demo
CPU / Memory (2): top/htop/ps -o pid,pcpu,pmem,comm -p <pid>, free -h, vm_stat (mac)
Disk / IO (2): df -h, du -sh /var/log, iostat/vmstat/dstat
Network (2): ss -tulpn/netstat -tulpn, curl -I <service-endpoint>/ping
Logs (2): journalctl -u <service> -n 50, tail -n 50 /var/log/<file>.log
Choose one target service/process (e.g., ssh, cron, docker, your web app) and stick to it for the drill.
For each command, add a 1–2 line note on what you observed (e.g., “CPU spikes to 80% when restarting”, “No recent errors in last 50 lines”).
End with a “If this worsens” section listing 3 next steps you would take (ex: restart strategy, increase log verbosity, collect strace).
Keep it concise and actionable (aim for ~1 page).




