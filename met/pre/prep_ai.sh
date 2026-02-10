#!/bin/sh
############################################################
#to   prepare VPD and CO2
#by   2010/03/31, hanasaki, NIES: H08ver1.0
#by   2021/12/01, ai,       NIES: modified
#by   2026/02/28, tamaoki,  NIES: integrated
############################################################
# Basic settings (Edit here if you wish)
############################################################
PRJ=wfde
RUN=____
YEARMIN=1956
YEARMAX=2019
MONS="01 02 03 04 05 06 07 08 09 10 11 12"
############################################################
# Geographical setting (Edit here if you change spatial domain/resolution)
############################################################
L=259200
XY="720 360"
L2X=${DIRH08}/map/dat/l2x_l2y_/l2x.hlf.txt
L2Y=${DIRH08}/map/dat/l2x_l2y_/l2y.hlf.txt
LONLAT="-180 180 -90 90"
SUF=.hlf
############################################################
# Input directory (Do not edit here unless you are an expert)
############################################################
DIRRH=${DIRH08}/met/dat/RH______/
DIRTAIR=${DIRH08}/met/dat/Tair____/
DIRORG=${DIRH08}/map/org/Ai2023/
DIRCRP=${DIRH08}/crp/org/SWIM/
############################################################
# Input (Do not edit here unless you are an expert)
############################################################
RH=${DIRRH}${PRJMET}${RUNMET}${SUF}DY
TAIR=${DIRTAIR}${PRJ}${RUN}${SUF}DY
CO2ORG=${DIRORG}CO2/co2_historical_annual_1850_2014.txt
RAM2NAME=${DIRCRP}ram2name.txt
############################################################
# Output directory (Do not edit here unless you are an expert)
############################################################
DIRVPD=${DIRH08}/met/dat/Vpd_____/
DIRCO2=${DIRH08}/met/dat/Co2_____/
DIRFER=${DIRH08}/map/dat/fer_____/
############################################################
# Output (Do not edit here unless you are an expert)
############################################################
VPD=${DIRVPD}${PRJ}${RUN}${SUF}DY
############################################################
# Job (Prepare directory)
############################################################
if [ ! -d $DIRFER ]; then mkdir -p $DIRFER; fi
if [ ! -d $DIRVPD ]; then mkdir -p $DIRVPD; fi
if [ ! -d $DIRCO2 ]; then mkdir -p $DIRCO2; fi
############################################################
# Job (Prepare VPD, CO2, FER)
############################################################
# prepare VPD
prog_VPD $L $RH $TAIR $VPD $YEARMIN $YEARMAX

# prepare CO2
YEAR=$YEARMIN
while [ $YEAR -le $YEARMAX ]; do
    if [ $YEAR -le 2014 ]; then 
	V=`awk '{if($1=='$YEAR') printf("%.2f\n",$2)}' $CO2ORG`
    elif [ $YEAR -eq 2015 ]; then
	V="399.95"
    elif [ $YEAR -eq 2016 ]; then
	V="403.12"
    elif [ $YEAR -eq 2017 ]; then
	V="405.79"
    elif [ $YEAR -eq 2018 ]; then
	V="408.76"
    elif [ $YEAR -eq 2019 ]; then
	V="411.79" #SSP585 2015-2019   
    fi
    
    for MON in $MONS; do
	DAY=01
	DAYMAX=`htcal $YEAR $MON`
	while [ $DAY -le $DAYMAX ]; do
	    DAY=`echo $DAY | awk '{printf("%2.2d",$1)}'`
	    CO2=${DIRCO2}${PRJ}${RUN}${YEAR}${MON}${DAY}${SUF}
	    htcreate $L $V $CO2
	    #   htmaskrplc $ARGHLF $CO2 ../dat/Tair____/G5__oc__20000101.hlf eq 1.0E20 1.0E20\
		# $DIRCO2${PRJ}${RUN}${YEAR}${M}${DD}${SUF}
	    DAY=`expr $DAY + 1 | awk '{printf("%2.2d",$1)}'`
	done
    done
    YEAR=$((YEAR+1))
done

# prepare ferilizer
for CROP in 5 12 15 19; do
    CRPNAM=`awk '{print $'"$CROP"'}' $RAM2NAME`
    FERORG=${DIRORG}/FER/lai_cal7_${CRPNAM}.asc
    FERDAT=${DIRFER}/lai_cal7_${CRPNAM}${SUF}
    htformat $L $XY $L2X $L2Y $LONLAT asciiu binary $FERORG $FERDAT
done

FERORG=${DIRORG}/FER/lai_assumed.asc
FERDAT=${DIRFER}/lai_assumed${SUF}
htformat $L $XY $L2X $L2Y $LONLAT asciiu binary $FERORG $FERDAT
    
