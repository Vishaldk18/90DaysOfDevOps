# Troubleshooting Runbook — `process_api` (PID 1)

**Date:** 2026-06-14
**Target:** `process_api` (PID 1) — the container's init/host process
**Goal:** Quick health snapshot + log trace + reusable next-step checklist

---

## 1. Environment Basics

**Command:**
```bash
uname -a
cat /etc/os-release
```
**Output:**
```
Linux vm 6.18.5 #1 SMP PREEMPT_DYNAMIC @0 x86_64 x86_64 x86_64 GNU/Linux
PRETTY_NAME="Ubuntu 24.04.4 LTS"
VERSION_CODENAME=noble
```
**Observation:** Ubuntu 24.04 (Noble) on kernel 6.18.5. Confirms OS/kernel version before correlating any issue with known bugs/patches.

---

## 2. Filesystem Sanity

**Command:**
```bash
mkdir -p /tmp/runbook-demo
cp /etc/hosts /tmp/runbook-demo/hosts-copy && ls -l /tmp/runbook-demo
```
**Output:**
```
total 4
-rw-r--r-- 1 root root 65 Jun 14 13:58 hosts-copy
```
**Observation:** Filesystem is writable, copy succeeded, permissions normal (root:root, 644). No filesystem-level blockers.

---

## 3. CPU / Memory

**Command:**
```bash
ps -o pid,ppid,pcpu,pmem,comm -p 1
free -h
```
**Output:**
```
  PID  PPID %CPU %MEM COMMAND
    1     0  7.0  0.1 process_api
               total        used        free      shared  buff/cache   available
Mem:           3.9Gi       214Mi       3.8Gi       4.2Mi        73Mi       3.7Gi
Swap:             0B          0B          0B
```
**Observation:** `process_api` using 7% CPU, 0.1% memory — light load. System has 3.8Gi free, 0B swap used. No memory pressure.

---

## 4. Disk / IO

**Command:**
```bash
df -h
du -sh /var/log
vmstat 1 2
```
**Output:**
```
Filesystem      Size  Used Avail Use% Mounted on
/dev/vda        252G  8.6G   10G  47% /
988K    /var/log

procs -----------memory---------- ---swap-- -----io---- -system-- -------cpu-------
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
 2  0      0 3959048  11580  63932    0    0   946     0  130    3  1 32 66  1  0
 0  0      0 3958796  11580  63976    0    0     0     0  210  423  0  0 100  0
```
**Observation:** Root disk at 47% (10G avail — tight but ok). `/var/log` is tiny (988K), no log bloat. vmstat shows a brief CPU spike (32% sys) on first sample, then idle — likely just the command startup cost, not sustained load.

---

## 5. Network

**Command:**
```bash
ss -tulpn
curl -I http://localhost:2024
```
**Output:**
```
(ss returned no listening sockets visible to this user)

curl: (52) Empty reply from server
```
**Observation:** No listening sockets visible (likely permission-restricted in this sandbox), and the API port (2024) returns an empty reply on HEAD request — endpoint doesn't respond to plain HTTP HEAD, but this doesn't necessarily mean it's down (could be protocol mismatch, e.g., it expects a different scheme/handshake).

---

## 6. Logs

**Command:**
```bash
tail -n 50 /var/log/dpkg.log
journalctl -n 50
```
**Output:**
```
2026-04-18 18:13:02 status installed ca-certificates-java:all 20240118
...
No journal files were found.
-- No entries --
```
**Observation:** No recent errors in dpkg.log (last entries are from initial image build, April 18). `journalctl` has no journal files — this container doesn't run systemd-journald, so systemd-based services won't log there.

---

## If This Worsens — Next 3 Steps

1. **Restart strategy:** If `process_api` (PID 1) becomes unresponsive, a container restart is the practical fix (can't `systemctl restart` without systemd) — escalate to the orchestrator/host to recycle the container rather than killing PID 1 directly.
2. **Increase log verbosity / find real logs:** Since `journalctl` is empty, check for app-specific log files (`find / -name "*.log" -mmin -60`) or env vars controlling log level (`env | grep -i LOG`), and tail those directly.
3. **Collect deeper diagnostics:** Run `strace -p 1 -c` for a syscall summary, `ss -tulpn` as root (or `cat /proc/net/tcp`) to confirm listening ports, and re-test the endpoint with `curl -v` (verbose) instead of `-I` to see the actual handshake/response.
