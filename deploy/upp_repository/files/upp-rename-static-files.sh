#!/bin/bash
DATE=$(date +%Y%m%d%H%M)

cd $S3_DIR/

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