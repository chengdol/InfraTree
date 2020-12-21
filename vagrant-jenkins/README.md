# Vagrant Jenkins Lab Environment
This Vagrantfile will bring up one primary Jenkins server and two agents, they are all CentOS.
The purpose of this configuration is to play with Jenkins.


TODO:
[ ] Idempotent provisioning
[ ] Jenkins pipeline declarative script

By default the server will install Jenkins latest stable version, customize the `provision/server.sh` file for your needs.
```bash
# bring up cluster
vagrant up

# power off
vagrant halt

# destroy cluster
vagrant destroy -f
```

SSH to each machine, then `sudo su -` as root user.
```bash
vagrant ssh [server]
vagrant ssh agent1
vagrant ssh agent2
```

These 3 machines use static private IP, which means they are in the same private network group and can SSH access from each other, you can open firefox to access Jenkins server `http://192.168.3.2:8080`:
```
server IP: 192.168.3.2
agent1 IP: 192.168.3.11
agent2 IP: 192.168.3.12
```

There is a SSH key pair generated during setup process in server machine and the public key is appended to `authorized_keys` in each agent, for example, SSH to agent1 from server:
```bash
ssh root@192.168.3.11
```

## Add Node Agent in Jenkins
When add node, launch agent via SSH:
- Create credential by `SSH Username with private key`:
  - username: `root`
  - private key is `/root/.ssh/id_rsa` in server machine

- Remote root directory: `/root` or other directory can be accessed.
- Host Key Verification Strategy: `Non verifying Verification Strategy`.




