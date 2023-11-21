#!/bin/sh
############################################################
#to   calculate precipitation
#by   2010/01/31, hanasaki, NIES: 
############################################################
PRJ=wfde
RUN=____
YEARMIN=0000; YEARMAX=0000
#
L=259200
SUF=.hlf

##########################
# Regional setting (.ko5)
##########################
#L=11088
#SUF=.ko5

############################################################
# macro
############################################################
MONS="00 01 02 03 04 05 06 07 08 09 10 11 12"
############################################################
# job
############################################################
if [ ! -d ../../met/dat/Prcp____ ]; then
  mkdir   ../../met/dat/Prcp____
fi
YEAR=$YEARMIN
while [ $YEAR -le $YEARMAX ]; do
for MON in $MONS; do
  RAINF=../../met/dat/Rainf___/${PRJ}${RUN}${YEAR}${MON}00${SUF}
  SNOWF=../../met/dat/Snowf___/${PRJ}${RUN}${YEAR}${MON}00${SUF}
  PRCP=../../met/dat/Prcp____/${PRJ}${RUN}${YEAR}${MON}00${SUF}
  htmath $L add $RAINF $SNOWF $PRCP
done
  YEAR=`expr $YEAR + 1`
done
