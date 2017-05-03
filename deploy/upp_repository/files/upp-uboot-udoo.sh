#!/bin/bash
DATE=$(date +%Y%m%d%H%M)

## DOWNLOAD UBOOT UDOO

cd $S3_DIR/

mkdir -p $UDOO_DIR/{dual,quad}

wget http://archlinuxarm.org/os/imx6/boot/udoo/u-boot-dual.imx -O $UDOO_DIR/dual/u-boot-udoo-dual-"$DATE".imx > /dev/null 2>&1
wget http://archlinuxarm.org/os/imx6/boot/udoo/u-boot-quad.imx -O $UDOO_DIR/quad/u-boot-udoo-quad-"$DATE".imx > /dev/null 2>&1



## VERIFY UBOOT UDOO FROM S3
UDOODUAL=$(aws s3 ls s3://$S3_BUCKET/boot/u-boot/udoo/dual/ --human-readable | awk 'END{print $5}')
if [ -n "$UDOODUAL" ]
then
	upp_download $UDOODUAL $UDOO_DIR/dual $S3_BUCKET boot/u-boot/udoo/dual
	upp_compareMD5 $UDOODUAL $UDOO_DIR/dual u-boot-udoo-dual-"$DATE".imx
fi

UDOOQUAD=$(aws s3 ls s3://$S3_BUCKET/boot/u-boot/udoo/quad/ --human-readable | awk 'END{print $5}')
if [ -n "$UDOOQUAD" ]
then
	upp_download $UDOOQUAD $UDOO_DIR/quad $S3_BUCKET boot/u-boot/udoo/quad
	upp_compareMD5 $UDOOQUAD $UDOO_DIR/quad u-boot-udoo-quad-"$DATE".imx
fi