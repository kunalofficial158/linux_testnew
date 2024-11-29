#!/bin/bash

# Path to the properties file
properties_file="tasks.properties"

# Read properties from the file
while IFS='=' read -r key value; do
  # Remove leading/trailing spaces from key and value
  key=$(echo "$key" | xargs)
  value=$(echo "$value" | xargs)
  
  # Store the key-value pairs in variables
  if [[ "$key" == "time" ]]; then
    time_list="$value"
  elif [[ "$key" == "emailIds" ]]; then
    email_list="$value"
  elif [[ "$key" == "tasks" ]]; then
    tasks_list="$value"
  fi
done < "$properties_file"

# Split the comma-delimited strings into arrays
IFS=', ' read -r -a times <<< "$time_list"
IFS=', ' read -r -a emails <<< "$email_list"
IFS=',' read -r -a tasks <<< "$tasks_list"


# Loop through each email ID and task
for i in "${!emails[@]}"; do
  email="${emails[$i]}"
  task="${tasks[$i]}"
  
  # Extract the username (part before @) from the email
  username=$(echo "$email" | cut -d'@' -f1)
  
  # Create a directory named after the username (before the @ in the email)
  mkdir -p "$username"
  
  # Loop through each time and calculate the time minus 30 minutes
  job_number=1
  for j in "${!times[@]}"; do
    time="${times[$j]}"
    
    # Extract hour and minute from the time
    hour=$(echo "$time" | cut -d':' -f1)
    minute=$(echo "$time" | cut -d':' -f2)
    
    # Subtract 30 minutes
    total_minutes=$((hour * 60 + minute - 30))
    new_hour=$((total_minutes / 60))
    new_minute=$((total_minutes % 60))
    
    # Ensure the new hour and minute are in the correct format (e.g., 04:30)
    new_hour=$(printf "%02d" "$new_hour")
    new_minute=$(printf "%02d" "$new_minute")
    
    # Define the notification file path
    notification_file="$username/notification$job_number.txt"
    
    # Schedule the file creation using `at` 30 minutes before the scheduled time
    echo \"$task at $new_hour:$new_minute\" > $notification_file" | at "$new_hour:$new_minute
    
    # Output the scheduling info with the username
    echo "Scheduled job $job_number for $username at $new_hour:$new_minute with task: $task"

    # Increment the job number for the next task
    job_number=$((job_number + 1))
  done
done

echo "Notification files are scheduled to be created successfully."

