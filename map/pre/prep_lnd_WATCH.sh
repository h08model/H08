#!/bin/sh
############################################################
#to   prepare WATCH geographical data
#by   2010/03/31, hanasaki, NIES: H08ver1.0
#
# Source:
#
# Haddeland, I., Douglas B. Clark, Wietse Franssen, Fulco Ludwig, 
# Frank Voss, Nigel W. Arnell, Nathalie Bertrand, Martin Best, 
# Sonja Folwell, Dieter Gerten, Sandra Gomes, Simon N. Gosling, 
# Stefan Hagemann, Naota Hanasaki, Richard Harding, Jens Heinke, 
# Pavel Kabat , Sujan Koirala, Taikan Oki, Jan Polcher, Tobias Stacke, 
# Pedro Viterbo, Graham P. Weedon, and Pat Yeh: 
# Multi-Model Estimate of the Global Terrestrial Water Balance: 
# Setup and First Results, Journal of Hydrometeorology,12,869-884,
# doi:10.1175/2011JHM1324.1
#
############################################################
# Geography (Do not edit here: 0.5 deg global only)
############################################################
L=259200
XY="720 360"
L2X=../../map/dat/l2x_l2y_/l2x.hlf.txt
L2Y=../../map/dat/l2x_l2y_/l2y.hlf.txt
LONLAT="-180 180 -90 90"
############################################################
# Input (Do not edit here unless you are an expert)
############################################################
GRDARA=../../map/dat/grd_ara_/grdara.hlf
TAIRTXT=../../map/org/WATCH/Tair____WFD_____20000000.hlf.txt
############################################################
# Output (Do not edit here unless you are an expert)
############################################################
DIRLNDMSK=../../map/dat/lnd_msk_
DIRLNDARA=../../map/dat/lnd_ara_
LOG=temp.log
#
LNDMSK=${DIRLNDMSK}/lndmsk.WATCH.hlf
LNDARA=${DIRLNDARA}/lndara.WATCH.hlf
############################################################
# Job (prepare directory)
############################################################
if [ !  -d ${DIRLNDMSK} ]; then  mkdir -p ${DIRLNDMSK}; fi
if [ !  -d ${DIRLNDARA} ]; then  mkdir -p ${DIRLNDARA}; fi
############################################################
# Job (create files)
############################################################
if [ -f $LOG ]; then
  /bin/rm $LOG
fi
#
htformat $L $XY $L2X $L2Y $LONLAT asciiu binary $TAIRTXT temp.hlf
htmaskrplc   $L $XY $L2X $L2Y $LONLAT temp.hlf temp.hlf gt 0 1 $LNDMSK > $LOG
htmaskrplc   $L $XY $L2X $L2Y $LONLAT $GRDARA  $LNDMSK eq 0 1.0E20 $LNDARA >> $LOG
echo Log: $LOG