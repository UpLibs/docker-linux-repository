upp_download()
{
	
	[ ! -d download ] && mkdir download

	aws s3api get-object --bucket upp-linux-repository.uppoints.com --key "$4"/"$1" "$1"

	wget "$3" -O download/"$2" > /dev/null 2>&1

	# md5sum "$1" > download/"$5"-md5

	# cd download
	
	# sed -i s/"$1"/"$2"/g "$5"-md5

	# STATUS=$(md5sum -c "$5"-md5 | awk '{print $2}')

	# cd ..

	# # if [ "$STATUS" == "OK" ]
	# if [ "$STATUS" == "SUCESSO" ]
	# then
	# 	echo "$2" "É IGUAL A" "$1"
	# 	# exit 0
	# fi

	# # if [ "$STATUS" != "OK" ]
	# if [ "$STATUS" != "SUCESSO" ]
	# then
	# 	echo "$2" "É DIFERENTE DE" "$1"
	# 	# exit 0
	# fi
}

export -f upp_download

upp_compareMD5() 
{
	md5sum "$1" > download/"$5"-md5

	cd download

	sed -i s/"$1"/"$2"/g "$3"-md5

	STATUS=$(md5sum -c "$3"-md5 | awk '{print $2}')

	cd ..

	# if [ "$STATUS" == "OK" ]
	if [ "$STATUS" == "SUCESSO" ]
	then
		echo "$2" "É IGUAL A" "$1"
		# exit 0
	fi

	# if [ "$STATUS" != "OK" ]
	if [ "$STATUS" != "SUCESSO" ]
	then
		echo "$2" "É DIFERENTE DE" "$1"
		# exit 0
	fi

}

export -f upp_compareMD5