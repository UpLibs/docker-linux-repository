#!/bin/bash
DATE=$(date +%Y%m%d%H%M)

## DOWNLOAD SHELLINABOX
cd $S3_DIR/

mkdir -p $SOFTWARES/
mkdir -p $SHELLINABOX_DIR/


wget http://github.com/shellinabox/shellinabox.git -O $SHELLINABOX_DIR/Shellinabox-"$DATE".tar.gz > /dev/null 2>&1

 
## VERIFY SHELLINABOX FROM S3
SHELLINABOX=$(aws s3 ls s3://$S3_BUCKET/softwares/shellinabox/ --human-readable | awk 'END{print $5}')

if [ -n "$SHELLINABOX" ]
then   
   upp_download $SHELLINABOX $SHELLINABOX_DIR $S3_BUCKET softwares/shellinabox
   upp_compareMD5 $SHELLINABOX $SHELLINABOX_DIR Shellinabox-"$DATE".tar.gz
fi




