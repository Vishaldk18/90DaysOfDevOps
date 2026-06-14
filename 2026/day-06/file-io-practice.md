# Linux File Operations and Redirection Practice

## Create a File

```bash
touch nf.txt
ls
```

## Write Content Using `>`

Incorrect command:
```bash
hello > nf.txt
```

Correct command:
```bash
echo "hell" > nf.txt
```

Verify content:
```bash
cat nf.txt
```

## Append Content Using `>>`

```bash
echo "hell2" >> nf.txt
cat nf.txt
```

## Append a Long Line

```bash
echo "Create a file named notes.txt Write 3 lines into the file using redirection (> and >>) Use cat to read the full file Use head and tail to read parts of the file Use tee once to write and display at the same time Keep it short (8–12 lines total in the file)" >> nf.txt
```

Verify:
```bash
cat nf.txt
```

## Read File Contents

Display first 10 lines:
```bash
head nf.txt
```

Display first line:
```bash
head -n 1 nf.txt
```

Display last 2 lines:
```bash
tail -n 2 nf.txt
```

## Use `tee` Command

Overwrite file and display output:
```bash
echo "this is the demo of tee command" | tee nf.txt
```

Verify:
```bash
cat nf.txt
```

Append to file and display output:
```bash
echo "this is the demo of tee command" | tee -a nf.txt
```

Verify:
```bash
cat nf.txt
```

## View Command History

```bash
history
```
