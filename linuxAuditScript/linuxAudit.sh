#!/bin/bash
#     Author:	Jake Kelley
#     Version:	1.0
#
# The following audit rules must be added to the top of /etc/audit/rules.d/audit.rules
#
#     -a always,exit -F arch=b64 -S mount,umount2 -F dir=/run/media -F key=media
#     -a always,exit -F arch=b64 -S mount,umount2 -F dir=/media -F key=media
#     -a always,exit -F arch=b64 -S mount,umount2 -F dir=/dev/cdrom -F key=media
#     -a always,exit -F arch=b64 -S mount,umount2 -F dir=/dev/sr0 -F key=media
#
#     -a always,exit -F arch=b32 -S execve -C uid!=euid -F euid=0 -F auid>=1000 -F auid!=-1 -F key=sudolog
#     -a always,exit -F arch=b32 -S execve -C gid!=egid -F egid=0 -F auid>=1000 -F auid!=-1 -F key=sudolog
#     -a always,exit -F arch=b64 -S execve -C uid!=euid -F euid=0 -F auid>=1000 -F auid!=-1 -F key=sudolog
#     -a always,exit -F arch=b64 -S execve -C gid!=egid -F egid=0 -F auid>=1000 -F auid!=-1 -F key=sudolog 

DATE=$(date)
echo "#############################################################"
echo "##"
echo "##      LINUX AUDIT SCRIPT"
echo "##      ------------------"
echo "##      HOSTNAME: $(hostname)"
echo "##      SCRIPT RUNTIME: $DATE" 
echo "##"
echo "#############################################################"


echo -e "\n#############################################################"
echo -e " 1. RECENT ROOT SESSIONS ///// Verify against SUDO USE LOG"
last -Fdw root
echo -e "\n#############################################################"

echo -e "\n#############################################################"
echo -e " 2. PRIVILEGE ESCALATION ///// Verify against SUDO USE LOG"
ausearch -k sudolog --input-logs -i | grep -E 'type=PROCTITLE|type=SYSCALL'
echo -e "\n#############################################################"

echo -e " 3. BAD LOGIN ATTEMPTS ///// Verify no suspicious activity"
lastb -Fdw
echo -e "\n#############################################################"

echo -e " 4. ACCOUNT LOCKOUTS /////"
awk '/:!\$/' /etc/shadow | cut -d : -f1
echo -e "\n#############################################################"

echo -e " 5. CDROM ACTIVITY ///// Verify against MEDIA LOG"
ausearch -k media -i | grep 'type=PATH'
echo -e "\n#############################################################"

#echo -e " 6. ACCOUNT MODIFICATIONS /////"
#ausearch -k account_mod -i | grep -E "type=CONFIG_CHANGE|type=PROCTITLE|type=PATH"
#echo -e "\n#############################################################"

#echo -e " 6. CONFIG FILE CHANGES /////"
#ausearch -k conf_mod -i
#echo -e "\n#############################################################"

echo -e " 6. ACCOUNT, GROUP, ROLE CHANGES ///// Verify all changes are authorized and notated"
ausearch --input-logs -m ADD_USER -m DEL_USER -m ADD_GROUP -m USER_CHAUTHTOK -m DEL_GROUP -m CHGRP_ID -m ROLE_ASSIGN -m ROLE_REMOVE -i
echo -e "\n#############################################################"

echo -e " 7. CHECK FOR NULL PASSWORDS ///// Verify no null passwords"
users="$(cut -d: -f 1 /etc/passwd)"
for x in $users
do
passwd -S $x |grep "NP"
done
echo -e "\n#############################################################"

echo -e " 8. SYSTEM REBOOTS /////"
last reboot -Fdw
echo -e "\n#############################################################"

echo -e " 9. AVAILABLE DRIVE SPACE ///// Verify no partitions are dangerously close to filling up, will lock system"
df -h
echo -e "\n#############################################################"

echo -e " 10. AVAILABLE MEMORY ///// Verify nothing is tapping system at memory capacity"
free -h
echo -e "\n#############################################################"

echo -e " 11. ACTIVE NETWORK CONNECTIONS ///// Verify no unauthorized connections or ports are open"
netstat -natp
echo -e "\n#############################################################"
	
#echo -e " 13. PRIVILEGED CONFIG CHANGES ///// Verify all changes against MAINTENANCE LOG"
#ausearch --input-logs -k special-config-changes
#echo -e "\n#############################################################"

echo -e " 12. SELINUX MODE ///// Verify SELINUX is Enforcing"
getenforce
echo -e "\n#############################################################"
