#!/bin/sh
######################################################
#to   prepare mean 
#by   2012/06/05, hanasaki
######################################################
# Geography (Edit here)
######################################################
L=259200
SUF=.hlf

# settinf for Korean peninsula (.ko5)
#L=11088
#SUF=.ko5

# setting for Kyusyu (.ks1)
#L=32400
#SUF=.ks1

######################################################
# Settings (Edit here)
######################################################
PRJ=wfde
RUN=____
IDXORG=DY
YEARMIN=1979; YEARMAX=1979; YEAROUT=0000

# regional setting (.ks1)
#PRJ=AMeD
#RUN=AS1_
#IDXORG=DY
#YEARMIN=2014; YEARMAX=2014; YEAROUT=0000

######################################################
# Macro (Do not edit below unless you are an expert)
######################################################
DIR=../../met/dat
SUBDIRS="Tair____ Qair____ PSurf___ Wind____ SWdown__ LWdown__ Rainf___ Snowf___"

# regional setting (.ks1)
#DIR=../../met/dat
#SUBDIRS="Tair____ Qair____ PSurf___ Wind____ SWdown__ LWdown__ Rainf___ Snowf___ Prcp____"

######################################################
# Job
######################################################
for SUBDIR in $SUBDIRS; do
  IN=${DIR}/${SUBDIR}/${PRJ}${RUN}${SUF}
  httime $L ${IN}${IDXORG} $YEARMIN $YEARMAX ${IN}MO
  htmean $L ${IN}MO        $YEARMIN $YEARMAX $YEAROUT
  htmean $L ${IN}YR        $YEARMIN $YEARMAX $YEAROUT
done


