#!/bin/bash
###########################################################
#to   restore original filenames from temporal filenames
#by   2024/12/10, kajiyama, modified by hanasaki
###########################################################
#  Setting (Edit here)
###########################################################
converted_extension="=sy5"
original_extension=".sy5"
###########################################################
#  Input (Edit here according to your H08 direcotory path)
###########################################################
DIRPWD=`pwd`
DIRH08="/home/hanasaki/H08/H08/"
DIRORG="/home/hanasaki/H08/H08/URB/org/fileshare20241205/sydney/"
###########################################################
#  Job (restore files)
###########################################################
cd "$DIRORG"

for file in $(find . -name "*${converted_extension}"); do
    file=$(echo "$file"     | sed "s|^.\/||")
    new_file=$(echo "$file" | sed 's/-/\//g')
    save_file=${DIRH08}${new_file}
    mv "${DIRORG}${file}" "${save_file//$converted_extension/$original_extension}"
done

cd "$DIRPWD"
