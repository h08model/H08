#!/bin/sh
############################################################
#to   prepare flow direction 
#
#
#
############################################################
# Setting
############################################################
SUF=.ct5; ARG=${ARGCT5}    # Cape Town
SUF=.ln5; ARG=${ARGLN5}    # London
SUF=.tk5; ARG=${ARGTK5}    # Tokyo
SUF=.cn5; ARG=${ARGCN5}    # Chennai
SUF=.la5; ARG=${ARGLA5}    # LA
SUF=.rj5; ARG=${ARGRJ5}    # Rio de Janeiro
SUF=.pr5; ARG=${ARGPR5}    # Paris
SUF=.ty5; ARG=${ARGTY5}    # Tokyo
SUF=.sy5; ARG=${ARGSY5}    # Sydney
############################################################
# Input
############################################################
RIVNXL=../../map/out/riv_nxl_/rivnxl.CAMA${SUF}
RIVNUM=../../map/out/riv_num_/rivnum.CAMA${SUF}
############################################################
# Output
############################################################
OUT=temp.des${SUF}.txt
############################################################
# Temporary
############################################################
TMPBIN=temp${SUF}
TMPRIVNUM=temp.rivnum.txt
TMPRIVNXL=temp.rivnxl.txt
############################################################
# Job
############################################################
#
# initialization
#
if [ -f $OUT ]; then
  rm $OUT
fi
#if [ -f $OUT2 ]; then
#  rm $OUT2
#fi
#
#
#
#masktk5 $RIVNUM $RIVNUM gt 0 $TMPBIN long > $TMPRIVNUM
htmask ${ARG} $RIVNXL $RIVNXL gt 0 $TMPBIN long > $TMPRIVNXL
#
#
#
LINEMAX=`wc $TMPRIVNXL | awk '{print $1 - 1}'`
LINE=1
while [ $LINE -le $LINEMAX ]; do
  LORG=`sed -n "$LINE"p $TMPRIVNXL | awk '{print $3}'`
#  XYORG=`idtk5 l $LORG | awk '{print $1,$2}'`
  XYORG=`htid $ARG l $LORG | awk '{print $1,$2}'`
  LDES=`sed -n "$LINE"p $TMPRIVNXL | awk '{printf("%d",$4)}'`
#  XYDES=`idtk5 l $LDES | awk '{print $1,$2}'`
  XYDES=`htid $ARG l $LDES | awk '{print $1,$2}'`
  echo $XYORG $XYDES >> $OUT
  LINE=`expr $LINE + 1`
done
