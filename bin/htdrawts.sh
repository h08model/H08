#!/bin/sh
############################################################
#to   draw timeseries graph
#by   2010/03/31, hanasaki: H08ver1.0
############################################################
# GMT command preference
############################################################
#PSBASEMAP=psbasemap       # default
#PSTEXT=pstext             # default
#PSXY=psxy                 # default
#
#PSBASEMAP="GMT psbasemap" # ubuntu (if command "GMT" works in your system)
#PSTEXT="GMT pstext"       # ubuntu
#PSXY="GMT psxy"           # ubuntu
#
PSBASEMAP="gmt psbasemap" # ubuntu (if command "gmt" works in your system)
PSTEXT="gmt pstext"       # ubuntu
PSXY="gmt psxy"           # ubuntu
############################################################
#
############################################################
EPS=temp.eps
JPG=temp.jpg
############################################################
#
############################################################
if [ $# -lt 6 ]; then
  echo "Usage:  htdrawts c0ascts c0eps RFLAG JFLAG BLFAG TITLE [OPTION]"
  echo "OPTION: [bw, color, r0dat ]"
  echo "         bw: black and white"
  echo "         color: color"
  echo "         r0dat: draw the line of r0dat th column in bold."
  exit
fi
#
FILE=$1
EPS=$2
RFLAG=$3
JFLAG=$4
BFLAG=$5
TITLE=$6
#
if [ $# -eq 7 ]; then
  NUM=$7
  if [ "$NUM" != "bw" -a "$NUM" != "color" ]; then
    NUM=`echo $NUM | awk '{print $1+3}'`
  fi
else
  NUM=0
fi
############################################################
#
############################################################
LINES=`wc $FILE | awk '{print $1}'`
WORDS=`wc $FILE | awk '{print $2}'`
COLUMNS=`echo $WORDS $LINES | awk '{print $1/$2}'`
###if [ $COLUMNS -ge 5 ]; then
###  sed -e '1d' $FILE > temp.htdrawts.txt
###else
###  cp $FILE temp.htdrawts.txt
###fi
#
XMIN=`echo $RFLAG | sed -e 's-/- -g' | sed -e 's/-R//' | awk '{print $1}'`
XMAX=`echo $RFLAG | sed -e 's-/- -g' | sed -e 's/-R//' | awk '{print $2}'`
YMIN=`echo $RFLAG | sed -e 's-/- -g' | sed -e 's/-R//' | awk '{print $3}'`
YMAX=`echo $RFLAG | sed -e 's-/- -g' | sed -e 's/-R//' | awk '{print $4}'`
#
YTIT=`echo $YMAX | awk '{print $1*1.1}'`
XTIT=`echo $XMAX | awk '{print $1*0.5}'`
XANO=`echo $XMAX | awk '{print $1*0.25}'`
YANO=`echo $YMAX | awk '{print $1*0.2}'`
############################################################
#
############################################################
$PSBASEMAP $RFLAG $JFLAG $BFLAG -K > $EPS
COLUMN=4
while [ "$COLUMN" -le "$COLUMNS" ]; do
  if [ $NUM = "bw" ]; then
    if   [ $COLUMN = 4 ]; then
      WFLAG="-W3/0/0/0"
    elif [ $COLUMN = 5 ]; then
      WFLAG="-W3/0/0/0ta"
    elif [ $COLUMN = 6 ]; then
      WFLAG="-W3/128/128/128"
    elif [ $COLUMN = 7 ]; then
      WFLAG="-W3/128/128/128ta"
    elif [ $COLUMN = 8 ]; then
      WFLAG="-W3/192/192/192"
    elif [ $COLUMN = 9 ]; then
      WFLAG="-W3/192/192/192ta"
    fi
  elif [ $NUM = "color" ]; then
    if   [ $COLUMN = 4 ]; then
      WFLAG="-W3/0/0/0"
    elif [ $COLUMN = 5 ]; then
      WFLAG="-W3/0/0/0ta"
    elif [ $COLUMN = 6 ]; then
      WFLAG="-W3/255/0/0"
    elif [ $COLUMN = 7 ]; then
      WFLAG="-W3/255/0/0ta"
    elif [ $COLUMN = 8 ]; then
      WFLAG="-W3/0/255/0"
    elif [ $COLUMN = 9 ]; then
      WFLAG="-W3/0/255/0ta"
    fi
  elif [ $COLUMN = $NUM ]; then
    WFLAG=-W10
    awk '{print NR,$'$COLUMN'}' $FILE
  else
    WFLAG=-W3
  fi
  echo $COLUMN $WFLAG
  awk '{print NR,$'$COLUMN'}' $FILE | \
  $PSXY -O $RFLAG $JFLAG $BFLAG $WFLAG -K >> $EPS
  COLUMN=`expr $COLUMN + 1`
done
############################################################
#
############################################################
$PSTEXT -O $RFLAG $JFLAG $BFLAG -N  << EOF >> $EPS
$XTIT $YTIT 20 0 0 6 $TITLE
EOF

