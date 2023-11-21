#!/bin/sh
############################################################
#to   copy map tarballs to target directory
#by   2018/11/8, hanasaki
############################################################
# 
############################################################
DIRTGT=./data_map
############################################################
# 
############################################################
if [ !  -d $DIRTGT ]; then
  mkdir -p $DIRTGT
fi
#
cp ../crp/org/*tar* $DIRTGT
cp ../dam/org/*tar* $DIRTGT
cp ../lnd/org/*tar* $DIRTGT
cp ../map/org/*tar* $DIRTGT
cp ../met/org/*tar* $DIRTGT
cp ../riv/org/*tar* $DIRTGT
