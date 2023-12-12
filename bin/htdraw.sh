#!/bin/sh
############################################################
#to    draw map
#by    2010/03/31, hanasaki: H08 ver1.0
############################################################
# GMT command preference
############################################################
#PSBASEMAP=psbasemap       # default
#XYZ2GRD=xyz2grd           # default
#GRDIMAGE=grdimage         # default
#PSSCALE=psscale           # default
#PSTEXT=pstext             # default
#PSCOAST=pscoast           # default
#
#PSBASEMAP="GMT psbasemap" # ubuntu (if command "GMT" works in your system)
#XYZ2GRD="GMT xyz2grd"     # ubuntu
#GRDIMAGE="GMT grdimage"   # ubuntu
#PSSCALE="GMT psscale"     # ubuntu
#PSTEXT="GMT pstext"       # ubuntu
#PSCOAST="GMT pscoast"     # ubuntu
#
PSBASEMAP="gmt psbasemap" # ubuntu (if command "gmt" works in your system)
XYZ2GRD="gmt xyz2grd"     # ubuntu
GRDIMAGE="gmt grdimage"   # ubuntu
PSSCALE="gmt psscale"     # ubuntu
PSTEXT="gmt pstext"       # ubuntu
PSCOAST="gmt pscoast"     # ubuntu
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

#shift 9        # ubuntu: add # to the front

BIN=${10}         # ubuntu: change BIN=${10}
CPT=${11}         # ubuntu: change CPT=${11}
EPS=${12}         # ubuntu: change EPS=${12}
TITLE1=${13}      # ubuntu: change TITLE1=${13}
TITLE2=${14}      # ubuntu: change TITLE2=${14}
OPT=${15}         # ubuntu: change OPT=${15}

if [ "$EPS" = "" ]; then
  echo "Usage: htdraw n0l n0x n0y c0l2x c0l2y"
  echo "               p0lonmin p0lonmax p0latmin p0latmax"
  echo "               c0bin c0cpt c0eps [Title1] [Title2] [OPT]"
  echo "OPT:   [whitesea,blacksea,bluesea,graysea,whiteland,blackland]"
  exit
fi
############################################################
# Map Projection
############################################################
LONRANGE=`echo $LONMAX $LONMIN | awk '{printf("%d", $1 - $2)}'`
LATRANGE=`echo $LATMAX $LATMIN | awk '{printf("%d", $1 - $2)}'`
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
elif [ $LONRANGE -gt 30 -a $LATRANGE -gt 15 ];then
  LONANO=5.0; LONFRM=5.0; LATANO=5.0; LATFRM=5.0
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
LONTITLE2=`echo $LONMAX $LONMIN | awk '{print $1*0.8+$2*0.2}'`
LATTITLE1=`echo $LATMAX $LATMIN | awk '{print $1*1.1-$2*0.1}'`
LATTITLE2=`echo $LATMAX $LATMIN | awk '{print $1*1.1-$2*0.1}'`
######################################################################
# Macro
######################################################################
HFLAG="$NL $NX $NY $L2X $L2Y $LONMIN $LONMAX $LATMIN $LATMAX binary ascii3"
RFLAG="-R${LONMIN}/${LONMAX}/${LATMIN}/${LATMAX}"
JFLAG="-JX${WMAP}d/${HMAP}d"
BFLAG="-Ba${LONANO}f${LONFRM}::/a${LATANO}f${LATFRM}::neWS"
GRD=temp.grd
XYZ=temp.xyz
######################################################################
# Draw map
######################################################################
htformat    $HFLAG $BIN $XYZ
$PSBASEMAP   $RFLAG $JFLAG $BFLAG                            -K  > $EPS 
awk '{if($3!=1.0E20) print $1,$2,$3; else print $1,$2,"NaN"}' $XYZ | \
$XYZ2GRD     $RFLAG -G$GRD -I${GRIDSIZE}/${GRIDSIZE} -r
$GRDIMAGE -O $RFLAG $JFLAG $GRD -C$CPT                       -K >> $EPS 
$PSSCALE  -O -C$CPT -D${XSCA}/${YSCA}/${WSCA}/${HSCA}h -L    -K >> $EPS
######################################################################
# Put title
######################################################################
if [ "$TITLE1" != "" -a "$TITLE1" != "." ]; then
#  echo main title ${TITLE1}
$PSTEXT $JFLAG $RFLAG -K -N -O                  << EOF >> $EPS 
$LONTITLE1 $LATTITLE1 20 0.0 1 6 ${TITLE1}
EOF
fi
if [ "$TITLE2" != "" -a "$TITLE2" != "." ]; then
#  echo sub title ${TITLE2}        
$PSTEXT $JFLAG $RFLAG -K -N -O                  << EOF >> $EPS 
$LONTITLE2 $LATTITLE2 20 0.0 1 6 ${TITLE2}		
EOF
fi
######################################################################
# Draw coastline
######################################################################
if [ "$OPT" = "" ]; then
  $PSCOAST -O $RFLAG $JFLAG -Dl -W1                           >> $EPS
elif [ "$OPT" = "graysea" ]; then
  $PSCOAST -O $RFLAG $JFLAG -Dl -W1            -S51/51/51     >> $EPS
elif [ "$OPT" = "bluesea" ]; then
  $PSCOAST -O $RFLAG $JFLAG -Dl -W1            -S128/128/255  >> $EPS
elif [ "$OPT" = "blacksea" ]; then
  $PSCOAST -O $RFLAG $JFLAG -Dl -W1            -S0/0/0        >> $EPS
elif [ "$OPT" = "whitesea" ]; then
  $PSCOAST -O $RFLAG $JFLAG -Dl -W1            -S255/255/255  >> $EPS
elif [ "$OPT" = "blackland" ]; then
  $PSCOAST -O $RFLAG $JFLAG -Dl -W1            -G0/0/0        >> $EPS
elif [ "$OPT" = "whiteland" ]; then
  $PSCOAST -O $RFLAG $JFLAG -Dl -W1            -G255/255/255  >> $EPS
fi


#/bin/rm -f .gmtcommands ${GRD} ${XYZ}
