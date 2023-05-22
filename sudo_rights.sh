#!/bin/bash
# Copyright (C) 2019 tribe29 GmbH - License: GNU General Public License v2
# This file is part of Checkmk (https://checkmk.com). It is subject to the terms and
# conditions defined in the file COPYING, which is part of this source code package.

# Disable unused variable error (needed to keep track of version)

SUDOERSACCESS=$(cat /etc/sudoers | grep -vE "#|root|%wheel" | grep -E "ALL=NOPASSWD: /bin/su -[[:space:]]*|ALL=NOPASSWD: /usr/bin/su -[[:space:]]*|ALL=NOPASSWD: ALL|ALL=\(ALL\) NOPASSWD: /bin/su -[[:space:]]*|ALL=\(ALL\) NOPASSWD: /usr/bin/su -[[:space:]]*|ALL=\(ALL\) NOPASSWD: ALL[[:space:]]*"|awk '{print $1}' |awk -F ':' '{printf "%s ", $1}')
COUNTSUDOERS=$(cat /etc/sudoers | grep -vE "#|root|%wheel" | grep -E "ALL=NOPASSWD: /bin/su -[[:space:]]*|ALL=NOPASSWD: /usr/bin/su -[[:space:]]*|ALL=NOPASSWD: ALL|ALL=\(ALL\) NOPASSWD: /bin/su -[[:space:]]*|ALL=\(ALL\) NOPASSWD: /usr/bin/su -[[:space:]]*|ALL=\(ALL\) NOPASSWD: ALL[[:space:]]*"|awk '{print $1}' |awk -F ':' '{print $1}'|wc -w)
SUDOERSD=$(cd /etc/sudoers.d && ls -l /etc/sudoers.d | grep -rE "ALL=\(ALL\) NOPASSWD: /bin/su -[[:space:]]*($|"root")|ALL=\(ALL\) NOPASSWD: /usr/bin/su -[[:space:]]*($|"root")|ALL=\(ALL\) NOPASSWD: ALL[[:space:]]*($|\s|"root")"|awk '{print $1}' |awk -F ':' '{printf "%s ", $1}')
COUNT=$(cd /etc/sudoers.d && ls -l /etc/sudoers.d | grep -rE "ALL=\(ALL\) NOPASSWD: /bin/su -[[:space:]]*($|"root")|ALL=\(ALL\) NOPASSWD: /usr/bin/su -[[:space:]]*($|"root")|ALL=\(ALL\) NOPASSWD: ALL[[:space:]]*($|\s|"root")"|wc -l)


#if sudoers file has more than 0 root account make a warning alert

if [ $COUNTSUDOERS -gt 0 ]
then

echo "1 \"UXOS Root Rights Check\" - Root rights are granted in Sudoers file to $COUNTSUDOERS users : $SUDOERSACCESS "

# if sudoers file has none stay in ok status

else

# if the sudoers.d directory has greater than 0 file make a warning
    if [ $COUNT -gt 0 ]
    then
        echo "1 \"UXOS Root Rights Check\" - Root rights are granted in sudoers.d directory to $COUNT users : $SUDOERSD"
# if any sudoers directory or file has less stay in OK status
        else
                echo "0 \"UXOS Root Rights Check\" - Root rights are not granted to anyone"
    fi

fi
