#!/bin/sh
############################################################
#to    draw observed operation
#by    2010/08/23, Hanasaki, H08ver1.0
############################################################
# Edit here (basic)
############################################################
#IDS="3667 5146 5140 710 712 705 702 1307 1320 411 884 338 451 307 753 597 310 297 870 148 396 355"
IDS=5140
############################################################
# Edit here (in)
############################################################
LST=../../map/org/GRanD/GRanD_L.txt
############################################################
# Edit here (in/out)
############################################################
for ID in $IDS; do 
ID4=`echo $ID | awk '{printf("%4.4d",$1)}'`
# in
  OBSSTO=../dat/obs_sto_/____mon_0000${ID4}.txt
  OBSINF=../dat/obs_inf_/____mon_0000${ID4}.txt
  OBSRLS=../dat/obs_rls_/____mon_0000${ID4}.txt
  DAMDEM=../dat/off_dem_/WFDEN_C_0000${ID4}.txt
  YEARDISP=0000
# out
  DIRFIG=../fig/obs_ope_
  EPS=${DIRFIG}/____mon_0000${ID4}.eps
  PNG=${DIRFIG}/____mon_0000${ID4}.png
  if [ ! -d $DIRFIG ]; then
    mkdir -p $DIRFIG
  fi
############################################################
# Analyze
############################################################
  YEARMIN=`sed -n '1p' $OBSSTO | awk '{print $1}'`
  YEARMAX=`sed -n '$p' $OBSSTO | awk '{print $1}'`
  STOMAX=`awk '($3=='"$ID"'){print $10}' $LST`
  RLSMAX=`htstattxt max ${OBSINF}MO`
  RLSMAX=`echo $RLSMAX | awk '{print $1/1000}' | sed -e 's/^[<space>]//'`
  echo $YEARMIN $YEARMAX $STOMAX $RLSMAX
############################################################
# Macro (GMT)
############################################################
  JBAS="-JX9/18"
  RBAS="-R0/12/0/24"
  BBAS="-B0"
  JSTO="-JX9/9"
  RSTO="-R0/12/0/$STOMAX"
  BSTO="-Ba1::/a1000::neWS"
  JRLS="-JX9/9"
  RRLS="-R0/12/0/$RLSMAX"
  BRLS="-Ba1::/a1000::neWS"
  echo $JBAS $RBAS $BBAS
  echo $JSTO $RSTO $BSTO
  echo $JRLS $RRLS $BRLS
############################################################
# Job
############################################################
  psbasemap $JBAS $RBAS $BBAS                             -K > $EPS
  YEAR=$YEARMIN
  while [ $YEAR -le $YEARMAX ]; do
    awk '($1=='"$YEAR"'){print $2-0.5,$4/1000/1000/1000}' $OBSSTO
    awk '($1=='"$YEAR"'){print $2-0.5,$4/1000/1000/1000}' $OBSSTO | \
    psxy -O -X0 -Y9  $JSTO $RSTO $BSTO                   -K >> $EPS
    awk '($1=='"$YEAR"'){print $2-0.5,$4/1000}' $OBSRLS
    awk '($1=='"$YEAR"'){print $2-0.5,$4/1000}' $OBSRLS | \
    psxy -O -X0 -Y-9 $JRLS $RRLS $BRLS                   -K >> $EPS
    YEAR=`expr $YEAR + 1`
  done
  awk '($1=='$YEARDISP'){print $2-0.5,$4/1000}' $DAMDEM
  awk '($1=='$YEARDISP'){print $2-0.5,$4/1000}' $DAMDEM | \
  psxy -O -X0 -Y0 $JRLS $RRLS $BRLS -W5/255/0/0              >> $EPS
  htconv $EPS $PNG rot
  echo $PNG
  echo "monthly storage and release from $YEARMIN to $YEARMAX" 
done