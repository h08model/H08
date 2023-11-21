#!/bin/sh
############################################################
#to   list crop yield
#by   2011/06/02, hanasaki: H08 ver1.0
############################################################
#
############################################################
L=259200
XY="720 360"
L2X=../../map/dat/l2x_l2y_/l2x.hlf.txt
L2Y=../../map/dat/l2x_l2y_/l2y.hlf.txt
LONLAT="-180 180 -90 90"
ARG="$L $XY $L2X $L2Y $LONLAT"
SUF=.hlf

L=64800
XY="360 180"
L2X=../../map/dat/l2x_l2y_/l2x.one.txt
L2Y=../../map/dat/l2x_l2y_/l2y.one.txt
LONLAT="-180 180 -90 90"
ARG="$L $XY $L2X $L2Y $LONLAT"
SUF=.one
############################################################
#
############################################################
NATMSK=../../map/dat/nat_msk_/C05_____20000000${SUF}
NATCOD=../../map/dat/nat_cod_/C05_____20000000.txt
LNDARA=../../map/dat/lnd_ara_/lndara.GSWP2.one
CRPTYP=../../map/out/crp_typ1/L04_____00000000${SUF}
RAM2NAME=../../crp/org/SWIM/ram2name.txt
#
PRJ=GSW2
RUN=NEWN
IDS="5"
CATEGORYS="1st1 1st2 1st3 1st4"
YEARMIN=1961
YEARMIN=1986
YEARMAX=1986
#


JOB=makedata
JOB=getdata; COUNTRY=USA
############################################################
#
############################################################
ARA=temp.area${SUF}
TMP=temp${SUF}
TMP2=temp.2${SUF}
############################################################
#
############################################################
if [ $JOB = makedata ]; then
  YEAR=$YEARMIN
  while [ $YEAR -le $YEARMAX ]; do
    for CATEGORY in $CATEGORYS; do

      if [ $CATEGORY = 1st1 ]; then
        FRC=../../map/dat/irg_frcd/irgfrc.dbl.DS02.one
        htmath $L mul $LNDARA $FRC $ARA
      elif  [ $CATEGORY = 1st2 ]; then
        FRC=../../map/dat/irg_frcs/irgfrc.sgl.DS02.one
        htmath $L mul $LNDARA $FRC $ARA
      elif  [ $CATEGORY = 1st3 ]; then
        FRC=../../map/dat/rfd_frc_/rainfed.DS02.one
        htmath $L mul $LNDARA $FRC $ARA
      fi

      for ID in $IDS; do
        CRP=`awk '{print $'$ID'}' $RAM2NAME`
        DIR=../../crp/out/yld_${CATEGORY}
        YLD=${DIR}/${PRJ}${RUN}${YEAR}0000${SUF}
        DIR=../../crp/out/yld_${CRP}
        OUT=${DIR}/${PRJ}${RUN}${YEAR}0000.${CATEGORY}.txt
#        htmask $ARG $ARA $CRPTYP eq $ID $ARA > /dev/null
        htmask $ARG $ARA $CRPTYP eq $ID $ARA
        htbin2list $L $YLD $NATMSK $NATCOD $OUT weight $ARA
        echo $OUT
      done

    done
    YEAR=`expr $YEAR + 1`
  done
fi
############################################################
#
############################################################
if [ $JOB = getdata ]; then
  for CATEGORY in $CATEGORYS; do
    for ID in $IDS; do
      YEAR=$YEARMIN
      if [ -f $TMP ]; then
        rm $TMP
      fi
      while [ $YEAR -le $YEARMAX ]; do
        CRP=`awk '{print $'$ID'}' $RAM2NAME`
        DIR=../../crp/out/yld_${CRP}
        OUT=${DIR}/${PRJ}${RUN}${YEAR}0000.${CATEGORY}.txt
        DAT=`grep $COUNTRY $OUT | awk '{print $2}'`
        if [ "$DAT" = "" ]; then
          echo no $COUNTRY in $OUT
	  exit
        fi
        echo $YEAR 0 0 $DAT >> $TMP
        YEAR=`expr $YEAR + 1`
      done
      IDNAT=`grep -w $COUNTRY $NATCOD | awk '{print $2}'`
      echo $IDNAT
      OBS=../../crp/dat/yld_${CRP}/FAOSTAT_00000${IDNAT}.txt
      RFLAG=-R0/6000/0/6000
      JFLAG=-JX10.5/10.5
      BFLAG=-Ba1000::/a1000::neWS
      SFLAG=-Sa0.1
      EPS=temp.eps
      PNG=temp.png
      TITLE=${COUNTRY}_${CRP}
      htcat  ${OBS}YR ${TMP}YR $YEARMIN $YEARMAX > $TMP2
      htplotts $TMP2 $EPS $RFLAG $JFLAG $BFLAG $SFLAG $TITLE
      htconv $EPS $PNG rot
    done
  done
fi

