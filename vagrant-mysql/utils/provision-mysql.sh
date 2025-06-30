#!/bin/bash
# This is the provisioning script to install MySQL community service version
# 8.0.42 on rocky Linux arm64.

MYSQL_VERSION='8.0.42'
DOWNLOAD_PATH="https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-${MYSQL_VERSION}-1.el9.aarch64.rpm-bundle.tar"

echo "Download Mysql community server version ${MYSQL_VERSION}..."
wget -q ${DOWNLOAD_PATH}

echo 'uncompress download tar file...'
tar -xvf mysql-${MYSQL_VERSION}-1.el9.aarch64.rpm-bundle.tar

echo 'Install essential rpms...'
sudo dnf install -q -y \
  mysql-community-common-${MYSQL_VERSION}-1.el9.aarch64.rpm \
  mysql-community-libs-${MYSQL_VERSION}-1.el9.aarch64.rpm \
  mysql-community-client-plugins-${MYSQL_VERSION}-1.el9.aarch64.rpm \
  mysql-community-client-${MYSQL_VERSION}-1.el9.aarch64.rpm \
  mysql-community-server-${MYSQL_VERSION}-1.el9.aarch64.rpm \
  mysql-community-icu-data-files-${MYSQL_VERSION}-1.el9.aarch64.rpm

echo 'Enable mysqld...'
sudo systemctl enable mysqld
echo 'Start mysqld...'
sudo systemctl start mysqld

echo "Mysql server community version ${MYSQL_VERSION} is up and running!"
