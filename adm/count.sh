#!/bin/sh
############################################################
#to   count number of lines
#by   2010/03/31, hanasaki, NIES: H08ver1.0
############################################################
# You must edit here (basic)
############################################################
DIRH08=/home/tsukuba/Global2018      # H08 directory
############################################################
# You can edit here (directories to count lines)
############################################################
DIR1STS='cpl crp dam lnd map met riv'
DIR2NDS='bin pre pst'
############################################################
# Macro
############################################################
LANG=C
DIRPWD=`pwd`
############################################################
# Initialize
############################################################
LINEF=0       # Lines for Fortran code
LINESH=0      # Lines for Shell script
############################################################
# Count lines for adm
############################################################
DIR=${DIRH08}/adm
TMP=`find ${DIR} -name "*.sh" | head -1`
if [ "$TMP" != "" ]; then
  TMP=`wc ${DIR}/*.sh     | tail -1 | awk '{print $1}'`
  LINESH=`expr $LINESH + $TMP`
  echo $DIR $TMP
fi
############################################################
# Count lines for bin
############################################################
DIR=${DIRH08}/bin
TMP=`find ${DIR} -name "*.f"  | head -1`
if [ "$TMP" != "" ]; then
  TMP=`wc ${DIR}/*.f      | tail -1 | awk '{print $1}'`
  LINEF=`expr $LINEF + $TMP`
  echo $DIR $TMP
fi
############################################################
# Count lines for lib
############################################################
DIR=${DIRH08}/lib
TMP=`find ${DIR} -name "*.f"  | head -1`
if [ "$TMP" != "" ]; then
  TMP=`wc ${DIR}/*.f      | tail -1 | awk '{print $1}'`
  LINEF=`expr $LINEF + $TMP`
  echo $DIR $TMP
fi
############################################################
# Count lines for remaining directories
############################################################
for DIR1ST in $DIR1STS; do
  for DIR2ND in $DIR2NDS; do
    DIR=${DIRH08}/$DIR1ST/$DIR2ND
    if [ -d  $DIR ]; then
      TMP=`find ${DIR} -maxdepth 1 -name  "*.f"  | head -1`
      if [ "$TMP" != "" ]; then
        TMP=`wc ${DIR}/*.f  | tail -1 | awk '{print $1}'`
        LINEF=`expr $LINEF + $TMP`
        echo $DIR Fortran: $TMP
      fi
      TMP=`find ${DIR} -maxdepth 1 -name "*.F"  | head -1`
      if [ "$TMP" != "" ]; then
        TMP=`wc ${DIR}/*.F  | tail -1 | awk '{print $1}'`
        LINEF=`expr $LINEF + $TMP`
        echo $DIR Fortran90: $TMP
      fi
      TMP=`find ${DIR} -maxdepth 1 -name "*.sh"  | head -1`
      if [ "${TMP}" != "" ]; then
        TMP=`wc ${DIR}/*.sh | tail -1 | awk '{print $1}'`
        LINESH=`expr $LINESH + $TMP`
        echo $DIR Shell: $TMP
      fi
    fi
  done
done
############################################################
# Write results
############################################################
echo Total number of lines for Shell Script: $LINESH
echo Total number of lines for Fortran Source: $LINEF

exit



