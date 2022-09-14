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




while true ; do
    case "$1" in
        '--path')
            DIR_PATH="$2"
            vm_stat
            case "$3" in
                '--archive')
                    zip_vm_stat
                    break
                    ;;
            esac;;
        *)
            usage
            exit 0
            ;;
    esac
done



