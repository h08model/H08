#!/bin/sh
############################################################
#to   generate dam map
#by   2010/07/21, hanasaki
############################################################
# Basic settings (Edit here)
############################################################
PRJ=H06_; RUN=____              # PRJ/RUN for dam_cov/dam_gov
PRJ=GRan; RUN=D_L_              # PRJ/RUN for dam_cov/dam_gov

#PRJ=KYSY; RUN=____
#PRJDIS=AK10
#RUNDIS=LR__

PRJDIS=WFDE                     # Project name for discharge simulation
RUNDIS=LR__                     # Run name for discharge simulation
YEARDAMMIN=2000                    # Dams completed by this year is included
YEARDAMMAX=2000                    # Dams completed by this year is included
#YEARDAMMIN=1968
#YEARDAMMAX=1968
YEARDIS=0000                    # Discharge simulation of this year is used
CNTMAX=10                       # maximum downstream grid cells
DAMDBG=5140                     # Debugging dam 
#DAMDBG=9119
############################################################
# Macro (Do not edit here unless you are an expert)
############################################################
OPT=all                         # Option for prog_damalc
#RECMAX=507                      # max records for H06
RECMAX=983                      # max records for GRanD L
#RECMAX=23                       # for Kyusyu 2022
############################################################
# Geographical settings (Edit here if you change spatial domain/resolution)
############################################################
L=259200                        # Total num of grid cells
SUF=.hlf                        # Suffix
MAP=.WFDEI                      # Map

#L=11088                  # for Korean peninsula 2018
#SUF=.ko5
#MAP=.SNU

#L=32400                  # for Kyusyu 2022
#SUF=.ks1
#MAP=.kyusyu
############################################################
# Input (Do not edit here basically)
############################################################
YEARDAM=$YEARDAMMIN
while [ $YEARDAM -le $YEARDAMMAX ]; do
RIVNXL=../../map/out/riv_nxl_/rivnxl${MAP}${SUF}         # river downstream l
RIVSEQ=../../map/out/riv_seq_/rivseq${MAP}${SUF}         # river sequence
DAMCAP=../../map/dat/dam_cap_/${PRJ}${RUN}${YEARDAM}0000${SUF}  # dam capacity
DAMID_=../../map/dat/dam_id__/${PRJ}${RUN}${YEARDAM}0000${SUF}  # dam id
DAMNUM=../../map/dat/dam_num_/${PRJ}${RUN}${YEARDAM}0000${SUF}  # num of dams 
DAMPRP=../../map/dat/dam_prp_/${PRJ}${RUN}${YEARDAM}0000${SUF}  # dam purpose
RIVOUT=../../riv/out/riv_out_/${PRJDIS}${RUNDIS}${SUF}MO # river discharge
############################################################
# Output directory (Do not edit here basically)
############################################################
DIRDAMD2S=../../map/out/dam_d2s_
DIRDAMD2D=../../map/out/dam_d2d_
DIRDAMUP_=../../map/out/dam_up__
DIRDAMUPC=../../map/out/dam_upc_
DIRDAMALC=../../map/out/dam_alc_
DIRDAMDOM=../../map/out/dam_dom_
############################################################
# Output (Do not edit here basically)
############################################################
DAMD2D=${DIRDAMD2D}/$PRJ$RUN${SUF}ID       # dam gov. grid cells (Dam to Dam)
DAMD2S=${DIRDAMD2S}/$PRJ$RUN${SUF}ID       # dam gov. grid cells (Dam to Sea)
DAMUP_=${DIRDAMUP_}/$PRJ$RUN${SUF}         # Number of dams in upper stream 
DAMUPC=${DIRDAMUPC}/$PRJ$RUN${SUF}         # Cpacity of dams in upper stream
DAMALC=${DIRDAMALC}/$PRJDIS$RUNDIS${SUF}ID       # Dam allocation
DAMDOM=${DIRDAMDOM}/$PRJDIS$RUNDIS${SUF}         # Dam allocation
############################################################
# Job (make directory)
############################################################
if [ ! -d $DIRDAMD2S ]; then mkdir -p $DIRDAMD2S; fi
if [ ! -d $DIRDAMD2D ]; then mkdir -p $DIRDAMD2D; fi
if [ ! -d $DIRDAMUP_ ]; then mkdir -p $DIRDAMUP_; fi
if [ ! -d $DIRDAMUPC ]; then mkdir -p $DIRDAMUPC; fi
if [ ! -d $DIRDAMALC ]; then mkdir -p $DIRDAMALC; fi
if [ ! -d $DIRDAMDOM ]; then mkdir -p $DIRDAMDOM; fi
############################################################
# Job (prepare log file)
############################################################
DIRLOG=../log
if [ ! -d $DIRLOG    ]; then
  mkdir $DIRLOG
fi
LOG=${DIRLOG}/dam${MAP}${SUF}.log
if [ -f $LOG ]; then
  rm $LOG
fi
############################################################
# Job
############################################################
calc_damgov $L      $DAMDBG $CNTMAX   $RIVNXL \
            $RIVSEQ $DAMID_ $DAMNUM   $DAMCAP \
            $DAMD2S $DAMD2D $DAMUP_   $DAMUPC >> $LOG 2>&1
calc_damalc $L      $RECMAX $YEARDIS  $DAMDBG   $OPT \
            $DAMID_ $DAMPRP $DAMD2D   $RIVOUT $DAMALC $DAMDOM >> $LOG 2>&1
YEARDAM=`expr $YEARDAM + 1`
done
