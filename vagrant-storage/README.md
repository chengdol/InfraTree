# Linux Storage
This Vagrantfile will launch an instance with a primary disk 40GB and 2 additional disks 2GB each.

You can play with operations such as: partition disk, format, mount and NFS.
Also creation of logical volume, loop device, raid partitioning, etc.

At the time of writting, attaching additional disk is a experimental feature, have to enable it:
```bash
# up
VAGRANT_EXPERIMENTAL="disks" vagrant up

# down
vagrant destroy -f
```

The diagram can help refreshing your brain. Thinking about how to get it and what does it mean.
```bash
# lsblk
NAME                    MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                       8:0    0   40G  0 disk
├─sda1                    8:1    0    1G  0 part /boot
├─sda2                    8:2    0   31G  0 part
│ ├─centos_centos7-root 253:0    0   29G  0 lvm  /
│ └─centos_centos7-swap 253:1    0    2G  0 lvm  [SWAP]
└─sda3                    8:3    0  2.8G  0 part
sdb                       8:16   0    2G  0 disk
sdc                       8:32   0    2G  0 disk
├─sdc1                    8:33   0  500M  0 part
│ └─vg1-apple           253:2    0  600M  0 lvm
├─sdc2                    8:34   0  500M  0 part
│ └─vg1-apple           253:2    0  600M  0 lvm
└─sdc3                    8:35   0  500M  0 part
loop0                     7:0    0    1G  0 loop
├─loop0p1               259:0    0  200M  0 loop /loop0
└─loop0p2               259:1    0  400M  0 loop /loop1
loop1                     7:1    0    1G  0 loop /loop2
```
