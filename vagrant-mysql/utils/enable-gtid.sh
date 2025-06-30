#!/bin/bash
# Enable GTID config.
# show variables where variable_name in ('gtid_mode','enforce_gtid_consistency');

echo 'Enable GTID...'
sudo tee -a /etc/my.cnf <<EOF

gtid_mode = ON
enforce_gtid_consistency = ON

EOF

echo 'Restart mysqld...'
sudo systemctl restart mysqld

