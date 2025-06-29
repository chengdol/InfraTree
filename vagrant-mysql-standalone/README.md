## Context
The purpose is to use Vagrant to deploy a **standalone** specified version MySQL 
community server on rocky Linux VM.

The MySQL community server GA release can be found and download from 
[here](https://dev.mysql.com/downloads/mysql/8.4.html).

Please choose the OS and version accordingly in terms of the Vagrant VM:
* **OS**: Red Hat Enterprise Linux / Oracle Linux
* **OS version**: Red Hat Enterprise Linux 9 / Oracle Linux 9 (ARM, 64-bit)

## Provision Script
The provision scripts are in `privision` folder, for example the version 8.0.42
script is named as `privision-mysql-8.0.42.sh`, then use it in the Vagrantfile.

If you want to try other MySQL community server versions, please create separate
provision script and use it in Vagrantfile.

## Vagrant Commands
Some basica Vagrant commands to bring up the server and SSH to it:
```bash
vagrant status

vagrant up

vagrant ssh

vagrant destroy -f
```

## MySQL Configuration
### Obtain initial one-time root password
```bash
sudo grep 'temporary password' /var/log/mysqld.log
# then login with this password
mysql -uroot -p
```

### Reset Password
You must stick to the password policy(we can relax it later):
```sql
ALTER USER 'root'@'localhost' IDENTIFIED BY 'Easyone123!!';
```

### Update new root password with lower password policy
```sql
-- Lower the password policy to LOW
SET GLOBAL validate_password.policy = LOW;
-- Lower the minimum length (default is 8)
SET GLOBAL validate_password.length = 6;

-- Or
-- The password policy is managed by component file://component_validate_password
SELECT * FROM mysql.component;
-- You can disable it by
UNINSTALL COMPONENT 'file://component_validate_password';

-- Set a simple password
ALTER USER 'root'@'localhost' IDENTIFIED BY 'easyone';
```

Now, the MySQL server is up and running! You can start playing with it.
