#!/bin/sh
############################################################
#to list up water water withdrawal (ind+dom) and natural river discharge
#
############################################################
# Settings
############################################################
# Toy model (the Ara River only)
DEMIND=../../map/dat/dem_ind_/AQUASTAT20000000.ara.tk5
DEMDOM=../../map/dat/dem_dom_/AQUASTAT20000000.ara.tk5
RIVOUT=../../riv/out/riv_out_/W5E5LR__20190000.tk5
LS="808"
# Full model
DEMIND=../../map/dat/dem_ind_/AQUASTAT20000000.full.tk5
DEMDOM=../../map/dat/dem_dom_/AQUASTAT20000000.full.tk5
RIVOUT=../../riv/out/riv_out_/W5E5LR__20190000.tk5
LS="661 808 951 1023"
# Full model 2
DEMIND=../../map/dat/dem_ind_/AQUASTAT20000000.full2.tk5
DEMDOM=../../map/dat/dem_dom_/AQUASTAT20000000.full2.tk5
RIVOUT=../../riv/out/riv_out_/W5E5LR__20190000.tk5
LS="772 919 1026 1023"
############################################################
# Job
############################################################
echo L  Ind+Dom Dis
for L in $LS; do

  VIND=`pointtk5 l $DEMIND  $L | awk '{print $1/0.1/1000}'`
#pointtk5 l $DEMIND  808 | awk '{print $1/0.1/1000}'
#pointtk5 l $DEMIND  951 | awk '{print $1/0.1/1000}'
#pointtk5 l $DEMIND 1023 | awk '{print $1/0.1/1000}'

  VDOM=`pointtk5 l $DEMDOM  $L | awk '{print $1/0.15/1000}'`
#pointtk5 l $DEMDOM  808 | awk '{print $1/0.15/1000}'
#pointtk5 l $DEMDOM  951 | awk '{print $1/0.15/1000}'
#pointtk5 l $DEMDOM 1023 | awk '{print $1/0.15/1000}'

  VRIV=`pointtk5 l $RIVOUT  $L | awk '{print $1/1000}'`
#pointtk5 l $RIVOUT  808 | awk '{print $1/1000}'
#pointtk5 l $RIVOUT  951 | awk '{print $1/1000}'
#pointtk5 l $RIVOUT 1023 | awk '{print $1/1000}'

  echo $L $VIND $VDOM $VRIV | awk '{print $1, $2+$3, $4}'

done
