#!/bin/sh
ZY=$1
ZM=$2
ZD=1

ZDEND=`htcal $ZY $ZM`
while [ $ZD -le $ZDEND ]; do
  ZD=`printf %02d $ZD`
mv data_AMeDAS/AMeDAS2A01* .
  psur_point2grid $ZY $ZM $ZD > KSpsur_${ZY}_${ZM}_${ZD}.dat
 
  makebin_psur_daily $ZY $ZM $ZD

# KSpsur_grid.gmt $ZY $ZM $ZD > tmp.ps

#convert -trim tmp.ps ../../maji/wget/Psurf___/png/KSpsur_${ZY}${ZM}${ZD}.png

  mv  KSpsur_${ZY}_${ZM}_${ZD}.dat ../../met/org/AMeDAS
  mv -f  AMeDAS2A01_${ZY}_${ZM}_${ZD}.txt data_AMeDAS/

  ZD=`expr $ZD + 1`
done