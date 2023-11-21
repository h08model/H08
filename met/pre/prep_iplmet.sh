#!/bin/sh
############################################################
# 
############################################################
# Setting
############################################################
PRJ=wfde
RUN=____
DIRS="../dat/PSurf___/ ../dat/Rainf___/ ../dat/Snowf___/ ../dat/Wind____/ ../dat/LWdown__/ ../dat/Qair____/ ../dat/SWdown__/ ../dat/Tair____/"
YEARMIN=1986
YEARMAX=1986
MONTH="01 02 03 04 05 06 07 08 09 10 11 12"
############################################################
# Geographical Setting (Input)
############################################################
LIN=259200
XYIN="720 360"
L2XIN=../../map/dat/l2x_l2y_/l2x.hlf.txt
L2YIN=../../map/dat/l2x_l2y_/l2y.hlf.txt
LONLATIN="-180 180 -90 90"
ARGIN="$LIN $XYIN $L2XIN $L2YIN $LONLATIN"
SUFIN=.hlf
MAPIN=.WFDEI
############################################################
# Geographical Setting (Output)
############################################################
LOUT=36000
XYOUT="300 120"
L2XOUT=../../map/dat/l2x_l2y_/l2x.g5m.txt
L2YOUT=../../map/dat/l2x_l2y_/l2y.g5m.txt
LONMIN=73
LONMAX=98
LATMIN=22
LATMAX=32
ARGOUT="$LOUT $XYOUT $L2XOUT $L2YOUT $LONMIN $LONMAX $LATMIN $LATMAX"
GRD=0.08333
SUFOUT=.g5m
MAPOUT=.GBM
############################################################
# Input Map
############################################################
LNDMSKIN=../../map/dat/lnd_msk_/lndmsk${MAPIN}${SUFIN}
LNDMSKOUT=../../map/dat/lnd_msk_/lndmsk${MAPOUT}${SUFOUT}
############################################################
# Job
############################################################
GRDHLF=`echo "scale=5; $GRD/2" | bc`
RFLAGLONMIN=`echo "scale=5; $LONMIN + $GRDHLF" | bc`
RFLAGLONMAX=`echo "scale=5; $LONMAX - $GRDHLF" | bc`
RFLAGLATMIN=`echo "scale=5; $LATMIN + $GRDHLF" | bc`
RFLAGLATMAX=`echo "scale=5; $LATMAX - $GRDHLF" | bc`
RFLAG=$RFLAGLONMIN/$RFLAGLONMAX/$RFLAGLATMIN/$RFLAGLATMAX
#RFLAG=73.041666/97.958333/22.041664/31.958332  # GBM
#RFLAG=124.04166/130.95833/33.041664/43.958332  # KOREA
IFLAG=${GRD}/${GRD}

for DIR in $DIRS; do
  YEAR=$YEARMIN
  while [ $YEAR -le $YEARMAX ]; do
    for MON in $MONTH; do
      DAY=1
      DAYMAX=`htcal $YEAR $MON`
      while [ $DAY -le $DAYMAX ]; do
	DAY=`echo $DAY | awk '{printf("%2.2d",$1)}'`
	echo $DIR $YEAR $MON $DAY
	VARMET=${DIR}${PRJ}${RUN}${YEAR}${MON}${DAY}

	htmaskrplc $ARGIN ${VARMET}${SUFIN} $LNDMSKIN eq 0 NaN ${DIR}temp${SUFIN}
	htlinear $ARGIN $ARGOUT ${DIR}temp${SUFIN} ${DIR}temp${SUFOUT}
	htformat $ARGOUT binary ascii3 ${DIR}temp${SUFOUT} ${DIR}temp.xyz
		
	xyz2grd ${DIR}temp.xyz -R$RFLAG -I$IFLAG -G./grd -F
	surface ${DIR}temp.xyz -R$RFLAG -I$IFLAG -G./grd -T0 -Ll0

	grd2xyz grd > ${VARMET}.xyz
        SANCHK=`wc ${VARMET}.xyz | awk '{print $1}'`
        if [ $SANCHK != $LOUT ]; then
          echo setting error. array size inconsistent.
          exit
        fi

	htformat $ARGOUT ascii3 binary ${VARMET}.xyz  ${VARMET}${SUFOUT}
	htmaskrplc $ARGOUT ${VARMET}${SUFOUT} $LNDMSKOUT eq 0 0 ${VARMET}${SUFOUT}    
	DAY=`expr $DAY + 1`
      done
    done
    httime $LOUT ${DIR}${PRJ}${RUN}${SUFOUT}DY ${YEAR} ${YEAR} ${DIR}${PRJ}${RUN}${SUFOUT}MO
    httime $LOUT ${DIR}${PRJ}${RUN}${SUFOUT}DY ${YEAR} ${YEAR} ${DIR}${PRJ}${RUN}${SUFOUT}YR
    YEAR=`expr $YEAR + 1`
  done
done