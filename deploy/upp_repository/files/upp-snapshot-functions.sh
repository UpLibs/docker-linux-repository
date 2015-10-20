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

	# rm "$1"

	STATUS=$(md5sum -c MD5SUM | awk '{print $2}')

	cd ..
	rm -r temp

	# if [ "$STATUS" == "OK" ]
	if [ "$STATUS" == "SUCESSO" ]
	then
		echo "$3" "EQUALS" "$1"
		rm "$3"
	fi

	# if [ "$STATUS" != "OK" ]
	if [ "$STATUS" != "SUCESSO" ]
	then
		echo "$3" "NOT EQUAL TO" "$1"
	fi

}

export -f upp_compareMD5