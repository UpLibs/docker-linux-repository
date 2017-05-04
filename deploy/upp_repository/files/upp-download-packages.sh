#!/bin/bash
DATE=$(date +%Y%m%d%H%M)

cd $S3_DIR/

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
