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
ARGHLF="259200 720 360 ../../map/dat/l2x_l2y_/l2x.hlf.txt ../../map/dat/l2x_l2y_/l2y.hlf.txt -180 180 -90 90"
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
  BINHLF=${DIROUT}/GMIA5___20050000.hlf
     PNG=${DIROUT}/GMIA5___20050000.png
  BINAEI=../../map/dat/aei_____/GMIA5___20050000.gl5
#
# convert
#
  sed -e '1,6d' $ASC > $TMP
  htformat $ARGGL5 asciiu binary $TMP $BINGL5
  htmath   $LGL5 mul $BINGL5 $FACTOR $BINGL5
  if [ $OPTMUL = yes ]; then
    htmath $LGL5 mul $BINGL5 $BINAEI $BINGL5
  fi
  htuscale 6 6 $XYHLF $L2XGL5 $L2YGL5 $L2XHLF $L2YHLF $BINGL5 $BINHLF sum 
#
# draw
#
  gmt makecpt -T0/3000000000/500000000 -Z > $CPT 
  htdraw $ARGHLF $BINHLF $CPT $EPS
  htconv $EPS $PNG rot
  echo $PNG
done
