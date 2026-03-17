🧠 Shell Scripting – Interview Revision Notes (DevOps Focus)
 
---
 
🎯 1. Basics (Very Common Questions)
 
❓ What is Shebang?
 
- "#!/bin/bash" → tells system which interpreter to use.
- Required for executing script directly.
 
❓ How do you run a script?
 
chmod +x script.sh
./script.sh
bash script.sh
 
- "chmod +x" → makes script executable.
 
❓ Types of variables?
 
VAR="value"
echo $VAR
 
- "" "" → expands variables
- "' '" → treats as literal
 
❓ How to take user input?
 
read name
 
❓ Special variables (VERY IMPORTANT)
 
- "$0" → script name
- "$1, $2" → arguments
- "$#" → number of args
- "$@" → all args
- "$?" → last command exit status
 
---
 
🔀 2. Conditionals (Interview Favorite)
 
❓ String vs Integer comparison
 
[ "$a" = "$b" ]   # string
[ $a -eq $b ]     # integer
 
❓ File checks
 
[ -f file ]  # file exists
[ -d dir ]   # directory
[ -r file ]  # readable
 
❓ If-else syntax
 
if [ condition ]; then
  ...
elif [ condition ]; then
  ...
else
  ...
fi
 
❓ Logical operators
 
- "&&" → AND
- "||" → OR
- "!" → NOT
 
❓ Case statement (used in scripts like menu systems)
 
case $var in
  start) ;;
  stop) ;;
  *) ;;
esac
 
---
 
🔁 3. Loops (Very Practical)
 
❓ Types of loops
 
- for
 
for i in 1 2 3; do echo $i; done
 
- C-style
 
for ((i=0;i<5;i++)); do echo $i; done
 
- while
 
while [ condition ]; do ...; done
 
- until
 
until [ condition ]; do ...; done
 
❓ Loop control
 
- "break" → exit loop
- "continue" → skip iteration
 
❓ Real-world usage
 
for file in *.log; do echo $file; done
 
---
 
🧠 4. Functions (Common DevOps Use)
 
❓ How to define function?
 
func() {
  echo "Hello"
}
 
❓ Passing arguments
 
func() {
  echo $1
}
 
❓ Return vs echo
 
- "return" → exit status (0–255)
- "echo" → actual output
 
❓ Local variables
 
local var="value"
 
---
 
🔍 5. Text Processing (MOST IMPORTANT FOR DEVOPS)
 
❓ grep (search)
 
grep -i "error" file
grep -r "error" .
 
❓ awk (column processing)
 
awk '{print $1}'
awk -F: '{print $1}'
 
❓ sed (edit text)
 
sed 's/old/new/g'
sed -i 's/old/new/g'
 
❓ cut
 
cut -d: -f1
 
❓ sort & uniq
 
sort -n
sort -r
uniq -c
 
❓ wc
 
wc -l  # lines
 
❓ tail (log monitoring)
 
tail -f app.log
 
---
 
⚡ 6. Real DevOps One-Liners (Interview Gold)
 
🔥 Delete old files
 
find . -type f -mtime +7 -delete
 
🔥 Replace text in multiple files
 
sed -i 's/foo/bar/g' *.txt
 
🔥 Count errors
 
grep -c "ERROR" app.log
 
🔥 Monitor logs live
 
tail -f app.log | grep ERROR
 
🔥 Disk usage alert
 
df -h | awk '$5 > 80'
 
---
 
🛠️ 7. Error Handling (ADVANCED + HIGH IMPACT)
 
❓ Exit codes
 
- "0" → success
- non-zero → failure
 
echo $?
 
❓ Strict mode (BEST PRACTICE)
 
set -euo pipefail
 
- "-e" → exit on error
- "-u" → undefined variable error
- "pipefail" → catch pipe errors
 
❓ Debugging
 
set -x
 
❓ Trap (cleanup)
 
trap 'rm temp.txt' EXIT
 
---
 
🎯 Interview Tips (VERY IMPORTANT)
 
💡 Common questions they ask:
 
- Difference between ""$VAR"" and "$VAR"
- "grep vs awk vs sed"
- "$@ vs $*"
- "return vs exit"
- "while read" vs "for loop"
- Exit status "$?"
 
---
 
🚀 Final Pro Tip (Say This in Interview)
 
«“I usually write scripts with "set -euo pipefail", use "awk/grep/sed" for log parsing, and automate tasks like log monitoring, disk checks, and deployments.”»
 
---
 
✅ One-Line Summary
 
👉 Shell scripting = automation + text processing + system control
 
---
