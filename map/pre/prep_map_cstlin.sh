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
ARG=$ARGHLF
SUF=.hlf
L2X=../../map/dat/l2x_l2y_/l2x.hlf.txt
L2Y=../../map/dat/l2x_l2y_/l2y.hlf.txt
#
#MAP=.C05.nolake
MAP=.WFDEI
############################################################
# in
############################################################
LNDMSK=../../map/dat/lnd_msk_/lndmsk${MAP}${SUF}
NATMSK=../../map/dat/nat_msk_/C05_____20000000.hlf
ELVMIN=../../map/dat/elv_min_/ETOPO1__00000000.hlf
#
NATWATORG=../../map/org/MISC_Maps/natwat.txt
############################################################
# out
############################################################
DIRNATWAT=../../map/dat/nat_wat_
NATWAT=${DIRNATWAT}/natwat.hlf
#
DIRCSTLIN=../../map/dat/cst_lin_
BINCSTLIN=${DIRCSTLIN}/cstlin${MAP}${SUF}
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
htformat $ARG asciiu binary $NATWATORG $NATWAT
#
if [ ! -d $DIRCSTLIN ]; then
  mkdir -p $DIRCSTLIN
fi
#
prog_map_cstlin $L2X $L2Y $LNDMSK $NATMSK $NATWAT $BINCSTLIN $DISTANCE $ELVMIN $ELVMAX
############################################################
# job (draw)
############################################################
makecpt -T-0.5/1.5/1 > temp.cpt
htdraw $ARGHLF $BINCSTLIN temp.cpt $EPS
htconv $EPS $FIGCSTLIN rot
