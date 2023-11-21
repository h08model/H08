#!/bin/sh
############################################################
#to   prepare temporary crop files for regional simulation
#by   2011/10/06 hanasaki, NIES
############################################################
# Preparation
############################################################
# 
# This shell script uses global 5min crop area,
# crop-wise harvested area, and irrigated area data.
# Please make sure prep_map_AQUASTAT.sh is already finished.
#
############################################################
# Geography (Edit here if you change spatial domain/resolution)
############################################################
L=11088
XY="84 132"
L2X=../../map/dat/l2x_l2y_/l2x.ko5.txt
L2Y=../../map/dat/l2x_l2y_/l2y.ko5.txt
LONLAT="124 131 33 44"
ARG="$L $XY $L2X $L2Y $LONLAT"
SUF=.ko5
MAP=.SNU
############################################################
# Parameter (Edit here if you change settings)
############################################################
FCTIND=0.10   # consumption/withdrawal ratio for industrial water
FCTDOM=0.15   # consumption/withdrawal ratio for domestic water
############################################################
# In (Do not edit here unless you are an expert)
############################################################
LNDMSK=../../map/dat/lnd_msk_/lndmsk${MAP}${SUF}
#
POPTOTGL5=../../map/dat/pop_tot_/C05_a___20000000.gl5
NATMSKGL5=../../map/dat/nat_msk_/C05_____20000000.gl5
WITAGRGL5=../../map/dat/wit_agr_/AQUASTAT20000000.gl5
WITINDGL5=../../map/dat/wit_ind_/AQUASTAT20000000.gl5
WITDOMGL5=../../map/dat/wit_dom_/AQUASTAT20000000.gl5
############################################################
# Out (Do not edit here unless you are an expert)
############################################################
DIRPOPTOT=../../map/dat/pop_tot_
DIRNATMSK=../../map/dat/nat_msk_
DIRWITAGR=../../map/dat/wit_agr_
DIRWITIND=../../map/dat/wit_ind_
DIRWITDOM=../../map/dat/wit_dom_
DIRDEMIND=../../map/dat/dem_ind_
DIRDEMDOM=../../map/dat/dem_dom_
#
POPTOT=${DIRPOPTOT}/C05_a___20000000${SUF}
NATMSK=${DIRNATMSK}/C05_____20000000${SUF}
WITAGR=${DIRWITAGR}/AQUASTAT20000000${SUF}
WITIND=${DIRWITIND}/AQUASTAT20000000${SUF}
WITDOM=${DIRWITDOM}/AQUASTAT20000000${SUF}
DEMIND=${DIRDEMIND}/AQUASTAT20000000${SUF}
DEMDOM=${DIRDEMDOM}/AQUASTAT20000000${SUF}
############################################################
# Macro 
############################################################
LGL5=9331200
XYGL5="4320 2160"
L2XGL5=${DIRH08}/map/dat/l2x_l2y_/l2x.gl5.txt
L2YGL5=${DIRH08}/map/dat/l2x_l2y_/l2y.gl5.txt
LONLATGL5="-180 180 -90 90"
ARGGL5="$LGL5 $XYGL5 $L2XGL5 $L2YGL5 $LONLATGL5" 
#
XOFFSET=`echo $LONLAT | awk '{print ($1+180)*12+1}'`
YOFFSET=`echo $LONLAT | awk '{print (90-$4)*12+1}'`
############################################################
# Job (Prepare directory)
############################################################
if [ ! -d $DIRPOPTOT ]; then mkdir -p $DIRPOPTOT; fi
if [ ! -d $DIRWITAGR ]; then mkdir -p $DIRWITAGR; fi
if [ ! -d $DIRWITIND ]; then mkdir -p $DIRWITIND; fi
if [ ! -d $DIRWITDOM ]; then mkdir -p $DIRWITDOM; fi
if [ ! -d $DIRDEMIND ]; then mkdir -p $DIRDEMIND; fi
if [ ! -d $DIRDEMDOM ]; then mkdir -p $DIRDEMDOM; fi
############################################################
# Job (Population)
############################################################
htextract $ARGGL5 $ARG $POPTOTGL5 $POPTOT $XOFFSET $YOFFSET
htmask $ARG $POPTOT $LNDMSK eq 1 $POPTOT
############################################################
# Job (Boundary
############################################################
htextract $ARGGL5 $ARG $NATMSKGL5 $NATMSK $XOFFSET $YOFFSET
htmask $ARG $NATMSK $LNDMSK eq 1 $NATMSK
############################################################
# Job (Agricultural)
############################################################
if [ ! -f $WITAGRGL5 ]; then
  echo $WITAGRGL5 not exist.
  echo execute prep_map_AQUASTAT.sh first
else
  htextract $ARGGL5 $ARG $WITAGRGL5 $WITAGR $XOFFSET $YOFFSET
  htmask $ARG $WITAGR $LNDMSK eq 1 $WITAGR
fi
############################################################
# Job (Industrial)
############################################################
if [ ! -f $WITINDGL5 ]; then
  echo $WITINDGL5 not exist.
  echo execute prep_map_AQUASTAT.sh first
else
  htextract $ARGGL5 $ARG $WITINDGL5 $WITIND $XOFFSET $YOFFSET
  htmask $ARG $WITIND $LNDMSK eq 1 $WITIND
  htmath $L mul  $WITIND $FCTIND $DEMIND
fi
############################################################
# Job (Domestic)
############################################################
if [ ! -f $WITDOMGL5 ]; then
  echo $WITDOMGL5 not exist.
  echo execute prep_map_AQUASTAT.sh first
else
  htextract $ARGGL5 $ARG $WITDOMGL5 $WITDOM $XOFFSET $YOFFSET
  htmask $ARG $WITDOM $LNDMSK eq 1 $WITDOM
  htmath $L mul $WITDOM $FCTDOM $DEMDOM
fi