#!/bin/bash

fruits=("apple" "banana" "strawberry" "coconut" "greps")

for f in ${fruits[@]}
do
        echo "$f"
done


for i in {1..10}; do echo "$i"; done


#!/bin/bash

read -p "Enter a num:" Num

while [ $Num -ge 0 ]
do
        echo $Num
        (( Num-- ))
done

echo "Done...."


#!/bin/bash

if [ $# -eq 0 ]
then
        echo "Enter at your name while executing script, for e.g ./greet.sh vishal"
else
        echo "Hello $1, welcome to devops!!!!!"
fi



#!/bin/bash


echo "total number of arguments:$#"

for a in $@
do
        echo $a
done

echo "Name of scripts:$0"



[ ]	basic conditions
[[ ]]	advanced conditions (recommended)
(( ))	arithmetic
none	running commands

#!/bin/bash

if [ "$USER" != "root" ]
then
        echo "run as root"
        exit 1

fi

pkg_list=("nginx" "wget" "curl" "git")

echo "Updating package index..."
sudo apt-get update -qq

for p in "${pkg_list[@]}"
do
    if dpkg -s "$p" > /dev/null 2>&1
    then
        echo "$p already installed"
    else
        echo "Installing $p..."
        sudo apt-get install -y "$p" > /dev/null 2>&1
    fi
done


#!/bin/bash

set -e

mkdir /tmp/devops-test || echo "Direcotry already exists"

cd /tmp/devops-test

touch demo.txt




