# Linux Storage Experiment
This Vagrantfile will launch a instance with a primary disk 40GB and 2 additional disks 2GB each.

You can play with operations such as: partition disk, format, mount and NFS.

At the time of writting, attaching additional disk is a experimental feature, have to enable it
```bash
# up
VAGRANT_EXPERIMENTAL="disks" vagrant up

# down
vagrant destroy -f
```
