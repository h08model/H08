#!/bin/bash
source ~/.bashrc
############################################################
#to prepare urban data for the full model
#by 2024/2/26 nhanasaki
#
# data developers: Kajiyama, Kakiuchi, Takahashi (KKT)
############################################################
#Tokyo
SUF=.tk5; ARG="$ARGTK5"; L=$LTK5
MSK=../org/KKT/cty_msk_${SUF}
PRF=../org/KKT/cty_prf_${SUF}
SWG=../org/KKT/cty_swg_${SUF}
#London
YMD=00000000
#SUF=.ct5; ID=00000098; ARG="$ARGCT5"; L=$LCT5
#SUF=.ln5; ID=00000038; ARG="$ARGLN5"; L=$LLN5
#SUF=.cn5; ID=00000032; ARG="$ARGCN5"; L=$LCN5
#SUF=.la5; ID=00000017; ARG="$ARGLA5"; L=$LLA5
#SUF=.rj5; ID=00000016; ARG="$ARGRJ5"; L=$LRJ5
#SUF=.pr5; ID=00000021; ARG="$ARGPR5"; L=$LPR5
#SUF=.ty5; ID=00000001; ARG="$ARGTY5"; L=$LTY5

#out dated MSK=../../map/dat/cty_msk_/city_${ID}${SUF}
#out dated PRF=../../map/dat/cty_prf_/city_${ID}${SUF}
#out dated SWG=../../map/dat/cty_swg_/city_${ID}${SUF}

#MSK=../../map/dat/cty_msk_/GPW_____${YMD}${SUF}
#PRF=../../map/dat/cty_prf_/GPW_____${YMD}${SUF}
#SWG=../../map/dat/cty_swg_/GPW_____${YMD}${SUF}
#
# temporary
#
TMP=./temp${SUF}
EPS=./temp.eps
CPT=./CPT/map.cpt
#
# output
#
PNGNEW=./temp${SUF}.full.png
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
# draw a map (full)
############################################################
htcreate $L 0.0 $TMP
htmath $L add $TMP $MSK     $TMP   # urban area:   1
htmath $L add $TMP $PRF     $TMP   # intake point: 2
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
htconv  $EPS $PNGNEW rot
echo $PNGNEW
