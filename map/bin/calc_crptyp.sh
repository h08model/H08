#!/bin/sh
############################################################
#to   prepare crop calendar calculation
#by   2010/03/31, hanasaki, NIES: H08 ver1.0
############################################################
# Setting (Edit here if you change simulation)
############################################################
PRJ=M08_
RUN=____
YEAR=2000
############################################################
# Geographical settings (Edit here if you change spatial domain/resolution)
############################################################
L=259200
XY="720 360"
L2X=../../map/dat/l2x_l2y_/l2x.hlf.txt
L2Y=../../map/dat/l2x_l2y_/l2y.hlf.txt
LONLAT="-180 180 -90 90"
SUF=.hlf

#L=11088
#XY="84 132"
#L2X=../../map/dat/l2x_l2y_/l2x.ko5.txt
#L2Y=../../map/dat/l2x_l2y_/l2y.ko5.txt
#LONLAT="124 131 33 44"
#SUF=.ko5
#MAP=.SNU

############################################################
# Input (Do not edit here unless you are an expert)
############################################################
DIRDAT=../../map/dat/hvs_ara_
HA01=${PRJ}bar_${YEAR}0000${SUF}
HA02=${PRJ}cas_${YEAR}0000${SUF}
HA03=${PRJ}cot_${YEAR}0000${SUF}
HA04=${PRJ}grn_${YEAR}0000${SUF}
HA05=${PRJ}mai_${YEAR}0000${SUF}
HA06=${PRJ}mil_${YEAR}0000${SUF}
HA07=${PRJ}oil_${YEAR}0000${SUF}
HA08=${PRJ}oth_${YEAR}0000${SUF}
HA09=${PRJ}pot_${YEAR}0000${SUF}
HA10=${PRJ}pul_${YEAR}0000${SUF}
HA11=${PRJ}rap_${YEAR}0000${SUF}
HA12=${PRJ}ric_${YEAR}0000${SUF}
HA13=${PRJ}rye_${YEAR}0000${SUF}
HA14=${PRJ}sor_${YEAR}0000${SUF}
HA15=${PRJ}soy_${YEAR}0000${SUF}
HA16=${PRJ}sub_${YEAR}0000${SUF}
HA17=${PRJ}suc_${YEAR}0000${SUF}
HA18=${PRJ}sun_${YEAR}0000${SUF}
HA19=${PRJ}whe_${YEAR}0000${SUF}
############################################################
# Output (Do not edit here unless you are an expert)
############################################################
DIRCRPTYP1ST=../../map/out/crp_typ1
DIRCRPTYP2ND=../../map/out/crp_typ2
DIRCRPTYP1STFIG=../../map/fig/crp_typ1
DIRCRPTYP2NDFIG=../../map/fig/crp_typ2
#
CRPTYP1ST=${DIRCRPTYP1ST}/${PRJ}${RUN}${YEAR}0000${SUF}
CRPTYP2ND=${DIRCRPTYP2ND}/${PRJ}${RUN}${YEAR}0000${SUF}
CRPTYP1STFIG=${DIRCRPTYP1STFIG}/${PRJ}${RUN}${YEAR}0000.png
CRPTYP2NDFIG=${DIRCRPTYP2NDFIG}/${PRJ}${RUN}${YEAR}0000.png
############################################################
# Job (Make output directory)
############################################################
if [ ! -d $DIRCRPTYP1ST    ]; then  mkdir -p $DIRCRPTYP1ST; fi
if [ ! -d $DIRCRPTYP2ND    ]; then  mkdir -p $DIRCRPTYP2ND; fi
if [ ! -d $DIRCRPTYP1STFIG ]; then  mkdir -p $DIRCRPTYP1STFIG; fi
if [ ! -d $DIRCRPTYP2NDFIG ]; then  mkdir -p $DIRCRPTYP2NDFIG; fi
############################################################
# Job (Make dummy file if necessary)
############################################################
if [ -f $DIRDAT/$HA08 ]; then
  htcreate $L 0.0 $DIRDAT/$HA08
fi
############################################################
# Job (Make set file)
############################################################
SETFILE=temp.txt
if [ -f $SETFILE ]; then
  rm $SETFILE
fi
#
cat << EOF >> $SETFILE
&setcal
n0l=$L
c1hvsara(1)='$DIRDAT/$HA01'
c1hvsara(2)='$DIRDAT/$HA02'
c1hvsara(3)='$DIRDAT/$HA03'
c1hvsara(4)='$DIRDAT/$HA04'
c1hvsara(5)='$DIRDAT/$HA05'
c1hvsara(6)='$DIRDAT/$HA06'
c1hvsara(7)='$DIRDAT/$HA07'
c1hvsara(8)='$DIRDAT/$HA08'
c1hvsara(9)='$DIRDAT/$HA09'
c1hvsara(10)='$DIRDAT/$HA10'
c1hvsara(11)='$DIRDAT/$HA11'
c1hvsara(12)='$DIRDAT/$HA12'
c1hvsara(13)='$DIRDAT/$HA13'
c1hvsara(14)='$DIRDAT/$HA14'
c1hvsara(15)='$DIRDAT/$HA15'
c1hvsara(16)='$DIRDAT/$HA16'
c1hvsara(17)='$DIRDAT/$HA17'
c1hvsara(18)='$DIRDAT/$HA18'
c1hvsara(19)='$DIRDAT/$HA19'
c0crptyp1st='$CRPTYP1ST'
c0crptyp2nd='$CRPTYP2ND'
&end
EOF
############################################################
# Job (generate files)
############################################################
LOG=temp.log
prog_crptyp $SETFILE > $LOG
############################################################
# Job (Draw figures)
############################################################
#CPT=../../cpt/crptyp.cpt
#htdraw $L $XY $L2X $L2Y $LONLAT $CRPTYP1ST  $CPT temp.eps
#htconv temp.eps $CRPTYP1STFIG rot
#htdraw $L $XY $L2X $L2Y $LONLAT $CRPTYP2ND  $CPT temp.eps
#htconv temp.eps $CRPTYP2NDFIG rot
