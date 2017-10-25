# !/bin/bash
#
# Modify History
# --------------
# 00a 28mar17 lzw create

sudo cp 10-udev-copy-control.rules /etc/udev/rules.d
sudo mkdir -p /utils/
sudo cp addUSBDev.sh rmUSBDev.sh /utils/
