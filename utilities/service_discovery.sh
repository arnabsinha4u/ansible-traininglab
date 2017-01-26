#!/bin/bash 

cnt_master=${1:-1}
cnt_slaves=${2:-1}

masters=1
slaves=1

while [ $masters -le $cnt_master ]
do
  while [ $slaves -le $cnt_slaves ]
  do
    slave_ip_address=`docker inspect --format '{{ .NetworkSettings.IPAddress }}' master-$masters-slave-$slaves`
    docker exec master-$masters /bin/sh -c "echo $slave_ip_address master-$masters-slave-$slaves >> /etc/hosts"
    slaves=`expr $slaves + 1`
  done
  slaves=1
  masters=`expr $masters + 1`
done
