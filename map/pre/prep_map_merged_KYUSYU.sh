#!/bin/sh
############################################################
#to   prepare global canal data by Kitamura et al. (2014)
#by   2016/01/31, hanasaki
############################################################
#settings
############################################################
L=32400
XY="180 180"
L2X=../../map/dat/l2x_l2y_/l2x.ks1.txt
L2Y=../../map/dat/l2x_l2y_/l2y.ks1.txt
LONLAT="129 132 31 34"
ARG="$L $XY $L2X $L2Y $LONLAT"
MAP=.kyusyu
SUF=.ks1
CANSUF=.binks1      # suffix for canal (.bin+SUF)
#
MAX=5
OPT=conditionally
############################################################
# in
############################################################
 BININ=../org/KYUSYU/in__3___00000000${SUF}   # prep_explicit.sh
BINOUT=../org/KYUSYU/out_3___00000000${SUF}   # prep_explicit.sh
#
DIRCANORG=../../map/out/can_org_   # origin of canal water
DIRCANDES=../../map/out/can_des_   # destination of canal water
LCANIMPORG=$DIRCANORG/canorg.l.${OPT}.${MAX}${MAP}${SUF}
LCANIMPDES=$DIRCANDES/candes.l.${OPT}.${MAX}${MAP}${CANSUF}
#
RIVSEQ=../../map/out/riv_seq_/rivseq${MAP}${SUF}
############################################################
# out 
############################################################
 ASCIN=../org/KYUSYU/in__3___00000000.txt      # not used
ASCOUT=../org/KYUSYU/out_3___00000000.txt      # not used
#
LCANEXPORG=$DIRCANORG/canorg.l.explicit${MAP}${SUF} # not used
LCANEXPDES=$DIRCANDES/candes.l.explicit${MAP}${CANSUF}   # not used
LCANMRGORG=$DIRCANORG/canorg.l.merged.${MAX}${MAP}${SUF}
LCANMRGDES=$DIRCANDES/candes.l.merged.${MAX}${MAP}${CANSUF}
#
LOG=temp.log
############################################################
# job (print out non-zero points)
############################################################
#htmask   $ARGHLF $BININ  $BININ  ne 0 $BININ  all > $ASCIN
#htmask   $ARGHLF $BINOUT $BINOUT ne 0 $BINOUT all > $ASCOUT
htmask   $ARG $BININ  $BININ  ne 0 $BININ  long > $ASCIN
htmask   $ARG $BINOUT $BINOUT ne 0 $BINOUT long > $ASCOUT
############################################################
# convert
############################################################
if [ !  -d $DIRCANORG ]; then  mkdir -p $DIRCANORG; fi
if [ !  -d $DIRCANDES ]; then  mkdir -p $DIRCANDES; fi
#
echo start
prog_map_K14 $BININ $BINOUT $LCANIMPORG $LCANIMPDES $RIVSEQ                                 $LCANEXPORG    $LCANEXPDES $LCANMRGORG $LCANMRGDES > $LOG
echo Log: $LOG
