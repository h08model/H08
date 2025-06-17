#!/bin/sh
############################################################
#to   prepare WATCH Forcing Data
#by   2011/12/25, hanasaki
#
#     Citation:
#
#     Weedon et al. JHM (2011)
#
############################################################
# Preparation
#
# 1) See WFDEI's website and download netcdf files.
#
# 2) Make directory met/org/WFDEI and put files as follows
# 
# met/org/WFDEI/daily/Tair_daily_WFDEI_${YEAR}${MON}.nc
# met/org/WFDEI/daily/Qair_daily_WFDEI_${YEAR}${MON}.nc
# met/org/WFDEI/daily/Wind_daily_WFDEI_${YEAR}${MON}.nc
# met/org/WFDEI/daily/PSurf_daily_WFDEI_${YEAR}${MON}.nc
# met/org/WFDEI/daily/Rainf_daily_WFDEI_CRU_${YEAR}${MON}.nc
# met/org/WFDEI/daily/Snowf_daily_WFDEI_CRU_${YEAR}${MON}.nc
# met/org/WFDEI/daily/LWdown_daily_WFDEI_${YEAR}${MON}.nc
# met/org/WFDEI/daily/SWdown_daily_WFDEI_${YEAR}${MON}.nc
#
############################################################
# Settings (Change here)
############################################################
YEARMIN=1979
YEARMAX=1979
############################################################
# Macro (Do not change here unless you are an expert)
############################################################
DIRPWD=`pwd`
L=259200
MONS="01 02 03 04 05 06 07 08 09 10 11 12"
#VARS="LWdown PSurf Qair Rainf SWdown Snowf Tair Wind"
VARS="rlds ps huss prrn rsds prsn tas sfcWind"
TRESO=DY
############################################################
# Job (Convert netcdf file into binary file)
############################################################
for VAR in $VARS; do
  YEAR=$YEARMIN
  while [ $YEAR -le $YEARMAX ]; do
    for MON in $MONS; do
      if   [ $TRESO = 3H ]; then
        SECINT=10800
      elif [ $TRESO = DY ]; then
        SECINT=86400
      fi
      if   [ $VAR = "rlds" ]; then
        ADD=WFDEI
        DIROUT=../../met/dat/LWdown__
	VAR2=LWdown_
      elif [ $VAR = "ps" ]; then
        ADD=WFDEI
        DIROUT=../../met/dat/PSurf___
	VAR2=PSurf__
      elif [ $VAR = "huss" ]; then
        ADD=WFDEI
        DIROUT=../../met/dat/Qair____
	VAR2=Qair___
      elif [ $VAR = "prrn" ]; then
        ADD=WFDEI
        DIROUT=../../met/dat/Rainf___
	VAR2=Rainf__
      elif [ $VAR = "rsds" ]; then
        ADD=WFDEI
        DIROUT=../../met/dat/SWdown__
	VAR2=SWdown_
      elif [ $VAR = "prsn" ]; then
        ADD=WFDEI
        DIROUT=../../met/dat/Snowf___
	VAR2=Snowf__
      elif [ $VAR = "tas" ]; then
        ADD=WFDEI
        DIROUT=../../met/dat/Tair____
	VAR2=Tair___
      elif [ $VAR = "sfcWind" ]; then
        ADD=WFDEI
        DIROUT=../../met/dat/Wind____
	VAR2=Wind___
      fi
      if [ ! -d $DIROUT ]; then
        mkdir -p $DIROUT
      fi
      OUT=${DIROUT}/wfde____.hlf
#
      if   [ $TRESO = 3H ]; then
#  NC=../../met/org/WFDEI/3hourly/${VAR}_${ADD}_${YEAR}${MON}.nc(outdated)
   NC=../../met/org/WFDEI/3hourly/${VAR2}_${ADD}_${YEAR}${MON}.nc
      elif [ $TRESO = DY ]; then
#  NC=../../met/org/WFDEI/daily/${VAR}_daily_${ADD}_${YEAR}${MON}.nc(outdated)
   NC=../../met/org/WFDEI/daily/${VAR2}_wfde_____${YEAR}${MON}_DY.nc
      fi
      echo $NC
#
      NCHEAD=`ncdump -h $NC | wc | awk '{print $1}'`
      NCHEAD=`expr $NCHEAD + 2`
#
      ncdump -v$VAR $NC | sed '1,'${NCHEAD}'d' | sed -e '$d' | \
      sed -e 's/;//' | sed -e 's/,/ /g' | sed -e 's/_/1.0E20/g' > temp.txt
      prog_WFDEI temp.txt $YEAR $MON $SECINT ${OUT}${TRESO}
    done
    httime $L ${OUT}MO $YEAR $YEAR ${OUT}YR
    YEAR=`expr $YEAR + 1`
  done
done
