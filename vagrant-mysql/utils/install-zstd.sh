#!/bin/bash
# This script is used to install zstd for mysqlsh dump zstd files decode:
# https://github.com/facebook/zstd

echo 'Install zstd...'
sudo dnf install -q -y zstd

echo "zstd is installed..."
zstd -V