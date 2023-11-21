#!/bin/sh
############################################################
#to   prepare temporary crop files for regional simulation
#by   2011/10/06 hanasaki, NIES
############################################################
# Prepareation
############################################################
# 
# This shell script uses global 5min crop area,
# crop-wise harvested area, and irrigated area data.
# Please make sure prep_crp_R08M08S08.sh is already finished.
#
############################################################
# Setting (Edit here)
############################################################
V_CRPINT=1.5    # cropping intensity (uniform value for whole domain)
V_IRGEFF=0.35    # irrigation efficiency (uniform value for whole domain)
############################################################
# Geography (Edit here if you change spatial domain/resolution)
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
# In (Do not edit here unless you are an expert)
############################################################
IRGARAGL5=../../map/dat/irg_ara_/S05_____20000000.gl5
CRPARAGL5=../../map/dat/crp_ara_/R08_____20000000.gl5
   GRDGL5=../../map/dat/grd_ara_/grdara.gl5
   LNDMSK=../../map/dat/lnd_msk_/lndmsk${MAP}${SUF}
   GRDARA=../../map/dat/grd_ara_/grdara${SUF}
############################################################
# Out (Do not edit here unless you are an expert)
############################################################
DIRCRPINT=../../map/dat/crp_int_
DIRIRGEFF=../../map/dat/irg_eff_
DIRIRGARA=../../map/dat/irg_ara_
DIRCRPARA=../../map/dat/crp_ara_
#
CRPINT=${DIRCRPINT}/DS02____00000000${SUF}
IRGEFF=${DIRIRGEFF}/DS02____00000000${SUF}
IRGARA=${DIRIRGARA}/S05_____20000000${SUF}
CRPARA=${DIRCRPARA}/R08_____20000000${SUF}
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
TMPGL5=temp.gl5
TMPKS1=temp${SUF}
#
#TYPS="bar cas cot grn mai mil oil oth pot pul rap ric rye sor soy sub suc sun whe"
#
#XOFFSET=`echo $LONLAT | awk '{print ($1+180)*12+1}'`
#YOFFSET=`echo $LONLAT | awk '{print (90-$4)*12+1}'`
############################################################
# Job (Prepare directory)
############################################################
if [ ! -d $DIRCRPINT ]; then mkdir -p $DIRCRPINT; fi
if [ ! -d $DIRIRGEFF ]; then mkdir -p $DIRIRGEFF; fi
if [ ! -d $DIRIRGARA ]; then mkdir -p $DIRIRGARA; fi
if [ ! -d $DIRCRPARA ]; then mkdir -p $DIRCRPARA; fi
############################################################
# Job (Cropping intensity)
############################################################
htcreate $L $V_CRPINT $CRPINT 
htmask $ARG $CRPINT $LNDMSK eq 1 $CRPINT
############################################################
# Job (Irrigation efficiency)
############################################################
htcreate $L $V_IRGEFF $IRGEFF 
htmask $ARG $IRGEFF $LNDMSK eq 1 $IRGEFF
############################################################
# Job (Irrigated area)
############################################################
#htextract $ARGGL5 $ARG $IRGARAGL5 $IRGARA $XOFFSET $YOFFSET
htmath $LGL5 div $IRGARAGL5 $GRDGL5 $TMPGL5
htlinear $ARGGL5 $ARG $TMPGL5 $TMPKS1
htmath $L mul $TMPKS1 $GRDARA $IRGARA
htmask $ARG $IRGARA $LNDMSK eq 1 $IRGARA
############################################################
# Job (Cropping area)
############################################################
#htextract $ARGGL5 $ARG $CRPARAGL5 $CRPARA $XOFFSET $YOFFSET
htmath $LGL5 div $CRPARAGL5 $GRDGL5 $TMPGL5
htlinear $ARGGL5 $ARG $TMPGL5 $TMPKS1
htmath $L mul $TMPKS1 $GRDARA $CRPARA
htmask $ARG $CRPARA $LNDMSK eq 1 $CRPARA
############################################################
# Job (Harvest area)
############################################################
#for TYP in $TYPS; do
#  HVSARAGL5=../../map/dat/hvs_ara_/M08_${TYP}_20000000.gl5
#  HVSARA=../../map/dat/hvs_ara_/M08_${TYP}_20000000${SUF}
#  htextract $ARGGL5 $ARG $HVSARAGL5 $HVSARA $XOFFSET $YOFFSET
#  htmask $ARG $HVSARA $LNDMSK eq 1 $HVSARA
#done
