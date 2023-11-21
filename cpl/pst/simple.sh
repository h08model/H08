#!/bin/sh

ARG=$ARGHLF
PRJRUN=IP__pi__
YEAR=2000
LON=100.25
LAT=13.25
VARS="LWdown__ SWdown__"
MSK=../../map/dat/lnd_msk_/lndmsk.WATCH.hlf
TMP=temp.hlf

for VAR in $VARS; do
  BIN=../../met/dat/${VAR}/${PRJRUN}${YEAR}0600.hlf
  htmask  $ARG $BIN $MSK eq 1 $TMP 
  htpoint $ARG lonlat $TMP $LON $LAT
  htstat  $ARG ave $TMP
done