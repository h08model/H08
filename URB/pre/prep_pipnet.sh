#!/bin/sh
############################################################
#to  prepare pipeline network
#    (i.e., water demand to reflect water supply system
#       and water drainage to reflect sewage)
#by  2024/2/29, nhanasaki
############################################################
#
############################################################
source ~/.bashrc
L=1728; SUF=.tk5; ARG=$ARGTK5; NUMMAX=4 ID=        
#L=1296; SUF=.ct5; ARG=$ARGCT5; NUMMAX=3 ID=00000098
#L=1728; SUF=.ln5; ARG=$ARGLN5; NUMMAX=1 ID=00000038
#L=1728; SUF=.cn5; ARG=$ARGCN5; NUMMAX=3 ID=00000032
#L=2304; SUF=.la5; ARG=$ARGLA5; NUMMAX=3 ID=00000017
#L=4032; SUF=.rj5; ARG=$ARGRJ5; NUMMAX=2 ID=00000016
#L=5184; SUF=.pr5; ARG=$ARGPR5; NUMMAX=1 ID=00000021
L=1728; SUF=.ty5; ARG=$ARGTY5; NUMMAX=4 ID=
L=1728; SUF=.sy5; ARG=$ARGSY5; NUMMAX=3 ID=

YMD=00000000
JOB=2
############################################################
# Job 1 (toy; one river for one city)
############################################################
# input in common
DEMINDORG=../../map/dat/dem_ind_/AQUASTAT20000000${SUF}
DEMDOMORG=../../map/dat/dem_dom_/AQUASTAT20000000${SUF}
RIVOUT=../../riv/out/riv_out_/W5E5LR__20190000${SUF}
CPTDRN=./CPT/drn.cpt
CPTDRN=temp.cpt
CPTDEMDOM=./CPT/demdom.cpt
FRCGWD=../../map/dat/frc_gwd_/D12.CAMA${SUF}
FRCGWI=../../map/dat/frc_gwi_/D12.CAMA${SUF}
RIVARA=../../map/out/riv_ara_/rivara.CAMA${SUF}
if [ $JOB = 1 ]; then
# input
  MSK=../org/KKT/cty_msk_${SUF}
  PRF=../dat/cty_prf_.toy${SUF}
  SWG=../dat/cty_swg_.toy${SUF}
  RIVNUM=../org/KKT/cty_msk_${SUF}
  NUMMAX=1
  OPT=combine
# output
  DEMINDNEW=../../map/dat/dem_ind_/AQUASTAT20000000.toy${SUF}
  DEMDOMNEW=../../map/dat/dem_dom_/AQUASTAT20000000.toy${SUF}
  DRN=../../map/dat/cty_drn_/TOY_____${SUF}
  PNGDRN=temp.drn${SUF}.toy.png
  PNGDEMDOM=temp.demdom${SUF}.toy.png
  FRCGWDNEW=../../map/dat/frc_gwd_/TOY_____.CAMA${SUF}
  FRCGWINEW=../../map/dat/frc_gwi_/TOY_____.CAMA${SUF}
fi
############################################################
# Case 2 (full; the actual rivers for the city)
############################################################
if [ $JOB = 2 ]; then
# input
#  MSK=../org/KKT/cty_msk_${SUF}
#  PRF=../org/KKT/cty_prf_${SUF}
#  SWG=../org/KKT/cty_swg_${SUF}
#outdated  MSK=../../map/dat/cty_msk_/city_${ID}${SUF}
#outdated  PRF=../../map/dat/cty_prf_/city_${ID}${SUF}
#outdated  SWG=../../map/dat/cty_swg_/city_${ID}${SUF}

  MSK=../../map/dat/cty_msk_/GPW_____${YMD}${SUF}
  PRF=../../map/dat/cty_prf_/GPW_____${YMD}${SUF}
  SWG=../../map/dat/cty_swg_/GPW_____${YMD}${SUF}  
  RIVNUM=../../map/out/riv_num_/rivnum.CAMA${SUF}
  OPT=combine
