#!/bin/bash
#
# Descriptor:
#	Clean up when USB device is plug out.
#
# Modify History
# --------------
# 00a 29mar17 lzw create
# 00b 29mar17 lzw Fixes BUG-001
# 01a 11may17 lzw Fixes BUG-002,003,004, add logs.

# Check if the device is mounted.
if [ -d "/media/usb/$1" ];
then
    echo $(date +%F@%T:) "umount device $1." >> /utils/logs

    # Check if device is already umount manually.
    if [ ! -z $(cat /proc/mounts | grep /media/usb/$1) ];
    then
        # kill all processes using this device
        fuser -km /media/usb/$1/*
    fi

    # umount the device
    umount /media/usb/$1/*

    # clean the mount point
    rmdir -v /media/usb/$1/* /media/usb/$1
fi
