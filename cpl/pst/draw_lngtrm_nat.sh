#!/bin/sh
############################################################
#to   draw long term global mean hydrological component
#by   2011/01/03, hanasaki, NIES: H08ver1.0
############################################################
# Edit here (basic)
############################################################
PRJPRCPST=WEC_; RUNPRCPST=20__; TITLE="ECHAM"
PRJPRCPST=WCN_; RUNPRCPST=20__; TITLE="CNRM"
PRJPRCPST=WIP_; RUNPRCPST=20__; TITLE="IPSL"
PRJPRCPST=GSW2; RUNPRCPST=B1b_; TITLE="GSW2LR"
#
PRJRUNPST=WEC_; RUNRUNPST=20__; TITLE="ECHAM"
PRJRUNPST=WCN_; RUNRUNPST=20__; TITLE="CNRM"
PRJRUNPST=WIP_; RUNRUNPST=20__; TITLE="IPSL"
PRJRUNPST=GSW2; RUNRUNPST=LR__; TITLE="GSW2LR"
#
YEARMINPST=1986
YEARMAXPST=1995
#
JOBPREP=yes
JOBDRAW=yes
#
PNG=temp.png
############################################################
# Edit here (optional for future simulation)
############################################################
PRJPRCFUT=WEC_; RUNPRCFUT=A2__   # Leave blank to disable
PRJPRCFUT=WCN_; RUNPRCFUT=A2__   # Leave blank to disable
PRJPRCFUT=WIP_; RUNPRCFUT=A2__   # Leave blank to disable
#
PRJRUNFUT=WEC_; RUNRUNFUT=A2__   # Leave blank to disable
PRJRUNFUT=WCN_; RUNRUNFUT=A2__   # Leave blank to disable
PRJRUNFUT=WIP_; RUNRUNFUT=A2__   # Leave blank to disable
#
YEARMINFUT=                      # Leave blank to disable
YEARMAXFUT=                      # Leave blank to disable
############################################################
# Edit here (geography)
############################################################
L="259200"
XY="720 360"
L2X=../../map/dat/l2x_l2y_/l2x.hlf.txt
L2Y=../../map/dat/l2x_l2y_/l2y.hlf.txt
LONLAT="-180 180 -90 90"
SUF=.hlf
ARG="$L $XY $L2X $L2Y $LONLAT"
#
L="64800"
XY="360 180"
L2X=../../map/dat/l2x_l2y_/l2x.one.txt
L2Y=../../map/dat/l2x_l2y_/l2y.one.txt
LONLAT="-180 180 -90 90"
SUF=.one
ARG="$L $XY $L2X $L2Y $LONLAT"
############################################################
# Edit here (in)
############################################################
LNDARA=../../map/dat/lnd_ara_/lndara.GSWP2${SUF}
LNDARASUM=`htstat $ARG sum $LNDARA | awk '{print $1}'`
#
DIRPRC=../../met/dat/Prcp____
DIRRUN=../../lnd/out/Qtot____
#
TMP=temp${SUF}
############################################################
# Job (Precipitation)
############################################################
if [ $JOBPREP = yes ]; then

  OUTPRC=temp.prc.${PRJPRCPST}.txt
  if [ -f $OUTPRC ]; then
    rm $OUTPRC
  fi

  YEAR=$YEARMINPST
  while [ $YEAR -le $YEARMAXPST ]; do
    echo $YEAR
    PRC=${DIRPRC}/${PRJPRCPST}${RUNPRCPST}${YEAR}0000${SUF} 
    htmath $L mul $PRC $LNDARA $TMP
    DAT1=`htstat $ARG sum $TMP | awk '{print $1}'`
    echo $DAT1 $LNDARASUM $YEAR |\
    awk '{print $3,0,0,$1/$2*31536000}' >> $OUTPRC
    YEAR=`expr $YEAR + 1`
  done

  if [ "$YEARMINFUT" != "" ]; then
    YEAR=$YEARMINFUT
    while [ $YEAR -le $YEARMAXFUT ]; do
      echo $YEAR
      PRC=${DIRPRC}/${PRJPRCFUT}${RUNPRCFUT}${YEAR}0000${SUF} 
      htmath $L mul $PRC $LNDARA $TMP
      DAT1=`htstat $ARG sum $TMP | awk '{print $1}'`
      echo $DAT1 $LNDARASUM $YEAR |\
      awk '{print $3,0,0,$1/$2*31536000}' >> $OUTPRC
      YEAR=`expr $YEAR + 1`
    done
  fi
fi
############################################################
# Job (Runoff)
############################################################
if [ $JOBPREP = yes ]; then
  OUTRUN=temp.run.${PRJRUNPST}.txt
  if [ -f $OUTRUN ]; then
    rm $OUTRUN
  fi

  YEAR=$YEARMINPST
  while [ $YEAR -le $YEARMAXPST ]; do
    echo $YEAR
    RUN=${DIRRUN}/${PRJRUNPST}${RUNRUNPST}${YEAR}0000${SUF} 
    htmath $L mul $RUN $LNDARA $TMP
    DAT1=`htstat $ARG sum $TMP | awk '{print $1}'`
    echo $DAT1 $LNDARASUM $YEAR | \
    awk '{print $3,0,0,$1/$2*31536000}' >> $OUTRUN
    YEAR=`expr $YEAR + 1`
  done

  if [ "$YEARMINFUT" != "" ]; then
    YEAR=$YEARMINFUT
    while [ $YEAR -le $YEARMAXFUT ]; do
      echo $YEAR
      RUN=${DIRRUN}/${PRJRUNFUT}${RUNRUNFUT}${YEAR}0000${SUF} 
      htmath $L mul $RUN $LNDARA $TMP
      DAT1=`htstat $ARG sum $TMP | awk '{print $1}'`
      echo $DAT1 $LNDARASUM $YEAR |\
      awk '{print $3,0,0,$1/$2*31536000}' >> $OUTRUN
      YEAR=`expr $YEAR + 1`
    done
  fi
fi
############################################################
# Draw
############################################################
if [ $JOBDRAW = yes ]; then
  if [ "$YEARMAXFUT" = "" ]; then
    XMAXR=`echo $YEARMAXPST $YEARMINPST | awk '{print $1-$2+1}'`
  else
    XMAXR=`echo $YEARMAXFUT $YEARMINPST | awk '{print $1-$2+1}'`
  fi
  BXANO=a1
  RFLAG=-R1/${XMAXR}/0/1000
  JFLAG=-JX21.0/10.5
  BFLAG=-B${BXANO}::/a100::neWS
  htcat ${OUTPRC}YR ${OUTRUN}YR > temp.txt
  htdrawts temp.txt temp.eps $RFLAG $JFLAG $BFLAG $TITLE
  htconv temp.eps $PNG rot
  echo $PNG
fi