# output
  DEMINDNEW=../../map/dat/dem_ind_/AQUASTAT20000000.full${SUF}
  DEMDOMNEW=../../map/dat/dem_dom_/AQUASTAT20000000.full${SUF}
  DRN=../../map/dat/cty_drn_/FUL1____${SUF}
  PNGDRN=temp.drn${SUF}.full.png
  PNGDEMDOM=temp.demdom${SUF}.full.png
  FRCGWDNEW=../../map/dat/frc_gwd_/FUL1____.CAMA${SUF}
  FRCGWINEW=../../map/dat/frc_gwi_/FUL1____.CAMA${SUF}
fi
############################################################
# Case 3 (Modified)
############################################################
if [ $JOB = 3 ]; then
# input
#  MSK=../org/KKT/cty_msk_${SUF}
#  PRF=../dat/cty_prf_.full2${SUF}
#  SWG=../org/KKT/cty_swg_${SUF}
#outdated  MSK=../../map/dat/cty_msk_/city_${ID}${SUF}
#outdated  PRF=../../map/dat/cty_prf_/city_${ID}${SUF}
#outdated  SWG=../../map/dat/cty_swg_/city_${ID}${SUF}

  MSK=../../map/dat/cty_msk_/GPW_____${YMD}${SUF}
  PRF=../../map/dat/cty_prf_/GPW_____${YMD}${SUF}
  SWG=../../map/dat/cty_swg_/GPW_____${YMD}${SUF}  
  RIVNUM=../../map/out/riv_num_/rivnum.CAMA${SUF}
  OPT=separate
# output
  DEMINDNEW=../../map/dat/dem_ind_/AQUASTAT20000000.full2${SUF}
  DEMDOMNEW=../../map/dat/dem_dom_/AQUASTAT20000000.full2${SUF}
  DRN=../../map/dat/cty_drn_/FUL2____${SUF}
  PNGDRN=temp.drn${SUF}.full2.png
  PNGDEMDOM=temp.demdom${SUF}.full2.png
  FRCGWDNEW=../../map/dat/frc_gwd_/FUL2____.CAMA${SUF}
  FRCGWINEW=../../map/dat/frc_gwi_/FUL2____.CAMA${SUF}
fi
############################################################
# temporary
############################################################
EPS=temp.eps
############################################################
# calc
# Usage: n0l         c0ctymsk    c0ctyprf c0ctyswg
#        c0demdomorg c0demindorg c0rivout c0rivnum
#        c0rivara    c0frcgwd    c0frcgwi i0nummax
#        c0demdomnew c0demindnew c0ctydrn
#        c0frcgwdnew c0frcgwinew
############################################################
echo prog_pipnet $L $MSK $PRF $SWG $DEMDOMORG $DEMINDORG $RIVOUT $RIVNUM $RIVARA $FRCGWD $FRCGWI $NUMMAX $DEMDOMNEW $DEMINDNEW $DRN $FRCGWDNEW $FRCGWINEW $OPT
prog_pipnet $L $MSK $PRF $SWG $DEMDOMORG $DEMINDORG $RIVOUT $RIVNUM $RIVARA $FRCGWD $FRCGWI $NUMMAX $DEMDOMNEW $DEMINDNEW $DRN $FRCGWDNEW $FRCGWINEW $OPT
############################################################
# test 
############################################################
echo the original domestic and industrial water demand
htstat $ARG sum $DEMDOMORG
htstat $ARG sum $DEMINDORG

echo the new domestic and industrial water demand: must be identical
htstat $ARG sum $DEMDOMNEW
htstat $ARG sum $DEMINDNEW

gmt makecpt -T0/${L}/100 -Z > $CPTDRN

echo draw   $DRN $PNGDRN
htdraw $ARG $DRN $CPTDRN $EPS
htconv      $EPS $PNGDRN rot

echo draw   $DEMDOMNEW $PNGDEMDOM
htdraw $ARG $DEMDOMNEW $CPTDEMDOM $EPS
htconv      $EPS       $PNGDEMDOM rot


