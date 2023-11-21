#!/bin/sh
############################################################
# 
############################################################
# Setting
############################################################
DIR=../../map/dat/Albedo__/
#DIR=../../met/dat/Albedo__/ # for H08_20130501 and earlier versions
YEARMIN=0000
YEARMAX=0000
#YEARS="1991 1992 1993 1994 1995"
#YEARS="1986 1987 1988 1989 1990" #
MONTH="01 02 03 04 05 06 07 08 09 10 11 12"
DAY=00
############################################################
# Geographical Setting (Output)
############################################################
L=11088
XY="84 132"
L2X=../../map/dat/l2x_l2y_/l2x.ko5.txt
L2Y=../../map/dat/l2x_l2y_/l2y.ko5.txt
LONMIN=124
LONMAX=131
LATMIN=33
LATMAX=44
ARG="$L $XY $L2X $L2Y $LONMIN $LONMAX $LATMIN $LATMAX"
GRD=0.08333
SUF=.ko5
MAP=.SNU
############################################################
# Input Map
############################################################
LNDMSK=../../map/dat/lnd_msk_/lndmsk${MAP}${SUF}
############################################################
# Job
############################################################
GRDHLF=`echo "scale=5; $GRD/2" | bc`
RFLAGLONMIN=`echo "scale=5; $LONMIN + $GRDHLF" | bc`
RFLAGLONMAX=`echo "scale=5; $LONMAX - $GRDHLF" | bc`
RFLAGLATMIN=`echo "scale=5; $LATMIN + $GRDHLF" | bc`
RFLAGLATMAX=`echo "scale=5; $LATMAX - $GRDHLF" | bc`
RFLAG=$RFLAGLONMIN/$RFLAGLONMAX/$RFLAGLATMIN/$RFLAGLATMAX
IFLAG=${GRD}/${GRD}

YEAR=$YEARMIN
while [ $YEAR -le $YEARMAX ]; do
  for MON in $MONTH; do
    echo $YEAR $MON $DAY
    htmaskrplc $ARGHLF ${DIR}GSW2____${YEAR}${MON}${DAY}.hlf ${DIR}GSW2____${YEAR}${MON}${DAY}.hlf eq 1.0E20 NaN ${DIR}temp.hlf
    htlinear $ARGHLF $ARG ${DIR}temp.hlf ${DIR}temp${SUF}
    htformat $ARG binary ascii3 ${DIR}temp${SUF} ${DIR}temp.xyz
    
    xyz2grd ${DIR}temp.xyz -R$RFLAG -I$IFLAG -G./grd -F
    surface ${DIR}temp.xyz -R$RFLAG -I$IFLAG -G./grd -T0 -Ll0
    grd2xyz grd > ${DIR}GSW2____${YEAR}${MON}${DAY}.xyz
    htformat $ARG ascii3 binary ${DIR}GSW2____${YEAR}${MON}${DAY}.xyz  ${DIR}GSW2____${YEAR}${MON}${DAY}${SUF}
    htmaskrplc $ARG ${DIR}GSW2____${YEAR}${MON}${DAY}${SUF} $LNDMSK eq 0 0 ${DIR}GSW2____${YEAR}${MON}${DAY}${SUF}
  done
  YEAR=`expr $YEAR + 1`
done