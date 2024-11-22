#!/bin/sh
############################################################
#to   prepare global canal data by Kitamura et al. (2014)
#by   2016/01/31, hanasaki
############################################################
#settings
############################################################
L=259200
XY="720 360"
L2X=${DIRH08}/map/dat/l2x_l2y_/l2x.hlf.txt
L2Y=${DIRH08}/map/dat/l2x_l2y_/l2y.hlf.txt
LONLAT="-180 180 -90 90"
SUF=.hlf
MAP=.WFDEI
ARG="$L $XY $L2X $L2Y $LONLAT"

MAX=1
OPT=within
CANSUF=.binhlf   # suffix for canal (.bin+SUF)
############################################################
# in
############################################################
 ORGIN=../../map/org/K14/in__3___20000000.hlf.txt
ORGOUT=../../map/org/K14/out_3___20000000.hlf.txt
#
RIVSEQ=../../map/out/riv_seq_/rivseq${MAP}.hlf
#
DIRCANORG=../../map/out/can_org_   # origin of canal water
DIRCANDES=../../map/out/can_des_   # destination of canal water
LCANIMPORG=$DIRCANORG/canorg.l.${OPT}.${MAX}${MAP}${SUF}
LCANIMPDES=$DIRCANDES/candes.l.${OPT}.${MAX}${MAP}${CANSUF}
############################################################
# out 
############################################################
 BININ=../../map/org/K14/in__3___20000000.hlf
BINOUT=../../map/org/K14/out_3___20000000.hlf
 ASCIN=../../map/org/K14/in__3___20000000.txt
ASCOUT=../../map/org/K14/out_3___20000000.txt
#
LCANEXPORG=$DIRCANORG/canorg.l.canal.K14${SUF}
LCANEXPDES=$DIRCANDES/candes.l.canal.K14${CANSUF}
LCANMRGORG=$DIRCANORG/canorg.l.merged.${MAX}${MAP}${SUF}
LCANMRGDES=$DIRCANDES/candes.l.merged.${MAX}${MAP}${CANSUF}
#
LOG=temp.log
############################################################
# job
############################################################
htformat $ARGHLF asciiu binary $ORGIN  $BININ
htformat $ARGHLF asciiu binary $ORGOUT $BINOUT
############################################################
# job (fix problem: remove 33 of in 37.75,-121.75 and 30 of in -121.25,37.25)
############################################################
htedit $ARGHLF lonlat $BININ 1.0E20 -121.75 37.75 >  $LOG
htedit $ARGHLF lonlat $BININ 1.0E20 -121.25 37.25 >> $LOG
############################################################
# job (print out non-zero points)
############################################################
htmask   $ARGHLF $BININ  $BININ  ne 0 $BININ  all > $ASCIN
htmask   $ARGHLF $BINOUT $BINOUT ne 0 $BINOUT all > $ASCOUT
############################################################
# convert
############################################################
if [ !  -d $DIRCANORG ]; then  mkdir -p $DIRCANORG; fi
if [ !  -d $DIRCANDES ]; then  mkdir -p $DIRCANDES; fi
#
prog_map_K14 $BININ $BINOUT $LCANIMPORG $LCANIMPDES $RIVSEQ                                $LCANEXPORG    $LCANEXPDES $LCANMRGORG $LCANMRGDES >> $LOG
echo Log: $LOG
