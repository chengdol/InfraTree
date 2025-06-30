#!/bin/bash
# The MySQL installer or platform packaging enables the binlog by default, so
# no-ops here, if not, you need to enable it in MySQL config file.
# show variables where variable_name in ('log_bin', 'binlog_format');

OP=${1}
echo "Expected action: ${OP}"

if [ ${OP} = "ON" ]; then
  echo "Skip, as binlog is ON by default!"
else
  echo "Disable binlog ..."
  sudo sed -i 's/^#\s*\(disable_log_bin\)/\1/' /etc/my.cnf
fi

echo 'Restart mysqld...'
sudo systemctl restart mysqld

# You can check cat /etc/my.cnf and see:
# Remove the leading "# " to disable binary logging
# Binary logging captures changes between backups and is enabled by
# default. It's default setting is log_bin=binlog
# disable_log_bin
