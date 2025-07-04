#!/bin/bash
# This script is used to open tcp/3306 port as Rocky Linux by default firewall
# is ON.

echo "Open tcp/3306 port on firewall..."
sudo firewall-cmd --permanent --add-port=3306/tcp
sudo firewall-cmd --reload

echo "Check tcp/3306 is allowed..."
sudo firewall-cmd --list-ports

echo "Check MySQL 3306 port..."
sudo netstat -tunlp | grep 3306