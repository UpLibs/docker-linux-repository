#!/bin/bash
ARCHFILE=$(aws s3 ls s3://upp-linux-repository.uppoints.com/system/ --human-readable | awk 'END{print $5}')
UDOODUAL=$(aws s3 ls s3://upp-linux-repository.uppoints.com/boot/udoo/dual/ --human-readable | awk 'END{print $5}')
UDOOQUAD=$(aws s3 ls s3://upp-linux-repository.uppoints.com/boot/udoo/quad/ --human-readable | awk 'END{print $5}')
DATE=$(date +%Y%m%d%H%M)

source ./upp-snapshot-functions.sh

# upp_downloadAndCompare $ARCHFILE ArchLinuxARM-armv7-"$DATE".tar.gz http://archlinuxarm.org/os/ArchLinuxARM-armv7-latest.tar.gz system archlinux
# upp_downloadAndCompare $UDOODUAL u-boot-dual-"$DATE".imx http://archlinuxarm.org/os/imx6/boot/udoo/u-boot-dual.imx boot/udoo/dual u-boot-dual
# upp_downloadAndCompare $UDOOQUAD u-boot-quad-"$DATE".imx http://archlinuxarm.org/os/imx6/boot/udoo/u-boot-quad.imx boot/udoo/quad u-boot-quad

upp_download $ARCHFILE ArchLinuxARM-armv7-"$DATE".tar.gz http://archlinuxarm.org/os/ArchLinuxARM-armv7-latest.tar.gz system
upp_download $UDOODUAL u-boot-dual-"$DATE".imx http://archlinuxarm.org/os/imx6/boot/udoo/u-boot-dual.imx boot/udoo/dual
upp_download $UDOOQUAD u-boot-quad-"$DATE".imx http://archlinuxarm.org/os/imx6/boot/udoo/u-boot-quad.imx boot/udoo/quad

upp_compareMD5 $ARCHFILE ArchLinuxARM-armv7-"$DATE".tar.gz archlinux
upp_compareMD5 $UDOODUAL u-boot-dual-"$DATE".imx u-boot-dual
upp_compareMD5 $UDOOQUAD u-boot-quad-"$DATE".imx u-boot-quad

exit 0