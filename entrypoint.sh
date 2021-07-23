#!/bin/sh


echo "Creating bridge interface"
ip link add name br0 type bridge
ip addr add 172.20.0.1/24 dev br0
ip link set dev br0 up
echo "Done!"

echo "Configuring NAT"
#sysctl -w net.ipv4.ip_forward=1
iptables --table nat --append POSTROUTING --out-interface eth0 -j MASQUERADE
iptables --insert FORWARD --in-interface br0 -j ACCEPT
echo "Done!"

echo "Creating tap interface"
ip tuntap add dev tap0 mode tap
brctl addif br0 tap0
ifconfig tap0 up
echo "Done!"

echo "Adding default port forwarding rule for ssh on 23"
iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 23 -j DNAT --to 172.20.0.2:23 #TODO: automate this
#in production situations, we don't know what the internal address of the MicroVM will be.
echo "Done!"

echo "Launching MicroVM!"
firecracker --no-api --config-file /vm/config.json
echo "MicroVM Terminated!"