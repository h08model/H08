#!/bin/sh
############################################################
#to   prepare CIESIN Gridded Population of the World Ver 3
#by   2011/03/30, hanasaki, NIES
#
# Source:
#
# Center for International Earth Science Information Network (CIESIN)
# Columbia University, and Centro Internacional de Agricultura
# Tropical (CIAT) (2005), Gridded Population of the World Version 3 (GPWv3):
# Population Grids, Socioeconomic Data and Applications Center (SEDAC)
# Columbia University, Palisades, NY.
#
############################################################
# Preparation
############################################################
#
# For users:
# Download map-org-C05.tar.gz from the H08 file server.
#
# Methods:
#
# I obtained data below from http://sedac.ciesin.columbia.edu/gpw/global.jsp,
# and put them in ${DIRH08}/map/org/C05.
#
# National Indentifier grid: .ascii; 2.5min; for 2000
#
# The directory map/org/C05 contains following sub directories.
# gl_gpwv3_ntlbndid_ascii_25
# 
# 1) I opened bndsg.dbf with MS Excel
# 2) I removed "," (Korea DPR and Congo DR)
# 3) Then, I replaced " " and "'" with "_".
# 4) I saved the file as tab separeted text file (TXT), entitled bndsg.txt.
# 5) I copied the fifth and the fourth column of bndsg.txt, and saved as
#    map/dat/nat_cod_/C05_____20000000.txt.CIESINoriginal
#    Make sure that the first coulumn contains country name, and the second
#    contains number.
# 6) I removed the header part (i.e. "UNsdcode Countryeng" of the first line)
#
############################################################
# Input (Do not edit here unless you are an expert)
############################################################
DIR=../org/C05
DIRSUB=gl_gpwv3_ntlbndid_ascii_25
#
FILE=${DIR}/${DIRSUB}/glbnds.asc
COD=${DIR}/${DIRSUB}/bndsg.txt
############################################################
# Output (Do not edit here unless you are an expert)
############################################################
DIROUT=../dat/nat_msk_
#
OUT1=${DIROUT}/C05_____20000000.gl2
OUT2=${DIROUT}/C05_____20000000.one
OUT3=${DIROUT}/C05_____20000000.hlf
OUT4=${DIROUT}/C05_____20000000.gl5
############################################################
# Macro
############################################################
TMP=temp.txt
#
L2XONE=../../map/dat/l2x_l2y_/l2x.one.txt
L2YONE=../../map/dat/l2x_l2y_/l2y.one.txt
L2XHLF=../../map/dat/l2x_l2y_/l2x.hlf.txt
L2YHLF=../../map/dat/l2x_l2y_/l2y.hlf.txt
L2XGL5=../../map/dat/l2x_l2y_/l2x.gl5.txt
L2YGL5=../../map/dat/l2x_l2y_/l2y.gl5.txt
L2XGL2=../../map/dat/l2x_l2y_/l2x.gl2.txt
L2YGL2=../../map/dat/l2x_l2y_/l2y.gl2.txt
############################################################
# Job (generate L2X & L2Y for 2.5min and 5.0min)
############################################################
if [ ! -f $L2XGL2 -o ! -f $L2YGL2 ]; then
  htl2xl2y 37324800 8640 4320 $L2XGL2 $L2YGL2
fi
if [ ! -f $L2XGL5 -o ! -f $L2YGL5 ]; then
  htl2xl2y 9331200 4320 2160 $L2XGL5 $L2YGL5
fi
if [ ! -f $L2XHLF -o ! -f $L2YHLF ]; then
  htl2xl2y 259200 720 360 $L2XHLF $L2YHLF
fi
if [ ! -f $L2XONE -o ! -f $L2YONE ]; then
  htl2xl2y  64800 360 180 $L2XONE $L2YONE
fi
############################################################
# Job (prepare directory)
############################################################
if [ ! -d $DIROUT ]; then  mkdir -p $DIROUT; fi
############################################################
# Job (generate files)
############################################################
LOG=temp.log
#
sed -e '1,6d' $FILE > $TMP
prog_map_C05_nat $TMP $COD $OUT1 $OUT2 $OUT3 $OUT4 $L2XONE $L2YONE $L2XHLF $L2YHLF $L2XGL5 $L2YGL5 $L2XGL2 $L2YGL2 > $LOG
############################################################
# Job (generate country-id lookup table)
############################################################
if [ ! -f ../../map/dat/nat_cod_/C05_____20000000.txt ]; then
  if [ !  -d ../../map/dat/nat_cod_ ]; then
    mkdir -p ../../map/dat/nat_cod_
  fi
  cp ${DIR}/gl_gpwv3_ntlbndid_ascii_25/C05_____20000000.txt ../../map/dat/nat_cod_/C05_____20000000.txt
fi
echo Log: $LOG