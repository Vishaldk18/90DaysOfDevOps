#!/bin/bash

greet(){
  #read -p "Enter your name:" name
  echo "Hello, $1"
}



sum(){
  #read -p "Enter num1:" num1
  #read -p "Enter num2:" num2

  echo "sum is: $(( $1 + $2 ))"
}

greet vishal
sum 10 20




#!/bin/bash

check_disk(){
 
        used_disk=$(df -h / | awk 'NR==2 {print $2}' )
        echo "Used disk: $used_disk"
}


check_memory(){
        available_memory=$(free -h | awk 'NR==2 {print $4}')
        echo "Avaialble memory: $available_memory"
}



check_memory
check_disk


#!/bin/bash
set -euo pipefail

#set -u
#echo $name

#set -e
#cd kmmm
#echo "welcome tho devops"

#set -o pipefail
#false | true
#echo $?
~          
-e → exit on error
-u → error on unset variables
pipefail → pipelines fail correctly
By default, Bash sets a pipeline’s exit status to the exit status of the last command only.
This can hide failures earlier in the pipeline.


#!/bin/bash
 
demo_function() {
    local name="Vishal"
    echo "Inside function: $name"
}
 
demo_function
 
echo "Outside function: $name"


#!/bin/bash
 
demo_function() {
    name="Vishal"
    echo "Inside function: $name"
}
 
demo_function
 
echo "Outside function: $name"





                                                                                                                                             
                                                                                                                                             
                                                                                                                                             
