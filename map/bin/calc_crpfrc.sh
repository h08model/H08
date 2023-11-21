#!/bin/sh
############################################################
#to   prepare mosaic fraction by crop land use
#by   2010/09/30, hanasaki, NIES: H08ver1.0
############################################################
# Geographical settings (Edit here if you change spatial domain/resolution)
############################################################
L=259200
XY="720 360"
L2X=../../map/dat/l2x_l2y_/l2x.hlf.txt
L2Y=../../map/dat/l2x_l2y_/l2y.hlf.txt
LONLAT="-180 180 -90 90"
ARG="$L $XY $L2X $L2Y $LONLAT"
SUF=.hlf
MAP=.WFDEI

#L=11088
#XY="84 132"
#L2X=../../map/dat/l2x_l2y_/l2x.ko5.txt
#L2Y=../../map/dat/l2x_l2y_/l2y.ko5.txt
#LONLAT="124 131 33 44"
#ARG="$L $XY $L2X $L2Y $LONLAT"
#SUF=.ko5
#MAP=.SNU

############################################################
# Basic setting (Edit here if you wish)
############################################################
OPT="double"     # double or single
YEARMIN=2000; YEARMAX=2000; PRJRUNOUT=S05_____

############################################################
# Input (Edit here if you wish)
############################################################
YEAR=$YEARMIN
while [ $YEAR -le $YEARMAX ]; do
echo
echo $YEAR
echo
IRGARA=../../map/dat/irg_ara_/S05_____${YEAR}0000${SUF}  # Irrigated area
IRGEFF=../../map/dat/irg_eff_/DS02____00000000${SUF}  # Irrigat. effic.
CRPINT=../../map/dat/crp_int_/DS02____00000000${SUF}  # Crop intensity


LNDMSK=../../map/dat/lnd_msk_/lndmsk${MAP}${SUF}     # land mask
LNDARA=../../map/dat/lnd_ara_/lndara${MAP}${SUF}     # land area
CRPARA=../../map/dat/crp_ara_/R08_____${YEAR}0000${SUF} # cropland area

############################################################
# Output (Edit here if you wish)
############################################################
DIRCRPINT1ST=../../map/out/crp_int1          # crop intensity of 1st crop
DIRCRPINT2ND=../../map/out/crp_int2          # crop intensity of 2nd crop
DIRIRGARADBL=../../map/out/irg_arad          # irrigated area for double crop
DIRIRGARASGL=../../map/out/irg_aras          # irrigated area for single crop
   DIRRFDARA=../../map/out/rfd_ara_          # rainfed cropland area 
   DIRNONARA=../../map/out/non_ara_          # non cropland area
DIRIRGFRCDBL=../../map/out/irg_frcd          # land area fraction for d crop
DIRIRGFRCSGL=../../map/out/irg_frcs          # land area fraction for s crop
   DIRRFDFRC=../../map/out/rfd_frc_          # land area fraction rainfed
   DIRNONFRC=../../map/out/non_frc_          # land area fraction non crop
#
CRPINT1ST=${DIRCRPINT1ST}/${PRJRUNOUT}${YEAR}0000${SUF}
CRPINT2ND=${DIRCRPINT2ND}/${PRJRUNOUT}${YEAR}0000${SUF}
IRGARADBL=${DIRIRGARADBL}/${PRJRUNOUT}${YEAR}0000${SUF}
IRGARASGL=${DIRIRGARASGL}/${PRJRUNOUT}${YEAR}0000${SUF}
   RFDARA=${DIRRFDARA}/${PRJRUNOUT}${YEAR}0000${SUF}
   NONARA=${DIRNONARA}/${PRJRUNOUT}${YEAR}0000${SUF}
IRGFRCDBL=${DIRIRGFRCDBL}/${PRJRUNOUT}${YEAR}0000${SUF}
IRGFRCSGL=${DIRIRGFRCSGL}/${PRJRUNOUT}${YEAR}0000${SUF}
   RFDFRC=${DIRRFDFRC}/${PRJRUNOUT}${YEAR}0000${SUF}
   NONFRC=${DIRNONFRC}/${PRJRUNOUT}${YEAR}0000${SUF}
#
LOG=temp.log
############################################################
# Job (prepare directory)
############################################################
if [ !  -f $DIRCRPINT1ST ]; then  mkdir -p $DIRCRPINT1ST; fi
if [ !  -f $DIRCRPINT2ND ]; then  mkdir -p $DIRCRPINT2ND; fi
if [ !  -f $DIRIRGARADBL ]; then  mkdir -p $DIRIRGARADBL; fi
if [ !  -f $DIRIRGARASGL ]; then  mkdir -p $DIRIRGARASGL; fi
if [ !  -f $DIRRFDARA    ]; then  mkdir -p $DIRRFDARA; fi
if [ !  -f $DIRNONARA    ]; then  mkdir -p $DIRNONARA; fi
if [ !  -f $DIRIRGFRCDBL ]; then  mkdir -p $DIRIRGFRCDBL; fi
if [ !  -f $DIRIRGFRCSGL ]; then  mkdir -p $DIRIRGFRCSGL; fi
if [ !  -f $DIRRFDFRC    ]; then  mkdir -p $DIRRFDFRC; fi
if [ !  -f $DIRNONFRC    ]; then  mkdir -p $DIRNONFRC; fi
############################################################
# Job (crop intensity)
############################################################
prog_crpint $L $CRPINT $CRPINT1ST $CRPINT2ND
############################################################
# Job (area & fraction for standard double crops)
############################################################
if [ $OPT = "double" ]; then
# area of irrigation double
  htmath $L mul $IRGARA $CRPINT2ND $IRGARADBL
  echo Irrigated area for double crop: `htstat $ARG sum $IRGARADBL` >  $LOG
