#!/bin/sh
############################################################
#to prepare meteorological data
#
############################################################
#
#
# Preparation
#
# 1) Go to https://ccca-scenario.nies.go.jp
#    and download netcdf files.
#
# 2) Make directory met/org/WFDEI/daily and put those files.
#
############################################################
# Settings
############################################################
YEARMIN=1979; YEARMAX=1979
MONS="01 02 03 04 05 06 07 08 09 10 11 12"
TRESO=DY
#
VARS="rlds ps huss prrn rsds prsn tas sfcWind"
#
L=$LHLF
XY=$XYHLF
L2X=$L2XHLF
L2Y=$L2YHLF
SUF=.hlf
#
DIRPWD=`pwd`
############################################################
#Job (convert netcdf file into binary file)
############################################################
# Download
############################################################
for VAR in $VARS; do
  YEAR=$YEARMIN
  while [ $YEAR -le $YEARMAX ]; do 
      for MON in $MONS; do
	  DIRORG=../../met/org/WFDEI/daily
	  NCORG=${DIRORG}/${VAR}_wfde_____${YEAR}01-${YEAR}12_DY.nc.tar.gz
	  tar xf $NCORG -C $DIRORG
#	  
          if   [ $TRESO = 3H ]; then
	      SECINT=10800
	  elif [ $TRESO = DY ]; then
	      SECINT=86400
	  fi
	  if   [ $VAR = "rlds" ]; then
	      ADD=WFDEI
	      VAR2=LWdown__
	  elif [ $VAR = "ps" ]; then
	      ADD=WFDEI
	      VAR2=PSurf___
	  elif [ $VAR = "huss" ]; then
	      ADD=WFDEI
	      VAR2=Qair____
	  elif [ $VAR = "prrn" ]; then
	      ADD=WFDEI
	      VAR2=Rainf___
	  elif [ $VAR = "rsds" ]; then
	      ADD=WFDEI
	      VAR2=SWdown__
	  elif [ $VAR = "prsn" ]; then
	      ADD=WFDEI
	      VAR2=Snowf___
	  elif [ $VAR = "tas" ]; then
	      ADD=WFDEI
	      VAR2=Tair____
	  elif [ $VAR = "sfcWind" ]; then
	      ADD=WFDEI
	      VAR2=Wind____
	  fi
	  DIROUT=../../met/dat/${VAR2}
	  if [ ! -d $DIROUT ]; then
	      mkdir -p $DIROUT
	  fi
	  OUT=${DIROUT}/wfde____${SUF}
#
	  if   [ $TRESO = 3H ]; then
	      NC=../../met/org/WFDEI/3hourly/${VAR}_${ADD}_${YEAR}${MON}.nc
          elif [ $TRESO = DY ]; then
	      NC=../../met/org/WFDEI/daily/${VAR}_wfde_____${YEAR}${MON}_DY.nc
	  fi
#
          NCHEAD=`ncdump -h $NC | wc | awk '{print $1}'`
          NCHEAD=`expr $NCHEAD + 2`
#
          ncdump -v$VAR $NC | sed '1, '${NCHEAD}'d' | sed -e '$d' |\
          sed -e 's/;//' | sed -e 's/,/ /g' | sed -e 's/_/1.0E20/g' > temp.txt
          prog_WFDEI temp.txt $YEAR $MON $SECINT ${OUT}${TRESO}
#
# Upsidedown
#
	  DAY=00
	  DAYMAX=`htcal $YEAR $MON`
	  while [ $DAY -le $DAYMAX ]; do
	      DAY=`echo $DAY | awk '{printf("%2.2d",$1)}'`
	      FILE=../../met/dat/${VAR2}/wfde____$YEAR$MON${DAY}${SUF}
	      echo $FILE
	      htarray $L $XY $L2X $L2Y upsidedown $FILE $FILE
	      DAY=`expr $DAY + 1 | awk '{printf("%2.2d",$1)}'`
	  done
#
    done
#
# generate annual mean data
#      
    httime $L ${OUT}MO $YEAR $YEAR ${OUT}YR
#
    YEAR=`expr $YEAR + 1`
  done
done
