# !/bin/bash
#
# Modify History
# --------------
# 00a 28mar17 lzw create
# 01a 19mar18 lzw restart udev to activate the setting.

sudo cp 10-udev-copy-control.rules /etc/udev/rules.d
sudo mkdir -p /utils/
sudo cp addUSBDev.sh rmUSBDev.sh /utils/
sudo /etc/init.d/udev restart