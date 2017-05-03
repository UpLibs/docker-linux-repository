#!/bin/bash

DATE=$(date +%Y%m%d%H%M)

source ./upp-functions.sh
upp_export_variables

echo "Starting Snapshot Control."

source $REPOSITORY_DIR/env.txt

## DOWNLOAD ARCH
./upp-arch.sh

## DOWNLOAD SHELLINABOX
./upp-shellinabox.sh

## DOWNLOAD BATS
./upp-bats.sh

## DOWNLOAD UBOOT UDOO
./upp-uboot-udoo.sh



## DOWNLOAD PACKAGES
cd $S3_DIR/

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

cd $SHELLINABOX_DIR
rm *.tar.gz

cd $BATS_DIR
rm *.itar.gz
