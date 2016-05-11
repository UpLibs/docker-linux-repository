#!/bin/bash

DATE=$(date +%Y%m%d%H%M)
URL_MIRROR=${URL_MIRROR}
S3_BUCKET=${S3_BUCKET}
REPOSITORY_DIR="/var/cache/repository"
S3_DIR="$REPOSITORY_DIR/s3"
SYSTEM_DIR="$S3_DIR/system"
BOOT_DIR="$S3_DIR/boot"
UDOO_DIR="$BOOT_DIR/u-boot/udoo"
PACKAGES_DIR="$S3_DIR/packages"
ARM_DIR="$PACKAGES_DIR/armv7h"

source $REPOSITORY_DIR/env.txt

upp_download()
{
	mkdir "$2"/temp
	
	aws s3api get-object --bucket "$3" --key "$4"/"$1" "$2"/temp/"$1"

}

upp_compareMD5() 
{
	md5sum "$2"/"$3" > "$2"/temp/MD5SUM

	cd "$2"/temp

	sed -i s/"$3"/temp'\/'"$1"/g MD5SUM

	STATUS=$(md5sum -c MD5SUM | awk '{print $2}')

	cd ..
	rm -r temp

	if [ "$STATUS" == "OK" ]
	then
		echo "$3" "EQUALS" "$1"
		rm "$3"
	fi

	if [ "$STATUS" != "OK" ]
	then
		echo "$3" "NOT EQUAL TO" "$1"
	fi

}

upp_verifySnapshotLogSize()
{

	LINES=$(wc -l $PACKAGES_DIR/snapshots/armv7h/snapshot_"$DATE".txt | awk '{print $1}')
	MINIMUM=200
	if [ "$LINES" -lt "$MINIMUM" ]
	then
		cd $PACKAGES_DIR
		rm ./snapshots/armv7h/snapshot_"$DATE".txt
		rm ./snapshots/armv7h/not_downloaded/aint_downloaded_packages_"$DATE".txt
		rm ./snapshots/armv7h/downloaded/downloaded_packages_"$DATE".txt
		
		cd $SYSTEM_DIR/armv7h
		rm *.tar.gz
		
		cd $SYSTEM_DIR/armv7h/rpi-2
		rm *.tar.gz

		cd $UDOO_DIR/dual/
		rm *.imx
		cd $UDOO_DIR/quad/
		rm *.imx

		exit 1
	fi
}

cd $REPOSITORY_DIR/
mkdir -p $S3_DIR/
cd $S3_DIR/

## DOWNLOAD ARCH
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


## DOWNLOAD UBOOT UDOO
mkdir -p $UDOO_DIR/{dual,quad}
wget http://archlinuxarm.org/os/imx6/boot/udoo/u-boot-dual.imx -O $UDOO_DIR/dual/u-boot-dual-"$DATE".imx > /dev/null 2>&1
wget http://archlinuxarm.org/os/imx6/boot/udoo/u-boot-quad.imx -O $UDOO_DIR/quad/u-boot-quad-"$DATE".imx > /dev/null 2>&1

## VERIFY UBOOT UDOO FROM S3
UDOODUAL=$(aws s3 ls s3://$S3_BUCKET/boot/udoo/dual/ --human-readable | awk 'END{print $5}')
if [ -n "$UDOODUAL" ]
then
	upp_download $UDOODUAL $UDOO_DIR/dual $S3_BUCKET boot/udoo/dual
	upp_compareMD5 $UDOODUAL $UDOO_DIR/dual u-boot-dual-"$DATE".imx
fi

UDOOQUAD=$(aws s3 ls s3://$S3_BUCKET/boot/udoo/quad/ --human-readable | awk 'END{print $5}')
if [ -n "$UDOOQUAD" ]
then
	upp_download $UDOOQUAD $UDOO_DIR/quad $S3_BUCKET boot/udoo/quad
	upp_compareMD5 $UDOOQUAD $UDOO_DIR/quad u-boot-quad-"$DATE".imx
fi

## DOWNLOAD PACKAGES
mkdir -p $PACKAGES_DIR/
mkdir -p $PACKAGES_DIR/snapshots
mkdir -p $PACKAGES_DIR/snapshots/armv7h
mkdir -p $PACKAGES_DIR/snapshots/armv7h/{downloaded,not_downloaded}

cd $PACKAGES_DIR/
wget -nH -N -r --no-parent $URL_MIRROR > snapshot_"$DATE".txt 2>&1

## FILTER
cat snapshot_"$DATE".txt | grep saved | awk '{print $6}' > ./snapshots/armv7h/downloaded/downloaded_packages_"$DATE".txt
cat snapshot_"$DATE".txt | grep 'not retrieving.' | awk '{print $8}' > ./snapshots/armv7h/not_downloaded/aint_downloaded_packages_"$DATE".txt
sed -i s/[\“\”\‘\’]/\'/g ./snapshots/armv7h/downloaded/downloaded_packages_"$DATE".txt
sed -i s/[\“\”\‘\’]/\'/g ./snapshots/armv7h/not_downloaded/aint_downloaded_packages_"$DATE".txt

## ORGANIZING
rm snapshot_*.txt
cat ./snapshots/armv7h/downloaded/downloaded_packages_"$DATE".txt ./snapshots/armv7h/not_downloaded/aint_downloaded_packages_"$DATE".txt | sort > ./snapshots/armv7h/snapshot_"$DATE".txt

upp_verifySnapshotLogSize

## RENAME STATIC FILES
mkdir -p $ARM_DIR
cd $ARM_DIR
for file in `find . -type d | awk -F "/" '{print $2}'`
do
find . -iname "$file.abs" -exec echo "rename -f 's/$file\.abs$/$file\.ver$DATE\.abs/' {}" \; | bash
find . -iname "$file.abs.*" -exec echo "rename -f 's/$file\.abs\./$file\.ver$DATE\.abs\./' {}" \; | bash

find . -iname "$file.db" -exec echo "rename -f 's/$file\.db$/$file\.ver$DATE\.db/' {}" \; | bash
find . -iname "$file.db.*" -exec echo "rename -f 's/$file\.db\./$file\.ver$DATE\.db\./' {}" \; | bash

find . -iname "$file.files" -exec echo "rename -f 's/$file\.files$/$file\.ver$DATE\.files/' {}" \; | bash
find . -iname "$file.files.*" -exec echo "rename -f 's/$file\.files\./$file\.ver$DATE\.files\./' {}" \; | bash

done


## SYNC
cd $REPOSITORY_DIR/
/sbin/aws s3 sync $S3_DIR/ s3://$S3_BUCKET --acl public-read

## CLEAN
cd $SYSTEM_DIR/armv7h
rm *.tar.gz

cd $SYSTEM_DIR/armv7h/rpi-2
rm *.tar.gz

cd $UDOO_DIR/dual
rm *.imx

cd $UDOO_DIR/quad
rm *.imx
