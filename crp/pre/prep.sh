#!/bin/sh
############################################################
#to   prepare state varaiables and default parameters
#by   2010/09/30, hanasaki, NIES: H08ver1.0
############################################################
# Geographical settings (Edit here if you change spatial domain/resolution)
############################################################
L=259200
XY="720 360"
L2X=../../map/dat/l2x_l2y_/l2x.hlf.txt
L2Y=../../map/dat/l2x_l2y_/l2y.hlf.txt
LONLAT="-180 180 -90 90"
SUF=.hlf

#####################
# Regional settings 
#####################
# for .ko5 2018
#L=11088
#XY="84 132"
#L2X=../../map/dat/l2x_l2y_/l2x.ko5.txt
#L2Y=../../map/dat/l2x_l2y_/l2y.ko5.txt
#LONLAT="124 131 33 44"
#SUF=.ko5

# for .ks1 2022
#L=32400
#XY="180 180"
#L2X=../../map/dat/l2x_l2y_/l2x.ks1.txt
#L2Y=../../map/dat/l2x_l2y_/l2y.ks1.txt
#LONLAT="129 132 31 34"
#SUF=.ks1

############################################################
# Basic settings (Edit here if you wish)
############################################################
PRJSIM=WFDE             # Project name of simulation
RUNSIM=LR__             # Run     name of simulation
PRJMET=wfde             # Project name of meteorological input
RUNMET=____             # Run     name of meteorological input
#PRJSIM=AK10
#RUNSIM=LR__
#PRJMET=AMeD
#RUNMET=AS1_
#
YEARMIN=1979
YEARMAX=1979
#YEARMIN=2014
#YEARMAX=2014
YEAROUT=0000
############################################################
# Input (Do not change here basically)
############################################################
VARMETS="../../met/dat/SWdown__/${PRJMET}${RUNMET}${SUF} ../../met/dat/Tair____/${PRJMET}${RUNMET}${SUF}"
VARLNDS="../../lnd/out/PotEvap_/${PRJSIM}${RUNSIM}${SUF} ../../lnd/out/Evap____/${PRJSIM}${RUNSIM}${SUF}"
############################################################
# Job (Prepare directory)
############################################################
if [ ! -d ../../crp/ini ]; then  mkdir ../../crp/ini; fi
############################################################
# Job (Generate initial value)
############################################################
htcreate $L 0 ../../crp/ini/uniform.0.0${SUF}
############################################################
# Job (Generate temporal mean of meteorological input data)
############################################################
for VARMET in $VARMETS; do
  htmean $L ${VARMET}DY ${YEARMIN} ${YEARMAX} ${YEAROUT}
  htmean $L ${VARMET}MO ${YEARMIN} ${YEARMAX} ${YEAROUT}
done
############################################################
# Job (Generate temporal mean of land surface output data)
############################################################n
for VARLND in $VARLNDS; do
  htmean $L ${VARLND}DY ${YEARMIN} ${YEARMAX} ${YEAROUT}
  htmean $L ${VARLND}MO ${YEARMIN} ${YEARMAX} ${YEAROUT}
  httime $L ${VARLND}MO 0000 0000 ${VARLND}YR
done
