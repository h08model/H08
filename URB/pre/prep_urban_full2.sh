#!/bin/bash
source ~/.bashrc
############################################################
#to prepare urban data for the full2 model
#by 2024/2/26 nhanasaki
#
# data developers: Kajiyama, Kakiuchi, Takahashi (KKT)
############################################################
#Tokyo
SUF=.tk5
MSK=../org/KKT/cty_msk_${SUF}
PRF=../org/KKT/cty_prf_${SUF}
SWG=../org/KKT/cty_swg_${SUF}
#
# Other cities: DO NOT RUN this script because there is nothing to modify except Tokyo!!
#
YMD=00000000
#SUF=.ct5; ID=00000098; ARG="$ARGCT5"; L=$LCT5
#SUF=.ln5; ID=00000038; ARG="$ARGLN5"; L=$LLN5
#SUF=.cn5; ID=00000032; ARG="$ARGCN5"; L=$LCN5
#SUF=.la5; ID=00000017; ARG="$ARGLA5"; L=$LLA5
#SUF=.rj5; ID=00000016; ARG="$ARGRJ5"; L=$LRJ5
#SUF=.pr5; ID=00000021; ARG="$ARGPR5"; L=$LPR5

#outdated MSK=../../map/dat/cty_msk_/city_${ID}${SUF}
#outdated PRF=../../map/dat/cty_prf_/city_${ID}${SUF}
#outdated SWG=../../map/dat/cty_swg_/city_${ID}${SUF}

MSK=../../map/dat/cty_msk_/GPW_____${YMD}${SUF}
PRF=../../map/dat/cty_prf_/GPW_____${YMD}${SUF}
SWG=../../map/dat/cty_swg_/GPW_____${YMD}${SUF}
#
# temporary
#
TMP=./temp${SUF}
EPS=./temp.eps
CPT=./CPT/map.cpt
#
# output
#
PRFNEW2=../../map/dat/cty_prf_/GPW_FUL2${YMD}${SUF}
PNGNEW2=./temp${SUF}.full2.png
############################################################
# list up location
############################################################
#findtk5 $MSK $MSK eq 1 $TMP long
echo
echo purifacation plants
htmask $ARG $PRF $PRF eq 1 $TMP long
echo
echo sewage plants
htmask $ARG $SWG $SWG eq 1 $TMP long
############################################################
# Relocate the purification plants (intake points; full2)
############################################################
#htedit $ARG l $PRFNEW2 0 661  # Tokyo Tone original location
#htedit $ARG l $PRFNEW2 0 808  # Tokyo Ara
#htedit $ARG l $PRFNEW2 0 951  # Tokyo Tama
#htedit $ARG l $PRFNEW2 0 1023 # Tokyo Sagami
#
#htedit $ARG l $PRFNEW2 1 772  # Tokyo Tone new location (page 67 of Hanasaki-san's notebook)
#htedit $ARG l $PRFNEW2 1 919  # Tokyo Ara
#htedit $ARG l $PRFNEW2 1 1026 # Tokyo Tama
#htedit $ARG l $PRFNEW2 1 1023 # Tokyo Sagami
############################################################
# draw a map (full2)
############################################################
htcreate $L 0.0 $TMP
htmath $L add $TMP $MSK     $TMP   # urban area:   1
htmath $L add $TMP $PRFNEW2 $TMP   # intake point: 2
htmath $L add $TMP $SWG     $TMP
htmath $L add $TMP $SWG     $TMP   # waste water treatment plant: 3
#
# Route of the Ara River in Tokyo
#
#edittk5   l $TMP 4.0  846
#edittk5   l $TMP 4.0  883
#edittk5   l $TMP 4.0  919
#edittk5   l $TMP 4.0  956
#edittk5   l $TMP 4.0  957
#edittk5   l $TMP 4.0  958
#edittk5   l $TMP 4.0  995
htdraw $ARG $TMP $CPT $EPS
htconv  $EPS $PNGNEW2 rot
