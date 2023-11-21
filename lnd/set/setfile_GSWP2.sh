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
&setlnd
i0yearmin=${YEARMIN}
i0yearmax=${YEARMAX}
i0secint=86400
i0ldbg=1
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
c0balbedo='../../met/dat/Albedo__/GSW2____${SUF}MO'

c0wind='../../met/dat/Wind____/GSW2B1b_${SUF}DY'
c0rainf='../../met/dat/Rainf___/GSW2B1b_${SUF}DY'
c0snowf='../../met/dat/Snowf___/GSW2B1b_${SUF}DY'
c0tair='../../met/dat/Tair____/GSW2B1b_${SUF}DY'
c0qair='../../met/dat/Qair____/GSW2B1b_${SUF}DY'
c0rh='NO'
c0psurf='../../met/dat/PSurf___/GSW2B1b_${SUF}DY'
c0swdown='../../met/dat/SWdown__/GSW2B1b_${SUF}DY'
c0lwdown='../../met/dat/LWdown__/GSW2B1b_${SUF}DY'

c0soilmoist='../../lnd/out/SoilMois/GSW2AAAA${SUF}MO'
c0soiltemp='../../lnd/out/SoilTemp/GSW2AAAA${SUF}MO'
c0avgsurft='../../lnd/out/AvgSurfT/GSW2AAAA${SUF}MO'
c0swe='../../lnd/out/SWE_____/GSW2AAAA${SUF}MO'

c0swnet='../../lnd/out/SWnet___/GSW2AAAA${SUF}MO'
c0lwnet='../../lnd/out/LWnet___/GSW2AAAA${SUF}MO'
c0qh='../../lnd/out/Qh______/GSW2AAAA${SUF}MO'
c0qle='../../lnd/out/Qle_____/GSW2AAAA${SUF}MO'
c0qg='../../lnd/out/Qg______/GSW2AAAA${SUF}MO'
c0qf='../../lnd/out/Qf______/GSW2AAAA${SUF}MO'
c0qv='../../lnd/out/Qv______/GSW2AAAA${SUF}MO'

c0evap='../../lnd/out/Evap____/GSW2AAAA${SUF}DY'
c0qs='../../lnd/out/Qs______/GSW2AAAA${SUF}MO'
c0qsb='../../lnd/out/Qsb_____/GSW2AAAA${SUF}MO'
c0qtot='../../lnd/out/Qtot____/GSW2AAAA${SUF}DY'
c0potevap='../../lnd/out/PotEvap_/GSW2AAAA${SUF}DY'

c0soilmoistini='../../lnd/ini/uniform.150.0${SUF}'
c0soiltempini='../../lnd/ini/uniform.283.15${SUF}'
c0avgsurftini='../../lnd/ini/uniform.283.15${SUF}'
c0sweini='../../lnd/ini/uniform.0.0${SUF}'

c0subsnow='../../lnd/out/SubSnow_/GSW2AAAA${SUF}MO'
c0salbedo='../../lnd/out/SAlbedo_/GSW2AAAA${SUF}MO'

c0tcor='NO'
c0pcor='NO'
c0lcor='NO'
c0tairout='NO'
c0rainfout='NO'
c0snowfout='NO'
c0lwdownout='NO'

&end
EOF