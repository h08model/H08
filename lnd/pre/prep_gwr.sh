#!/bin/sh
############################################################
#to   estimate parameter fr for groundwater recharge
#by   2015/10/19, hanasaki
#
#     Algorithm by Doll and Fiedler, 2008, HESS (DF08)
#
############################################################
# settings (Edit below)
############################################################
L=259200
XY="720 360"
L2X=../../map/dat/l2x_l2y_/l2x.hlf.txt
L2Y=../../map/dat/l2x_l2y_/l2y.hlf.txt
LONLAT="-180 180 -90 90"
SUF=.hlf
ARG="$L $XY $L2X $L2Y $LONLAT"

# Regional setting (.ko5)
#L=11088
#XY="84 132"
#L2X=../../map/dat/l2x_l2y_/l2x.ko5.txt
#L2Y=../../map/dat/l2x_l2y_/l2y.ko5.txt
#LONLAT="124 131 33 44"
#SUF=.ko5
#ARG="$L $XY $L2X $L2Y $LONLAT"

# Regional setting (.ks1)
#L=32400
#XY="180 180"
#L2X=../../map/dat/l2x_l2y_/l2x.ks1.txt
#L2Y=../../map/dat/l2x_l2y_/l2y.ks1.txt
#LONLAT="129 132 31 34"
#SUF=.ks1
#ARG="$L $XY $L2X $L2Y $LONLAT"

#
OPTREL=yes              # relief (or slope)
OPTTEX=yes              # texture (or soil type)
OPTGEO=yes              # geology
OPTPRM=yes              # permafrost and glacier
OPTAGR=yes              # aggregation
############################################################
# in
############################################################
DIRSLP=../../map/dat/slp_cls_
SOITYP=../../map/dat/soi_typ_/GSWP3___00000000${SUF}
GEOLOG=../../map/dat/geo_cls_/OneGeo__00000000.3cls${SUF}
  TAIR=../../met/dat/Tair____/wfde____00000000${SUF}
  PRCP=../../met/dat/Prcp____/wfde____00000000${SUF}
#  TAIR=../../met/dat/Tair____/AMeDAS1_00000000${SUF} #for kyusyu
#  PRCP=../../met/dat/Prcp____/AMeDAS1_00000000${SUF} #for kyusyu
   PRM=../../map/dat/prm_msk_/prmmsk.merkator${SUF}
############################################################
# out
############################################################
DIROUT=../dat/gwr_____
FR=${DIROUT}/fr${SUF}         # Parameter fr of DF08
FT=${DIROUT}/ft${SUF}         # Parameter ft of DF08
FA=${DIROUT}/fa${SUF}         # Parameter fa of DF08
FG=${DIROUT}/fg${SUF}         # Parameter fg of DF08
FP=${DIROUT}/fp${SUF}         # Parameter fp of DF08
RGMAX=${DIROUT}/rgmax${SUF}   # Parameter Rgmax of DF08
SCO=${DIROUT}/slope${SUF}     # Slope class
#
DIRFIG=../dat/gwr_____
PNGFR=${DIRFIG}/fr.png        # Parameter fr of DF08
PNGFT=${DIRFIG}/ft.png        # Parameter ft of DF08
PNGFA=${DIRFIG}/fa.png        # Parameter fa of DF08
PNGFG=${DIRFIG}/fg.png        # Parameter fg of DF08
PNGFP=${DIRFIG}/fp.png        # Parameter fp of DF08
PNGRGMAX=${DIRFIG}/rgmax.png  # Parameter Rgmax of DF08
#
if [ ! -d $DIROUT ]; then mkdir -p $DIROUT; fi
#
CPT=temp.cpt
EPS=temp.eps
LOG=temp.log
############################################################
# Job 1: A1 Relief 
############################################################
CLSS="1 2 3 4 5 6 7 8"
if [ $OPTREL = yes ]; then
  for CLS in $CLSS; do
    SLPS=`echo $SLPS $DIRSLP/FAO2009_00000000.Cl${CLS}${SUF}`
  done
  prog_gwr_fr $L $SLPS $FR $SCO > $LOG
#
  gmt makecpt -T0/1/0.1 -Z > $CPT
  htdraw $ARG $FR $CPT $EPS
  htconv $EPS $PNGFR rot
  echo $PNGFR  >> $LOG
fi
############################################################
# Job 2: A2 Texture 
############################################################
if [ $OPTTEX = yes ]; then
  prog_gwr_ft $L $SOITYP $FT $RGMAX  >> $LOG
#
  gmt makecpt -T0/1/0.1 -Z > $CPT
  htdraw $ARG $FT $CPT $EPS
  htconv $EPS $PNGFT rot
  echo $PNGFT  >> $LOG
#

  gmt makecpt -T0/0.00005787/0.00001574 -Z > $CPT
#
  htdraw $ARG $RGMAX $CPT $EPS
  htconv $EPS $PNGRGMAX rot
  echo $PNGRGMAX  >> $LOG
fi
############################################################
# Job 3: A3 Geology
############################################################
if [ $OPTGEO = yes ]; then
  prog_gwr_fa $L $GEOLOG $TAIR $PRCP $FA  >> $LOG
#
  gmt makecpt -T0/1/0.1 -Z > $CPT
  htdraw $ARG $FA $CPT $EPS
  htconv $EPS $PNGFA rot
  echo $PNGFA  >> $LOG
fi
############################################################
# Job 4: A4 Permafrost
############################################################
if [ $OPTPRM = yes ]; then
  prog_gwr_fp $L $PRM $FP  >> $LOG
#
  gmt makecpt -T0/1/0.1 -Z > $CPT
  htdraw $ARG $FP $CPT $EPS
  htconv $EPS $PNGFP rot
  echo $PNGFP  >> $LOG
fi
############################################################
# Job 5: A5 Aggregate
############################################################
if [ $OPTAGR = yes ]; then
  htcreate $L 1.0 $FG
  htmath   $L mul $FG $FR $FG
  htmath   $L mul $FG $FT $FG
  htmath   $L mul $FG $FA $FG
  htmath   $L mul $FG $FP $FG
#
  gmt makecpt -T0/1/0.1 -Z > $CPT
  htdraw $ARG $FG $CPT $EPS
  htconv $EPS $PNGFG rot
  echo $PNGFG  >> $LOG
fi

echo log: $LOG
