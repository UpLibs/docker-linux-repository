#!/bin/bash

DATE=$(date +%Y%m%d%H%M)

## DOWNLOAD SHELLINABOX
cd $S3_DIR/
mkdir -p $SOFTWARES/
mkdir -p $BATS_DIR/


wget http://github.com/shellinabox/shellinabox.git -O $SHELLINABOX_DIR/Shellinabox-"$DATE".tar.gz > /dev/null 2>&1


## VERIFY SHELLINABOX FROM S3
BATS=$(aws s3 ls s3://$S3_BUCKET/softwares/bats/ --human-readable | awk 'END{print $5}')
if [ -n "$BATS" ]
then   
   upp_download $BATS $BATS_DIR $S3_BUCKET softwares/bats
   upp_compareMD5 $BATS $BATS_DIR Bats-"$DATE".tar.gz
fi

