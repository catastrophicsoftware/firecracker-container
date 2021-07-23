#!/bin/sh

echo "Creating bridge interface"
ip link add name br0 type bridge
ip addr add 172.20.0.1/24 dev br0
ip link set dev br0 up
echo "Done!"

echo "Configuring NAT"
sysctl -w net.ipv4.ip_forward=1
iptables --table nat --append POSTROUTING --out-interface eth0 -j MASQUERADE
iptables --insert FORWARD --in-interface br0 -j ACCEPT
echo "Done!"

echo "Creating tap interface"
ip tuntap add dev tap0 mode tap
brctl addif br0 tap0
ifconfig tap0 up
echo "Done!"

echo "Launching MicroVM!"
firecracker --no-api --config-file /vm/config.json
echo "MicroVM Terminated!"