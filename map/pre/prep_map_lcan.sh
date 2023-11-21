#!/bin/sh
############################################################
#to   prepare a map of implicit canal
#by   2014/05/09, hanasaki
############################################################
# settings (edit here)
#
# option "within":  origin and destination are in the same basin.
#        "nolimit": not necessarily in the same basin.
############################################################
L=259200
XY="720 360"
L2X=${DIRH08}/map/dat/l2x_l2y_/l2x.hlf.txt
L2Y=${DIRH08}/map/dat/l2x_l2y_/l2y.hlf.txt
LONLAT="-180 180 -90 90"
SUF=.hlf
MAP=.WFDEI
ARG="$L $XY $L2X $L2Y $LONLAT"
#
OPT=within          # within or nolimit
MAX=1               # maximum distance of implicit canal
############################################################
# in (edit here )
############################################################
ELVMINORG=../../map/org/K14/ETOPO1__00000000.hlf.txt
#
RIVNUM=../../map/out/riv_num_/rivnum${MAP}${SUF}
RIVARA=../../map/out/riv_ara_/rivara${MAP}${SUF}
RIVSEQ=../../map/out/riv_seq_/rivseq${MAP}${SUF}
RIVNXL=../../map/out/riv_nxl_/rivnxl${MAP}${SUF}
############################################################
# out
############################################################
DIRELVMIN=../../map/dat/elv_min_
ELVMIN=${DIRELVMIN}/ETOPO1__00000000${SUF}
#
DIRCANORG=../../map/out/can_org_   # origin of canal water
DIRCANDES=../../map/out/can_des_   # destination of canal water
DIRCANSCO=../../map/out/can_sco_   # score
DIRCANCNT=../../map/out/can_cnt_   # counter
XCANORG=$DIRCANORG/canorg.x.${OPT}.${MAX}${MAP}${SUF}
YCANORG=$DIRCANORG/canorg.y.${OPT}.${MAX}${MAP}${SUF}
LCANORG=$DIRCANORG/canorg.l.${OPT}.${MAX}${MAP}${SUF}
LCANDES=$DIRCANDES/candes.l.${OPT}.${MAX}${MAP}.bin
CANSCO=$DIRCANSCO/cansco.${OPT}.${MAX}${MAP}${SUF}
CANCNT=$DIRCANCNT/cancnt.${OPT}.${MAX}${MAP}${SUF}
#
LOG=temp.log
############################################################
# job
############################################################
if [ ! -d $DIRELVMIN ]; then  mkdir $DIRELVMIN; fi
if [ ! -d $DIRCANORG ]; then  mkdir $DIRCANORG; fi
if [ ! -d $DIRCANDES ]; then  mkdir $DIRCANDES; fi
if [ ! -d $DIRCANSCO ]; then  mkdir $DIRCANSCO; fi
if [ ! -d $DIRCANCNT ]; then  mkdir $DIRCANCNT; fi
#
############################################################
# job
############################################################
htformat $ARGHLF asciiu binary ${ELVMINORG} ${ELVMIN}

prog_map_lcan $ARG $ELVMIN $RIVNUM $RIVARA $RIVSEQ $RIVNXL $LCANORG $XCANORG $YCANORG $CANSCO $CANCNT $MAX $OPT $LCANDES > $LOG
#############################################################
# check
############################################################
FILES="$XCANORG $YCANORG $LCANORG $LCANDES $CANSCO $CANCNT"
for FILE in $FILES; do
  echo $FILE >> $LOG
  echo Sum `htstat $ARGHLF sum $FILE` >> $LOG
  echo Max `htstat $ARGHLF max $FILE` >> $LOG
  echo Min `htstat $ARGHLF min $FILE` >> $LOG
done
echo Log: $LOG
