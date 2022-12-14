#!/bin/bash
set -x
set -e
#Variables
vm_stat () {
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
        else
            echo FAIL
            echo "cannot create directory $DIR_PATH"
            exit 1
        fi
    fi
}


zip_vm_stat () {
    sudo tar cfz report.tar.gz $DIR_PATH/
}


usage () {
    echo "Enter the right PATH.\nExample of usage: sh script1.sh --path PATH_TO_DEST_DIR --archive\n\nArguments and options:\n--path, required                 - PATH to destination directory.\n--archive, optional              - option to compese destination directory."
}


optspec=":-:"
while getopts "$optspec" optchar; do
    case "${optchar}" in
        -)
            case "${OPTARG}" in
                path)
                    DIR_PATH="${OPTIND}"
                    vm_stat
                    ;;
                archive)
                    zip_vm_stat
		    ;;
            esac
            ;;
    esac
done    
    	
while getopts "p:a" params; do
    case $params in	
        p)
            DIR_PATH=$OPTARG
            vm_stat
            ;;
        a)
            zip_vm_stat
	    ;;
        ?)
            usage
	    exit1
	    ;;
    esac
done




