#!/bin/sh
############################################################
#
#
#
#
############################################################
# In/Out
#
# - How to edit GRanD_tk5_noedit
# - Replace lon/lat with the observed
# - Remove
#
############################################################
#
# Setting
#
LONMIN=138; LONMAX=141; LATMIN=34; LATMAX=38; SUF=.tk5; ARG=$ARGTK5
LONMIN=-3;  LONMAX=1;   LATMIN=50; LATMAX=53; SUF=.ln5; ARG=$ARGLN5
#
# In
#
LSTEDITED=../org/GRanD/GRanD${SUF}.txt      # Edited file of $LSTOUT
RIVARA=../../map/out/riv_ara_/rivara.CAMA${SUF}
#
# Reservoirs to include
#
NAMES2="Yagisawa  Naramata      Fujiwara  Aimata 
        Sonohara  Shimokubo     Kusaki    Wataraseyusuichi
        Arakawa   Futase
        Ogohchi   Murayama
        Sagami    Shiroyama     Miyagase"
# Urayama and Takizawa were missing in GRanD
# Miho Doshi Ishigoya were missing but can be neglected
# Because, these are out of basin, too small, and sub-dam, respectively.
############################################################
# Job 2 Compare simulated and observed catchment area
############################################################
echo 
echo Name-Lon-Lat-AreaSim-AreaObs
echo 
for NAME in $NAMES2; do
  if [ -f $LSTEDITED ]; then
    LONLATCAT="`awk '($5=="'$NAME'"){print $1, $2, $11}' $LSTEDITED`"
    LONLAT="`echo $LONLATCAT | awk '{print $1,$2}'`"
    CATOBS="`echo $LONLATCAT | awk '{print $3}'`"
    CATSIM=`htpoint $ARG lonlat $RIVARA $LONLAT | awk '{print $1/1000/1000}'`
    echo $NAME $LONLAT $CATSIM $CATOBS
  fi
done
