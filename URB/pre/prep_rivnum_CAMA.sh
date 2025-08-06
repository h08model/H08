#!/bin/sh
############################################################
#to   prepare the river id (river number) file
#by   2024/11/26, hanasaki
############################################################
# setting

L=1728; SUF=.tk5
L=1728; SUF=.ln5
L=1728; SUF=.cn5
L=1296; SUF=.ct5
L=2304; SUF=.la5
L=4032; SUF=.rj5
L=5148; SUF=.pr5
L=1728; SUF=.ty5
L=1728; SUF=.sy5

MAP=.CAMA
# in
RIVNXL=../../map/out/riv_nxl_/rivnxl${MAP}${SUF}
# out
DIRRIVNUM=../../map/out/riv_num_
RIVNUM=${DIRRIVNUM}/rivnum${MAP}${SUF}
RIVMTH=temp.rivmth${SUF}
############################################################
#
############################################################
prog_rivnum_CAMA $L $RIVNXL $RIVNUM $RIVMTH
