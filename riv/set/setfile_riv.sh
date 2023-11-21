########################
# create set file
########################
PRJ=GSW2
SUF=.ko5
MAP=.SNU

YEARMIN=1979
YEARMAX=1979
########################
SETFILE=${PRJ}____00000000.set
if [ -f $SETFILE ] ; then
    rm $SETFILE
fi

cat <<EOF >> $SETFILE
&setriv
i0yearmin=${YEARMIN}
i0yearmax=${YEARMAX}
i0ldbg=1
i0secint=86400
c0qtot='../../lnd/out/Qtot____/${PRJ}AAAA${SUF}DY'
c0rivsto='../../riv/out/riv_sto_/${PRJ}AAAA${SUF}MO'
c0rivout='../../riv/out/riv_out_/${PRJ}AAAA${SUF}MO'
c0rivstoini='../../riv/ini/uniform.0.0${SUF}'
c0rivseq='../../map/out/riv_seq_/rivseq${MAP}${SUF}'
c0rivnxl='../../map/out/riv_nxl_/rivnxl${MAP}${SUF}'
c0rivnxd='../../map/out/riv_nxd_/rivnxd${MAP}${SUF}'
c0lndara='../../map/dat/lnd_ara_/lndara${MAP}${SUF}'
c0flwvel='../../riv/dat/uniform.0.5${SUF}'
c0medrat='../../riv/dat/uniform.1.4${SUF}'
i0spnflg=0
r0spnerr=0.05
r0spnrat=0.95
&end
EOF