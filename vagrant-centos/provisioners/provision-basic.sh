#!/bin/bash
set -eux

## stop firewalld
sudo systemctl stop firewalld
sudo systemctl disable firewalld
