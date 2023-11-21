#!/bin/sh
############################################################
#to   prepare temporary parameter and initial file 
#by   2010/09/30, hanasaki, NIES: H08ver1.0
############################################################
# Geographical Settings (Edit here if you change spatial domain/resolution)
############################################################
L=259200
XY="720 360"
L2X=../../map/dat/l2x_l2y_/l2x.hlf.txt
L2Y=../../map/dat/l2x_l2y_/l2y.hlf.txt
LONLAT="-180 180 -90 90"
SUF=.hlf
MAP=.WFDEI

# Regional setting (.ko5)
#L=11088
#XY="84 132"
#LONLAT="124 131 33 44"
#L2X=../../map/dat/l2x_l2y_/l2x.ko5.txt
#L2Y=../../map/dat/l2x_l2y_/l2y.ko5.txt
#SUF=.ko5
#MAP=.SNU

# Regional setting (.ks1)
#L=32400
#XY="180 180"
#LONLAT="129 132 31 34"
#L2X=../../map/dat/l2x_l2y_/l2x.ks1.txt
#L2Y=../../map/dat/l2x_l2y_/l2y.ks1.txt
#SUF=.ks1
#MAP=.kyusyu

############################################################
# Basic Settings (Edit here if you change settings)
############################################################
V_SOILMOISTINI=150.0                      # Soil moisture initial value
V_SOILTEMPINI=283.15                      # Soil temperature initial value
V_SWEINI=0.0                              # Snow water equivalent initial value
V_AVGSURFTINI=283.15                      # Avg surface temperature initial val
V_SOILDEPTH=1.00                          # Soil depth
V_FIELDCAP=0.30                           # Field capacity
V_WILT=0.15                               # Wilting point
V_CG=13000.00                             # Cg 
V_CD=0.003                                # Cd 
V_GAMMA=2.00                              # Runoff parameter gamma
V_TAU=100.00                              # Runoff parameter tau
############################################################
# Macro (Do not edit here unless you are an expert)
############################################################
JOBS="SOILMOISTINI SOILTEMPINI SWEINI AVGSURFTINI SOILDEPTH FIELDCAP WILT CG CD GAMMA TAU"
############################################################
# Input (Do not edit here unless you are an expert)
############################################################
LNDMSK=../../map/dat/lnd_msk_/lndmsk${MAP}${SUF}
############################################################
# Job
############################################################
for JOB in $JOBS; do
  if [ $JOB = SOILMOISTINI ]; then
    VAL=$V_SOILMOISTINI 
    DIR=../../lnd/ini
    FILE=${DIR}/uniform.${VAL}${SUF}
  elif [ $JOB = SOILTEMPINI ]; then
    VAL=$V_SOILTEMPINI 
    DIR=../../lnd/ini
    FILE=${DIR}/uniform.${VAL}${SUF}
  elif [ $JOB = SWEINI ]; then
    VAL=$V_SWEINI 
    DIR=../../lnd/ini
    FILE=${DIR}/uniform.${VAL}${SUF}
  elif [ $JOB = AVGSURFTINI ]; then
    VAL=$V_AVGSURFTINI 
    DIR=../../lnd/ini
    FILE=${DIR}/uniform.${VAL}${SUF}
  elif [ $JOB = SOILDEPTH ]; then
    VAL=$V_SOILDEPTH 
    DIR=../../lnd/dat
    FILE=${DIR}/uniform.${VAL}${SUF}
  elif [ $JOB = FIELDCAP ]; then
    VAL=$V_FIELDCAP 
    DIR=../../lnd/dat
    FILE=${DIR}/uniform.${VAL}${SUF}
  elif [ $JOB = WILT ]; then
    VAL=$V_WILT 
    DIR=../../lnd/dat
    FILE=${DIR}/uniform.${VAL}${SUF}
  elif [ $JOB = CG ]; then
    VAL=$V_CG 
    DIR=../../lnd/dat
    FILE=${DIR}/uniform.${VAL}${SUF}
  elif [ $JOB = CD ]; then
    VAL=$V_CD 
    DIR=../../lnd/dat
    FILE=${DIR}/uniform.${VAL}${SUF}
  elif [ $JOB = GAMMA ]; then
    VAL=$V_GAMMA 
    DIR=../../lnd/dat
    FILE=${DIR}/uniform.${VAL}${SUF}
  elif [ $JOB = TAU ]; then
    VAL=$V_TAU 
    DIR=../../lnd/dat
    FILE=${DIR}/uniform.${VAL}${SUF}
  fi
  if [ ! -d $DIR ]; then
    mkdir -p $DIR
  fi
  htcreate $L $VAL $FILE
  htmask   $L $XY $L2X $L2Y $LONLAT $FILE $LNDMSK eq 1 $FILE
done
