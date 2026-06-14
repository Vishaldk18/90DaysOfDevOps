# Linux Fundamentals — Hands-On Practice Notes

Date: 2026-06-14
Environment: Ubuntu-based container (no systemd as PID 1 — common in containers/sandboxes)

---

## 1. Process Checks

### Command 1: `ps -ef | head -20`
List all running processes in full format.

```
UID        PID  PPID  C STIME TTY          TIME CMD
root         1     0  1 13:50 ?        00:00:01 /process_api --firecracker-init ...
root         2     0  0 13:50 ?        00:00:00 [kthreadd]
root         3     2  0 13:50 ?        00:00:00 [pool_workqueue_release]
root         4     2  0 13:50 ?        00:00:00 [kworker/R-rcu_gp]
...
root        14     2  0 13:50 ?        00:00:00 [ksoftirqd/0]
root        15     2  0 13:50 ?        00:00:00 [rcu_preempt]
```

**Observation:** PID 1 here is `/process_api` instead of the usual `systemd` or `init` — this confirms the system is running inside a container (no systemd as init).

---

### Command 2: `pgrep -fl bash`
Find a process by name and get its PID.

```
569 sh
```

**Observation:** `pgrep -fl <pattern>` returns PID + command line — useful for quickly locating a process before taking action (kill, renice, strace, etc.).

---

## 2. Service Checks

### Command 3: `systemctl status cron`

```
System has not been booted with systemd as init system (PID 1). Can't operate.
Failed to connect to bus: Host is down
```

**Observation:** `systemctl` is installed (`which systemctl` confirms it), but it can't run because this environment uses a custom init (`process_api`), not `systemd`. On a real VM/server, this command would show service state (`active/inactive`), uptime, and recent log lines.

---

### Command 4: `which systemctl service cron` + `ls /etc/init.d/`

```
/usr/bin/systemctl
/usr/sbin/service
dbus
procps
x11-common
```

**Observation:** The binaries exist, but `/etc/init.d/` only has a few legacy service scripts (`dbus`, `procps`, `x11-common`) — `cron` isn't installed/configured in this image. This is a good fundamentals lesson: tooling can be present while the service itself is absent — always verify both.

---

## 3. Log Checks

### Command 5: `tail -n 20 /var/log/dpkg.log`

```
2026-04-18 18:12:26 status installed gstreamer1.0-plugins-bad:amd64 1.24.2-1ubuntu4
2026-04-18 18:12:26 trigproc dictionaries-common:all 1.29.7 <none>
2026-04-18 18:12:26 status installed dictionaries-common:all 1.29.7
2026-04-18 18:12:26 trigproc libc-bin:amd64 2.39-0ubuntu8.7 <none>
2026-04-18 18:12:26 status installed libc-bin:amd64 2.39-0ubuntu8.7
2026-04-18 18:13:00 status triggers-pending ca-certificates-java:all 20240118
2026-04-18 18:13:02 status installed ca-certificates-java:all 20240118
```

**Observation:** `tail -n <N> <file>` is a quick way to check the most recent entries of any log file — here it's package install history rather than service activity.

---

### Command 6: `journalctl --no-pager -n 10`

```
No journal files were found.
-- No entries --
```

**Observation:** `journalctl` returns no entries because this container has no running systemd-journald. On a standard Linux server, this would show the last 10 log entries across all services.

---

## 4. Mini Troubleshooting Flow (find → inspect → act)

Goal: Start a background process, find it, check its state, then kill it and verify.

```bash
# Step 1: Start a background process
sleep 60 &
SLEEP_PID=$!
echo "Started sleep with PID $SLEEP_PID"
```
```
Started sleep with PID 586
```

```bash
# Step 2: Inspect the process
ps -p $SLEEP_PID
```
```
  PID TTY          TIME CMD
  586 ?        00:00:00 sleep
```

```bash
# Step 3: Take action — kill it
kill $SLEEP_PID
```

```bash
# Step 4: Verify it's gone
sleep 1
ps -p $SLEEP_PID
```
```
  PID TTY          TIME CMD
```
(empty output — process no longer exists)

**Flow summary:**
1. Find the PID (`pgrep` or `ps -ef | grep <name>`).
2. Inspect its state (`ps -p <PID>`, check STAT column for R/S/D/Z/T).
3. Take action (`kill <PID>` for graceful stop, `kill -9 <PID>` if it doesn't respond).
4. Verify the action worked (`ps -p <PID>` should return empty / non-zero exit).

---

## Key Takeaways
- `ps -ef` and `pgrep -fl` are the fastest way to locate processes by pattern.
- `systemctl`/`service` depend on systemd being PID 1 — containers often lack this.
- Logs aren't always in `journalctl`; fallback to flat files under `/var/log/`.
- A troubleshooting flow is always: **find → inspect → act → verify**.
