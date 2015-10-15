# DATE=$(date +%Y%m%d%H%M)

upp_downloadLastS3Arch()
{

	mkdir download

	# FILENAME=$(aws s3 ls s3://upp-linux-repository.uppoints.com/system/ --human-readable | awk 'END{print $5}')
	aws s3api get-object --bucket upp-linux-repository.uppoints.com --key system/"$1" "$1"

	wget http://archlinuxarm.org/os/ArchLinuxARM-armv7-latest.tar.gz -O download/"$2" > /dev/null 2>&1

	md5sum "$1" > download/MD5SUM
	
	cd download
	sed -i s/"$1"/"$2"/g MD5SUM

	STATUS=$(md5sum -c MD5SUM | awk '{print $2}')

	# if [ "$STATUS" == "OK" ]
	if [ "$STATUS" == "SUCESSO" ]
	then
		echo "ESTÁ OK!"
		exit 0
	fi

	# if [ "$STATUS" != "OK" ]
	if [ "$STATUS" != "SUCESSO" ]
	then
		echo "ERRO!"
		exit 0
	fi
}

# upp_downloadLastS3Arch()
# {
# 	mkdir download

# 	FILENAME=$(aws s3 ls s3://upp-linux-repository.uppoints.com/system/ --human-readable | awk 'END{print $5}')
# 	aws s3api get-object --bucket upp-linux-repository.uppoints.com --key system/$FILENAME $FILENAME

# 	wget http://archlinuxarm.org/os/ArchLinuxARM-armv7-latest.tar.gz -O download/ArchLinuxARM-armv7-"$DATE".tar.gz > /dev/null 2>&1

# 	md5sum $FILENAME > download/MD5SUM
	
# 	cd download
# 	sed -i s/$FILENAME/ArchLinuxARM-armv7-"$DATE".tar.gz/g MD5SUM

# 	STATUS=$(md5sum -c MD5SUM | awk '{print $2}')

# 	# if [ "$STATUS" == "OK" ]
# 	if [ "$STATUS" == "SUCESSO" ]
# 	then
# 		echo "ESTÁ OK!"
# 		exit 0
# 	fi

# 	# if [ "$STATUS" != "OK" ]
# 	if [ "$STATUS" != "SUCESSO" ]
# 	then
# 		echo "ERRO!"
# 		exit 0
# 	fi
# }

export -f upp_downloadLastS3Arch