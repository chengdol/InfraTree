## Context
This is Vagrant for MySQL replication setup, it is similiar to the `mysql-standalone`
Vagrant, but the configuration are set for replication so here it brings up one
primary and one replica (the replica number is configurable).

After they are up, you can perform replication based on [reference](https://dev.mysql.com/doc/refman/8.0/en/replication-configuration.html).

Please note:
1. The replication here is binary log based, no GTID is enabled.

You can customize or extend it if necessary :-)

## Vagrant Commands
Some basica Vagrant commands to bring up the server and SSH to it:
```bash
vagrant status

vagrant up [primary/replica1]

vagrant ssh [primary/replica1]

vagrant destroy -f
```

## Login
The root@localhost password is reset as `easyone`, please use it to login mysql.