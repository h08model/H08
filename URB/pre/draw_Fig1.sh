#!/bin/sh
############################################################
#to    draw map
#by    2013/08/22, hanasaki
############################################################
# GMT command preference
############################################################
PSBASEMAP=psbasemap       # default
XYZ2GRD=xyz2grd           # default
GRDIMAGE=grdimage         # default
PSSCALE=psscale           # default
PSTEXT=pstext             # default
PSCOAST=pscoast           # default
#
PSBASEMAP="gmt psbasemap" # ubuntu
XYZ2GRD="gmt xyz2grd"     # ubuntu
GRDIMAGE="gmt grdimage"   # ubuntu
PSSCALE="gmt psscale"     # ubuntu
PSTEXT="gmt pstext"       # ubuntu
PSCOAST="gmt pscoast"     # ubuntu
PSXY="gmt psxy"           # ubuntu
############################################################
# Argument
############################################################
#ARG="$ARGCT5"; SUF=.ct5; ID=00000098
#ARG="$ARGLN5"; SUF=.ln5; ID=00000038
ARG="$ARGTK5"; SUF=.tk5; ID=
#ARG="$ARGCN5"; SUF=.cn5; ID=00000032
#ARG="$ARGLA5"; SUF=.la5; ID=00000017
#ARG="$ARGRJ5"; SUF=.rj5; ID=00000016
#ARG="$ARGPR5"; SUF=.pr5; ID=00000021
ARG="$ARGTY5"; SUF=.ty5; ID=
ARG="$ARGSY5"; SUF=.sy5; ID=

YMD=00000000

#NX=`echo $XY | awk '{print $1}'`
#NY=`echo $XY | awk '{print $2}'`
#LONMIN=`echo $LONLAT | awk '{print $1}'`
#LONMAX=`echo $LONLAT | awk '{print $2}'`
#LATMIN=`echo $LONLAT | awk '{print $3}'`
#LATMAX=`echo $LONLAT | awk '{print $4}'`
#ARG="$NL $NX $NY $L2X $L2Y $LONMIN $LONMAX $LATMIN $LATMAX"
NL=`echo $ARG | awk '{print $1}'`
NX=`echo $ARG | awk '{print $2}'`
NY=`echo $ARG | awk '{print $3}'`
L2X=`echo $ARG | awk '{print $4}'`
L2Y=`echo $ARG | awk '{print $5}'`
LONMIN=`echo $ARG | awk '{print $6}'`
LONMAX=`echo $ARG | awk '{print $7}'`
LATMIN=`echo $ARG | awk '{print $8}'`
LATMAX=`echo $ARG | awk '{print $9}'`

#DAMLST=./GRanD${SUF}.txt
#JFLAG="-JX8d/6d"

#BIN=temp.cp5
#AL=../../map/dat/lnd_msk_/lndmsk.K10S.cp5
#C2=../../map/out/sub_bsn_/C2.cp5
#BB=../../map/out/sub_bsn_/BB.cp5
#SK=../../map/out/sub_bsn_/SK.cp5
#Y6=../../map/out/sub_bsn_/Y6.cp5
BIN=../../map/out/riv_num_/rivnum.CAMA${SUF}
#outdated CTYMSK=../../map/dat/cty_msk_/city_${ID}${SUF}
#outdated CTYPRF=../../map/dat/cty_prf_/city_${ID}${SUF}
#outdated CTYSWG=../../map/dat/cty_swg_/city_${ID}${SUF}
CTYMSK=../../map/dat/cty_msk_/GPW_____${YMD}${SUF}
CTYPRF=../../map/dat/cty_prf_/GPW_____${YMD}${SUF}
CTYSWG=../../map/dat/cty_swg_/GPW_____${YMD}${SUF}
if [ "$SUF" = ".tk5" ]; then
  CTYMSK=../org/KKT/cty_msk_${SUF}
  #  CTYPRF=../org/KKT/cty_prf_${SUF}
    CTYPRF=../dat/cty_prf_.full2${SUF}
  CTYSWG=../org/KKT/cty_swg_${SUF}
fi

#CPT=../CPT/HRL2013.cpt
EPS=../fig/Fig1${SUF}.eps
PNG=../fig/Fig1${SUF}.png
CPT=./CPT/basin.cpt
###FLWDIR=../../map/dat/flw_dir_/flwdir.K10S.cp5
DES=temp.des${SUF}.txt
TMP=temp.txt
TMPBIN=temp${SUF}
OPT=graysea
############################################################
#
############################################################
#htmaskrplc $ARG $AL  $C2 eq 1 2 $BIN
#htmaskrplc $ARG $BIN $BB eq 1 3 $BIN
#htmaskrplc $ARG $BIN $SK eq 1 3 $BIN
#htmaskrplc $ARG $BIN $Y6 eq 1 1 $BIN
############################################################
#
############################################################
###htformat $ARG binary ascii3 $FLWDIR $TMP
###cat $TMP | awk '{     if($3==1) print $1, $2, $1, $2+0.0833;                                   else if($3==3) print $1, $2, $1+0.0833, $2;                                   else if($3==5) print $1, $2, $1, $2-0.0833;                                   else if($3==7) print $1, $2, $1-0.0833, $2}' > $DES
############################################################
# Map Projection
############################################################
LONRANGE=`echo $LONMAX $LONMIN | awk '{printf("%d", $1 - $2)}'`
LATRANGE=`echo $LATMAX $LATMIN | awk '{printf("%d", $1 - $2)}'`
LONRANGE2=`echo $LONRANGE | awk '{printf("%d", $1 * 2)}'`
LATRANGE2=`echo $LATRANGE | awk '{printf("%d", $1 * 2)}'`
JFLAG="-JX${LONRANGE2}d/${LATRANGE2}d"
#
echo Lon-range: $LONRANGE Lat-range: $LATRANGE
#
if [ $LONRANGE -gt $LATRANGE ]; then
  FACTOR=`echo 21.6 $LONRANGE | awk '{print $1/$2}'`
