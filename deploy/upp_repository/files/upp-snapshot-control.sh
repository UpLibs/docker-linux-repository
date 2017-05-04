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
echo "Download Packages..."
./upp-download-packages.sh

upp_verifySnapshotLogSize

## RENAME STATIC FILES
echo "Renaming files..."
./upp-rename-static-files.sh


## SYNC
echo "Sync..."
upp_sync $REPOSITORY_DIR $S3_DIR $S3_BUCKET

## CLEAN
echo "Clean..."
upp_clean $SYSTEM_DIR/armv7h "*.tar.gz"
upp_clean $SYSTEM_DIR/armv7h/rpi-2 "*.tar.gz"
upp_clean $UDOO_DIR/dual "*.imx"
upp_clean $UDOO_DIR/quad "*.imx"
upp_clean $SHELLINABOX_DIR "*.tar.gz"
upp_clean $BATS_DIR "*.tar.gz"

echo "Done..."
