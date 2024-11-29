#!/bin/bash

#a temp file is made to keep changes
>temp_log.txt

#looped through each line of tmp file

echo "The log file in the question"
cat log.txt
echo "---------"


while read -r line; do
	
	#finding the user action source destination from the ques3log.txt and then making a key of "user,source,destination" 

	user=$(echo "$line" | awk '{print $3}')
	action=$(echo "$line" | awk '{print $4}')
	sources=$(echo "$line" | awk '{print $8}') 
	destination=$(echo "$line" | awk '{print $10}')
	key="$user $sources $destination"
						
	#till here the templog.txt will be
	#Chinnakani Bangalore Sivakasi 
	#Ganesh Bangalore Madurai
	#Chinnakani Bangalore sivakasi	


	#now if else is used to check according to the conditions
	
	if [ "$action" == "booked" ]; then
		echo "$key booked" >> temp_log.txt			#if action is booked put "booked" in front of key
							
	elif [ "$action" == "cancelled" ]; then
		sed -i "/^$key booked$/d" temp_log.txt 			#if action is cancelled then chk for "key booked"	
									#if present delete	
	fi 

	done < log.txt
	
	#now we need to find username and number of tickets booked
	
	echo "Printing the content of temporary file" 
	cat temp_log.txt
	echo "---------"
	echo "Final Ans:"

	awk '{ print $1 }' temp_log.txt | sort | uniq -c | awk '{print $2 "," $1}'      
	
	#using awk we find username, we sort according to string, then put number in front of username -> 
	#1 Chinnakani
	# then  
	# it awk change the order
	# Chinnakani,1






