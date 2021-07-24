# firecracker-container

##REQUIREMENTS:
-A host with KVM virtualization enabled
-Create a root filesystem image
-Compile or acquire an uncompressed linux kernel binary
-Create a firecracker MicroVM config file

###USAGE:
The kernel, rootfs image and config file will need to be mounted into the container under /vm
Make sure that the filepaths in the config file reference locations under /vm

-It is required that the iface_id in the config file for the MicroVM be eth0
-It is required that the host_dev_name config file for the MicroVM be tap0
-tap0 is automatically created when the host container launches
-It is expected that the rootfs image is configured to bring up eth0, with the address 172.20.0.2

```
{
  "boot-source": {
    "kernel_image_path": "/vm/vmlinux.bin",
    "boot_args": "console=ttyS0 reboot=k panic=1 pci=off"
  },
  "drives": [
    {
      "drive_id": "rootfs",
      "path_on_host": "/vm/alpine.ext4",
      "is_root_device": true,
      "is_read_only": false
    }
  ],
  "machine-config": {
    "vcpu_count": 1,
    "mem_size_mib": 512,
    "ht_enabled": false
  },
  "network-interfaces": [
  {
    "iface_id": "eth0",
    "guest_mac": "5a:b4:b9:f1:72:0f",
    "host_dev_name": "tap0"
  }]
}
```

```
docker run -d --name test \
-v "$PWD"/vms/alpine/vmlinux.bin:/vm/vmlinux.bin \
-v "$PWD"/vms/alpine/alpine.ext4:/vm/alpine.ext4 \
-v "$PWD"/vms/alpine/alpine.json:/vm/config.json  \
--sysctl net.ipv4.ip_forward=1 \
--cap-add=NET_ADMIN \
--privileged \
-p 23:22 \
firecracker
```

##Limitations:
Currently, only a single port forwarding rule is created in the host container to forward port 22 (inside the host container) to port 22 on the MicroVMs address.
If you need to forward additional ports to the MicroVM (which is somewhat likely) you will need to hack together your own solution to have the host container create these rules at launch