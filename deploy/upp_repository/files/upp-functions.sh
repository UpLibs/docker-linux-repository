#!/bin/bash

upp_export_variables()
{
    eval $( cat ./upp-variables.sh)
}
export -f upp_export_variables

upp_download()
{
	mkdir "$2"/temp
	
	aws s3api get-object --bucket "$3" --key "$4"/"$1" "$2"/temp/"$1"

}
export -f upp_download

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
export -f upp_compareMD5

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
export -f upp_verifySnapshotLogSize

upp_sync()
{
  cd $1/
  /sbin/aws s3 sync $2/ s3://$3 --acl public-read
}
export -f upp_sync

upp_clean()
{
  cd $1
  rm $2
}
export -f upp_clean