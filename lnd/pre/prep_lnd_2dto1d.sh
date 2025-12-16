#!/bin/sh
##############################################################
#to   prepare 1 dimentional data
#by   2024/10/17, tamaoki, NIES: H08ver1.0
##############################################################
# Settings (Edit here if you change spacial domain/resolution) 
##############################################################
YEARMEAN=0000
YEARMIN=1979; YEARMAX=1979
MONS="01 02 03 04 05 06 07 08 09 10 11 12"
PRCPMONS="00 01 02 03 04 05 06 07 08 09 10 11 12"
#
LALL=259200                 # L for 2d data
LLND=67209                  # L for 1d data
XY="720 360"                       
L2XLND=../../map/dat/l2x_l2y_/l2x.hlo.txt
L2YLND=../../map/dat/l2x_l2y_/l2y.hlo.txt
LONLAT="-180 180 -90 90"
#
SUFIN=.hlf                  # Suffix for 2d data
SUFOUT=.hlo                 # Suffix for 1d data
MAP=.WFDEI
#
PRJMET=wfde
RUNMET=____
PRJMAP=GSW2
RUNMAP=____
#
#############################################################
# Input Data
#############################################################
LNDMSK=../../map/dat/lnd_msk_/lndmsk${MAP}${SUFIN}
DIRMET=../../met/dat
DIRMAP=../../map/dat
DIRLND=../../lnd/dat
DIRINI=../../lnd/ini
DIRRIV=../../map/out/riv_num_
DIRPRC=${DIRMET}/Prcp____
DIRARA=${DIRMAP}/lnd_ara_
DIRGWR=${DIRLND}/gwr_____
#
METVARS="Tair____ LWdown__ SWdown__ PSurf___ Qair____ Rainf___ Snowf___ Wind____"
MAPVARS="Albedo__"
LNDVARS="0.003 0.15 0.30 1.00 100.00 13000.00 2.00"
INIVARS="150.0 283.15 0.0"
GAMTAUS="gamma___ tau_____"
GWRVARS="fa fp fr ft fg rgmax"

#############################################################
# Output Data
#############################################################
CPT=temp.cpt
EPS=temp.eps
PNG=temp.png

#############################################################
# Conversion (ALL --> LND)
#############################################################
# Daily met data
YEAR=$YEARMIN
while [ $YEAR -le $YEARMAX ]; do
    for MON in $MONS; do
	DAY=00
	DAYMAX=`htcal $YEAR $MON`
        while [ $DAY -le $DAYMAX ]; do
	    DAY=`echo $DAY | awk '{printf("%2.2d",$1)}'`
	    for METVAR in $METVARS; do
		METDAT=${DIRMET}/${METVAR}/${PRJMET}${RUNMET}${YEAR}${MON}${DAY}${SUFIN}
		METOUT=${DIRMET}/${METVAR}/${PRJMET}${RUNMET}${YEAR}${MON}${DAY}${SUFOUT}
		echo $METDAT
		echo $METOUT
		ht2dto1d $LALL $XY $METDAT $LNDMSK $METOUT $L2XLND $L2YLND
	    done
	    DAY=`expr $DAY + 1 | awk '{printf("%2.2d",$1)}'`
	done
    done
    YEAR=`expr $YEAR + 1`
done

# Map data
for MON in $MONS; do
    for MAPVAR in $MAPVARS; do
        MAPDAT=${DIRMAP}/${MAPVAR}/${PRJMAP}${RUNMAP}${YEARMEAN}${MON}00${SUFIN}
	MAPOUT=${DIRMAP}/${MAPVAR}/${PRJMAP}${RUNMAP}${YEARMEAN}${MON}00${SUFOUT}
	echo $MAPDAT
	echo $MAPOUT
	ht2dto1d $LALL $XY $MAPDAT $LNDMSK $MAPOUT $L2XLND $L2YLND
    done
done	    


# Average met data
for METVAR in $METVARS; do
    METMDA=${DIRMET}/${METVAR}/${PRJMET}${RUNMET}${YEARMEAN}0000${SUFIN}
    METMOU=${DIRMET}/${METVAR}/${PRJMET}${RUNMET}${YEARMEAN}0000${SUFOUT}
    echo $METMDA
    echo $METMOU
    ht2dto1d $LALL $XY $METMDA $LNDMSK $METMOU $L2XLND $L2YLND
done

for PRCPMON in $PRCPMONS; do
    PRCDAT=${DIRPRC}/${PRJMET}${RUNMET}${YEARMEAN}${MON}00${SUFIN}
    PRCOUT=${DIRPRC}/${PRJMET}${RUNMET}${YEARMEAN}${MON}00${SUFOUT}
    echo $PRCDAT
    echo $PRCOUT
    ht2dto1d $LALL $XY $PRCDAT $LNDMSK $PRCOUT $L2XLND $L2YLND
