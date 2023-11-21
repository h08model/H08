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
# See H08 website for the original data.
#
# 1)Make directory met/org/WFD and put files as follows
# 
# met/org/WFD/Tair_WFD_${YEAR}${MON}.nc
# met/org/WFD/Qair_WFD_${YEAR}${MON}.nc
# met/org/WFD/Wind_WFD_${YEAR}${MON}.nc
# met/org/WFD/PSurf_WFD_${YEAR}${MON}.nc
# met/org/WFD/Rainf_WFD_${YEAR}${MON}.nc
# met/org/WFD/Snowf_WFD_${YEAR}${MON}.nc
# met/org/WFD/LWdown_WFD_GPCC_${YEAR}${MON}.nc
# met/org/WFD/SWdown_WFD_GPCC_${YEAR}${MON}.nc
#
############################################################
# Settings (Change here)
############################################################
YEARMIN=1958
YEARMAX=1958
############################################################
# Macro (Do not change here unless you are an expert)
############################################################
DIRPWD=`pwd`
L=259200
MONS="01 02 03 04 05 06 07 08 09 10 11 12"
VARS="LWdown PSurf Qair Rainf SWdown Snowf Tair Wind"
############################################################
# Job (Convert netcdf file into binary file)
############################################################
for VAR in $VARS; do
  YEAR=$YEARMIN
  while [ $YEAR -le $YEARMAX ]; do
    for MON in $MONS; do
      if   [ $VAR = "LWdown" ]; then
        ADD=WFD
        DIROUT=../../met/dat/LWdown__
        SECINT=21600
      elif [ $VAR = "PSurf" ]; then
        ADD=WFD
        DIROUT=../../met/dat/PSurf___
        SECINT=21600
      elif [ $VAR = "Qair" ]; then
        ADD=WFD
        DIROUT=../../met/dat/Qair____
        SECINT=21600
      elif [ $VAR = "Rainf" ]; then
        ADD=WFD_GPCC
        DIROUT=../../met/dat/Rainf___
        SECINT=10800
      elif [ $VAR = "SWdown" ]; then
        ADD=WFD
        DIROUT=../../met/dat/SWdown__
        SECINT=10800
      elif [ $VAR = "Snowf" ]; then
        ADD=WFD_GPCC
        DIROUT=../../met/dat/Snowf___
        SECINT=10800
      elif [ $VAR = "Tair" ]; then
        ADD=WFD
        DIROUT=../../met/dat/Tair____
        SECINT=21600
      elif [ $VAR = "Wind" ]; then
        ADD=WFD
        DIROUT=../../met/dat/Wind____
        SECINT=21600
      fi
      if [ ! -d $DIROUT ]; then
        mkdir $DIROUT
      fi
      OUT=${DIROUT}/WFD_____.hlf
#
      NC=../../met/org/WFD/${VAR}_${ADD}_${YEAR}${MON}.nc
      echo $NC
#
      if [ ! -f temp.land.txt ]; then
        NC=../../met/org/WFD/SWdown_WFD_195801.nc
        NCHEAD=`ncdump -h $NC | wc | awk '{print $1}'`
        NCHEAD=`expr $NCHEAD + 1`
        ncdump -vland $NC | sed '1,'${NCHEAD}'d' | sed -e'$d' | \
        sed -e 's/;//' > temp.txt
        sed -e 's/land =//g' temp.txt > temp.land.txt
      fi
#
      NCHEAD=`ncdump -h $NC | wc | awk '{print $1}'`
      NCHEAD=`expr $NCHEAD + 2`
#
      ncdump -v$VAR $NC | sed '1,'${NCHEAD}'d' | sed -e'$d' | \
      sed -e 's/;//' > temp.txt
      prog_WFD temp.txt temp.land.txt $YEAR $MON $SECINT ${OUT}6H
    done
    httime $L ${OUT}MO $YEAR $YEAR ${OUT}YR
    YEAR=`expr $YEAR + 1`
  done
done
