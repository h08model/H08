#!/bin/sh
##################################################################
#to   prepare water demand for dams
#by   2010/08/23, hanasaki, NIES: H08ver1.0
##################################################################
# Edit here (settings)
##################################################################
PRJ=WFDE
#RUN=__C_
RUN=N_C_
SUF=.hlf
#
IDS="3667 5146 5140 710 712 705 702 1307 1320 411 884 338 451 307 753 597 310 297 870 148 396 355"
IDS=5140   # Reservoir ID (GRanD)
#
LDBG=26199
YEARMIN=1979
YEARMAX=1979
YEARDAM=2000
##################################################################
# Edit here (job)
##################################################################
JOBBIN=yes                   # create binary file
JOBPNT=yes                   # extract one point from the binary file
##################################################################
# Edit here (geography)
##################################################################
SUF=.hlf
L=259200
XY="720 360"
L2X=../../map/dat/l2x_l2y_/l2x${SUF}.txt
L2Y=../../map/dat/l2x_l2y_/l2y${SUF}.txt
LONMIN=-180
LONMAX=180
LATMIN=-90
LATMAX=90
##################################################################
# Prepare DamAgr
##################################################################
DEMAGR=../../lnd/out/DemAgr__/${PRJ}${RUN}${SUF}MO
htmean $L $DEMAGR $YEARMIN $YEARMAX 0000
##################################################################
# Edit here (in)
##################################################################
DEMIND=../../map/dat/wit_ind_/AQUASTAT20000000${SUF}FX
DEMDOM=../../map/dat/wit_dom_/AQUASTAT20000000${SUF}FX
DAMID_=../../map/dat/dam_id__/GRanD_L_${YEARDAM}0000${SUF}
DAMALC=../../map/out/dam_alc_/WFDELR__${SUF}ID
DEMAGR=../../lnd/out/DemAgr__/${PRJ}${RUN}${SUF}MO
##################################################################
# Edit here (out)
##################################################################
DIRDAMDEM=../../dam/dat/dam_dem_
DIROFFDEM=../../dam/dat/off_dem_
if [ !  -d $DIRDAMDEM ]; then
  mkdir -p $DIRDAMDEM
fi
if [ !  -d $DIROFFDEM ]; then
  mkdir -p $DIROFFDEM
fi
DAMDEM=${DIRDAMDEM}/${PRJ}${RUN}${SUF}MO

for ID in $IDS; do
ID4=`echo $ID | awk '{printf("%4.4d",$1)}'`
OFFDEM=${DIROFFDEM}/${PRJ}${RUN}0000${ID4}.txt
##################################################################
# Macro
##################################################################
TMP=temp${SUF}
##################################################################
# Job
##################################################################
YEARMIN=0000
YEARMAX=0000

if [ $JOBBIN = yes ]; then
  prog_damdem $L $LDBG $YEARMIN $YEARMAX $DAMID_ $DEMAGR $DEMIND $DEMDOM $DAMALC $DAMDEM
fi
##################################################################
# Job
##################################################################
if [ $JOBPNT = yes ]; then
  LPNT=`htmask $L $XY $L2X $L2Y $LONMIN $LONMAX $LATMIN $LATMAX \
            $DAMID_ $DAMID_ eq $ID $TMP long | head -1 | awk '{print $3}'`
  htpointts $L $XY $L2X $L2Y $LONMIN $LONMAX $LATMIN $LATMAX \
            l $DAMDEM $YEARMIN $YEARMAX $LPNT >  $OFFDEM
fi
done
