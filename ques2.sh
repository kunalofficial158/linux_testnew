#!/bin/bash

echo "TASK 1"
#find the free and used memory
echo "You will see the used and not used memory"
free -h                                           
#free is used for seeing the used and unused memory -h in human readble form

echo "------------------------------"


echo "TASK 2"
# disk space is greater than 50%, it should create a notification.txt in alerts directory
 
mkdir -p "$HOME/alert"

disk_usage=$(df / | grep / | awk '{print $5}' | sed 's/%//') 
 
echo "Disk usage $disk_usage%"

left_disk_usage=$((100-disk_usage))


# Get the largest file in the entire system 
largest_file=$(du -ah /$HOME | sort -rh | head -n 1) 


# Check if the disk usage is greater than 50% 
if [ $disk_usage -gt 50 ]; then 
	echo "Disk space is greater than 50%." 
	{ 
		echo "Current usage: $disk_usage%" 
		echo "Disk space left: $left_disk_usage%" 
		echo "Largest file: $largest_file" 
	} > "$HOME/alert/notification.txt" 
	echo "Disk space is >50%, notification file created." 
else 
	echo "Disk space is <50%, notification file not created." 
fi

echo "------------------------------"



echo "TASK 3"


# Print the 10 largest files in the specified directory, ignoring permission errors
du -ah /$HOME 2>/dev/null | sort -n -r | head -n 10

# lets get it explained one by one
# du :: Short for "disk usage," this command estimates file space usage.
# -a ::  This option includes all files, not just directories, in the output.
# / ::   after this directory address needs to be give 
# I am searching the directory -> "\\wsl.localhost\Ubuntu\home\kunal158\file"
# 2>/dev/null :: means "redirect the standard error stream (file descriptor 2) to /dev/null," effectively ignoring any error message
# There are 3 descriptors -> 0 is standard input (stdin), 1 is standard output (stdout), and 2 is standard error (stderr).
# sort -n -r :: sort sorts lines of text, -n means numerical, sort -r means reverse order.
# head -n 10 :: head outputs the first part of files ,-n 10 means show the first 10 lines.
