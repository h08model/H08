#!/bin/sh
############################################################
#to   export the source code of H08
#by   2010/03/31, hanasaki, NIES: H08ver1.0
############################################################
# You must edit here (basic)
############################################################
DIRBUP=/data3/tsukuba/matsuda/BACKUP    #
VER=H08_20190606                # version
############################################################
# You can edit here (directories)
############################################################
DIR1STS='map met riv lnd crp dam cpl'
DIR2NDSRCS="bin pre pst"
############################################################
# You can edit here (out)
############################################################
SCRIPT=install.sh
DIROUT=${DIRBUP}/${VER}
############################################################
# Macro
############################################################
DIRPWD=`pwd`                  # present workng directory
############################################################
# Remove adm/Mkinclude
############################################################
if [ -f ${DIROUT}/adm/Mkinclude ]; then
  echo remove ${DIROUT}/adm/Mkinclude
  rm ${DIROUT}/adm/Mkinclude
fi
############################################################
# Generate Script
############################################################
echo '#!/bin/sh'                        >  ${DIROUT}/$SCRIPT
############################################################
# Source adm
############################################################
DIR1ST=adm
echo 'if [ ! -f adm/Mkinclude ]; then'  >> ${DIROUT}/$SCRIPT
echo '  echo please set adm/Mkinclude'  >> ${DIROUT}/$SCRIPT
echo '  echo afterward, continue again' >> ${DIROUT}/$SCRIPT
echo '  exit'                           >> ${DIROUT}/$SCRIPT
echo 'fi'                               >> ${DIROUT}/$SCRIPT
############################################################
# Source lib
############################################################
DIR1ST=lib
echo cd   $DIR1ST                       >> ${DIROUT}/$SCRIPT
echo echo ----------------------------  >> ${DIROUT}/$SCRIPT
echo echo install.sh: lib               >> ${DIROUT}/$SCRIPT
echo echo ----------------------------  >> ${DIROUT}/$SCRIPT
echo make clean                         >> ${DIROUT}/$SCRIPT
echo make all                           >> ${DIROUT}/$SCRIPT
echo cd   ../                           >> ${DIROUT}/$SCRIPT
############################################################
# Source bin
############################################################
DIR1ST=bin
echo cd   $DIR1ST                       >> ${DIROUT}/$SCRIPT
echo echo ----------------------------  >> ${DIROUT}/$SCRIPT
echo echo install.sh: bin               >> ${DIROUT}/$SCRIPT
echo echo ----------------------------  >> ${DIROUT}/$SCRIPT
echo make clean                         >> ${DIROUT}/$SCRIPT
echo make all                           >> ${DIROUT}/$SCRIPT
echo cd   ../                           >> ${DIROUT}/$SCRIPT
############################################################
# Source others
############################################################
for DIR1ST in $DIR1STS; do
  for DIR2ND in $DIR2NDSRCS; do
    echo $DIRBUP/$VER/$DIR1ST/$DIR2ND
    if [ -d $DIRBUP/$VER/$DIR1ST/$DIR2ND ]; then
      echo "if [ -d ${DIR1ST}/${DIR2ND} ]; then" >> ${DIROUT}/$SCRIPT
      echo echo ----------------------------     >> ${DIROUT}/$SCRIPT
      echo echo install.sh: ${DIR1ST}/${DIR2ND}  >> ${DIROUT}/$SCRIPT
      echo echo ----------------------------     >> ${DIROUT}/$SCRIPT
      echo "  cd   ${DIR1ST}/${DIR2ND}"          >> ${DIROUT}/$SCRIPT
      echo '  if [ -f Makefile ]; then'          >> ${DIROUT}/$SCRIPT
      echo "    make clean"                      >> ${DIROUT}/$SCRIPT
      echo "    make all"                        >> ${DIROUT}/$SCRIPT
      echo '  fi'                                >> ${DIROUT}/$SCRIPT
      echo '  cd   ../../'                       >> ${DIROUT}/$SCRIPT
      echo 'fi'                                  >> ${DIROUT}/$SCRIPT
    fi
  done
done
############################################################
# copy the licence and policy files
############################################################
FILES="licence_en.pdf licence_ja.pdf policy_en.pdf policy_ja.pdf"
for FILE in $FILES; do
  if [ ! -f $FILE ]; then
    echo file $FILE lacking. stop.
  else
    cp $FILE ${DIROUT}/adm
  fi
done
############################################################
# tar and gzip
############################################################
cd     ${DIRBUP}
tar cf ${VER}.tar ${VER}
gzip   ${VER}.tar

