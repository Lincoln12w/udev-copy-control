#!/bin/bash
#
# Descriptor:
#	Get Device Info for udev rules
#
# Modify History
# --------------
# 00a 28mar17 lzw create
# 00b 29mar17 lzw rename to addUSBDev.sh
#                   do mount options here.
# 01a 11may17 lzw Fixes BUG-003,005, add logs.

dev=$1
dev=${dev%%[0-9]*}

# Check device name, don't mount sdb when sdb1 existed.
if [ $dev = $1 ];
then
    if [ "/dev/$dev" != "$(ls /dev/$dev*)" ];
    then
        exit
    fi
fi

# Check if the device is non-removable (Disk)
removable=$(cat /sys/block/$dev/removable)

# take control is it is a removable device (USB).
if [ $removable = "1" ];
then
    # Get device LABEL by blkid
    str=$(blkid -s LABEL /dev/$1)
    str=${str%\"*}
    str=${str##*\"}

    # Add label for devices don't have a label.
    if [ -z $str ];
    then
        str="NONAME"
    fi

    echo $(date +%F@%T:) "mount device $1: $str" >> /utils/logs

    # create a mount point
    mkdir -p /media/usb/$1/$str

    # mount the usb device on /media/usb/
    mount -t auto -o dmask=022 /dev/$1 /media/usb/$1/$str
else
    echo $(date +%F@%T:) "skiped device $1, because it is a disk." >> /utils/logs
fi
