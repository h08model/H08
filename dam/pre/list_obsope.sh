#!/bin/sh
############################################################
#to   generate lookup table
#by   2010/03/31, hanasaki, NIES: H08ver1.0
############################################################
# Edit here (in)
############################################################
PRJ=WFDE
RUN=LR__
MIS=-999
IDS="3667 5146 5140 710 712 705 702 1307 1320 411 884 338 451 307 753 597 310 297 870 148 396 355"
############################################################
# Edit here (geography)
############################################################
L=259200
XY="720 360"
LONLAT="-180 180 -90 90"
L2X=../../map/dat/l2x_l2y_/l2x.hlf.txt
L2Y=../../map/dat/l2x_l2y_/l2y.hlf.txt
SUF=.hlf
############################################################
# Edit here (in)
############################################################
 DAMLST=../../map/org/GRanD/GRanD_L.txt
FLD2DRO=../../riv/out/fld2dro_/${PRJ}${RUN}00000000${SUF}
 FLDDUR=../../riv/out/fld_dur_/${PRJ}${RUN}00000000${SUF}
############################################################
# Edit here (out)
############################################################
DIROUT=../../dam/dat/obs_lst_
if [ ! -d $DIROUT ]; then mkdir -p $DIROUT; fi
OUT=${DIROUT}/obsdat.txt
if [   -f $OUT    ]; then rm $OUT; fi
############################################################
# Job
#
# - get id
# - mean annual discharge
# - data period
# - capacity over annual discahrge
# - start month of operating year
# - end month of operating year
############################################################
for ID in $IDS; do
#
  ID4=`echo $ID | awk '{printf("%4.4d",$1)}'`
#
  MEANFILE=../dat/obs_inf_/meanmon_0000${ID4}.txt
  if [ -f $MEANFILE ]; then
    DIS=`htstattxt ave ${MEANFILE}MO | awk '{print $1/1000}'`
  else
    DIS=$MIS
  fi

#
  MONFILE=../dat/obs_inf_/____mon_0000${ID4}.txt
  if [ -f $MONFILE ]; then
    YEARMIN=`head -1 $MONFILE | awk '{print $1}'`
    YEARMAX=`tail -1 $MONFILE | awk '{print $1}'`
  else
    YEARMIN=$MIS
    YEARMAX=$MIS
  fi

#
  INFO=`awk '($3=='"$ID"'){print $1,$2,$5,$6,$7,$10,$12,$13,$14,$15,$16,$17,$18}' $DAMLST`
  LON=`echo $INFO | awk '{print $1}'` 
  LAT=`echo $INFO | awk '{print $2}'` 
  NAME=`echo $INFO | awk '{print $3}'` 
  COUNTRY=`echo $INFO | awk '{print $4}'` 
  COMPLETE=`echo $INFO | awk '{print $5}'` 
  CAP=`echo $INFO | awk '{print $6}'` 
  HYD=`echo $INFO | awk '{print $7}'` 
  SUP=`echo $INFO | awk '{print $8}'` 
  CTR=`echo $INFO | awk '{print $9}'` 
  IRG=`echo $INFO | awk '{print $10}'` 
  NAV=`echo $INFO | awk '{print $11}'` 
  OTH=`echo $INFO | awk '{print $12}'` 
  AREA=`echo $INFO | awk '{print $13}'` 

#
  DIS=`echo $DIS | awk '{printf("%d",$1)}'`
  if [ $DIS -ne 0 ]; then
    CBYD=`echo $CAP $DIS | awk '{print $1/$2/0.365/86.400}'`
  else
    CBYD=0
  fi
#
  if [ $LON != -9999 ]; then
    FST=`htpoint $L $XY $L2X $L2Y $LONLAT lonlat $FLD2DRO $LON $LAT`
    FST=`echo $FST | awk '{printf("%d",$1)}'`
  else
    FST=0
  fi
#
  if [ $LON != -9999 ]; then
    DUR=`htpoint $L $XY $L2X $L2Y $LONLAT lonlat $FLDDUR $LON $LAT`
    DUR=`echo $DUR | awk '{printf("%d",$1)}'`
  else
    DUR=0
  fi
#    
  echo $ID $NAME $COUNTRY $COMPLETE $AREA $CAP $DIS $CBYD $YEARMIN $YEARMAX $FST $DUR |
  awk '{printf("%4d %24s %12s %4d %6d %6d %4d %4.2f %4d %4d %2d %2d\n",$1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12)}' >> $OUT
  echo $ID ok
  REC=`expr $REC + 1`
done