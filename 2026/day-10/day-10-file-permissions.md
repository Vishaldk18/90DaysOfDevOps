# Day 10 Challenge - File Permissions & File Operations

## Objective

Learn and practice Linux file operations and file permissions using commands such as `touch`, `cat`, `vim`, `chmod`, `head`, and `tail`.

---

## Files Created

| File       | Purpose                                       |
| ---------- | --------------------------------------------- |
| devops.txt | Empty file created using touch                |
| notes.txt  | Text file with sample content                 |
| script.sh  | Shell script containing a simple echo command |

---

## Task 1: Create Files

### Create Empty File

```bash
touch devops.txt
```

### Create notes.txt with Content

```bash
echo "Linux file permissions practice" > notes.txt
echo "Day 10 Challenge" >> notes.txt
echo "Learning chmod command" >> notes.txt
```

### Create script.sh

```bash
vim script.sh
```

Contents:

```bash
echo "Hello DevOps"
```

### Verify Files

```bash
ls -l
```

Sample Output:

```text
-rw-r--r-- 1 user user    0 Jun 14 10:00 devops.txt
-rw-r--r-- 1 user user   65 Jun 14 10:02 notes.txt
-rw-r--r-- 1 user user   20 Jun 14 10:05 script.sh
```

---

## Task 2: Read Files

### Read notes.txt

```bash
cat notes.txt
```

### View script.sh in Read-Only Mode

```bash
vim -R script.sh
```

### Display First 5 Lines of /etc/passwd

```bash
head -n 5 /etc/passwd
```

### Display Last 5 Lines of /etc/passwd

```bash
tail -n 5 /etc/passwd
```

---

## Task 3: Understand Permissions

Permission Format:

```text
rwxrwxrwx
│  │  │
│  │  └── Others
│  └───── Group
└──────── Owner
```

Permission Values:

| Permission  | Value |
| ----------- | ----- |
| Read (r)    | 4     |
| Write (w)   | 2     |
| Execute (x) | 1     |

Check permissions:

```bash
ls -l devops.txt notes.txt script.sh
```

Example:

```text
-rw-r--r-- devops.txt
-rw-r--r-- notes.txt
-rw-r--r-- script.sh
```

Explanation:

* Owner: Read and Write
* Group: Read Only
* Others: Read Only
* No execute permission is set

---

## Task 4: Modify Permissions

### Make script.sh Executable

```bash
chmod +x script.sh
```

Verify:

```bash
ls -l script.sh
```

Output:

```text
-rwxr-xr-x script.sh
```

Run Script:

```bash
./script.sh
```

Output:

```text
Hello DevOps
```

---

### Make devops.txt Read-Only

Remove write permission for all:

```bash
chmod a-w devops.txt
```

Verify:

```bash
ls -l devops.txt
```

Output:

```text
-r--r--r-- devops.txt
```

---

### Set notes.txt Permission to 640

```bash
chmod 640 notes.txt
```

Verify:

```bash
ls -l notes.txt
```

Output:

```text
-rw-r----- notes.txt
```

Meaning:

* Owner: Read + Write
* Group: Read
* Others: No Access

---

### Create Directory with Permission 755

```bash
mkdir project
chmod 755 project
```

Verify:

```bash
ls -ld project
```

Output:

```text
drwxr-xr-x project
```

---

## Task 5: Test Permissions

### Attempt to Write to Read-Only File

```bash
echo "test" >> devops.txt
```

Possible Output:

```text
Permission denied
```

---

### Remove Execute Permission

```bash
chmod -x script.sh
```

Attempt to Run:

```bash
./script.sh
```

Output:

```text
bash: ./script.sh: Permission denied
```

---

## Permission Changes

| File       | Before    | After     |
| ---------- | --------- | --------- |
| script.sh  | rw-r--r-- | rwxr-xr-x |
| devops.txt | rw-r--r-- | r--r--r-- |
| notes.txt  | rw-r--r-- | rw-r----- |
| project    | default   | rwxr-xr-x |

---

## Commands Used

```bash
touch devops.txt

echo "Linux file permissions practice" > notes.txt
echo "Day 10 Challenge" >> notes.txt
echo "Learning chmod command" >> notes.txt

vim script.sh

cat notes.txt

vim -R script.sh

head -n 5 /etc/passwd

tail -n 5 /etc/passwd

chmod +x script.sh

./script.sh

chmod a-w devops.txt

chmod 640 notes.txt

mkdir project

chmod 755 project

ls -l

ls -ld project
```

---

## Screenshots

Add screenshots for:

1. File creation
2. Initial permissions using ls -l
3. Reading files with cat, head, and tail
4. Executing script.sh
5. Permission changes with chmod
6. Directory permissions
7. Permission denied errors

---

## What I Learned

1. Linux permissions are divided into Owner, Group, and Others.
2. The chmod command is used to control read, write, and execute permissions.
3. Execute permission is required to run scripts, while write permission is required to modify files.

---

## Conclusion

Successfully created files, viewed contents, modified permissions using chmod, executed scripts, and tested permission restrictions. This exercise helped reinforce Linux file management and permission concepts used daily in DevOps and System Administration.

