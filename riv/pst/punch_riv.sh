#!/bin/sh
############################################################
#to   line up H08 discharge value
#by   2017/05/19, fujiwara, NIES: 
############################################################
PRJ=AK10
RUN=LRDp
RGN=KYSY
VER=v2__
YEARMIN=2001
YEARMAX=2005
TRESO=DY  # DY or MO
############################################################
# Geographical Setting
############################################################
L=32400
XY="180 180"
L2X=../../map/dat/l2x_l2y_/l2x.ks1.txt
L2Y=../../map/dat/l2x_l2y_/l2y.ks1.txt
LONLAT="129 132 31 34"
ARG="$L $XY $L2X $L2Y $LONLAT"
SUF=.ks1
MAP=.kyusyu
############################################################
# river IDs (check river number)
############################################################
IDS="01 02 03 04 05 06 07 08 10" # kyusyu
############################################################
# Map
############################################################
STNLST=../../JSCE/dat/stn_lst_/stnlst${MAP}_v2.txt
############################################################
# 
############################################################
RIVOUTD=../../JSCE/out/riv_out_/${PRJ}${RUN}${SUF}DY
RIVOUTM=../../JSCE/out/riv_out_/${PRJ}${RUN}${SUF}MO
############################################################
# Directory and file of input/output (Edit here)
############################################################
DIROUTD=../../JSCE/out/punch__D
DIRCATD=../../JSCE/out/catts__D
DIROBSD=../../JSCE/dat/riv_disD
DIRNSED=../../JSCE/out/nse____D
NSELSTD=$DIRNSED/${PRJ}${RUN}00000000.txt
DIROUTM=../../JSCE/out/punch__M
DIRCATM=../../JSCE/out/catts__M
DIROBSM=../../JSCE/dat/riv_disM
DIRNSEM=../../JSCE/out/nse____M
NSELSTM=$DIRNSEM/${PRJ}${RUN}00000000.txt
############################################################
# Jobs
############################################################
if [ $TRESO = "DY" ]; then
  DIROUT=$DIROUTD
  DIRCAT=$DIRCATD
  DIROBS=$DIROBSD
  DIRNSE=$DIRNSED
  NSELST=$NSELSTD
  RIVOUT=$RIVOUTD
elif [ $TRESO = "MO" ]; then
  DIROUT=$DIROUTM
  DIRCAT=$DIRCATM
  DIROBS=$DIROBSM
  DIRNSE=$DIRNSEM
  NSELST=$NSELSTM
  RIVOUT=$RIVOUTM
fi
if [ ! -e $DIROUT ]; then  mkdir $DIROUT; fi
if [ ! -e $DIRCAT ]; then  mkdir $DIRCAT; fi
if [ ! -e $DIRNSE ]; then  mkdir $DIRNSE; fi
if [ -f $NSELST ]; then  rm $NSELST; fi

  

for ID in $IDS; do
  H08TXT=$DIROUT/${PRJ}${RUN}000000${ID}.txt
  CATTXT=$DIRCAT/${PRJ}${RUN}000000${ID}.txt
  OBSTXT=$DIROBS/${RGN}${VER}000000${ID}.txt
  LON=`awk -v "id=$ID" '($1==id){print $4}' $STNLST`
  LAT=`awk -v "id=$ID" '($1==id){print $5}' $STNLST`
  htpointts $ARG lonlat $RIVOUT $YEARMIN $YEARMAX $LON $LAT | \
      awk '{print $1,$2,$3,$4/1000}' > $H08TXT
  MLITID=`awk -v "id=$ID" '($1==id){print $10}' $STNLST`
  htcatts ${H08TXT}${TRESO} ${OBSTXT}${TRESO} > $CATTXT
#
### NSE ###
  NSE=`htmettxt nse ${H08TXT}${TRESO} ${OBSTXT}${TRESO} $YEARMIN $YEARMAX | \
      awk '{print $1*1,$2}'`

  echo $ID $NSE >> $NSELST
done