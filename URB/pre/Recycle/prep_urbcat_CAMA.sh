
############################################################
#
#
############################################################
# city-specific setting
L=1728; SUF=.ty5
# common setting
MAP=.CAMA
# in
RIVNXL=../../map/out/riv_nxl_/rivnxl${MAP}${SUF}
RIVNUM=../../map/out/riv_num_/rivnum${MAP}${SUF}
# out
URBCAT=temp.urbcat${MAP}${SUF}
############################################################
#
############################################################
prog_urbcat_CAMA $L $RIVNXL $RIVNUM $URBCAT
