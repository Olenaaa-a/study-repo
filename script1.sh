#!/bin/bash


#Variables
DIR_PATH=$1


vm_stat () {
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
}


zip_vm_stat () {
    sudo tar cfz report.tar.gz $DIR_PATH/
}




#Commands
if [ "$DIR_PATH" = "" ];
then
    echo 'Path value is empty'
    exit 1
fi

if [ ! -d $DIR_PATH ];
then
    mkdir -p $DIR_PATH
    if [ $? -eq 0 ];
    then
        vm_stat
	while getopts "--archieve" option; do
            case $option in
                —archieve) 
    		    zip_vm_stat
                    exit;;
            esac
        done
    else
        echo FAIL
        echo "cannot create directory $DIR_PATH"
        exit 1
    fi
fi
