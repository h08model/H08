#!/bin/sh
############################################################
#to   prepare a map of implicit canal
#by   2014/05/09, hanasaki
############################################################
# settings (edit here)
#
# option "within":  origin and destination are in the same basin.
#        "nolimit": not necessarily in the same basin.
#        "conditionally": allow inter-basin water transfer if 
#                         the catchment area of destination is 
#                         smaller than the threshold.
############################################################
L=32400
XY="180 180"
L2X=../../map/dat/l2x_l2y_/l2x.ks1.txt
L2Y=../../map/dat/l2x_l2y_/l2y.ks1.txt
LONLAT="129 132 31 34"
ARG="$L $XY $L2X $L2Y $LONLAT"
SUF=.ks1
CANSUF=.binks1
MAP=.kyusyu
#
OPT=conditionally   # within or nolimit or conditionally
MAX=5               # maximum distance of implicit canal
#
BSNSIZ=../../map/out/riv_ara_/rivara${MAP}${SUF}
BSNSIZTHR=10000000  # 100 km2
############################################################
LJP1=2138400
XYJP1="1620 1320"
L2XJP1=../../map/dat/l2x_l2y_/l2x.jp1.txt
L2YJP1=../../map/dat/l2x_l2y_/l2y.jp1.txt
LONLATJP1="122 149 24 46"
ARGJP1="$LJP1 $XYJP1 $L2XJP1 $L2YJP1 $LONLATJP1"
SUFJP1=.jp1
############################################################
# in (edit here )
############################################################
ELVMINORG=../../map/org/JAPAN/ETOPO1__00000000.jp1.txt
#
RIVNUM=../../map/out/riv_num_/rivnum${MAP}${SUF}
RIVARA=../../map/out/riv_ara_/rivara${MAP}${SUF}
RIVSEQ=../../map/out/riv_seq_/rivseq${MAP}${SUF}
RIVNXL=../../map/out/riv_nxl_/rivnxl${MAP}${SUF}
############################################################
# out
############################################################
DIRELVMIN=../../map/dat/elv_min_
ELVMINJP1=${DIRELVMIN}/ETOPO1__00000000${SUFJP1}
ELVMIN=${DIRELVMIN}/ETOPO1__00000000${SUF}
# hanasaki ELVMINREG=${DIRELVMIN}/ETOPO1__00000000${SUF}
#
DIRCANORG=../../map/out/can_org_   # origin of canal water
DIRCANDES=../../map/out/can_des_   # destination of canal water
DIRCANSCO=../../map/out/can_sco_   # score
DIRCANCNT=../../map/out/can_cnt_   # counter
XCANORG=$DIRCANORG/canorg.x.${OPT}.${MAX}${MAP}${SUF}
YCANORG=$DIRCANORG/canorg.y.${OPT}.${MAX}${MAP}${SUF}
LCANORG=$DIRCANORG/canorg.l.${OPT}.${MAX}${MAP}${SUF}
LCANDES=$DIRCANDES/candes.l.${OPT}.${MAX}${MAP}${CANSUF}
CANSCO=$DIRCANSCO/cansco.${OPT}.${MAX}${MAP}${SUF}
CANCNT=$DIRCANCNT/cancnt.${OPT}.${MAX}${MAP}${SUF}
#
LOG=temp.log
############################################################
# job
############################################################
htformat $ARGJP1 ascii3 binary ${ELVMINORG} ${ELVMINJP1}
#
X_EDGE=`echo $LONLAT $LONLATJP1 | awk '{print(($1-$5)*60+1)}'`
Y_EDGE=`echo $LONLAT $LONLATJP1 | awk '{print(($8-$4)*60+1)}'`
htextract $ARGJP1 $ARG ${ELVMINJP1} ${ELVMIN} $X_EDGE $Y_EDGE
#
#echo "htformat $ARGHLF asciiu binary ${ELVMINORG} ${ELVMIN}"
#exit
# hanasaki htlinear $ARGHLF $ARG $ELVMIN $ELVMINREG
############################################################
# job
############################################################
if [ ! -d $DIRELVMIN ]; then  mkdir $DIRELVMIN; fi
if [ ! -d $DIRCANORG ]; then  mkdir $DIRCANORG; fi
if [ ! -d $DIRCANDES ]; then  mkdir $DIRCANDES; fi
if [ ! -d $DIRCANSCO ]; then  mkdir $DIRCANSCO; fi
if [ ! -d $DIRCANCNT ]; then  mkdir $DIRCANCNT; fi
#
prog_map_lcan2 $ARG $ELVMIN $RIVNUM $RIVARA $RIVSEQ $RIVNXL $LCANORG $XCANORG $YCANORG $CANSCO $CANCNT $MAX $OPT $LCANDES $BSNSIZ $BSNSIZTHR > $LOG
#############################################################
# check
############################################################
FILES="$XCANORG $YCANORG $LCANORG $LCANDES $CANSCO $CANCNT"
for FILE in $FILES; do
  echo $FILE >> $LOG
#  echo Sum `htstat $ARGHLF sum $FILE` >> $LOG
#  echo Max `htstat $ARGHLF max $FILE` >> $LOG
#  echo Min `htstat $ARGHLF min $FILE` >> $LOG
  echo Sum `htstat $ARG sum $FILE` >> $LOG
  echo Max `htstat $ARG max $FILE` >> $LOG
  echo Min `htstat $ARG min $FILE` >> $LOG

done
echo Log: $LOG
