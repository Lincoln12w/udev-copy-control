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
# 01b 29mar18 lzw Explicitly get the return value for `umount` command. '$?' works wired sometimes (.iso image).

# Check if the device is mounted.
if [[ -d "/media/usb/$1" ]]; then
  echo $(date +%F@%T:) "umount device $1." >> /utils/logs

  # Check if device is already umount manually. -n means ! -z.
  if [[ -n "$(cat /proc/mounts | grep /media/usb/$1)" ]]; then
    # kill all processes using this device
    fuser -km "/media/usb/$1/"*
    if [[ "$?" -ne 0 ]]; then
      echo "Unable to kill process that use" "/media/usb/$1/"* >> /utils/logs
      exit
    fi
  fi

  # umount the device
  ret=$(umount "/media/usb/$1/"*)
  if [[ "${ret}" -ne 0 ]]; then
    echo "Unable to umount" "/media/usb/$1/"* >> /utils/logs
    exit
  fi

  # clean the mount point
  rmdir -v "/media/usb/$1/"* "/media/usb/$1"
  if [[ "$?" -ne 0 ]]; then
    echo "Unable to rmdir" "/media/usb/$1/"* >> /utils/logs
    exit
  fi
fi
