#!/bin/sh
############################################################
#to   draw long term global mean hydrological component
#by   2011/01/03, hanasaki, NIES: H08ver1.0
############################################################
# Edit here (basic)
############################################################
PRJDAMPST=WEC_; RUNDAMPST=20H_; TITLE="ECHAM"
PRJDAMPST=WCN_; RUNDAMPST=20H_; TITLE="CNRM"
PRJDAMPST=WIP_; RUNDAMPST=20H_; TITLE="IPSL"
PRJDAMPST=GSW2; RUNDAMPST=LECD; TITLE="GSW2LR"
#
PRJDEMPST=WEC_; RUNDEMPST=20I_
PRJDEMPST=WCN_; RUNDEMPST=20I_
PRJDEMPST=WIP_; RUNDEMPST=20I_
PRJDEMPST=GSW2; RUNDEMPST=L_C_
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
PRJDAMFUT=WEC_; RUNDAMFUT=A2H_
PRJDAMFUT=WCN_; RUNDAMFUT=A2H_
PRJDAMFUT=WIP_; RUNDAMFUT=A2H_
#
PRJDEMFUT=WEC_; RUNDEMFUT=A2I_
PRJDEMFUT=WCN_; RUNDEMFUT=A2I_
PRJDEMFUT=WIP_; RUNDEMFUT=A2I_
#
YEARMINFUT=
YEARMAXFUT=
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
DIRDAM=../../dam/out/dam_sto_
DIRDEM=../../lnd/out/DemAgr__
#DIRDEM=../../lnd/out/WitAgr__
#
TMP=temp${SUF}
############################################################
# Job (Reservoir storage)
############################################################
if [ "$JOBPREP" = "yes" ]; then
  OUTDAM=temp.dam.${PRJDAMPST}.txt
  if [ -f $OUTDAM ]; then
    rm $OUTDAM
  fi

  YEAR=$YEARMINPST
  while [ $YEAR -le $YEARMAXPST ]; do
    echo $YEAR
    DAM=${DIRDAM}/${PRJDAMPST}${RUNDAMPST}${YEAR}0000${SUF} 

    DAT1=`htstat $ARG sum $DAM | awk '{print $1}'`
    echo $YEAR $DAT1 |\
    awk '{print $1,0,0,$2/1000/1000/1000/1000}' >> $OUTDAM
    YEAR=`expr $YEAR + 1`
  done

  if [ "$YEARMINFUT" != "" ]; then
    YEAR=$YEARMINFUT
    while [ $YEAR -le $YEARMAXFUT ]; do
      echo $YEAR
      DAM=${DIRDAM}/${PRJDAMFUT}${RUNDAMFUT}${YEAR}0000${SUF} 

      DAT1=`htstat $ARG sum $DAM | awk '{print $1}'`
      echo $YEAR $DAT1 |\
      awk '{print $1,0,0,$2/1000/1000/1000/1000}' >> $OUTDAM

      YEAR=`expr $YEAR + 1`
    done
  fi
fi
############################################################
# Job (Demand)
############################################################
if [ $JOBPREP = yes ]; then
  OUTDEM=temp.dem.${PRJDAMPST}.txt
  if [ -f $OUTDEM ]; then
    rm $OUTDEM
  fi

  YEAR=$YEARMINPST
  while [ $YEAR -le $YEARMAXPST ]; do
    echo $YEAR
    DEM=${DIRDEM}/${PRJDEMPST}${RUNDEMPST}${YEAR}0000${SUF} 

    DAT1=`htstat $ARG sum $DEM | awk '{print $1}'`
    echo $YEAR $DAT1 |\
    awk '{print $1,0,0,$2*31.536/1000/1000}' >> $OUTDEM
    YEAR=`expr $YEAR + 1`
  done

  if [ "$YEARMINFUT" != "" ]; then
    YEAR=$YEARMINFUT
    while [ $YEAR -le $YEARMAXFUT ]; do
      echo $YEAR
      DEM=${DIRDEM}/${PRJDEMFUT}${RUNDEMFUT}${YEAR}0000${SUF} 

      DAT1=`htstat $ARG sum $DEM | awk '{print $1}'`
      echo $YEAR $DAT1 |\
      awk '{print $1,0,0,$2*31.536/1000/1000}' >> $OUTDEM
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
  RFLAG=-R1/${XMAXR}/0/10000
  JFLAG=-JX21.0/10.5
  BFLAG=-B${BXANO}::/a1000::neWS
  htcat ${OUTDAM}YR ${OUTDEM}YR > temp.txt
  htdrawts temp.txt temp.eps $RFLAG $JFLAG $BFLAG $TITLE
  htconv temp.eps $PNG rot
  echo $PNG
fi


