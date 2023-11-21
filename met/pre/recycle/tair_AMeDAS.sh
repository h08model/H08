#!/bin/sh
ZY=$1
ZM=$2
ZD=1

ZDEND=`htcal $ZY $ZM`
while [ $ZD -le $ZDEND ]; do
  ZD=`printf %02d $ZD`
mv data_AMeDAS/AMeDAS2C06* .
  tair_point2grid $ZY $ZM $ZD > KStair_${ZY}_${ZM}_${ZD}.dat

  makebin_tair_daily $ZY $ZM $ZD

# KStair_grid.gmt $ZY $ZM $ZD > tmp.ps

#convert -trim tmp.ps ../../maji/wget/Tair____/png/KStair_${ZY}${ZM}${ZD}.png

  mv KStair_${ZY}_${ZM}_${ZD}.dat ../org/AMeDAS
  mv -f  AMeDAS2C06_${ZY}_${ZM}_${ZD}.txt data_AMeDAS/

  ZD=`expr $ZD + 1`
done