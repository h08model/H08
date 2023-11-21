#!/bin/sh
###############################################
# map/pre/prep_GIS.sh
###############################################
# 2013/12/10
# 2015/01/29 add function(replace if lndmsk not equal 1)
###############################################
# Yusuke SAITO (NIES-RA)
# Hodaka KAMOSHIDA (NIES-RA)
###############################################
# suf & map setting
###############################################
SUF=.ko5
MAP=.GIS
###############################################
# job setting
###############################################
JOBS="lndmsk flwdir"
###############################################
# basin number setting
###############################################
NUM=1
###############################################
# geographical setting
###############################################
L=11088
XY="84 132"
L2X=../dat/l2x_l2y_/l2x${SUF}.txt
L2Y=../dat/l2x_l2y_/l2y${SUF}.txt
LONLAT="124 131 33 44"
ARG="$L $XY $L2X $L2Y $LONLAT"
###############################################
# input file
###############################################
DIRORG=../org/GIS
FLWDIRORG=${DIRORG}/map-org-flwdir${MAP}${SUF}.txt
LNDMSKORG=${DIRORG}/map-org-lndmsk${MAP}${SUF}.txt
###############################################
# output directory
###############################################
DIRLNDMSK=../dat/lnd_msk_
DIRFLWDIR=../dat/flw_dir_
###############################################
# job
###############################################
for JOB in $JOBS; do
  if [ $JOB = lndmsk ]; then
      mkdir ${DIRLNDMSK}
    OUT=${DIRLNDMSK}/lndmsk${MAP}${SUF}
    sed -e "1, 6d" $LNDMSKORG > temp.txt
    htformat $ARG asciiu binary temp.txt $OUT
    htmaskrplc $ARG $OUT $OUT ne $NUM 0 $OUT
    htmaskrplc $ARG $OUT $OUT eq $NUM 1 $OUT
  elif [ $JOB = flwdir ]; then
      mkdir ${DIRFLWDIR}
    OUT=${DIRFLWDIR}/flwdir${MAP}${SUF}
    sed -e "1, 6d" $FLWDIRORG > temp.txt
    htformat $ARG asciiu binary temp.txt $OUT
    htmaskrplc $ARG $OUT $OUT eq   1  3 $OUT
    htmaskrplc $ARG $OUT $OUT eq   4  5 $OUT
    htmaskrplc $ARG $OUT $OUT eq   8  6 $OUT
    htmaskrplc $ARG $OUT $OUT eq  16  7 $OUT
    htmaskrplc $ARG $OUT $OUT eq  32  8 $OUT
    htmaskrplc $ARG $OUT $OUT eq  64  1 $OUT
    htmaskrplc $ARG $OUT $OUT eq   2  4 $OUT
    htmaskrplc $ARG $OUT $OUT eq 128  2 $OUT
  fi
done
OUT=${DIRFLWDIR}/flwdir${MAP}${SUF}
MASK=${DIRLNDMSK}/lndmsk${MAP}${SUF}
htmaskrplc $ARG $OUT $MASK ne 1 0 $OUT