#!/bin/sh
ZY=$1
ZM=$2
ZD=1

ZDEND=`htcal $ZY $ZM`
while [ $ZD -le $ZDEND ]; do
  ZD=`printf %02d $ZD`
mv data_AMeDAS/AMeDAS2C11* .
  wind_point2grid $ZY $ZM $ZD > KSwind_${ZY}_${ZM}_${ZD}.dat

  makebin_wind_daily $ZY $ZM $ZD

# KSwind_grid.gmt $ZY $ZM $ZD > tmp.ps

#convert -trim tmp.ps ../../maji/wget/Wind____/png/KSwind_${ZY}${ZM}${ZD}.png

  mv -f KSwind_${ZY}_${ZM}_${ZD}.dat ../org/AMeDAS
  mv -f AMeDAS2C11_${ZY}_${ZM}_${ZD}.txt data_AMeDAS/

  ZD=`expr $ZD + 1`
done