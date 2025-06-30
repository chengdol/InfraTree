#!/bin/bash
# This is the provisioning script to update Mysql root@localhost password to a
# simple one.

INIT_PW=$(sudo grep 'temporary password' /var/log/mysqld.log | awk {'print $NF'})
COM_PW='o9T-2312daxd4puJ'
FINAL_PW='easyone'

echo 'Temporary password is:' ${INIT_PW}

echo 'Create a complicated transition password...'
mysql -uroot --connect-expired-password -p${INIT_PW} \
  -e "ALTER USER root@localhost IDENTIFIED BY '${COM_PW}';"

echo 'Lower the password policy constraints...' 
mysql -uroot -p${COM_PW} \
  -e 'SET GLOBAL validate_password.policy = LOW;' \
  -e 'SET GLOBAL validate_password.length = 6;'

echo 'Create an easy password...'
mysql -uroot -p${COM_PW} \
  -e "ALTER USER root@localhost IDENTIFIED BY '${FINAL_PW}';"

echo "The password setup is done: ${FINAL_PW}"