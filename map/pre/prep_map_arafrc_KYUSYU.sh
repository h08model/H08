#!/bin/sh
############################################################
#to   prepare areal fraction for cpl/bin/main.sh
#by   hanasaki, 2021/11/29
############################################################
# Settings
############################################################
L=32400
XY="180 180"
L2X=../../map/dat/l2x_l2y_/l2x.ks1.txt
L2Y=../../map/dat/l2x_l2y_/l2y.ks1.txt
LONLAT="129 132 31 34"
ARG="$L $XY $L2X $L2Y $LONLAT"
SUF=.ks1
MAP=.kyusyu
#
LDBG=119
#
CPT=temp.cpt
EPS=temp.eps
############################################################
# in
############################################################
LNDARA=../../map/dat/lnd_ara_/lndara${MAP}${SUF}
PADARA=../../map/dat/paddy___/NIAES___19950000${SUF}
FLDARA=../../map/dat/upland__/NIAES___19950000${SUF}
BARARA=../../map/dat/barwhe__/NIAES___19950000${SUF}
IRGARA=../../map/dat/irg_ara_/S05_____20000000${SUF}
############################################################
# out
############################################################
PNG1=temp.1.png
PNG2=temp.2.png
PNG3=temp.3.png
PNG4=temp.4.png
PNG5=temp.5.png
#
DIRARAFRC=../../map/out/ara_frc_
ARAFRC1=${DIRARAFRC}/irg2frcP${SUF}
ARAFRC2=${DIRARAFRC}/irg_frcP${SUF}
ARAFRC3=${DIRARAFRC}/irg_frcF${SUF}
ARAFRC4=${DIRARAFRC}/rfd_frcF${SUF}
ARAFRC5=${DIRARAFRC}/non_frc_${SUF}
############################################################
# job
############################################################
if [ !  -d $DIRARAFRC ]; then
  mkdir -p $DIRARAFRC
fi
prog_map_arafrc_KYUSYU $LNDARA  $PADARA  $FLDARA  $BARARA  $IRGARA \
                $ARAFRC1 $ARAFRC2 $ARAFRC3 $ARAFRC4 $ARAFRC5 $L $LDBG