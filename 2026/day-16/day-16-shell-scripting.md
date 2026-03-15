#!/bin/bash
echo "Hello Devops!"


#!/bin/bash

Name="vishal"
Role="DevOps Engineer"

echo 'Hello, I am $Name and I am a $Role'


#!/bin/bash

read -p "Enter your name:" Name
read -p "Enter your fav tool:" Tool
echo "Hello $Name, and my fav $Tool"


#!/bin/bash

read -p "Enter num:" Num

if [ $Num -eq 0 ]; then
        echo "Number equal to zero"
elif [ $Num -gt 0 ]; then
        echo "Number greater than zero"
else
        echo "Number less than zero"
fi



#!/bin/bash

read -p "Enter the file path to check:" file_path

if [ -f $file_path ]; then
        echo "File exists.."
else
        echo "File does not exist..."
fi




!/bin/bash

read -p "Enter service name: " service
read -p "Do you want to check status (y/n): " check

if [ "$check" = "y" ]; then
    if systemctl is-active --quiet "$service"; then
        echo "$service is active and running"
    else
        echo "$service is not running"
    fi
else
    echo "Skipped"
fi
