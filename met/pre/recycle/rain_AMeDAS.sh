#!/bin/sh
ZY=$1
ZM=$2
ZD=1

ZDEND=`htcal $ZY $ZM`
while [ $ZD -le $ZDEND ]; do
  ZD=`printf %02d $ZD`
mv data_AMeDAS/AMeDAS2C03* .
  rain_point2grid $ZY $ZM $ZD > KSrain_${ZY}_${ZM}_${ZD}.dat
  makebin_rain_daily $ZY $ZM $ZD

# KSrain_grid.gmt $ZY $ZM $ZD > tmp.ps

#convert -trim tmp.ps ../../maji/wget/Rainf___/png/KSrain_${ZY}${ZM}${ZD}.png

  mv -f KSrain_${ZY}_${ZM}_${ZD}.dat ../org/AMeDAS
  mv -f AMeDAS2C03_${ZY}_${ZM}_${ZD}.txt data_AMeDAS/

  ZD=`expr $ZD + 1`
done