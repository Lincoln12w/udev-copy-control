# README

## Description

To disable the wrote access for group & other, mainly to disable *copying* files to USB devices.

Key poinys:

- Use `udev` to control the mount state of the device to control the access of device.
- Use cmd `blkid` to get device information.
- Use cmd `fuser -km` to kill all processes using the mounted device.
- Use file `/sys/block/sdx/removable` to decide if device is disk or USB.
- Use file `/proc/mounts` to decide if the device is already umount manually.

## Usage

Just run the shell `setup.sh`.

## Version

- v1.0 - 20170328:

  - First release, only test on ubuntu 14.04

- v1.1 - 20170329:

  - BUG 001 fixed: before umount device, automatically kill all processes that using this device.

- v1.2 - 20170511:

  - Add logs for debug & monitor.
  - BUG 002 fixed. Add check `if device is disk or USB`, NOT let udev take control of mounting disks!
  - BUG 003 fixed. Catch those device who doesn't have partion (`sd[b-z]`),
                   skip device `sd[b-z]` when device `sd[b-z][0-9]` existed,
                   check if the mount point exist when perform remove for device `sd[b-z]`.   
  - BUG 004 fixed. For consistency mount point `/media/usb/sd[a-z]*/LABEL`,
                   create a label "NONAME" for device which doesn't have a LABEL.   
  - BUG 005 fixed. Check if the device is manually umounted before use `fuser -km` to kill the processings.

## Known Issues

Cause `/sys/block/sdx/removable` is used to indicate the device is an USB or not, and this script will only take control the USB device, mobile HDD will not be controlled currently.