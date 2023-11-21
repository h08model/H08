#!/bin/sh
############################################################
#to   convert FAOSTAT CSV files into unix readable text
#by   2010/04/21, hanasaki: H08ver1.0
############################################################
#ICONV="iconv -f Unicode -t ANSI_X3.4"
ICONV="iconv -f UTF-16 -t ANSI_X3.4-1968//TRANSLIT "
SED=/sw/bin/sed
############################################################
# Argument
############################################################
if [ $# -ne 2 ]; then
  echo htcsv2txt CSV TXT
  exit
else
  IN=$1
  OUT=$2
fi
############################################################
# Temporary files
############################################################
TMP1=temp.faocsv2txt.1.txt
TMP2=temp.faocsv2txt.2.txt
TMP3=temp.faocsv2txt.3.txt
############################################################
# Convert encode
############################################################
$ICONV < $IN > $TMP1
dos2unix $TMP1 > /dev/null
############################################################
# Remove accent 
############################################################
$SED -e 's/\^o/o/g' $TMP1 | $SED -e "s/'e/e/g" > $TMP2
############################################################
# Convert <space> <comma> <apostrophe> into <underscore>
# Remove  <slash> <parentheses>
# Remove two continuous <underscores>
############################################################
$SED -e 's/ /_/g' $TMP2 | $SED -e 's/,/_/g' | $SED -e "s/'/_/g" | \
$SED -e 's-/--g'        | $SED -e "s/(//g"  | $SED -e "s/)//g"  | \
$SED -e 's/__/_/g' > $TMP3
############################################################
# Replace null with -9999
# if OPT = tab then replace <tab> into "+ +" then
# if OPT = comma then replace <comma> into "+ +" then
############################################################
$SED -e 's/_\t/\t/g' $TMP3 | \
$SED -e 's/\t/+ +/g'       | $SED -e 's/+$/++/g' | \
$SED -e 's/++/-9999/g'     | $SED -e 's/+//g' > $OUT
