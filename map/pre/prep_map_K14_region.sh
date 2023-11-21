#!/bin/sh
############################################################
#to   prepare global canal data by Kitamura et al. (2014)
#by   2016/01/31, hanasaki
#
#
#
#
############################################################
#settings
############################################################
L=11088
XY="84 132"
L2X=../../map/dat/l2x_l2y_/l2x.ko5.txt
L2Y=../../map/dat/l2x_l2y_/l2y.ko5.txt
LONLAT="124 131 33 44"
ARG="$L $XY $L2X $L2Y $LONLAT"
MAP=.SNU
SUF=.ko5
MAX=1
OPT=within
############################################################
# in
############################################################
 ORGIN=../../map/org/K14/in__3___20000000.hlf.txt
ORGOUT=../../map/org/K14/out_3___20000000.hlf.txt
#
RIVSEQ=../../map/out/riv_seq_/rivseq${MAP}${SUF}
############################################################
# out 
############################################################
 BININ=../../map/org/K14/in__3___20000000.hlf
 BININ2=../../map/org/K14/in__3___20000000${SUF}
BINOUT=../../map/org/K14/out_3___20000000.hlf
BINOUT2=../../map/org/K14/out_3___20000000${SUF}
 ASCIN=../../map/org/K14/in__3___20000000.txt
ASCOUT=../../map/org/K14/out_3___20000000.txt
#
DIRCANORG=../../map/out/can_org_   # origin of canal water
DIRCANDES=../../map/out/can_des_   # destination of canal water
#LCANEXPORG=$DIRCANORG/canorg.l.canal.K14.hlf
LCANEXPORG=$DIRCANORG/canorg.l.canal.K14${SUF}
LCANEXPDES=$DIRCANDES/candes.l.canal.K14.bin
#LCANIMPORG=$DIRCANORG/canorg.l.${OPT}.${MAX}${MAP}.hlf
LCANIMPORG=$DIRCANORG/canorg.l.${OPT}.${MAX}${MAP}${SUF}
LCANIMPDES=$DIRCANDES/candes.l.${OPT}.${MAX}${MAP}.bin
#LCANMRGORG=$DIRCANORG/canorg.l.merged.${MAX}${MAP}.hlf
LCANMRGORG=$DIRCANORG/canorg.l.merged.${MAX}${MAP}${SUF}
LCANMRGDES=$DIRCANDES/candes.l.merged.${MAX}${MAP}.bin
#
LOG=temp.log
############################################################
# job
############################################################
htformat $ARGHLF asciiu binary $ORGIN  $BININ
htformat $ARGHLF asciiu binary $ORGOUT $BINOUT
htlinear $ARGHLF $ARG $BININ $BININ2
htlinear $ARGHLF $ARG $BINOUT $BINOUT2
############################################################
# job (fix problem: remove 33 of in 37.75,-121.75 and 30 of in -121.25,37.25)
############################################################
#htedit $ARGHLF lonlat $BININ 1.0E20 -121.75 37.75 >  $LOG
#htedit $ARGHLF lonlat $BININ 1.0E20 -121.25 37.25 >> $LOG
htedit $ARG lonlat $BININ2 1.0E20 -121.75 37.75 >  $LOG
htedit $ARG lonlat $BININ2 1.0E20 -121.25 37.25 >> $LOG
############################################################
# job (print out non-zero points)
############################################################
#htmask   $ARGHLF $BININ  $BININ  ne 0 $BININ  all > $ASCIN
#htmask   $ARGHLF $BINOUT $BINOUT ne 0 $BINOUT all > $ASCOUT
htmask   $ARG $BININ2  $BININ2  ne 0 $BININ2  all > $ASCIN
htmask   $ARG $BINOUT2 $BINOUT2 ne 0 $BINOUT2 all > $ASCOUT
############################################################
# convert
############################################################
if [ !  -d $DIRCANORG ]; then  mkdir -p $DIRCANORG; fi
if [ !  -d $DIRCANDES ]; then  mkdir -p $DIRCANDES; fi
#

prog_map_K14 $BININ2 $BINOUT2 $LCANIMPORG $LCANIMPDES $RIVSEQ                                $LCANEXPORG    $LCANEXPDES $LCANMRGORG $LCANMRGDES >> $LOG
echo Log: $LOG