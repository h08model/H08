#!/bin/sh

ZY=$1
ZM=$2
LV=$3
#ZD=$1
ZD=1
ZDEND=`htcal $ZY $ZM`
while [ $ZD -le $ZDEND ]; do
ZD=`printf %02d $ZD`
#for ZD in 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31
#do
#################
#tair
#################
if [ $LV -eq 1 ]; then
mv data_AMeDAS/AMeDAS2A06_${ZY}_${ZM}_${ZD}.txt data_AMeDAS/AMeDAS2C06_${ZY}_${ZM}_${ZD}.txt

#rm -f AMeDAS2B02_${ZY}_${ZM}_${ZD}.txt 
#rm -f AMeDAS2A06_${ZY}_${ZM}_${ZD}.txt
#################
#wind
#################
mv data_AMeDAS/AMeDAS2A11_${ZY}_${ZM}_${ZD}.txt  data_AMeDAS/AMeDAS2C11_${ZY}_${ZM}_${ZD}.txt
#rm -f AMeDAS2B03_${ZY}_${ZM}_${ZD}.txt
#rm -f AMeDAS2A11_${ZY}_${ZM}_${ZD}.txt
#################
#daylight_hours 
#################
mv data_AMeDAS/AMeDAS2A14_${ZY}_${ZM}_${ZD}.txt  data_AMeDAS/AMeDAS2C14_${ZY}_${ZM}_${ZD}.txt
#rm -f AMeDAS2B04_${ZY}_${ZM}_${ZD}.txt
#rm -f AMeDAS2A14_${ZY}_${ZM}_${ZD}.txt
################
#rain
################
mv data_AMeDAS/AMeDAS2A03_${ZY}_${ZM}_${ZD}.txt  data_AMeDAS/AMeDAS2C03_${ZY}_${ZM}_${ZD}.txt
#rm -f AMeDAS2B01_${ZY}_${ZM}_${ZD}.txt
#rm -f AMeDAS2A03_${ZY}_${ZM}_${ZD}.txt
#awk '{print $1,$2,$3,$4}' AMeDAS2B02_${ZY}_${ZM}_${ZD}.txt >> AMeDAS2A06_${ZY}_${ZM}_${ZD}.txt   
#awk '{print $1,$2,$3,$4}' AMeDAS2B03_${ZY}_${ZM}_${ZD}.txt >> AMeDAS2A11_${ZY}_${ZM}_${ZD}.txt
#awk '{print $1,$2,$3,$4}' AMeDAS2B04_${ZY}_${ZM}_${ZD}.txt >> AMeDAS2A14_${ZY}_${ZM}_${ZD}.txt
#sort AMeDAS2A14_${ZY}_${ZM}_${ZD}.txt | uniq  > AMeDAS2C14_${ZY}_${ZM}_${ZD}.txt 
#sort AMeDAS2A06_${ZY}_${ZM}_${ZD}.txt | uniq  > AMeDAS2C06_${ZY}_${ZM}_${ZD}.txt
#sort AMeDAS2A11_${ZY}_${ZM}_${ZD}.txt | uniq  > AMeDAS2C11_${ZY}_${ZM}_${ZD}.txt
else
cat data_AMeDAS/AMeDAS2B02_${ZY}_${ZM}_${ZD}.txt data_AMeDAS/AMeDAS2A06_${ZY}_${ZM}_${ZD}.txt > data_AMeDAS/AMeDAS2C06_${ZY}_${ZM}_${ZD}.txt
cat data_AMeDAS/AMeDAS2B03_${ZY}_${ZM}_${ZD}.txt data_AMeDAS/AMeDAS2A11_${ZY}_${ZM}_${ZD}.txt > data_AMeDAS/AMeDAS2C11_${ZY}_${ZM}_${ZD}.txt
cat data_AMeDAS/AMeDAS2B04_${ZY}_${ZM}_${ZD}.txt data_AMeDAS/AMeDAS2A14_${ZY}_${ZM}_${ZD}.txt > data_AMeDAS/AMeDAS2C14_${ZY}_${ZM}_${ZD}.txt
cat data_AMeDAS/AMeDAS2B01_${ZY}_${ZM}_${ZD}.txt data_AMeDAS/AMeDAS2A03_${ZY}_${ZM}_${ZD}.txt > data_AMeDAS/AMeDAS2C03_${ZY}_${ZM}_${ZD}.txt
fi
ZD=`expr $ZD + 1`
done

