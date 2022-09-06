#!/bin/bash


#Variables
DIR_PATH=$1
echo $1

#Commands
mkdir -p $DIR_PATH
uname -a | tee $DIR_PATH/info
cat /etc/lsb-release | tee -a $DIR_PATH/info
df -h | tee $DIR_PATH/disks
lsblk | tee -a $DIR_PATH/disks
cat /etc/fstab | tee -a $DIR_PATH/disks
sudo fdisk -x /dev/sda | tee -a $DIR_PATH/disks 
sudo du -ch --max-depth=1 / 2> /dev/null | tee -a $DIR_PATH/disks 
cp /proc/cpuinfo $DIR_PATH/
chmod a+w $DIR_PATH/cpuinfo
top -n 1 | head -n 5 | tee -a $DIR_PATH/cpuinfo 
sudo tar cfz report.tar.gz $DIR_PATH/
  
