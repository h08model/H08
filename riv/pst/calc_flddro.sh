#!/bin/sh
############################################################
#to   calculate operational year 
#by   2010/06/30, hanasaki, NIES: H08ver1.0
############################################################
# Basic settings (Edit here)
############################################################
PRJ=WFDE          #
RUN=LR__          #
#PRJ=AK10
#RUN=LR__
YEARMIN=0000      #
YEARMAX=0000      #
LDBG=27641        #
#LDBG=5734
PROG=prog_flddro  #
#
LOG=temp.log
############################################################
# Geographical settings (Edit here if you change spatial domain/resolution)
############################################################
L=259200          #
SUF=.hlf          #

#L=11088           # for Korean peninsula 2018
#SUF=.ko5

#L=32400            # for Kyusyu 2022
#SUF=.ks1
############################################################
# Input (Do not edit here basically)
############################################################
RIVOUTMON=../../riv/out/riv_out_/$PRJ$RUN${SUF}MO
RIVOUTANU=../../riv/out/riv_out_/$PRJ$RUN${SUF}YR
############################################################
# Output directory (Do not edit here basically)
############################################################
  DIRFLGFLD=../../riv/out/fld_dro_
 DIRFLD2DRO=../../riv/out/fld2dro_
 DIRDRO2FLD=../../riv/out/dro2fld_
  DIRFLDDUR=../../riv/out/fld_dur_
  DIRFLDRAT=../../riv/out/fld_rat_
############################################################
# Output (Do not edit here basically)
############################################################
     FLGFLD=$DIRFLGFLD/$PRJ$RUN${SUF}YR
    FLD2DRO=$DIRFLD2DRO/$PRJ$RUN${SUF}YR
    DRO2FLD=$DIRDRO2FLD/$PRJ$RUN${SUF}YR
     FLDDUR=$DIRFLDDUR/$PRJ$RUN${SUF}YR
     FLDRAT=$DIRFLDRAT/$PRJ$RUN${SUF}YR
############################################################
# Job (Prepare directory)
############################################################
  if [ ! -d $DIRFLGFLD  ]; then mkdir -p $DIRFLGFLD;  fi
  if [ ! -d $DIRFLD2DRO ]; then mkdir -p $DIRFLD2DRO; fi
  if [ ! -d $DIRDRO2FLD ]; then mkdir -p $DIRDRO2FLD; fi
  if [ ! -d $DIRFLDDUR  ]; then mkdir -p $DIRFLDDUR;  fi
  if [ ! -d $DIRFLDRAT  ]; then mkdir -p $DIRFLDRAT;  fi
############################################################
#
############################################################
YEAR=$YEARMIN
while [ $YEAR -le $YEARMAX ]; do
  $PROG $L $YEAR $LDBG $RIVOUTMON $RIVOUTANU $FLGFLD $FLD2DRO $DRO2FLD $FLDDUR $FLDRAT > $LOG
  YEAR=`expr $YEAR + 1`
done
