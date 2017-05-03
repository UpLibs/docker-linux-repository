#!/bin/bash
DATE=$(date +%Y%m%d%H%M)

cd $REPOSITORY_DIR/
mkdir -p $S3_DIR/

## DOWNLOAD ARCH
cd $S3_DIR/

mkdir -p $SYSTEM_DIR/
mkdir -p $SYSTEM_DIR/armv7h

## armv7
wget http://archlinuxarm.org/os/ArchLinuxARM-armv7-latest.tar.gz -O $SYSTEM_DIR/armv7h/ArchLinuxARM-armv7-"$DATE".tar.gz > /dev/null 2>&1

## rpi-2
mkdir -p $SYSTEM_DIR/armv7h/rpi-2
wget http://archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz -O $SYSTEM_DIR/armv7h/rpi-2/ArchLinuxARM-armv7-rpi-2-"$DATE".tar.gz > /dev/null 2>&1

## VERIFY ARCH FROM S3
ARCHARMV7=$(aws s3 ls s3://$S3_BUCKET/system/armv7h/ --human-readable | awk 'END{print $5}')
if [ -n "$ARCHARMV7" ]
then
	upp_download $ARCHARMV7 $SYSTEM_DIR/armv7h $S3_BUCKET system/armv7h
	upp_compareMD5 $ARCHARMV7 $SYSTEM_DIR/armv7h ArchLinuxARM-armv7-"$DATE".tar.gz
fi

ARCHRPI2=$(aws s3 ls s3://$S3_BUCKET/system/armv7h/rpi-2/ --human-readable | awk 'END{print $5}')
if [ -n "$ARCHRPI2" ]
then
	upp_download $ARCHRPI2 $SYSTEM_DIR/armv7h/rpi-2 $S3_BUCKET system/armv7h/rpi-2
	upp_compareMD5 $ARCHRPI2 $SYSTEM_DIR/armv7h/rpi-2 ArchLinuxARM-armv7-rpi-2-"$DATE".tar.gz
fi