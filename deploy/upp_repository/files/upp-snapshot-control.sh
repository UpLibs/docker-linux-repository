#!/bin/bash

DATE=$(date +%Y%m%d%H%M)
URL_MIRROR=${URL_MIRROR:-http://br.mirror.archlinuxarm.org/armv7h/}
S3_BUCKET=${S3_BUCKET}
REPOSITORY_DIR="/var/cache/repository"
S3_DIR="$REPOSITORY_DIR/s3"
SYSTEM_DIR="$S3_DIR/system"
BOOT_DIR="$S3_DIR/boot"
UDOO_DIR="$BOOT_DIR/udoo"
PACKAGES_DIR="$S3_DIR/packages"

source $REPOSITORY_DIR/env.txt

cd $REPOSITORY_DIR/
mkdir -p $S3_DIR/
cd $S3_DIR/

## DOWNLOAD ARCH
mkdir -p $SYSTEM_DIR/
wget http://archlinuxarm.org/os/ArchLinuxARM-armv7-latest.tar.gz -O $SYSTEM_DIR/ArchLinuxARM-armv7-"$DATE".tar.gz > /dev/null 2>&1

## DOWNLOAD UBOOT UDOO
mkdir -p $UDOO_DIR/{dual,quad}
wget http://archlinuxarm.org/os/imx6/boot/udoo/u-boot-dual.imx -O $BOOT_DIR/dual/u-boot-dual-"$DATE".imx > /dev/null 2>&1
wget http://archlinuxarm.org/os/imx6/boot/udoo/u-boot-quad.imx -O $BOOT_DIR/quad/u-boot-quad-"$DATE".imx > /dev/null 2>&1

## DOWNLOAD PACKAGES
mkdir -p $PACKAGES_DIR/
mkdir -p $PACKAGES_DIR/{snapshots,downloaded,not_downloaded}

cd $PACKAGES_DIR/
wget -nH -N -r --no-parent $URL_MIRROR > snapshot_"$DATE".txt 2>&1

## FILTER
cat snapshot_"$DATE".txt | grep saved | awk '{print $6}' > ./downloaded/downloaded_packages_"$DATE".txt 
cat snapshot_"$DATE".txt | grep 'not retrieving.' | awk '{print $8}' > ./not_downloaded/aint_downloaded_packages_"$DATE".txt 


## ORGANIZING
rm snapshot_"$DATE".txt
cat ./downloaded/downloaded_packages_"$DATE".txt ./not_downloaded/aint_downloaded_packages_"$DATE".txt | sort > ./snapshots/snapshot_"$DATE".txt

## SYNC
cd $REPOSITORY_DIR/ 
/sbin/aws s3 sync $S3_DIR/ s3://$S3_BUCKET --acl public-read