# area of irrigation single
  htmath $L mul $IRGARA    $CRPINT1ST $IRGARASGL
  htmath $L sub $IRGARASGL $IRGARADBL $IRGARASGL
  echo Irrigated area for single crop: `htstat $ARG sum $IRGARASGL` >> $LOG
# area of rainfed
  htmath $L sub $CRPARA    $IRGARASGL $RFDARA
  htmath $L sub $RFDARA    $IRGARADBL $RFDARA
  htmaskrplc $ARG   $RFDARA    $RFDARA lt 0.0 0.0 $RFDARA    > /dev/null
  echo Rainfed area:       `htstat $ARG sum $RFDARA`         >> $LOG
# area of non-cropland
  htmath $L sub $LNDARA $IRGARASGL $NONARA
  htmath $L sub $NONARA $IRGARADBL $NONARA
  htmath $L sub $NONARA $RFDARA    $NONARA
  htmaskrplc $ARG $NONARA $NONARA lt 0.0 0.0 $NONARA > /dev/null
  echo Non-cropland area: `htstat $ARG sum $NONARA`          >> $LOG
# fraction of irrigation single
  htmath $L div $IRGARASGL $LNDARA $IRGFRCSGL
  echo Irrig area fraction max single: `htstat $ARG max $IRGFRCSGL` >> $LOG
  echo Irrig area fraction min single: `htstat $ARG min $IRGFRCSGL` >> $LOG
# fraction of irrigation double
  htmath $L div $IRGARADBL $LNDARA $IRGFRCDBL
  echo Irrig area fraction max double: `htstat $ARG max $IRGFRCDBL` >> $LOG
  echo Irrig area fraction min double: `htstat $ARG min $IRGFRCDBL` >> $LOG
# fraction of rainfed
  htmath $L div $RFDARA    $LNDARA $RFDFRC
  echo Rainfed area fraction max: `htstat $ARG max $RFDFRC`  >> $LOG
  echo Rainfed area fraction min: `htstat $ARG min $RFDFRC`  >> $LOG
# fraction of non-cropland
  htmath $L div $NONARA   $LNDARA $NONFRC
  htmask $ARG $NONFRC $LNDMSK eq 1 $NONFRC   > /dev/null
  echo Non-crop area fraction max: `htstat $ARG max $NONFRC` >> $LOG
  echo Non-crop area fraction min: `htstat $ARG min $NONFRC` >> $LOG
elif [ $OPT = "single" ]; then
# area of irrigation single
    htmath $L mul $IRGARA    $CRPINT1ST $IRGARASGL
  echo Irrigated area:     `htstat $ARG sum $IRGARASGL`      >> $LOG
# area of rainfed
  htmath $L sub $CRPARA    $IRGARASGL $RFDARA
  htmaskrplc $ARG   $RFDARA    $RFDARA lt 0.0 0.0 $RFDARA
  echo Rainfed area:       `htstat $ARG sum $RFDARA`         >> $LOG
# area of non-cropland
  htmath $L sub $LNDARA $IRGARASGL $NONARA
  htmath $L sub $NONARA $RFDARA    $NONARA
  htmaskrplc $ARG $NONARA $NONARA lt 0.0 0.0 $NONARA > /dev/null
  echo Non-cropland area: `htstat $ARG sum $NONARA`          >> $LOG
# fraction of irrigation single
  htmath $L div $IRGARASGL $LNDARA $IRGFRCSGL
  echo Irrig area fraction max: `htstat $ARG max $IRGFRCSGL` >> $LOG
  echo Irrig area fraction min: `htstat $ARG min $IRGFRCSGL` >> $LOG
# fraction of rainfed
  htmath $L div $RFDARA    $LNDARA $RFDFRC
  echo Irrig area fraction max: `htstat $ARG max $IRGFRCSGL` >> $LOG
  echo Irrig area fraction min: `htstat $ARG min $IRGFRCSGL` >> $LOG
# fraction of non-cropland
  htmath $L div $NONARA   $LNDARA $NONFRC
  htmask $ARG $NONFRC $LNDMSK eq 1 $NONFRC   > /dev/null
  echo Non-crop area fraction max: `htstat $ARG max $NONFRC` >> $LOG
  echo Non-crop area fraction min: `htstat $ARG min $NONFRC` >> $LOG
fi

  YEAR=`expr $YEAR + 1`
done
