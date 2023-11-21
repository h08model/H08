#/bin/sh
############################################################
#to   prepare coast line map
#by   2014/04/25, hanasaki
############################################################
# Prameters (critically sensitive to the results)
############################################################
DISTANCE=3
ELVMAX=9999
############################################################
# geography
############################################################
L=11088
XY="84 132"
L2X=../../map/dat/l2x_l2y_/l2x.ko5.txt
L2Y=../../map/dat/l2x_l2y_/l2y.ko5.txt
LONLAT="124 131 33 44"
ARG="$L $XY $L2X $L2Y $LONLAT"
MAP=.SNU
SUF=.ko5

L2XHLF=../../map/dat/l2x_l2y_/l2x.hlf.txt
L2YHLF=../../map/dat/l2x_l2y_/l2y.hlf.txt
SUFHLF=.hlf
#
#MAP=.C05.nolake
MAPHLF=.WFDEI
############################################################
# in
############################################################
LNDMSK=../../map/dat/lnd_msk_/lndmsk${MAP}${SUF}
NATMSK=../../map/dat/nat_msk_/C05_____20000000${SUF}
ELVMIN=../../map/dat/elv_min_/ETOPO1__00000000${SUF}
#
NATWATORG=../../map/org/MISC_Maps/natwat.txt
############################################################
# out
############################################################
DIRNATWAT=../../map/dat/nat_wat_
NATWAT=${DIRNATWAT}/natwat.hlf
NATWAT2=${DIRNATWAT}/natwat${SUF}
#
DIRCSTLIN=../../map/dat/cst_lin_
BINCSTLIN=${DIRCSTLIN}/cstlin${MAP}${SUF}
BINCSTLIN2=${DIRCSTLIN}/cstlin${MAP}${SUF}
FIGCSTLIN=${DIRCSTLIN}/cstlin${MAP}.png
############################################################
# macro
############################################################
CPT=temp.cpt
EPS=temp.eps

############################################################
# job (map)
############################################################
if [ ! -d $DIRNATWAT ]; then
  mkdir -p $DIRNATWAT
fi
#
htformat $ARGHLF asciiu binary $NATWATORG $NATWAT
htlinear $ARGHLF $ARG $NATWAT $NATWAT2
#
if [ ! -d $DIRCSTLIN ]; then
  mkdir -p $DIRCSTLIN
fi
#
prog_map_cstlin $L2X $L2Y $LNDMSK $NATMSK $NATWAT2 $BINCSTLIN $DISTANCE $ELVMIN $ELVMAX
############################################################
# job (draw)
############################################################
makecpt -T-0.5/1.5/1 > temp.cpt
#htlinear $ARGHLF $ARG $BINCSTLIN $BINCSTLIN2 
htdraw $ARG $BINCSTLIN temp.cpt $EPS
htconv $EPS $FIGCSTLIN rot
echo   $FIGCSTLIN
