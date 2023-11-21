#!/bin/sh
############################################################
#to   prepare soiltype data
#by   2018/09/04, hanasaki
#
# For users:
#   Download map-org-GSWP3_SoilType.tar.gz from the web server
#
# How I obtained the data
#
#   Data is provided by Dr. Sujan Koirala for GSWP3
#
# http://hydro.iis.u-tokyo.ac.jp/~sujan/research/gswp3/soil-texture-map.html
#
# URL=http://hydro.iis.u-tokyo.ac.jp/~sujan/data/GSWP3/SoilData/
# FORG=slidx.hwsd.final.hlf
# %wget $URL/$FORG
#
#   Copy the Look Up Table of the page, and
#   save as ../../map/dat/soi_typ_/GSWP3___.lut.txt
#   This must be like below.
#
#  1  Sand            1.30E+06 0.3 0.372.45E-05 -0.05 3.3
#  2  Loamy_Sand      1.30E+06 0.3 0.391.75E-05 -0.07 3.8
#  3  Sandy_Loam      1.30E+06 0.3 0.428.35E-06 -0.16 4.34
#  4  Loam            1.30E+06 0.3 0.482.36E-06 -0.65 5.25
#  5  Silt_Loam       1.30E+06 0.3 0.471.10E-06 -0.84 3.63
#  6  Silt            1.30E+06 0.3 0.444.66E-06 -0.24 5.96
#  7  Sandy_Clay_Loam 1.30E+06 0.3 0.416.31E-06 -0.12 7.32
#  8  Clay_Loam       1.30E+06 0.3 0.381.44E-06 -0.63 8.41
#  9  Silty_Clay_Loam 1.30E+06 0.3 0.452.72E-06 -0.28 8.34
#  10 Sandy_Clay      1.30E+06 0.3 0.424.25E-06 -0.12 9.7
#  11 Silty_Clay      1.30E+06 0.3 0.481.02E-06 -0.58 10.78
#  12 Clay            1.30E+06 0.3 0.451.33E-06 -0.27 12.93
#  13 Ice             1.80E+06 2.2 -9999        -9999 -9999
#
############################################################
# settings
############################################################
LHLF=259200
XYHLF="720 360"
L2XHLF="../../map/dat/l2x_l2y_/l2x.hlf.txt"
L2YHLF="../../map/dat/l2x_l2y_/l2y.hlf.txt"
LONLATHLF="-180 180 -90 90"
ARGHLF="$LHLF $XYHLF $L2XHLF $L2YHLF $LONLATHLF"
############################################################
# Geographical Setting (Output)
############################################################
L=11088
XY="84 132"
L2X=../../map/dat/l2x_l2y_/l2x.ko5.txt
L2Y=../../map/dat/l2x_l2y_/l2y.ko5.txt
LONLAT="124 131 33 44"
ARG="$L $XY $L2X $L2Y $LONLAT"
SUF=.ko5
MAP=.SNU

#1min x 1min for Kyusyu (.ks1)
#L=32400
#XY="180 180"
#L2X=../../map/dat/l2x_l2y_/l2x.ks1.txt
#L2Y=../../map/dat/l2x_l2y_/l2y.ks1.txt
#LONLAT="129 132 31 34"
#ARG="$L $XY $L2X $L2Y $LONLAT"
#SUF=.ks1
#MAP=.kyusyu

############################################################
# in
############################################################
DIRORG=../../map/org/GSWP3_SoilType
FORG=slidx.hwsd.final.hlf.txt
FLUT=GSWP3___.lut.txt
############################################################
# out
############################################################
DIROUT=../../map/dat/soi_typ_
FBIN=GSWP3___00000000.hlf
FBIN2=GSWP3___00000000${SUF}
############################################################
# job
############################################################
if [ !  -d $DIROUT ]; then  mkdir -p $DIROUT; fi
if [ !  -d $DIROUT ]; then  mkdir -p $DIROUT; fi
#
cp $DIRORG/$FLUT $DIROUT/$FLUT
htformat $ARGHLF asciiu binary $DIRORG/$FORG $DIROUT/$FBIN

htarray $LHLF $XYHLF $L2XHLF $L2YHLF upsidedown $DIROUT/$FBIN $DIROUT/$FBIN
htarray $LHLF $XYHLF $L2XHLF $L2YHLF shift      $DIROUT/$FBIN $DIROUT/$FBIN

   htlinear $ARGHLF $ARG $DIROUT/$FBIN $DIROUT/$FBIN2
