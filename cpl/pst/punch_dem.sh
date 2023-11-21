#!/bin/sh
############################################################
#to   
# LID = Land Improvement District
#by   2018/01/19, fujiwara, NIES: 
############################################################
PRJ=AK10
RUNN_C_=N_Ca
YEARMIN=2007
YEARMAX=2012
MONS="01 02 03 04 05 06 07 08 09 10 11 12"
############################################################
# Geographical Setting
############################################################
L=32400
XY="180 180"
L2X=../../map/dat/l2x_l2y_/l2x.ks1.txt
L2Y=../../map/dat/l2x_l2y_/l2y.ks1.txt
LONLAT="129 132 31 34"
ARG="$L $XY $L2X $L2Y $LONLAT"
SUF=.ks1
MAP=.kyusyu
############################################################
# LID IDs
############################################################
VER=v3__
IDS="01 02 03 04 05 06 07 08 09 10 11"
############################################################
# LID mask
############################################################
LIDMSK=../../map/dat/lid_id__/${PRJ}${VER}00000000${SUF}
#LIDMSK=../../map/org/KYUSYU/tochikairyoku_v1${SUF}
#ARATXT=../../map/org/KYUSYU/tochikairyoku_area.txt
ARATXT=../../map/dat/lid_id__/${PRJ}${VER}00000000.txt
############################################################
# Map
############################################################
IRGARA=../../map/org/map-org-KYUSYU/area/all_area2.ks1
############################################################
# Output Directory
############################################################
DIRLIDDEMD=../../lnd/out/lid_demD
DIRLIDDEMM=../../lnd/out/lid_demM
DIRLIDSUP=../../lnd/out/lid_sup_
############################################################
# Jobs
############################################################
if [ ! -e $DIRLIDDEMD ]; then  mkdir $DIRLIDDEMD; fi
if [ ! -e $DIRLIDDEMM ]; then  mkdir $DIRLIDDEMM; fi
if [ ! -e $DIRLIDSUP ]; then  mkdir $DIRLIDSUP; fi

IDINI=`echo $IDS | awk '{print $1}'`
for ID in $IDS; do
  echo "ID:" $ID
#  ID=`printf "%02d\n" $ID`

  DEMAGRDTXT=$DIRLIDDEMD/${PRJ}${RUNN_C_}000000${ID}.txt
  DEMAGRMTXT=$DIRLIDDEMM/${PRJ}${RUNN_C_}000000${ID}.txt
#  SUPAGRTXT=$DIRLIDSUP/${PRJ}${RUNLECD}000000${ID}.txt

  YR=$YEARMIN
  while [ $YR -le $YEARMAX ]; do
    for MON in $MONS; do
      DEMAGRM=../../lnd/out/DemAgr__/${PRJ}${RUNN_C_}${YR}${MON}00${SUF}
#      SUPAGR=../../lnd/out/SupAgr__/${PRJ}${RUNLECD}${YR}${MON}00${SUF}

      htmask $ARG $DEMAGRM $LIDMSK eq $ID temp1${SUF}
#      htmask $ARG $SUPAGR $LIDMSK eq $ID temp2${SUF}
      
      DAT1=`htstat $ARG sum temp1${SUF} | awk '{print $1/1000}'`
#      DAT2=`htstat $ARG sum temp2${SUF} | awk '{print $1/1000}'`

      if [ $YR -eq $YEARMIN -a $MON -eq "01" ]; then
	echo $YR $MON "0" $DAT1 > $DEMAGRMTXT
#	echo $YR $MON "0" $DAT2 > $SUPAGRTXT
      else
	echo $YR $MON "0" $DAT1 >> $DEMAGRMTXT
#	echo $YR $MON "0" $DAT2 >> $SUPAGRTXT
      fi
      DAY=1
      DAYMAX=`htcal $YR $MON`
      while [ $DAY -le $DAYMAX ]; do
	DAY=`printf "%02d\n" $DAY`
        DEMAGRD=../../lnd/out/DemAgr__/${PRJ}${RUNN_C_}${YR}${MON}${DAY}${SUF}
	htmask $ARG $DEMAGRD $LIDMSK eq $ID temp1${SUF}
	DAT1=`htstat $ARG sum temp1${SUF} | awk '{print $1/1000}'`
	if [ $YR -eq $YEARMIN -a $MON -eq "01" -a $DAY -eq "01" ]; then
	  echo $YR $MON $DAY $DAT1 > $DEMAGRDTXT
	else
	  echo $YR $MON $DAY $DAT1 >> $DEMAGRDTXT
	fi
	DAY=`expr $DAY + 1`
      done
    done
    YR=`expr $YR + 1`
  done

## area ##
  htmask $ARG $IRGARA $LIDMSK eq $ID temp${SUF}
  DAT=`htstat $ARG sum temp${SUF} | awk '{print $1/10000}'`
  if [ $ID -eq $IDINI ]; then
    echo "ID Area[ha]" > $ARATXT
  fi
  echo $ID $DAT >> $ARATXT
done