else
  FACTOR=`echo 10.8 $LATRANGE | awk '{print $1/$2}'`
fi
#
echo Factor: $FACTOR
#
WMAP=`echo $LONRANGE | awk '{print $1*'${FACTOR}'}'`
HMAP=`echo $LATRANGE | awk '{print $1*'${FACTOR}'}'`
#
echo Width-map: $WMAP Height-map: $HMAP
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

BFLAG="-Ba${LONANO}f${LONFRM}::/a${LATANO}f${LATFRM}::neWS"
GRD=temp.grd
XYZ=temp.xyz
echo $RFLAG
echo $JFLAG
echo $BFLAG
######################################################################
# Draw map
######################################################################
htmaskrplc  $ARG $BIN    $CTYMSK eq 1 -1 $TMPBIN
htmaskrplc  $ARG $TMPBIN $CTYPRF eq 1 -2 $TMPBIN
htmaskrplc  $ARG $TMPBIN $CTYSWG eq 1 -3 $TMPBIN
htformat    $HFLAG $TMPBIN $XYZ
$PSBASEMAP   $RFLAG $JFLAG $BFLAG                            -K  > $EPS 
awk '{if($3!=1.0E20) print $1,$2,$3; else print $1,$2,"NaN"}' $XYZ | \
$XYZ2GRD     $RFLAG -G$GRD -I${GRIDSIZE}/${GRIDSIZE} -F
$GRDIMAGE -O $RFLAG $JFLAG $GRD -C$CPT                       -K >> $EPS 
######################################################################
# Put flow direction
######################################################################
RECMAX=`wc $DES | awk '{print $1}'`
REC=1
while [ $REC -le $RECMAX ]; do
  echo $REC / $RECMAX
  sed -n ''$REC'p' $DES | awk '{printf("%f %f\n%f %f",$1,$2,$3,$4)}'
  sed -n ''$REC'p' $DES | awk '{printf("%f %f\n%f %f",$1,$2,$3,$4)}' |\
  $PSXY  -O $RFLAG $JFLAG $BFLAG -W    -K >> $EPS
  REC=`expr $REC + 1`
done
######################################################################
# Put major stations
######################################################################
#cat $DAMLST |\
#$PSXY  -O $RFLAG $JFLAG $BFLAG -Sc0.2 -K >> $EPS
#cat $DAMLST | awk '{print $1,$2,"10","0.0","1","6",$3}' |\
#$PSTEXT  -O $RFLAG $JFLAG $BFLAG -N    -K >> $EPS
#cat ../DAT/HRL2013_met.txt |\
#$PSXY  -O $RFLAG $JFLAG $BFLAG -Sc0.2 -W1/0/0/0 -G255/255/255 -K >> $EPS
#cat ../DAT/HRL2013_riv.txt | awk '{print $1,$2}' |\
#$PSXY  -O $RFLAG $JFLAG $BFLAG -Ss0.3           -G0/0/0       -K >> $EPS
#cat ../DAT/HRL2013_riv.txt | awk '{print $1,$2-0.2,10,0,1,6,$3}' > $TMP
#cat $TMP
#cat $TMP |\
#$PSTEXT  -O $RFLAG $JFLAG $BFLAG -N    -K >> $EPS
######################################################################
# Put title
######################################################################
if [ "$TITLE1" != "" -a "$TITLE1" != "." ]; then
#  echo main title ${TITLE1}
  $PSTEXT -O $RFLAG $JFLAG -N                  -K   << EOF >> $EPS
  $LONTITLE1 $LATTITLE1 20 0.0 1 6 ${TITLE1}
EOF
fi
if [ "$TITLE2" != "" -a "$TITLE2" != "." ]; then
#  echo sub title ${TITLE2}
  $PSTEXT -O $RFLAG $JFLAG -N                   -K  << EOF >> $EPS
  $LONTITLE2 $LATTITLE2 20 0.0 1 6 ${TITLE2}		
EOF
fi
######################################################################
# Draw coastline
######################################################################

if [ "$OPT" = "" ]; then
  $PSCOAST -O $RFLAG $JFLAG -Dh -W1                           >> $EPS
elif [ "$OPT" = "graysea" ]; then
  $PSCOAST -O $RFLAG $JFLAG -Dh -W1            -S51/51/51     >> $EPS
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

htconv $EPS $PNG rothr

#/bin/rm -f .gmtcommands ${GRD} ${XYZ}
