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
# 01b 19mar18 lzw Fixes BUG-006.
# 01c 20mar18 lzw Mount with `iocharset=utf8` option to support Chinese.
# 01d 29mar18 lzw Explicitly get the return value for `mount` command. '$?' works wired sometimes (.iso image).

dev="$1"
dev="${dev%%[0-9]*}"

# Check device name, don't mount sdb when sdb1 existed.
if [[ "$dev" = "$1" ]]; then
  if [[ "/dev/${dev}" != "$(ls /dev/${dev}*)" ]]; then
      exit
  fi
fi

# Check if the device is non-removable (Disk)
removable="$(cat /sys/block/${dev}/removable)"

# take control is it is a removable device (USB).
if [[ "${removable}" = "1" ]]; then
  # Get device LABEL by blkid
  str="$(blkid -s LABEL /dev/$1)"
  str="${str%\"*}"
  str="${str##*\"}"
  # Replace all '\ ' with '_' in LABEL, which may cause the `mount` command failed.
  str="${str//\ /_}"


  # Add label for devices don't have a label.
  if [[ -z "${str}" ]]; then
    str="NONAME"
  fi

  echo $(date +%F@%T:) "mount device $1: ${str}" >> /utils/logs

  # create a mount point
  mkdir -p "/media/usb/$1/${str}"
  if [[ "$?" -ne 0 ]]; then
    echo "Unable to mkdir /media/usb/$1/${str}" >> /utils/logs
    exit
  fi

  # mount the usb device on /media/usb/
  ret=$(mount -t auto -o dmask=022,iocharset=utf8 "/dev/$1" "/media/usb/$1/${str}")
  if [[ "${ret}" -ne 0 ]]; then
    echo "Unable to mount /media/usb/$1/${str}: return ${ret}" >> /utils/logs
    exit
  fi
else
    echo $(date +%F@%T:) "skiped device $1, because it is a disk." >> /utils/logs
fi
