#!/usr/bin/env bash
#
# Convert qemu builder output from packer to vagrant-libvirt box
#
# Usage: post-proc-vagrant-libvirt path/to/image [size_in_GB]

set -e

dir=$(dirname $1)
file=$(basename $1)
box_name="${file%.*}.box"

disk_size='40'
[[ "$#" -eq 2 ]] && disk_size="$2"

[ -d "$dir" ] || { echo "Invalid directory"; exit 1; }
cd $dir
[ -f "$file" ] || { echo "Invalid file"; exit 1; }

cat >metadata.json <<EOF
{
  "provider": "libvirt",
  "format": "qcow2",
  "virtual_size": "$disk_size"
}
EOF

cat >Vagrantfile <<EOF
Vagrant.configure("2") do |config|
  config.vm.provider :libvirt do |libvirt|
    libvirt.driver = "qemu"
  end
end
EOF

qemu-img convert -p -O qcow2 $file box.img
tar cvzf $box_name metadata.json Vagrantfile box.img
rm -rf metadata.json Vagrantfile box.img $file
