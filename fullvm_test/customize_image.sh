#!/bin/sh

if [ ! -f jammy-server-cloudimg-amd64.img ]; then
    sudo apt-get install libguestfs-tools
    wget https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img
fi

cp jammy-server-cloudimg-amd64.img customized.img

sudo virt-customize --format qcow2 -a customized.img --upload nyx-loader.service:/etc/systemd/system/nyx-loader.service
sudo virt-customize --format qcow2 -a customized.img --run-command "systemctl enable nyx-loader.service"
sudo virt-customize --format qcow2 -a customized.img --mkdir "/opt/nyx"
sudo virt-customize --format qcow2 -a customized.img --upload ../packer/packer/linux_x86_64-userspace/bin64/loader:/opt/nyx/loader
sudo virt-customize --format qcow2 -a customized.img --upload ../packer/packer/linux_x86_64-userspace/bin64/hget:/opt/nyx/hget
sudo virt-customize --format qcow2 -a customized.img --upload ../packer/packer/linux_x86_64-userspace/bin64/habort:/opt/nyx/habort
sudo virt-customize --format qcow2 -a customized.img --run-command "chmod +x /opt/nyx/*"
