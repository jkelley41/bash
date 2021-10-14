#!/bin/bash
#     Author:   Jake Kelley
#     Version:  1.0
cat <<EOF >> /etc/crontab
##### WEEKLY LINUX AUDIT SCRIPT TASK #####
0 0 * * sun root /root/audits/linuxAuditCall.sh
##########################################
EOF

