#!/bin/sh
######################################################
#to    draw scatter diagram
#by    2011/06/08, hanasaki: H08ver1.0
######################################################
# get argument
######################################################
if [ $# -lt 7 ]; then
  echo Usage: htplot DAT c0eps RFLAG JFLAG BFLAG SFLAG TITLE [SIZELAB]
  exit
fi
#
DAT=$1
EPS=$2
RFLAG=$3
JFLAG=$4
BFLAG=$5
SFLAG=$6
TITLE=$7
if [ $# = 8 ]; then
  SIZELAB=$8
else
  SIZELAB=
fi
#
#DISOBS=../riv/dat/stn_obs_/________03629000.YR.txt
#DISSIM=temp.1.txt
#YEARMIN=1986
#YEARMAX=1995
#RFLAG=-R0/5/0/5
#BFLAG=-Ba1::/a1neWS
#JFLAG=-JX10.5/10.5
#SFLAG=-Sa0.1
#EPS=temp.eps

TITLEX=`echo $RFLAG | awk 'BEGIN{FS="/"}{print $2*0.5}'`
TITLEY=`echo $RFLAG | awk 'BEGIN{FS="/"}{print $2*1.1}'`
######################################################
# job
######################################################
if [ "$SIZELAB" = "" ]; then
  awk '{print $2,$3}' $DAT | \
  psxy      $RFLAG $JFLAG $BFLAG $SFLAG -K > $EPS
else
  if [ -f $EPS ]; then
    rm $EPS
  fi
  RECMAX=`wc $DAT | awk '{print $1}'`
  REC=1
  while [ $REC -le $RECMAX ]; do
    LAB=`sed -n ''$REC'p' $DAT | awk '{print $1}'`
    sed -n ''$REC'p' $DAT | awk '{print $2,$3}' | \
    psxy $OFLAG     $RFLAG $JFLAG $BFLAG $SFLAG               -K >> $EPS
    OFLAG=-O
    sed -n ''$REC'p' $DAT | awk '{print $2,$3}' | \
    psxy $OFLAG     $RFLAG $JFLAG $BFLAG -Sl${SIZELAB}/${LAB} -K >> $EPS
    REC=`expr $REC + 1`
  done
fi
pstext -O $RFLAG $JFLAG $BFLAG -N <<EOF >> $EPS
$TITLEX  $TITLEY 20 0 0 6 $TITLE
EOF
