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
# Geographical settings (Edit here if you change spatial domain/resolution)
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
LNDMSK=../../map/dat/lnd_msk_/lndmsk.WATCH.hlf
#
FLWDIRORG1=../../map/org/WATCH/ddm30_flowdir_modelint_2008.asc
FLWDIRORG2=../../map/org/WATCH/ddm30_flowdir_cru_neva.asc
############################################################
# Output (Do not change here unless you are an expert)
############################################################
DIRFLWDIR=../../map/dat/flw_dir_
#
FLWDIR1=${DIRFLWDIR}/flwdir.DDM30.hlf
FLWDIR2=${DIRFLWDIR}/flwdir.WATCH.hlf
############################################################
# Job (prepare directory)
############################################################
if [ !  -d ${DIRFLWDIR} ]; then    mkdir -p ${DIRFLWDIR};   fi
############################################################
# Job (generate files)
############################################################
LOG=temp.log
if [ -f $LOG ]; then
  /bin/rm $LOG
fi

sed -e '1,6d' $FLWDIRORG1 > temp.txt
prog_riv_WATCH temp.txt $FLWDIR1 > $LOG
#
sed -e '1,6d' $FLWDIRORG2 > temp.txt
prog_riv_WATCH temp.txt $FLWDIR2 >> $LOG
echo Log: $LOG