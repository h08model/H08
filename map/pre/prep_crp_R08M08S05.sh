#!/bin/sh
############################################################
#to   prepare Ramankutty et al 2008; Monfreda et al 2008; Siebert et al 2005
#by   2011/04/05, hanasaki, NIES: H08 ver1.0
#
# Source:
#
# Ramankutty, N., A. Evan, C. Monfreda, and J. A. Foley (2008), 
# Farming the Planet. Part 1: The Geographic Distribution of 
# Global Agricultural Lands in the Year 2000, 
# Glob. Biogeochem. Cycles. GB1003, doi:10.1029/2007GB002952
#
# Monfreda, C., N. Ramankutty, and J. A. Foley (2008), 
# Farming the Planet. Part 2: The Geographic Distribution of 
# Crop Areas and Yields in the Year 2000, 
# Glob. Biogeochem. Cycles. GB1022, doi:10.1029/2007GB002947
#
# Siebert, S., P. Doll, J. Hoogeveen, J. M. Faures, 
# K. Frenken, and S. Feick (2005), 
# Development and validation of the global map of irrigation areas,
# Hydrol. Earth Syst. Sc., 9(5), 535-547.
#
############################################################
# Preparation 
############################################################
#  For users:
#  Download map-org-DS02.tar.gz, map-org-S05.tar.gz, 
#           map-org-M05.tar.gz, map-org-R05.tar.gz from the H08 file server
#
#  How I made these tar files:
#
# 1. Visit Navin Ramankutty's group website.
#    http://www.geog.mcgill.ca/~nramankutty/Datasets/Datasets.html
# 2. Download their data, and copy to org/R08.
#    Data: ArcASCII, Cropland2000_5min.asc
#    Data: ArcASCII, Pasture2000_5min.asc
# 3. Now org/R08 looks,
#    Cropland2000_5min.asc   Pasture2000_5min.asc
# 4. Visit Navin Ramankutty's group website.
#    http://www.geog.mcgill.ca/~nramankutty/Datasets/Datasets.html
# 5. Download their data, and copy them to org/M08.
#    Data: ArcASCII, ????_harea.asc.gz
#    Crop: barley,   cassava,   cotton,   groundnut, maize, 
#          millet,   oilpalm,             potato,    pulsenes, 
#          rapeseed, rice,      rye,      sorghum,   soybean, 
#          sugarbeet,sugaracane,sunflower,wheat
# 6. Now org/M08 looks,
#                            millet_harea.asc        sorghum_harea.asc
#                            oilpalm_harea.asc       soybean_harea.asc
#    barley_harea.asc        potato_harea.asc        sugarbeet_harea.asc
#    cassava_harea.asc       pulsenes_harea.asc      sugarcane_harea.asc
#    cotton_harea.asc        rapeseed_harea.asc      sunflower_harea.asc
#    groundnut_harea.asc     rice_harea.asc          wheat_harea.asc
#    maize_harea.asc         rye_harea.asc
# 7. Visit AQUASTAT website.
#    http://www.fao.org/nr/water/aquastat/irrigationmap/index10.stm
# 8. Download "the Global Map of Irrigated Areas -version 4.0.1
#    area equipped for irrigation expressed as percentage of total area",
#    and copy it to org/S05.
# 9. Now org/S05 looks,
#    gmia_v4_0_1_pct.asc
#
############################################################
# Settings (select one)
############################################################
#JOBS="crp pas" # for Ramankutty et al. 2008 data
#JOBS="irg"     # for Siebert et al. 2005 data
#JOBS="bar cas cot grn mai mil oil oth pot pul rap ric rye sor soy sub suc sun whe"           # for Monfreda et al. 2008 data
JOBS="crp pas bar cas cot grn mai mil oil oth pot pul rap ric rye sor soy sub suc sun whe irg" # for all
############################################################
# Macro
############################################################
TMP=temp.txt
GRDARA=temp.grdara.gl5
#
L2XONE=../../map/dat/l2x_l2y_/l2x.one.txt
L2YONE=../../map/dat/l2x_l2y_/l2y.one.txt
L2XHLF=../../map/dat/l2x_l2y_/l2x.hlf.txt
L2YHLF=../../map/dat/l2x_l2y_/l2y.hlf.txt
L2XGL5=../../map/dat/l2x_l2y_/l2x.gl5.txt
L2YGL5=../../map/dat/l2x_l2y_/l2y.gl5.txt
############################################################
# Job (prepare l2x/l2y/grid area for 5min global)
############################################################
if [ ! -f $L2XGL5 -o ! -f $L2YGL5 ]; then
  htl2xl2y 9331200 4320 2160 $L2XGL5 $L2YGL5
