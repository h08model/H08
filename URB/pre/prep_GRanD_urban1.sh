#!/bin/sh
############################################################
#to   make GRanD_tk5_noedit
#
#
#
############################################################
# Methods
#
# Job 1: Show the dams in the domain
#
# Mannually list up the dams to inclue, and set $NAMES
#
# Job 2: Extract the data from GRanD and 
#
############################################################
#
# Setting
#
LONMIN=138; LONMAX=141; LATMIN=34; LATMAX=38; SUF=.tk5
LONMIN=-3; LONMAX=1; LATMIN=50; LATMAX=53; SUF=.ln5
#
# In
#
LSTFULL=../../map/org/GRanD/GRanD_M.txt  # original
#
# Out
#
LSTOUT=../org/GRanD/GRanD${SUF}.raw.txt  # Extracted the reservoirs in $NAMES
############################################################
#
############################################################
NAMES="Yagisawa  Naramata      Fujiwara  Aimata 
       Sonohara  Shimokubo     Kusaki    Wataraseyusuichi
       Arakawa   Futase
       Ogohchi   Murayamakami  Murayamashimo
       Sagami    Shiroyama     Miyagase"
NAMES=
# Urayama and Takizawa were missing in GRanD
# Miho Doshi Ishigoya were missing but can be neglected
# Because, these are out of basin, too small, and sub-dam, respectively.
############################################################
# Job 1 Dams in the area
############################################################
awk '($1>'$LONMIN'&&$1<'$LONMAX'&&$2>'$LATMIN'&&$2<'$LATMAX'){print}' $LSTFULL
############################################################
# Job 2 Extract data
############################################################
#
# initialize
#
if [ -f $LSTOUT ]; then
  rm $LSTOUT
fi

for NAME in $NAMES; do
  awk '($5=="'$NAME'"){print}' $LSTFULL >> $LSTOUT
done

