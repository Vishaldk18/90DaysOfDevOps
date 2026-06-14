# Day 13 Challenge - Linux Volume Management (LVM)
# Prerequisites

Switch to root user:

```bash
sudo -i
```

or

```bash
sudo su
```

If no spare disk is available, create a virtual disk:

```bash
dd if=/dev/zero of=/tmp/disk1.img bs=1M count=1024

losetup -fP /tmp/disk1.img

losetup -a
```

Example Output:

```text
/dev/loop0: []: (/tmp/disk1.img)
```

---

# Task 1: Check Current Storage

## Commands

```bash
lsblk

pvs

vgs

lvs

df -h
```

## Purpose

* `lsblk` → Display block devices.
* `pvs` → Show Physical Volumes.
* `vgs` → Show Volume Groups.
* `lvs` → Show Logical Volumes.
* `df -h` → Show mounted filesystems and usage.

---

# Task 2: Create Physical Volume

## Command

```bash
pvcreate /dev/loop0
```

or

```bash
pvcreate /dev/sdb
```

## Verify

```bash
pvs
```

Example Output:

```text
PV         VG   Fmt  Attr PSize  PFree
/dev/loop0      lvm2 a--  <1.00g <1.00g
```

---

# Task 3: Create Volume Group

## Command

```bash
vgcreate devops-vg /dev/loop0
```

or

```bash
vgcreate devops-vg /dev/sdb
```

## Verify

```bash
vgs
```

Example Output:

```text
VG        #PV #LV #SN Attr   VSize  VFree
devops-vg   1   0   0 wz--n- 1020M 1020M
```

---

# Task 4: Create Logical Volume

## Command

```bash
lvcreate -L 500M -n app-data devops-vg
```

### Parameters

* `-L 500M` → Create 500 MB volume.
* `-n app-data` → Logical volume name.
* `devops-vg` → Volume group name.

## Verify

```bash
lvs
```

Example Output:

```text
LV       VG        Attr       LSize
app-data devops-vg -wi-a----- 500.00m
```

---

# Task 5: Format and Mount Logical Volume

## Format with ext4

```bash
mkfs.ext4 /dev/devops-vg/app-data
```

## Create Mount Point

```bash
mkdir -p /mnt/app-data
```

## Mount Volume

```bash
mount /dev/devops-vg/app-data /mnt/app-data
```

## Verify

```bash
df -h /mnt/app-data
```

Example Output:

```text
Filesystem                     Size Used Avail Use% Mounted on
/dev/mapper/devops--vg-app--data
                               477M   24K  442M   1% /mnt/app-data
```

---

# Task 6: Extend the Logical Volume

## Extend by 200 MB

```bash
lvextend -L +200M /dev/devops-vg/app-data
```

Example Output:

```text
Size of logical volume devops-vg/app-data changed from 500.00 MiB to 700.00 MiB.
```

## Resize Filesystem

```bash
resize2fs /dev/devops-vg/app-data
```

## Verify

```bash
df -h /mnt/app-data
```

Example Output:

```text
Filesystem                     Size Used Avail Use% Mounted on
/dev/mapper/devops--vg-app--data
                               677M   25K  642M   1% /mnt/app-data
```

---

# Complete Command List

```bash
sudo -i

dd if=/dev/zero of=/tmp/disk1.img bs=1M count=1024

losetup -fP /tmp/disk1.img

losetup -a

lsblk

pvs

vgs

lvs

df -h

pvcreate /dev/loop0

pvs

vgcreate devops-vg /dev/loop0

vgs

lvcreate -L 500M -n app-data devops-vg

lvs

mkfs.ext4 /dev/devops-vg/app-data

mkdir -p /mnt/app-data

mount /dev/devops-vg/app-data /mnt/app-data

df -h /mnt/app-data

lvextend -L +200M /dev/devops-vg/app-data

resize2fs /dev/devops-vg/app-data

df -h /mnt/app-data
```

---

# LVM Architecture

```text
Physical Disk (/dev/sdb or /dev/loop0)
            │
            ▼
Physical Volume (PV)
            │
            ▼
Volume Group (VG)
            │
            ▼
Logical Volume (LV)
            │
            ▼
Filesystem (ext4)
            │
            ▼
Mount Point (/mnt/app-data)
```
