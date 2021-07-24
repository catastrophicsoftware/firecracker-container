#!/bin/sh

echo "Creating bridge interface"
ip link add name br0 type bridge
ip addr add 172.20.0.1/24 dev br0
ip link set dev br0 up
echo "Done!"

echo "Configuring NAT"
iptables --table nat --append POSTROUTING --out-interface eth0 -j MASQUERADE
iptables --insert FORWARD --in-interface br0 -j ACCEPT
echo "Done!"

echo "Creating tap interface"
ip tuntap add dev tap0 mode tap
brctl addif br0 tap0
ifconfig tap0 up
echo "Done!"

echo "Adding default port forwarding rule for ssh"
iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 22 -j DNAT --to $MICROVM_IP:22
echo "Done!"

echo "Launching MicroVM!"
firecracker --no-api --config-file config.json
echo "MicroVM Terminated!"