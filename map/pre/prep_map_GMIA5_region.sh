#!/bin/sh
############################################################
#to  prepare Global Map of Irrigated Area Ver5
#by  2018/09/12, hanasaki
############################################################
# set
############################################################
JOBS="1 2 3 4"
############################################################
# macro
############################################################
TMP=temp.txt
CPT=temp.cpt
EPS=temp.eps
#
ARGGL5="9331200 4320 2160 ../../map/dat/l2x_l2y_/l2x.gl5.txt ../../map/dat/l2x_l2y_/l2y.gl5.txt -180 180 -90 90"

############################################################
# Geography (region)
############################################################
L=11088
XY="84 132"
L2X=../../map/dat/l2x_l2y_/l2x.ko5.txt
L2Y=../../map/dat/l2x_l2y_/l2y.ko5.txt
LONLAT="124 131 33 44"
ARG="$L $XY $L2X $L2Y $LONLAT"
SUF=.ko5
MAP=.SNU

# for Kyusyu 2022
#L=32400
#XY="180 180"
#L2X=../../map/dat/l2x_l2y_/l2x.ks1.txt
#L2Y=../../map/dat/l2x_l2y_/l2y.ks1.txt
#LONLAT="129 132 31 34"
#ARG="$L $XY $L2X $L2Y $LONLAT"
#SUF=.ks1
#MAP=.kyusyu

############################################################
# in/out
############################################################
for JOB in $JOBS; do
  if   [ $JOB = 1 ]; then
    ASC=../../map/org/GMIA5/gmia_v5_aei_ha.asc  # ha
    DIROUT=../../map/dat/aei_____               # m2
    FACTOR=10000.0; OPTMUL=no
    NOTE=Area_Equipped_with_Irrigation
  elif [ $JOB = 2 ]; then
    ASC=../../map/org/GMIA5/gmia_v5_aai_pct_aei.asc # percent
    DIROUT=../../map/dat/aai_____                   # m2
    FACTOR=0.01; OPTMUL=yes
    NOTE=Area_Actually_Irrigated
  elif [ $JOB = 3 ]; then
    ASC=../../map/org/GMIA5/gmia_v5_aeigw_pct_aei.asc # percent
    DIROUT=../../map/dat/aeig____                     # m2
    FACTOR=0.01; OPTMUL=yes
    NOTE=Area_Equipped_with_Irrigation
  elif [ $JOB = 4 ]; then
    ASC=../../map/org/GMIA5/gmia_v5_aeisw_pct_aei.asc # percent
    DIROUT=../../map/dat/aeis____                     # m2
    FACTOR=0.01; OPTMUL=yes
    NOTE=Area_Equipped_with_Surfacewater
  fi
#
# directory
#
  if [  ! -d $DIROUT ]; then
    mkdir -p $DIROUT
  fi
#
# out
#
  BINGL5=${DIROUT}/GMIA5___20050000.gl5
  BINREG=${DIROUT}/GMIA5___20050000${SUF}
     PNG=${DIROUT}/GMIA5___20050000.png
  BINAEI=../../map/dat/aei_____/GMIA5___20050000.gl5
#
# convert
#
echo $TMP $ASC
  sed -e '1,6d' $ASC > $TMP
echo fin
  htformat $ARGGL5 asciiu binary $TMP $BINGL5
  htmath   $LGL5 mul $BINGL5 $FACTOR $BINGL5
  if [ $OPTMUL = yes ]; then
    htmath $LGL5 mul $BINGL5 $BINAEI $BINGL5
  fi

#
# region
# 
  htlinear $ARGGL5 $ARG $BINGL5 $BINREG
#
# draw
#
  gmt makecpt -T0/3000000000/500000000 -Z > $CPT 
  htdraw $ARG $BINREG $CPT $EPS
  htconv $EPS $PNG rot
  echo $PNG
done
