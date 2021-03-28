#!/bin/bash
# 
# Make Vagrantfile as well as inventory file for ansible
# Usage:
#    ./make.sh [number_of_machine]
# Parameters:
#    number_of_machine: 1 in default, less than 10
#########################################################
#set -x

base_dir=$(dirname `which $0`)
if [[ "${base_dir}" != "." ]]; then
  echo "[ERROR] please run make.sh in its directory as ./make.sh"
  exit 1
fi

number_of_machine=${1:-1}
if (( number_of_machine > 9 )); then
  echo "[ERROR] number of machine must less than 10"
  exit 1
fi

vagrant_file="Vagrantfile.sample"
ansibe_inventory_file="vagrant_ansible_inventory.ini.sample"

# make Vagrantfile
out_file=${vagrant_file%.*}
/bin/cp -f ${vagrant_file} ${out_file}
sed -i '' -e "s#{{ num_of_machine }}#${number_of_machine}#" ${out_file}

# make inventory file
out_file=${ansibe_inventory_file%.*}

# avoid the sed insert problem on MacOS
echo "[all]" > ${out_file}
for i in $(seq 1 ${number_of_machine})
do
  echo "worker${i} ansible_port=1300${i} ansible_ssh_private_key_file=$(pwd)/.vagrant/machines/worker${i}/virtualbox/private_key" >> ${out_file}
done

echo >> ${out_file}
cat ${ansibe_inventory_file} >> ${out_file}
