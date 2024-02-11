#!/bin/bash

# Step 1: Enable IP Forwarding
echo "Current IP Forwarding status:"
cat /proc/sys/net/ipv4/ip_forward
sleep 2
echo "Enabling IP Forwarding..."                                              sudo sysctl -w net.ipv4.ip_forward=1
sudo sysctl -p

sleep 2
# Step 2: Flush PREROUTING Chain (Optional)                                   echo "Flushing PREROUTING chain..."
sudo iptables -t nat -F PREROUTING
sleep 2
# Step 3: Set Up Port Forwarding
echo "Setting up port forwarding..."                                          sudo iptables -t nat -A PREROUTING -p tcp --dport 8080 -j DNAT --to-destination 144.202.69.96:22498
                                                                              # Step 4: Verify iptables Rules
echo "Current iptables rules:"
sudo iptables -t nat -L
sleep 2
echo "Port forwarding configured successfully!"
