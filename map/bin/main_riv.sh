#!/bin/sh
############################################################
#to   generate maps for river model
#by   2010/03/31, hanasaki, NIES
############################################################
# Geography (Edit here if you change spatial domain/resolution)
############################################################
L=259200                                   # Array size
XY="720 360"                               # Lon/Lat division
LONLAT="-180 180 -90 90"                   # Geographical range
L2X=../../map/dat/l2x_l2y_/l2x.hlf.txt     # L2X
L2Y=../../map/dat/l2x_l2y_/l2y.hlf.txt     # L2Y
SUF=.hlf                                   # Suffix
MAP=.WFDEI                                 # Land/Sea mask
LDBG=26201                                 # Debugging point

# regional setting (.ko5)
#L=11088
#XY="84 132"
#LONLAT="124 131 33 44"
#L2X=../../map/dat/l2x_l2y_/l2x.ko5.txt
#L2Y=../../map/dat/l2x_l2y_/l2y.ko5.txt
#SUF=.ko5
#MAP=.SNU
#LDBG=5896

#1min x 1min for Kyusyu (.ks1)
#L=32400
#XY="180 180"
#LONLAT="129 132 31 34"
#L2X=../../map/dat/l2x_l2y_/l2x.ks1.txt
#L2Y=../../map/dat/l2x_l2y_/l2y.ks1.txt
#SUF=.ks1
#MAP=.kyusyu
#LDBG=5734

############################################################
# Input (Do not edit here basically)
############################################################
FLWDIR=../dat/flw_dir_/flwdir${MAP}${SUF}       # Flow direction file
LNDARA=../dat/lnd_ara_/lndara${MAP}${SUF}       # Grid area file
############################################################
# Output (Do not edit here basically)  
############################################################
DIRRIVNXL=../out/riv_nxl_
DIRRIVNXD=../out/riv_nxd_
DIRRIVSEQ=../out/riv_seq_
DIRRIVARA=../out/riv_ara_
DIRRIVNUM=../out/riv_num_
#
RIVNXL=$DIRRIVNXL/rivnxl${MAP}${SUF}          # River downstream l
RIVNXD=$DIRRIVNXD/rivnxd${MAP}${SUF}          # River downstream distance
RIVSEQ=$DIRRIVSEQ/rivseq${MAP}${SUF}          # River sequence file
RIVARA=$DIRRIVARA/rivara${MAP}${SUF}          # River area file
RIVNUM=$DIRRIVNUM/rivnum${MAP}${SUF}          # River id file
#RIVORD=../out/rivord${MAP}${SUF}             # River order file
#RIVJNC=../out/rivjnc${MAP}${SUF}             # River juction file
#RIVLEN=../out/rivlen${MAP}${SUF}             # River length file
#RIVCOL=../out/rivcol{MAP}${SUF}              # River color file
############################################################
# Job (Prepare output directory)
############################################################
if [ ! -d $DIRRIVNXL ]; then mkdir -p $DIRRIVNXL; fi
if [ ! -d $DIRRIVNXD ]; then mkdir -p $DIRRIVNXD; fi
if [ ! -d $DIRRIVSEQ ]; then mkdir -p $DIRRIVSEQ; fi
if [ ! -d $DIRRIVARA ]; then mkdir -p $DIRRIVARA; fi
if [ ! -d $DIRRIVNUM ]; then mkdir -p $DIRRIVNUM; fi
############################################################
# Job (prepare log file)
############################################################
DIRLOG=../log
if [ ! -d $DIRLOG    ]; then 
  mkdir $DIRLOG
fi
LOG=${DIRLOG}/riv${MAP}${SUF}.log
if [ -f $LOG ]; then
  rm $LOG
fi
############################################################
# Job (generate files)
############################################################
echo ====== INPUT  ======                                    >> $LOG
echo $MAP                                                    >> $LOG
echo $SUF                                                    >> $LOG
echo $FLWDIR                                                 >> $LOG
echo ======= OUTPUT ======                                   >> $LOG
calc_rivnxl $L $XY $L2X $L2Y $LONLAT $FLWDIR $RIVNXL $RIVNXD >> $LOG 2>&1 
calc_rivseq $L $XY $L2X $L2Y $FLWDIR $RIVSEQ                 >> $LOG 2>&1 
calc_rivara $L $LNDARA $RIVSEQ $RIVNXL $RIVARA               >> $LOG 2>&1 
calc_rivnum $L $XY $L2X $L2Y $LONLAT $FLWDIR $RIVNXL $RIVNUM $LDBG >> $LOG 2>&1
