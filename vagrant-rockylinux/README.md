# Context
This git repo contains Vagrantfile and provisioning scripts to bring up a CentOS
VM through Vagrant plus VirtualBox.

- The `Vagrantfile-template` contains Vagrant configuration to bring up Centos VM.
- The `privisioners` folder contains installation script to be run after VM is up.

## Prerequisite
Download and install Vagrant:
- https://www.vagrantup.com/downloads

Download and install VirtualBox:
- https://www.virtualbox.org/wiki/Downloads

## How-to
Specify which provisioner script to run, for example to run `privision-basic.sh`:
```bash
sed -e "s|#SUFFIX#|basic|g" ./Vagrantfile-template > ./Vagrantfile
```
Simply run vagrant command to launch VM:
```bash
vagrant up
```
Good output example:
```
==> default: Importing base box 'bento/rockylinux-9'...
==> default: Matching MAC address for NAT networking...
==> default: Checking if box 'bento/rockylinux-9' version '202502.21.0' is up to date...
==> default: Setting the name of the VM: vagrant-centos_default_1750737985993_20662
==> default: Clearing any previously set network interfaces...
==> default: Preparing network interfaces based on configuration...
    default: Adapter 1: nat
    default: Adapter 2: hostonly
==> default: Forwarding ports...
    default: 22 (guest) => 2222 (host) (adapter 1)
==> default: Running 'pre-boot' VM customizations...
==> default: Booting VM...
==> default: Waiting for machine to boot. This may take a few minutes...
    default: SSH address: 127.0.0.1:2222
    default: SSH username: vagrant
    default: SSH auth method: private key
    default:
    default: Vagrant insecure key detected. Vagrant will automatically replace
    default: this with a newly generated keypair for better security.
    default:
    default: Inserting generated public key within guest...
    default: Removing insecure key from the guest if it's present...
    default: Key inserted! Disconnecting and reconnecting using new SSH key...
==> default: Machine booted and ready!
==> default: Checking for guest additions in VM...
    default: No guest additions were detected on the base box for this VM! Guest
    default: additions are required for forwarded ports, shared folders, host only
    default: networking, and more. If SSH fails on this machine, please install
    default: the guest additions and repackage the box to continue.
    default:
    default: This is not an error message; everything may continue to work properly,
    default: in which case you may ignore this message.
==> default: Setting hostname...
==> default: Configuring and enabling network interfaces...
==> default: Running provisioner: shell...
    default: Running: /var/folders/yp/sv8d1b
...
```

Note that if you update vagrantfile after you run `vagrant up` and you want to
recreate the VM, you may need to run
```bash
vagrant reload
```

Check VM status:
```bash
vagrant status

default                   running (virtualbox)
```

SSH to VM, vagrant user is in `sudo` group, switch to root user by `sudo su -`:
```bash
vagrant ssh
```

Poweroff VM, all VM changes are kept:
```bash
vagrant halt
```

Delete and release VM resources:
```bash
vagrant destroy -f
```
