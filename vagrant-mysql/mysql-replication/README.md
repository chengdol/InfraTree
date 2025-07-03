## Context
This is Vagrant for MySQL replication setup, it is similiar to the `mysql-standalone`
Vagrant, but the configurations are set for replication: it brings up one
primary and one replica (the replica number is configurable in Vagrantfile).

After they are up and running, you can perform replication based on official
[reference](https://dev.mysql.com/doc/refman/8.0/en/replication-configuration.html).

> Please note: The setting here is only binary log based, GTID is not enabled. 
You can customize or extend it if necessary.

## Vagrant Commands
Some basica Vagrant commands to bring up the server and SSH to it:
```bash
vagrant status

# replica index starts from "1"
vagrant up [primary/replica1]

vagrant ssh [primary/replica1]

vagrant destroy -f
```

## Login
The root@localhost password is reset as `easyone`, please use it to login mysql.