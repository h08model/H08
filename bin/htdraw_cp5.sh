#!/bin/sh
############################################################
#to    draw map
#by    2010/03/31, hanasaki: H08 ver1.0
############################################################
# Argument
############################################################
NL=$1          # NL=64800
NX=$2          # NX=360
NY=$3          # NY=180
L2X=$4
L2Y=$5
LONMIN=$6      # LONMIN=-180.00
LONMAX=$7      # LONMAX=180.00
LATMIN=$8      # LATMIN=-90.00
LATMAX=$9      # LATMAX=90.00

shift 9

BIN=$1
CPT=$2
EPS=$3
TITLE1=$4
TITLE2=$5
OPT=$6

if [ "$EPS" = "" ]; then
  echo "Usage: bin2eps NL NX NY L2X L2Y LONMIN LONMAX LATMIN LATMAX"
  echo "               BIN CPT EPS [Title1] [Title2] [OPT]"
  echo "OPT:   [whitesea,blacksea,bluesea,graysea,whiteland,blackland]"
  exit
fi
############################################################
# Map Projection
############################################################
LONRANGE=`echo $LONMAX $LONMIN | awk '{print $1 - $2}'`
LATRANGE=`echo $LATMAX $LATMIN | awk '{print $1 - $2}'`
#
#echo $LONRANGE $LATRANGE
#
if [ $LONRANGE -gt $LATRANGE ]; then
  FACTOR=`echo 21.6 $LONRANGE | awk '{print $1/$2}'`
else
  FACTOR=`echo 10.8 $LATRANGE | awk '{print $1/$2}'`
fi
#
#echo $FACTOR
#
WMAP=`echo $LONRANGE | awk '{print $1*'${FACTOR}'}'`
HMAP=`echo $LATRANGE | awk '{print $1*'${FACTOR}'}'`
#
#echo $WMAP $HMAP
#
if [ $LONRANGE -gt 180 -a $LATRANGE -gt 90 ];then
  LONANO=30.0; LONFRM=30.0; LATANO=30.0; LATFRM=30.0
elif [ $LONRANGE -gt 90 -a $LATRANGE -gt 45 ];then
  LONANO=10.0; LONFRM=10.0; LATANO=10.0; LATFRM=10.0
else
  LONANO=1.0; LONFRM=1.0; LATANO=1.0; LATFRM=1.0
fi
#
GRIDSIZE=`echo $LONRANGE $NX | awk '{print $1/$2}'`
#
XSCA=`echo $WMAP | awk '{print $1*0.5}'`
YSCA=`echo $HMAP | awk '{print $1*-0.1}'`
WSCA=$WMAP
HSCA=0.5
#
LONTITLE1=`echo $LONMAX $LONMIN | awk '{print $1*0.5+$2*0.5}'`
LONTITLE2=`echo $LONMAX $LONMIN | awk '{print $1*0.2+$2*0.8}'`
LATTITLE1=`echo $LATMAX $LATMIN | awk '{print $1*1.2-$2*0.2}'`
LATTITLE2=`echo $LATMAX $LATMIN | awk '{print $1*1.2+$2*0.2}'`
######################################################################
# Macro
######################################################################
HFLAG="$NL $NX $NY $L2X $L2Y $LONMIN $LONMAX $LATMIN $LATMAX binary ascii3"
#RFLAG="-R${LONMIN}/${LONMAX}/${LATMIN}/${LATMAX}"
RFLAG="-R97/102/13/20"
#JFLAG="-JX${WMAP}d/${HMAP}d"
JFLAG="-JX10d/14d"
#BFLAG="-Ba${LONANO}f${LONFRM}::/a${LATANO}f${LATFRM}::neWS"
BFLAG="-Ba1f1::/a1f1::neWS"
GRD=temp.grd
XYZ=temp.xyz
######################################################################
# Draw map
######################################################################
htformat    $HFLAG $BIN $XYZ
psbasemap   $RFLAG $JFLAG $BFLAG                            -K  > $EPS 
awk '{print $1, $2, $3}' $XYZ | \
xyz2grd     $RFLAG -G$GRD -I${GRIDSIZE}/${GRIDSIZE} -F
grdimage -O $RFLAG $JFLAG $GRD -C$CPT                       -K >> $EPS 
#psscale  -O -C$CPT -D${XSCA}/${YSCA}/${WSCA}/${HSCA}h -L    -K >> $EPS
psscale  -O -C$CPT -D5/-1/10/0.5h -L    -K >> $EPS
######################################################################
# Put title
######################################################################
if [ "$TITLE1" = "" -o "$TITLE1" = "." ]; then
  echo No main title
else
  echo main title ${TITLE1}
  pstext -O $RFLAG $JFLAG -N                  -K   << EOF >> $EPS
  $LONTITLE1 $LATTITLE1 20 0.0 1 6 ${TITLE1}
EOF
fi
if [ "$TITLE2" = "" -o "$TITLE2" = "." ]; then
  echo No sub title
else
  echo sub title ${TITLE2}
  pstext -O $RFLAG $JFLAG -N                   -K  << EOF >> $EPS
  $LONTITLE2 $LATTITLE2 20 0.0 1 6 ${TITLE2}		
EOF
fi
######################################################################
# Draw coastline
######################################################################
if [ "$OPT" = "" ]; then
  pscoast -O $RFLAG $JFLAG -Dc -W1                           >> $EPS
elif [ "$OPT" = "graysea" ]; then
  pscoast -O $RFLAG $JFLAG -Dc -W1            -S51/51/51     >> $EPS
elif [ "$OPT" = "bluesea" ]; then
  pscoast -O $RFLAG $JFLAG -Dc -W1            -S128/128/255  >> $EPS
elif [ "$OPT" = "blacksea" ]; then
  pscoast -O $RFLAG $JFLAG -Dc -W1            -S0/0/0        >> $EPS
elif [ "$OPT" = "whitesea" ]; then
  pscoast -O $RFLAG $JFLAG -Dc -W1            -S255/255/255  >> $EPS
elif [ "$OPT" = "blackland" ]; then
  pscoast -O $RFLAG $JFLAG -Dc -W1            -G0/0/0        >> $EPS
elif [ "$OPT" = "whiteland" ]; then
  pscoast -O $RFLAG $JFLAG -Dc -W1            -G255/255/255  >> $EPS
fi

/bin/rm -f .gmtcommands ${GRD} ${XYZ}





