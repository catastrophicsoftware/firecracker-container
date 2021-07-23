# firecracker-container

Containerized firecracker.

USAGE EXAMPLE:

docker run -d --name test \
-v "$PWD"/vms/alpine/vmlinux.bin:/vm/vmlinux.bin \
-v "$PWD"/vms/alpine/alpine.ext4:/vm/alpine.ext4 \
-v "$PWD"/vms/alpine/alpine.json:/vm/config.json  \
--sysctl net.ipv4.ip_forward=1 \
--cap-add=NET_ADMIN \
--privileged \
-p 23:22 \
firecracker