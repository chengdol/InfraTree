# Vagrant Jenkins Lab Environment
This Vagrantfile will bring up one primary Jenkins server and two agents, they are all CentOS based.
The purpose of this configuration is to play around with Jenkins features and functionalities.

By default the server machine will install Jenkins with latest stable version, customize the `scripts/server.sh` provisioning file to your needs.

For general purpose centOS virtual machine setup, refer to: 
- https://github.com/chengdol/vagrant-centos

From Vagrant's perspective, the access name of virtual machine:
- server
- agent1
- agent2

The hostname for each is:
- jenkins-server
- jenkins-agent1
- jenkins-agent2

These 3 machines use static private IP, which means they are in the same private network group and can SSH access from each other, you can open firefox to access Jenkins server `http://192.168.3.2:8080`:
- server IP: 192.168.3.2
- agent1 IP: 192.168.3.11
- agent2 IP: 192.168.3.12

There is a SSH key pair generated during setup process in server machine and the public key is appended to `authorized_keys` in each agent, for example, SSH to agent1 from server:
```bash
ssh vagrant@192.168.3.11
```

You can modify the IP in `Vagrantfile`.
The synced folder inside all machines is `/vagrant`, which get sync with project root directory in host.

## Prerequisite
Use latest version is fine.

Download and install Vagrant:
- https://www.vagrantup.com/downloads

Download and install VirtualBox: 
- https://www.virtualbox.org/wiki/Downloads

## Procedure
Create project folder:
```bash
mkdir vagrant-jenkins
cd vagrant-jenkins
git clone https://github.com/chengdol/vagrant-jenkins.git .
```

Simply run vagrant command to launch all virtual machines, the same command for boot machine after poweroff:
```bash
## launch all
vagrant up

## launch specified
vagrant up [machine name]
```
Access Jenkin web UI from `localhost:8080` (the port may vary due to collision, see Vagrant boot output)

SSH to guest machine, vagrant user is in sudo group, switch to root user by `sudo su -`:
```bash
vagrant ssh [server]
vagrant ssh agent1
vagrant ssh agent2
```

After exit from guest machine, poweroff, all changes in machine are kept:
```bash
vagrant halt
```

Or just delete and release all resources:
```bash
vagrant destroy -f
```

## Add Node Agent in Jenkins
When add node item, launch agent via SSH:
- Create credential by `SSH Username with private key`:
  - username: `vagrant`
  - private key is `/home/vagrant/.ssh/id_rsa` in server machine

- Remote root directory: `/home/vagrant` or other directory can be accessed.
- Host Key Verification Strategy: `Non verifying Verification Strategy`.

## TODO
- Idempotent provisioning
- Jenkins pipeline declarative script



