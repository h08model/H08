#!/bin/sh
ZY=$1
ZM=$2
ZD=1  #$3

ZDEND=`htcal $ZY $ZM`
while [ $ZD -le $ZDEND ]; do
  ZD=`printf %02d $ZD`
mv data_AMeDAS/AMeDAS2A4L* .
  day_AMeDAS_lwdo $ZY $ZM $ZD |awk '{print $1,$2,$3,$4}' > lwdo_${ZY}_${ZM}_${ZD}.dat

  lwdo_point2grid $ZY $ZM $ZD > KSlwdo_${ZY}_${ZM}_${ZD}.dat

  makebin_lwdo_daily $ZY $ZM $ZD

# KSlwdo_grid.gmt $ZY $ZM $ZD > tmp.ps

#convert -trim tmp.ps ../../maji/wget/LWdown__/png/KSlwdo_${ZY}${ZM}${ZD}.png

  mv -f  lwdo_${ZY}_${ZM}_${ZD}.dat data_AMeDAS/
  mv -f KSlwdo_${ZY}_${ZM}_${ZD}.dat ../org/AMeDAS
  mv -f AMeDAS2A4L_${ZY}_${ZM}_${ZD}.txt data_AMeDAS/

  ZD=`expr $ZD + 1`
done