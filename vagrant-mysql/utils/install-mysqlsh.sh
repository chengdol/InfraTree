#!/bin/bash
# This script is used to install mysql shell

# download site: https://dev.mysql.com/downloads/shell/
MYSQLSH_VERSION='8.0.42'
DOWNLOAD_PATH="https://dev.mysql.com/get/Downloads/MySQL-Shell/mysql-shell-${MYSQLSH_VERSION}-1.el9.aarch64.rpm"

echo "Download Mysql shell version ${MYSQLSH_VERSION}..."
wget -q ${DOWNLOAD_PATH}

echo 'Install Mysql shell rpm...'
sudo dnf install -q -y \
  mysql-shell-${MYSQLSH_VERSION}-1.el9.aarch64.rpm

echo "Mysql shell is installed..."
mysqlsh -V