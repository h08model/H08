#!/bin/sh
############################################################
#to  prepare
#
############################################################
# settings
############################################################
MAP=.WFDEI
############################################################
# in
############################################################
   AAI=../../map/dat/aai_____/GMIA5___20050000.hlf # area actually irrig
   AEI=../../map/dat/aei_____/GMIA5___20050000.hlf # area equipped for irrig
  AEIS=../../map/dat/aeis____/GMIA5___20050000.hlf # area irrigated with sw
  AEIG=../../map/dat/aeig____/GMIA5___20050000.hlf # area irrigated with gw
#
LNDMSK=../../map/dat/lnd_msk_/lndmsk${MAP}.hlf
############################################################
# out
############################################################
DIRAAIS=../../map/dat/aais____    # area actually irrig with sw
DIRAAIG=../../map/dat/aaig____    # area actually irrig with gw 
DIRFRCAEIG=../../map/dat/aeigfrc_ # area equipped for irrigation fraction gw
 DIRFRCAAI=../../map/dat/aai_frc_ # area equipped for irrigation fraction
#
   AAIS=${DIRAAIS}/GMIA5___20050000.hlf
   AAIG=${DIRAAIG}/GMIA5___20050000.hlf
 FRCAAI=${DIRFRCAAI}/GMIA5___20050000.hlf 
FRCAEIG=${DIRFRCAEIG}/GMIA5___20050000.hlf 
 FIGFRCAAI=${DIRFRCAAI}/GMIA5___20050000.png
FIGFRCAEIG=${DIRFRCAEIG}/GMIA5___20050000.png
#
AAIM=../../map/dat/aai_____/GMIA5___20050000${MAP}.hlf # masked
AEIM=../../map/dat/aei_____/GMIA5___20050000${MAP}.hlf # masked
FRCAEIGM=${DIRFRCAEIG}/GMIA5___20050000${MAP}.hlf      # masked
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
htmath $LHLF div $AEIG $AEI $FRCAEIG
htmaskrplc $ARGHLF $FRCAEIG $FRCAEIG eq 1.0E20 0 $FRCAEIG > $LOG
htmath $LHLF div $AAI  $AEI $FRCAAI
htmath $LHLF mul $AEIG $FRCAAI $AAIG
htmath $LHLF mul $AEIS $FRCAAI $AAIS
#
htmaskrplc $ARGHLF $FRCAEIG $LNDMSK eq 0 0 $FRCAEIGM >> $LOG
htmaskrplc $ARGHLF $AEI     $LNDMSK eq 0 0 $AEIM     >> $LOG
htmaskrplc $ARGHLF $AAI     $LNDMSK eq 0 0 $AAIM     >> $LOG
############################################################
# draw
############################################################
gmt makecpt -T0/1/0.1 -Z > $CPT
htdraw $ARGHLF $FRCAEIG $CPT $EPS
htconv $EPS    $FIGFRCAEIG rot
echo Fig: $FIGFRCAEIG                                >> $LOG
htdraw $ARGHLF $FRCAAI $CPT $EPS
htconv $EPS    $FIGFRCAAI rot
echo Fig: $FIGFRCAAI                                 >> $LOG
echo Log: $LOG                                       >> $LOG

