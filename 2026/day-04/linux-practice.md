Today’s goal is to practice Linux fundamentals with real commands.

You will create a short practice note by actually running basic commands and capturing what you see:

Check running processes
Inspect one systemd service
Capture a small troubleshooting flow
This is hands-on. Keep it simple and focused on fundamentals.

Follow these rules while creating your practice note:

Run and record output for at least 6 commands
Include 2 process commands (ps, top, pgrep, etc.)
Include 2 service commands (systemctl status, systemctl list-units, etc.)
Include 2 log commands (journalctl -u <service>, tail -n 50, etc.)
Pick one service on your system (example: ssh, cron, docker) and inspect it
Keep it simple and actionable


Process checks
Service checks
Log checks
Mini troubleshooting steps
1) to find a process either use ps -ef | grep or pgrep get the pid
2) take the necessary action like if you wnat to kill it use kill or check the stat





