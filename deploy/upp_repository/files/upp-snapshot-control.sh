#!/bin/bash

DATE=$(date +%Y%m%d%H%M)
URL_MIRROR=${URL_MIRROR:-http://br.mirror.archlinuxarm.org/armv7h/}
S3_BUCKET=${S3_BUCKET}
REPOSITORY_DIR="/var/cache/repository"
S3_DIR="$REPOSITORY_DIR/s3"
SYSTEM_DIR="$S3_DIR/system"
BOOT_DIR="$S3_DIR/boot"
PACKAGES_DIR="$S3_DIR/packages"

cd $REPOSITORY_DIR/
mkdir -p $S3_DIR/
cd $S3_DIR/

## DOWNLOAD ARCH
mkdir -p $SYSTEM_DIR/
wget http://archlinuxarm.org/os/ArchLinuxARM-armv7-latest.tar.gz -O $SYSTEM_DIR/ArchLinuxARM-armv7-"$DATE".tar.gz > /dev/null 2>&1

## DOWNLOAD UBOOT
mkdir -p $BOOT_DIR/
wget http://archlinuxarm.org/os/imx6/boot/udoo/u-boot-dual.imx -O $BOOT_DIR/u-boot-dual-"$DATE".imx > /dev/null 2>&1
wget http://archlinuxarm.org/os/imx6/boot/udoo/u-boot-quad.imx -O $BOOT_DIR/u-boot-quad-"$DATE".imx > /dev/null 2>&1

## DOWNLOAD PACKAGES
mkdir -p $PACKAGES_DIR/
cd $PACKAGES_DIR/
wget -nH -N -r --no-parent $URL_MIRROR > snapshot_"$DATE".txt 2>&1

## FILTER
#cat snapshot_"$DATE".txt | grep salvo | awk -F "\“" '{print $2}' | awk -F "\”" '{print $1}' > downloaded_packages_"$DATE".txt 
#cat snapshot_"$DATE".txt | grep ignorando.| awk -F "\“" '{print $2}' | awk -F "\”" '{print $1}' > aint_downloaded_packages_"$DATE".txt 

cat snapshot_"$DATE".txt | grep saved | awk -F "\"" '{print $2}' | awk -F "\"" '{print $1}' > downloaded_packages_"$DATE".txt 
cat snapshot_"$DATE".txt | grep 'not retrieving.' | awk -F "\"" '{print $2}' | awk -F "\"" '{print $1}' > aint_downloaded_packages_"$DATE".txt 


## ORGANIZING
rm snapshot_"$DATE".txt
cat downloaded_packages_"$DATE".txt aint_downloaded_packages_"$DATE".txt | sort > snapshot_"$DATE".txt

## SYNC
cd $REPOSITORY_DIR/ 
/sbin/aws s3 sync s3/ s3://$S3_BUCKET --acl public-read
