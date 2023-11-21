#!/bin/sh
ZY=$1
ZM=$2
ZD=1

ZDEND=`htcal $ZY $ZM`
while [ $ZD -le $ZDEND ]; do
  ZD=`printf %02d $ZD`
mv data_AMeDAS/AMeDAS2A3Q* .
  day_AMeDAS_qair $ZY $ZM $ZD  > qair_${ZY}_${ZM}_${ZD}.dat
  
  qair_point2grid $ZY $ZM $ZD > KSqair_${ZY}_${ZM}_${ZD}.dat
  
  makebin_qair_daily $ZY $ZM $ZD

# KSqair_grid.gmt $ZY $ZM $ZD > tmp.ps

#convert -trim tmp.ps ../../maji/wget/Qair____/png/KSqair_${ZY}${ZM}${ZD}.png

  mv -f  qair_${ZY}_${ZM}_${ZD}.dat data_AMeDAS/
  mv -f  KSqair_${ZY}_${ZM}_${ZD}.dat ../org/AMeDAS
  mv -f  AMeDAS2A3Q_${ZY}_${ZM}_${ZD}.txt data_AMeDAS/

  ZD=`expr $ZD + 1`
done