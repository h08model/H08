#!/bin/sh
ZY=$1
ZM=$2
ZD=1

ZDEND=`htcal $ZY $ZM`
while [ $ZD -le $ZDEND ]; do
  ZD=`printf %02d $ZD`
mv data_AMeDAS/AMeDAS2C14* .
  day_AMeDAS_swdo $ZY $ZM $ZD | awk '{print $1,$2,$3,$4}' > swdo_${ZY}_${ZM}_${ZD}.dat

  swdo_point2grid $ZY $ZM $ZD > KSswdo_${ZY}_${ZM}_${ZD}.dat

  makebin_swdo_daily $ZY $ZM $ZD

# KSswdo_grid.gmt $ZY $ZM $ZD > tmp.ps

#convert -trim tmp.ps ../../maji/wget/SWdown__/png/KSswdo_${ZY}${ZM}${ZD}.png

  mv -f  swdo_${ZY}_${ZM}_${ZD}.dat data_AMeDAS/
  mv -f KSswdo_${ZY}_${ZM}_${ZD}.dat ../org/AMeDAS
  mv -f AMeDAS2C14_${ZY}_${ZM}_${ZD}.txt data_AMeDAS/

  ZD=`expr $ZD + 1`
done