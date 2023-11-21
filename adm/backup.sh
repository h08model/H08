#!/bin/sh
############################################################
#to   backup the source code
#by   2010/03/31, hanasaki, NIES: H08ver1.0
############################################################
# You must edit here (basic)
############################################################
DIRBUP=/data3/tsukuba/matsuda/BACKUP          # Backu up directory 
DIRH08=/data3/tsukuba/matsuda/BACKUP/H08_20200201   # H08 root directory
############################################################
# You can edit here (directories to back up)
############################################################
DIR1STS='cpl crp dam lnd map met riv'     # Exclude adm,bin,cpt,lib 
DIR2NDS='bin pre pst'
############################################################
# Macro
############################################################
LANG=C
DATE=`date "+%Y%m%d"`
############################################################
# Make directory
############################################################
if [ ! -d $DIRBUP ]; then
  echo  making $DIRBUP
  mkdir $DIRBUP
fi

DIROUT=${DIRBUP}/H08_$DATE

if [ ! -d ${DIROUT} ]; then
  echo  making $DIROUT
  mkdir $DIROUT
fi
############################################################
# Back up adm
############################################################
mkdir $DIROUT/adm
cp ${DIRH08}/adm/Mkinclude*             $DIROUT/adm
cp ${DIRH08}/adm/*.sh                   $DIROUT/adm
cp ${DIRH08}/adm/*shrc                  $DIROUT/adm
############################################################
# Back up bin
############################################################
mkdir $DIROUT/bin
cp ${DIRH08}/bin/Makefile               $DIROUT/bin
cp ${DIRH08}/bin/*.f                    $DIROUT/bin
cp ${DIRH08}/bin/*.F                    $DIROUT/bin
cp ${DIRH08}/bin/*.sh                   $DIROUT/bin
############################################################
# Back up cpt
############################################################
mkdir $DIROUT/cpt
cp ${DIRH08}/cpt/*cpt                   $DIROUT/cpt
############################################################
# Back up lib
############################################################
mkdir $DIROUT/lib
cp ${DIRH08}/lib/Makefile               $DIROUT/lib
cp ${DIRH08}/lib/*f                     $DIROUT/lib
############################################################
# Back up remaining directories
############################################################
for DIR1ST in $DIR1STS; do
  mkdir $DIROUT/$DIR1ST
  for DIR2ND in $DIR2NDS; do
    if [ -d ${DIRH08}/$DIR1ST/$DIR2ND ]; then
      mkdir $DIROUT/$DIR1ST/$DIR2ND
      cp ${DIRH08}/$DIR1ST/$DIR2ND/Makefile  $DIROUT/$DIR1ST/$DIR2ND
      cp ${DIRH08}/$DIR1ST/$DIR2ND/*.f       $DIROUT/$DIR1ST/$DIR2ND
      cp ${DIRH08}/$DIR1ST/$DIR2ND/*.F       $DIROUT/$DIR1ST/$DIR2ND
      cp ${DIRH08}/$DIR1ST/$DIR2ND/*.sh      $DIROUT/$DIR1ST/$DIR2ND
    fi
  done
done

echo "All files [Makefile, fortran code, shell script] copied in " $DIROUT