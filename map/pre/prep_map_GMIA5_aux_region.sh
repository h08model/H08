#!/bin/sh
############################################################
#to  prepare
#
############################################################
# settings
############################################################
L=11088
XY="84 132"
L2X=../../map/dat/l2x_l2y_/l2x.ko5.txt
L2Y=../../map/dat/l2x_l2y_/l2y.ko5.txt
LONLAT="124 131 33 44"
ARG="$L $XY $L2X $L2Y $LONLAT"
MAP=.SNU
SUF=.ko5

#1min x 1min for Kyusyu (.ks1)
#L=32400
#XY="180 180"
#L2X=../../map/dat/l2x_l2y_/l2x.ks1.txt
#L2Y=../../map/dat/l2x_l2y_/l2y.ks1.txt
#LONLAT="129 132 31 34"
#ARG="$L $XY $L2X $L2Y $LONLAT"
#MAP=.kyusyu
#SUF=.ks1

############################################################
# in
############################################################
   AAI=../../map/dat/aai_____/GMIA5___20050000${SUF} # area actually irrig
   AEI=../../map/dat/aei_____/GMIA5___20050000${SUF} # area equipped for irrig
  AEIS=../../map/dat/aeis____/GMIA5___20050000${SUF} # area irrigated with sw
  AEIG=../../map/dat/aeig____/GMIA5___20050000${SUF} # area irrigated with gw
#
LNDMSK=../../map/dat/lnd_msk_/lndmsk${MAP}${SUF}
############################################################
# out
############################################################
DIRAAIS=../../map/dat/aais____    # area actually irrig with sw
DIRAAIG=../../map/dat/aaig____    # area actually irrig with gw 
DIRFRCAEIG=../../map/dat/aeigfrc_ # area equipped for irrigation fraction gw
 DIRFRCAAI=../../map/dat/aai_frc_ # area equipped for irrigation fraction
#
   AAIS=${DIRAAIS}/GMIA5___20050000${SUF}
   AAIG=${DIRAAIG}/GMIA5___20050000${SUF}
 FRCAAI=${DIRFRCAAI}/GMIA5___20050000${SUF} 
FRCAEIG=${DIRFRCAEIG}/GMIA5___20050000${SUF} 
 FIGFRCAAI=${DIRFRCAAI}/GMIA5___20050000.png
FIGFRCAEIG=${DIRFRCAEIG}/GMIA5___20050000.png
#
AAIM=../../map/dat/aai_____/GMIA5___20050000${MAP}${SUF} # masked
AEIM=../../map/dat/aei_____/GMIA5___20050000${MAP}${SUF} # masked
FRCAEIGM=${DIRFRCAEIG}/GMIA5___20050000${MAP}${SUF}      # masked
#
LOG=temp.log
############################################################
# macro
############################################################
CPT=temp.cpt
EPS=temp.eps

############################################################
# job
############################################################
if [ !  -f $DIRFRCAEIG ]; then
  mkdir -p $DIRFRCAEIG
fi
if [ !  -f $DIRFRCAAI ]; then
  mkdir -p $DIRFRCAAI
fi
if [ !  -f $DIRAAIG ]; then
  mkdir -p $DIRAAIG
fi
if [ !  -f $DIRAAIS ]; then
  mkdir -p $DIRAAIS
fi
#
htmath $L div $AEIG $AEI $FRCAEIG
htmaskrplc $ARG $FRCAEIG $FRCAEIG eq 1.0E20 0 $FRCAEIG > $LOG
htmath $L div $AAI  $AEI $FRCAAI
htmath $L mul $AEIG $FRCAAI $AAIG
htmath $L mul $AEIS $FRCAAI $AAIS
#
htmaskrplc $ARG $FRCAEIG $LNDMSK eq 0 0 $FRCAEIGM >> $LOG
htmaskrplc $ARG $AEI     $LNDMSK eq 0 0 $AEIM     >> $LOG
htmaskrplc $ARG $AAI     $LNDMSK eq 0 0 $AAIM     >> $LOG
############################################################
# draw
############################################################
gmt makecpt -T0/1/0.1 -Z > $CPT
htdraw $ARG $FRCAEIG $CPT $EPS
htconv $EPS    $FIGFRCAEIG rot
echo Fig: $FIGFRCAEIG
htdraw $ARG $FRCAAI $CPT $EPS
htconv $EPS    $FIGFRCAAI rot
echo Fig: $FIGFRCAAI
echo Log: $LOG

