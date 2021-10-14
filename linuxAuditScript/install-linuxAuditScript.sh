#!/bin/bash

# Created by Jake Kelley
# Installs linuxAuditScript.sh

### SCRIPT VARIABLES ###
# Bash output colors
BLUE='\033[1;94m'
YELLOW='\033[1;93m'
GREEN='\033[1;92m'
NC='\033[0m'
# Directory of this script, used to locate auditing scripts in same directory
SCRIPTDIR=`dirname $0`
# Directory of audit output location
AUDITDIR='/root/audits'



# Copy all linuxAudit scripts to $AUDITDIR
if [ -d "$AUDITDIR" ]
then
	echo -e "${BLUE}$AUDITDIR exists...${NC}"
else
	echo -e "${Yellow}Creating $AUDITDIR...${NC}"
	mkdir $AUDITDIR
fi

echo -e "${BLUE}Copying auditing scripts to $AUDITDIR...${NC}"
cp -r $SCRIPTDIR/* $AUDITDIR/

echo -e "${GREEN}Done...${NC}"



# Install cronjob
echo -e "${BLUE}Installing cronjob for automated audit reports...${NC}"

$AUDITDIR/linuxAuditCronSetup.ish

echo -e "${GREEN}Done...${NC}"



echo -e "${BLUE}Audit reports can be viewed in the $AUDITDIR directory${NC}"
echo -e "${BLUE}To run a manual audit, run the following: # $AUDITDIR/linuxAuditCall.sh${NC}"
