#  Author:	Jake Kelley
#  Version:	1.0
#
#  THIS SCRIPT IS NOT INTENDED TO SERVE AS A SIEM REPLACEMENT, AND SHOULD ONLY BE USED
#  IN SMALL ENVIRONMENTS FOR AUTOMATED AUDIT REVIEW. AUDITOR SHOULD STILL BE FULLY AWARE
#  OF SYSTEM ACTIVITIES AND CAPABLE OF PERFORMING A MANUAL AUDIT, SATISFYING ALL CHECKS.
#
#  THIS SCRIPT ALSO REQUIRES AND RELIES ON AUDITD RULES FROM DISA STIG TO BE IMPLEMENTED, 
#  AND WILL NOT PROVIDE THE PROPER RESULTS WITHOUT THEM. SEE DISA STIG RHEL AUDITING CONTROLS.
#  A COPY OF THE /etc/audit/rules.d/audit.rules IS INCLUDED IN THIS DIRECTORY FOR REFERENCE.

1. Place all three scripts in a folder "/root/audits/"
	# mkdir /root/audits
	# mv linuxAudit*.sh /root/audits/

2. Run CronSetup script to establish automated running of script every Sunday at 00:00
	# /root/audits/linuxAuditCronSetup.sh

3. Script will now place a dated output file every Sunday in /root/audits/...

4. Audit script can also be run manually by running the following command:
	# /root/audits/linuxAuditCall.sh