fi
if [ ! -f $GRDARA ]; then
  prog_grdara 9331200 4320 2160 $L2XGL5 $L2YGL5 -180 180 -90 90 $GRDARA
fi
############################################################
# Job (prepare one degree and half degree global map)
############################################################
for JOB in $JOBS; do
  if   [ $JOB = crp ]; then
    DIRORG=../org/R08
    DIROUT=../dat/crp_ara_
    ONE=${DIROUT}/R08_____20000000.one
    HLF=${DIROUT}/R08_____20000000.hlf
    GL5=${DIROUT}/R08_____20000000.gl5
    OPT=frc
    MIS=-9999
  elif [ $JOB = pas  ]; then
    DIRORG=../org/R08
    DIROUT=../dat/pas_ara_
    ONE=${DIROUT}/R08_____20000000.one
    HLF=${DIROUT}/R08_____20000000.hlf
    GL5=${DIROUT}/R08_____20000000.gl5
    OPT=frc
    MIS=-9999
  elif [ $JOB = irg  ]; then
    DIRORG=../org/S05
    DIROUT=../dat/irg_ara_
    ONE=${DIROUT}/S05_____20000000.one
    HLF=${DIROUT}/S05_____20000000.hlf
    GL5=${DIROUT}/S05_____20000000.gl5
    OPT=pct
    MIS=-9
  else
    DIRORG=../org/M08
    DIROUT=../dat/hvs_ara_
    ONE=${DIROUT}/M08_${JOB}_20000000.one
    HLF=${DIROUT}/M08_${JOB}_20000000.hlf
    GL5=${DIROUT}/M08_${JOB}_20000000.gl5
    OPT=frc
    MIS=-9999
  fi
#
  if   [ $JOB = crp  ]; then
    FILE=${DIRORG}/Cropland2000_5min.asc
  elif [ $JOB = pas  ]; then
    FILE=${DIRORG}/Pasture2000_5min.asc
  elif [ $JOB = irg  ]; then
    FILE=${DIRORG}/gmia_v4_0_1_pct.asc
  elif [ $JOB = bar  ]; then
    FILE=${DIRORG}/barley_harea.asc    
  elif [ $JOB = cas  ]; then
    FILE=${DIRORG}/cassava_harea.asc    
  elif [ $JOB = cot  ]; then
    FILE=${DIRORG}/cotton_harea.asc    
  elif [ $JOB = grn  ]; then
    FILE=${DIRORG}/groundnut_harea.asc    
  elif [ $JOB = mai  ]; then
    FILE=${DIRORG}/maize_harea.asc    
  elif [ $JOB = mil  ]; then
    FILE=${DIRORG}/millet_harea.asc    
  elif [ $JOB = oil  ]; then
    FILE=${DIRORG}/oilpalm_harea.asc    
  elif [ $JOB = pot  ]; then
    FILE=${DIRORG}/potato_harea.asc    
  elif [ $JOB = pul  ]; then
    FILE=${DIRORG}/pulsenes_harea.asc    
  elif [ $JOB = rap  ]; then
    FILE=${DIRORG}/rapeseed_harea.asc    
  elif [ $JOB = ric  ]; then
    FILE=${DIRORG}/rice_harea.asc    
  elif [ $JOB = rye  ]; then
    FILE=${DIRORG}/rye_harea.asc    
  elif [ $JOB = sor  ]; then
    FILE=${DIRORG}/sorghum_harea.asc    
  elif [ $JOB = soy  ]; then
    FILE=${DIRORG}/soybean_harea.asc    
  elif [ $JOB = sub  ]; then
    FILE=${DIRORG}/sugarbeet_harea.asc    
  elif [ $JOB = suc  ]; then
    FILE=${DIRORG}/sugarcane_harea.asc    
  elif [ $JOB = sun  ]; then
    FILE=${DIRORG}/sunflower_harea.asc    
  elif [ $JOB = whe  ]; then
    FILE=${DIRORG}/wheat_harea.asc    
  fi
#
  if [ !  -d $DIROUT ]; then
    mkdir -p $DIROUT
  fi
#
  if [ $JOB != oth ]; then
    sed -e '1,6d' $FILE > $TMP
    prog_map_M08 $TMP $GL5 $ONE $HLF $L2XONE $L2YONE $L2XHLF $L2YHLF $L2XGL5 $L2YGL5 $GRDARA $OPT $MIS
  else
    htcreate 64800   0.0 $ONE
    htcreate 259200  0.0 $HLF
    htcreate 9331200 0.0 $GL5
  fi
done