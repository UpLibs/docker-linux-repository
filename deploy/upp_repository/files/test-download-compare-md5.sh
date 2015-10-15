#!/bin/bash
FILENAME=$(aws s3 ls s3://upp-linux-repository.uppoints.com/system/ --human-readable | awk 'END{print $5}')
DATE=$(date +%Y%m%d%H%M)

source ./upp-snapshot-functions.sh
upp_downloadLastS3Arch $FILENAME ArchLinuxARM-armv7-"$DATE".tar.gz