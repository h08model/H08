#/bin/sh
############################################################
#to   generate netcdf files of met/dat data
#by   2010/09/14, hanasaki, NIES
############################################################
# Edit here (basic)
############################################################
VARS="Tair Qair PSurf Wind SWdown LWdown Rainf Snowf"
PRJ=GSW2
RUN=B1b_
YEARMIN=1986
YEARMAX=1995
MONS="01 02 03 04 05 06 07 08 09 10 11 12"
SUF=.one
IDX=YR
############################################################
# Edit here (out)
############################################################
DIROUT=../dat/Weedon
############################################################
# Edit here (geography)
############################################################
NL=64800
NX=360
NY=180
L2X=../../map/dat/l2x_l2y_/l2x.one.txt
L2Y=../../map/dat/l2x_l2y_/l2y.one.txt
LONMIN=-180
LONMAX=180
LATMIN=-90
LATMAX=90
############################################################
# Prepare directory
############################################################
if [ ! -d $DIROUT ]; then 
  mkdir -p $DIROUT
fi
############################################################
# Job
############################################################
for VAR in $VARS; do
  if   [ $VAR = Tair   ]; then
    DIRIN=../dat/Tair____; UNIT=K;     LONG=Air_temperature_at_2m
  elif [ $VAR = Qair   ]; then
    DIRIN=../dat/Qair____; UNIT=kg/kg; LONG=Specific_humidity_at_2m
  elif [ $VAR = PSurf  ]; then
    DIRIN=../dat/PSurf___; UNIT=Pa;    LONG=Surface_pressure
  elif [ $VAR = Wind   ]; then
    DIRIN=../dat/Wind____; UNIT=m/s;   LONG=Wind_speed_at_10m
  elif [ $VAR = SWdown ]; then
    DIRIN=../dat/SWdown__; UNIT=W/m^2; LONG=Surface_incident_shortwave_radiation
  elif [ $VAR = LWdown ]; then
    DIRIN=../dat/LWdown__; UNIT=W/m^2; LONG=Surface_incident_longwave_radiation
  elif [ $VAR = Rainf  ]; then
    DIRIN=../dat/Rainf___; UNIT=kg/m^2/s; LONG=Rainfall_rate
  elif [ $VAR = Snowf  ]; then
    DIRIN=../dat/Snowf___; UNIT=kg/m^2/s; LONG=Snowfall_rate
  fi
  if [ $IDX = MO -o $IDX = YR ]; then
    OUT=${DIROUT}/${VAR}_GSWP2_P3_${YEARMIN}_${YEARMAX}_${IDX}.nc
    htcreatenc $NX $NY $LONMIN $LONMAX $LATMIN $LATMAX $OUT $IDX $YEARMIN $YEARMAX
  fi
  YEAR=$YEARMIN
  while [ $YEAR -le $YEARMAX ]; do
    for MON in $MONS; do
      IN=${DIRIN}/${PRJ}${RUN}${SUF}${IDX}
      if [ $IDX = 3H -o $IDX = DY ]; then
        OUT=${DIROUT}/${VAR}_GSWP2_P3_${YEAR}${MON}_${IDX}.nc
        htcreatenc $NX $NY $LONMIN $LONMAX $LATMIN $LATMAX $OUT $IDX $YEAR $MON
        htputncts $NL $NX $NY $L2X $L2Y $IN $YEAR $MON $OUT \
                  $VAR $UNIT $LONG $IDX
      elif [ $IDX = MO -o $IDX = YR ]; then
        htputncts $NL $NX $NY $L2X $L2Y $IN $YEAR $MON $OUT \
                  $VAR $UNIT $LONG $IDX $YEARMIN        
      fi
    done
    YEAR=`expr $YEAR + 1`
  done
done