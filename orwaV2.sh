#!/bin/bash

# Function to check if input is an IP address
is_ip() {
  local input=$1
  [[ $input =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]
}

# Function to fetch and display undetected URLs and hostnames for IP or domain
fetch_undetected_urls() {
  local input=$1
  local api_key_index=$2
  local api_key

  if [ $api_key_index -eq 1 ]; then
    api_key="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  elif [ $api_key_index -eq 2 ]; then
    api_key="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  else
    api_key="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
  fi

  if is_ip "$input"; then
    local URL="https://www.virustotal.com/vtapi/v2/ip-address/report?apikey=$api_key&ip=$input"
    echo -e "\nFetching data for IP: \033[1;34m$input\033[0m (using API key $api_key_index)"
  else
    local URL="https://www.virustotal.com/vtapi/v2/domain/report?apikey=$api_key&domain=$input"
    echo -e "\nFetching data for domain: \033[1;34m$input\033[0m (using API key $api_key_index)"
  fi

  response=$(curl -s "$URL")
  if [[ $? -ne 0 || -z "$response" ]]; then
    echo -e "\033[1;31mError fetching data for: $input\033[0m"
    return
  fi

  # Print hostnames if input is IP
  if is_ip "$input"; then
    hostnames=$(echo "$response" | jq -r '.resolutions[].hostname' 2>/dev/null)
    if [[ -n "$hostnames" ]]; then
      echo -e "\033[1;35mHostnames resolved for IP: $input\033[0m"
      echo "$hostnames"
    else
      echo -e "\033[1;33mNo hostnames found for IP: $input\033[0m"
    fi
  fi

  # Extract and print undetected URLs
  undetected_urls=$(echo "$response" | jq -r '.undetected_urls[][0]' 2>/dev/null)
  if [[ -z "$undetected_urls" ]]; then
    echo -e "\033[1;33mNo undetected URLs found for: $input\033[0m"
  else
    echo -e "\033[1;32mUndetected URLs for: $input\033[0m"
    echo "$undetected_urls"
  fi
}

# Function to display a countdown
countdown() {
  local seconds=$1
  while [ $seconds -gt 0 ]; do
    echo -ne "\033[1;36mWaiting for $seconds seconds...\033[0m\r"
    sleep 1
    : $((seconds--))
  done
  echo -ne "\033[0K"  # Clear the countdown line
}

# Check if an argument is provided
if [ -z "$1" ]; then
  echo -e "\033[1;31mUsage: $0 <ip_or_domain_or_file_with_mixed_inputs>\033[0m"
  exit 1
fi

# Initialize variables for API key rotation
api_key_index=1
request_count=0

# Check if the argument is a file
if [ -f "$1" ]; then
  while IFS= read -r input; do
    input=$(echo "$input" | sed 's|https\?://||') # Strip scheme if present
    fetch_undetected_urls "$input" $api_key_index
    countdown 20

    # Rotate API key every 5 requests
    request_count=$((request_count + 1))
    if [ $request_count -ge 5 ]; then
      request_count=0
      if [ $api_key_index -eq 1 ]; then
        api_key_index=2
      elif [ $api_key_index -eq 2 ]; then
        api_key_index=3
      else
        api_key_index=1
      fi
    fi
  done < "$1"
else
  input=$(echo "$1" | sed 's|https\?://||') # Strip scheme if present
  fetch_undetected_urls "$input" $api_key_index
fi

echo -e "\033[1;32mAll done!\033[0m"

