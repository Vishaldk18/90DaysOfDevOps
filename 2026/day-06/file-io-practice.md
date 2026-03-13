1  touch nf.txt
    2  ls
    3  hello > nf.txt
    4  echo"hell" > nf.txt
    5  echo "hell" > nf.txt
    6  cat nf.txt
    7  echo hell2 >> nf.txt
    8  cat nf.txt
    9  echo "Create a file named notes.txt Write 3 lines into the file using redirection (> and >>) Use cat to read the full file Use head and tail to read parts of the file Use tee once to write and display at the same time Keep it short (8–12 lines total in the file)" >> nf.txt
   10  cat nf.txt
   11  head nf.txt
   12  head -n 1 nf.txt
   13  tail -n 2 nf.txt
   14  echo "this is the demo of tee command" | tee nf.txt
   15  cat nf.txt
   16  echo "this is the demo of tee command" >>  | tee nf.txt
   17  echo "this is the demo of tee command" | tee -a nf.txt
   18  cat nf.txt
   19  history
