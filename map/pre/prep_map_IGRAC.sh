#!/bin/sh
############################################################
#to   
#by   2015/09/24, hanasaki
############################################################
# Settings
############################################################
JOBS="1 2 3 4 5"
############################################################
# In
############################################################
NATLST=../../map/dat/nat_cod_/C05_____20000000.txt
NATLSTALP=../../map/org/IGRAC/Alpha-3.txt
############################################################
# Out
############################################################
DIRPWD=`pwd`
for JOB in $JOBS; do
  if   [ $JOB = 1 ]; then
    ORG=../../../map/org/IGRAC/IGRAC_A_GWU.txt
    DIROUT=../../map/dat/SupAgrGT
  elif [ $JOB = 2 ]; then 
    ORG=../../../map/org/IGRAC/IGRAC_I_GWU.txt
    DIROUT=../../map/dat/SupIndGT
  elif [ $JOB = 3 ]; then 
    ORG=../../../map/org/IGRAC/IGRAC_D_GWU.txt
    DIROUT=../../map/dat/SupDomGT
  elif [ $JOB = 4 ]; then 
    ORG=../../../map/org/IGRAC/IGRAC_AID_GWU.txt
    DIROUT=../../map/dat/SupAIDGT
  elif [ $JOB = 5 ]; then 
    ORG=../../../map/org/IGRAC/IGRAC_Total_GWR.txt
    DIROUT=../../map/dat/Qrc_____
  fi
#
  if [ !  -f $DIROUT ]; then
    mkdir -p $DIROUT
  fi
  cd $DIROUT
  FILE1=IGRAC___19950000.txt
  ln -s  $ORG $FILE1
  cd $DIRPWD
  FILE2=IGRAC___19950000.alp.txt
  prog_map_IGRAC $NATLST $NATLSTALP ${DIROUT}/$FILE1 > ${DIROUT}/$FILE2
done
