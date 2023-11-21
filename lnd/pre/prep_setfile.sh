########################
# create set file
########################
PRJMET=AMeD     # for Kyusyu (.ks1)
RUNMET=AS1_
PRJ=AK10
RUN=LR__
SUF=.ks1
MAP=.kyusyu
#
#PRJ=NK03       # for Naka and Kuji river
#SUF=.nk1      
#MAP=.NakaKuji
#
YEARMIN=2014
YEARMAX=2014
########################
SETFILE=../set/${PRJ}____00000000.set
if [ -f $SETFILE ] ; then
    rm $SETFILE
fi

cat <<EOF >> $SETFILE
&setlnd
i0yearmin=${YEARMIN}
i0yearmax=${YEARMAX}
i0secint=86400
i0ldbg=5734
i0cntc=1000

i0spnflg=0
r0spnerr=0.05
r0spnrat=0.95
r0engbalc=1.0
r0watbalc=0.1

c0lndmsk='../../map/dat/lnd_msk_/lndmsk${MAP}${SUF}'
c0soildepth='../../lnd/dat/FILESD${SUF}'
c0w_fieldcap='../../lnd/dat/uniform.0.30${SUF}'
c0w_wilt='../../lnd/dat/uniform.0.15${SUF}'
c0cg='../../lnd/dat/uniform.13000.00${SUF}'
c0cd='../../lnd/dat/FILECD${SUF}'
c0gamma='../../lnd/dat/FILEGAMMA${SUF}'
c0tau='../../lnd/dat/FILETAU${SUF}'
c0balbedo='../../map/dat/Albedo__/GSW2____${SUF}MM'
c0gwdepth='../../lnd/dat/uniform.1.00${SUF}'
c0w_gwyield='../../lnd/dat/uniform.0.30${SUF}'
c0gwgamma='../../lnd/dat/uniform.2.00${SUF}'
c0gwtau='../../lnd/dat/uniform.100.00${SUF}'
c0gwrcf='../../lnd/dat/gwr_____/fg${SUF}'
c0gwrcmax='../../lnd/dat/gwr_____/rgmax${SUF}'

c0wind='../../met/dat/Wind____/${PRJMET}${RUNMET}${SUF}DY'
c0rainf='../../met/dat/Rainf___/${PRJMET}${RUNMET}${SUF}DY'
c0snowf='../../met/dat/Snowf___/${PRJMET}${RUNMET}${SUF}DY'
c0tair='../../met/dat/Tair____/${PRJMET}${RUNMET}${SUF}DY'
c0qair='../../met/dat/Qair____/${PRJMET}${RUNMET}${SUF}DY'
c0rh='NO'
c0psurf='../../met/dat/PSurf___/${PRJMET}${RUNMET}${SUF}DY'
c0swdown='../../met/dat/SWdown__/${PRJMET}${RUNMET}${SUF}DY'
c0lwdown='../../met/dat/LWdown__/${PRJMET}${RUNMET}${SUF}DY'

c0soilmoist='../../lnd/out/SoilMois/${PRJ}AAAA${SUF}MO'
c0soiltemp='../../lnd/out/SoilTemp/${PRJ}AAAA${SUF}MO'
c0avgsurft='../../lnd/out/AvgSurfT/${PRJ}AAAA${SUF}MO'
c0swe='../../lnd/out/SWE_____/${PRJ}AAAA${SUF}MO'

c0swnet='../../lnd/out/SWnet___/${PRJ}AAAA${SUF}MO'
c0lwnet='../../lnd/out/LWnet___/${PRJ}AAAA${SUF}MO'
c0qh='../../lnd/out/Qh______/${PRJ}AAAA${SUF}MO'
c0qle='../../lnd/out/Qle_____/${PRJ}AAAA${SUF}MO'
c0qg='../../lnd/out/Qg______/${PRJ}AAAA${SUF}MO'
c0qf='../../lnd/out/Qf______/${PRJ}AAAA${SUF}MO'
c0qv='../../lnd/out/Qv______/${PRJ}AAAA${SUF}MO'

c0evap='../../lnd/out/Evap____/${PRJ}AAAA${SUF}DY'
c0qs='../../lnd/out/Qs______/${PRJ}AAAA${SUF}MO'
c0qsb='../../lnd/out/Qsb_____/${PRJ}AAAA${SUF}MO'
c0qtot='../../lnd/out/Qtot____/${PRJ}AAAA${SUF}DY'
c0potevap='../../lnd/out/PotEvap_/${PRJ}AAAA${SUF}DY'

c0soilmoistini='../../lnd/ini/uniform.150.0${SUF}'
c0soiltempini='../../lnd/ini/uniform.283.15${SUF}'
c0avgsurftini='../../lnd/ini/uniform.283.15${SUF}'
c0sweini='../../lnd/ini/uniform.0.0${SUF}'
c0gwini='../../lnd/ini/uniform.0.0${SUF}'

c0subsnow='../../lnd/out/SubSnow_/${PRJ}AAAA${SUF}MO'
c0salbedo='../../lnd/out/SAlbedo_/${PRJ}AAAA${SUF}MO'

c0qrc='../../lnd/out/Qrc_____/${PRJ}AAAA${SUF}MO'
c0qbf='../../lnd/out/Qbf_____/${PRJ}AAAA${SUF}MO'
c0gw='../../lnd/out/GW______/${PRJ}AAAA${SUF}MO'

c0tcor='NO'
c0pcor='NO'
c0lcor='NO'
c0tairout='NO'
c0rainfout='NO'
c0snowfout='NO'
c0lwdownout='NO'

&end
EOF
