#!/bin/sh
############################################################
#to   draw figures
#by   2010/03/31, hanasaki, NIES: H08ver1.0
############################################################
# Settings (Edit here if you change settings)
############################################################
PRJ=WFDE
RUN=__C_
#PRJ=AK10
#RUN=LR__
YEAR=0000
MON=00
DAY=00
############################################################
# Settings (Edit here if you change settings)
############################################################
VARS="crp_ hvs_ plt_ yld_"
CRPS="mai_ ric_ whe_"
############################################################
# Geographical settings (Edit here if you change spatial domain/resolution)
############################################################
L=259200
XY="720 360"
L2X=../../map/dat/l2x_l2y_/l2x.hlf.txt
L2Y=../../map/dat/l2x_l2y_/l2y.hlf.txt
LONLAT="-180 180 -90 90"
ARG="$L $XY $L2X $L2Y $LONLAT"
SUF=.hlf

#L=11088
#XY="84 132"
#LONLAT="124 131 33 44"
#L2X=../../map/dat/l2x_l2y_/l2x.ko5.txt
#L2Y=../../map/dat/l2x_l2y_/l2y.ko5.txt
#ARG="$L $XY $L2X $L2Y $LONLAT"
#SUF=.ko5
#MAP=.SNU

#L=32400
#XY="180 180"
#L2X=../../map/dat/l2x_l2y_/l2x.ks1.txt
#L2Y=../../map/dat/l2x_l2y_/l2y.ks1.txt
#LONLAT="129 132 31 34"
#ARG="$L $XY $L2X $L2Y $LONLAT"
#SUF=.ks1
#MAP=.kyusyu

############################################################
# Jobs
# - create directory
# - make cpt file
# - draw figures
############################################################
for VAR in $VARS; do
  for CRP in $CRPS; do
#
    DIR=../../crp/fig/$VAR$CRP
    if [ ! -d $DIR  ]; then
      mkdir -p $DIR
    fi
#
    CPT=temp.cpt
    if   [ $VAR = reg_ ]; then
    gmt makecpt -T1/5/1 > $CPT
    elif [ $VAR = yld_ ]; then
    gmt makecpt -T0/10000/2000 -Z > $CPT
    else
    gmt makecpt -T1/365/30 > $CPT
    fi
#
    BIN=../../crp/out/$VAR$CRP/$PRJ$RUN$YEAR$MON$DAY$SUF
    EPS=temp.eps
    PNG=../../crp/fig/$VAR$CRP/$PRJ$RUN$YEAR$MON$DAY.png
    htdraw $ARG   $BIN $CPT $EPS $VAR$CRP $YEAR
    htconv $EPS   $PNG rot
    echo $PNG
#
  done
done