done

# Land Parameter
for LNDVAR in $LNDVARS; do
    LNDDAT=${DIRLND}/uniform.${LNDVAR}${SUFIN}    
    LNDOUT=${DIRLND}/uniform.${LNDVAR}${SUFOUT}
    echo $LNDDAT
    echo $LNDOUT
    ht2dto1d $LALL $XY $LNDDAT $LNDMSK $LNDOUT $L2XLND $L2YLND
done

for GAMTAU in $GAMTAUS; do
    GAMDAT=${DIRLND}/${GAMTAU}/${PRJMET}${RUNMET}00000000${SUFIN}
    GAMOUT=${DIRLND}/${GAMTAU}/${PRJMET}${RUNMET}00000000${SUFOUT}
    echo $GAMDAT
    echo $GAMOUT
    ht2dto1d $LALL $XY $GAMDAT $LNDMSK $GAMOUT $L2XLND $L2YLND
done

for GWRVAR in $GWRVARS; do
    GWRDAT=${DIRGWR}/${GWRVAR}${SUFIN}
    GWROUT=${DIRGWR}/${GWRVAR}${SUFOUT}
    echo $GWRDAT
    echo $GWROUT
    ht2dto1d $LALL $XY $GWRDAT $LNDMSK $GWROUT $L2XLND $L2YLND
done

# Initial Value
for INIVAR in $INIVARS; do
    INIDAT=${DIRINI}/uniform.${INIVAR}${SUFIN}
    INIOUT=${DIRINI}/uniform.${INIVAR}${SUFOUT}
    echo $INIDAT
    echo $INIOUT
    ht2dto1d $LALL $XY $INIDAT $LNDMSK $INIOUT $L2XLND $L2YLND
done	

# Map data for list_watbal.sh
    RIVNUMIN=${DIRRIV}/rivnum${MAP}${SUFIN}
    RIVNUOUT=${DIRRIV}/rivnum${MAP}${SUFOUT}
    LNDARAIN=${DIRARA}/lndara${MAP}${SUFIN}
    LNDAROUT=${DIRARA}/lndara${MAP}${SUFOUT}
    echo $RIVNUMIN
    echo $RIVNUOUT
    echo $LNDARAIN
    echo $LNDAROUT
    ht2dto1d $LALL $XY $RIVNUMIN $LNDMSK $RIVNUOUT $L2XLND $L2YLND
    ht2dto1d $LALL $XY $LNDARAIN $LNDMSK $LNDAROUT $L2XLND $L2YLND

#############################################################
# Confirm (max, min, sum, ave)
#############################################################
#           htstat $LLND $XY $L2XLND $L2YLND $LONLAT max $OUT
#	    htstat $LLND $XY $L2XLND $L2YLND $LONLAT min $OUT
#	    htstat $LLND $XY $L2XLND $L2YLND $LONLAT sum $OUT
#	    htstat $LLND $XY $L2XLND $L2YLND $LONLAT ave $OUT
		
#############################################################
# 1D-->2D (Graphic converison of meteorological data)
#############################################################
#		if [ $VAR = "Tair____" ]; then
#		    gmt makecpt -T0/330/110 -Z > $CPT
#		elif [ $VAR = "LWdown__" ]; then
#    		    gmt makecpt -T0/550/110 -Z > $CPT
#		elif [ $VAR = "SWdown__" ]; then
#		    gmt makecpt -T0/330/110 -Z > $CPT
#		elif [ $VAR = "Prcp____" ]; then
#		    gmt makecpt -T0/0.0003/0.0001 -Z > $CPT
#		elif [ $VAR = "PSurf___" ]; then
#		    gmt makecpt -T0/110000/55000 -Z > $CPT
#		elif [ $VAR = "Qair____" ]; then
#		    gmt makecpt -T0/0.03/0.01 -Z > $CPT
#		elif [ $VAR = "Rainf___" ]; then
#		    gmt makecpt -T0/0.0003/0.0001 -Z > $CPT
#		elif [ $VAR = "Snowf___" ]; then
#		    gmt makecpt -T0/0.00007/0.000035 -Z > $CPT
#		elif [ $VAR = "Wind____" ]; then
#		    gmt makecpt -T0/15/5 -Z > $CPT
#     		fi

#		htdraw $LLND $XY $L2XLND $L2YLND $LONLAT $OUT $CPT $EPS
#	        htconv $EPS $PNG rot



