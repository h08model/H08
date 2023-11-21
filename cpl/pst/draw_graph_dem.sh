#!/bin/sh
############################################################
#to   
#by   2018/11/05, fujiwara, NIES: 
############################################################
#IDS="01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18"
IDS="06" #"01 02 03 04 05 06 07 08 09 10 11"
#
PRJ=AK10
RUN=N_Ca
RUNFIG=a_03  # _03 = 0.3(IRGEFF), 005 = 0.05, __1 = 1
#
IRGEFF=0.3 # irrigation efficiency
#
TYLFIL=../../cpl/org/e-konzal_tyle50.txt
#
EKONZAL=ekonzal2
VER=v1__     # If you change VER, the graphs are made in other directory
#
YEARMIN=2007
YEARMAX=2012
TRESO=DY
#
############################################################
# Flag setting for graph
############################################################
RFLAG=-R0.5/60.5/0/100
BFLAG=-Ba6::/a20::neWS    #a for annotation
JFLAG=-JX20/5
OPT=color
FIGSIZ=rot
############################################################
# Input Directory
############################################################
DIROBSD=../../lnd/dat/wat_itkD
DIROBSM=../../lnd/dat/wat_itkM
DIRLIDD=../../lnd/out/lid_demD
DIRLIDM=../../lnd/out/lid_demM
############################################################
# Output Directory
############################################################
DIRFIG=../../lnd/fig
DIROUTD=$DIRFIG/wat_itkD
DIROUTM=$DIRFIG/wat_itkM
############################################################
# Jobs
############################################################
if [ ! -e $DIRFIG ]; then mkdir $DIRFIG; fi
if [ ! -e $DIROUTD ]; then mkdir $DIROUTD; fi
if [ ! -e $DIROUTM ]; then mkdir $DIROUTM; fi

ASC=temp.txt
TMP=temptemp.txt
TMP2=temp2.txt
EPS=temp.eps
OBSD2=temp5.txt
OBSM2=temp6.txt
#
#
for ID in $IDS; do
  TYLE=`awk -v "id=$ID" '($1==id){print $2}' $TYLFIL`
  echo $TYLE
#
  DIRIDD=$DIROUTD/$VER$ID
  DIRIDM=$DIROUTM/$VER$ID
#
  if [ ! -e $DIRIDD ]; then mkdir $DIRIDD; fi
  if [ ! -e $DIRIDM ]; then mkdir $DIRIDM; fi
#
  OBSD=$DIROBSD/${EKONZAL}000000${ID}.txt
  OBSM=$DIROBSM/${EKONZAL}000000${ID}.txt
  OBSMM=$DIROBSM/${EKONZAL}000000${ID}MM.txt
#
#  PNGD=$DIROUTD/${EKONZAL}000000${ID}.png
  PNGD=$DIRIDD/${PRJ}${RUNFIG}000000${ID}.png
#  PNGM=$DIROUTM/${EKONZAL}000000${ID}.png
  PNGM=$DIRIDM/${PRJ}${RUNFIG}000000${ID}.png
  PNGMM=$DIRIDM/${PRJ}${RUNFIG}000000${ID}MM.png
#
  H08D=$DIRLIDD/${PRJ}${RUN}000000${ID}.txt
  H08M=$DIRLIDM/${PRJ}${RUN}000000${ID}.txt
  H08MM=$DIRLIDM/${PRJ}${RUN}000000${ID}MM.txt
#
#  echo $OBSD
#  echo $OBSM
#
#  sed -e 's/-9999/NaN/g' $OBSD > $OBSD2
#  sed -e 's/-9999/NaN/g' $OBSM > $OBSM2
#
  sed -e 's/-9999/NaN/g' $OBSD | \
      awk -v "tyle=$TYLE" '{print $1,$2,$3,$4-tyle}' | \
      sed -e 's/-\[0-9\].*/0/g' > $OBSD2
  sed -e 's/-9999/NaN/g' $OBSM | \
      awk -v "tyle=$TYLE" '{print $1,$2,$3,$4-tyle}' | \
      sed -e 's/-\[0-9\].*/0/g' > $OBSM2
#
  for TRESO in DY MO; do
    if [ $TRESO = "DY" ]; then
      OBS=$OBSD2
      H08=$H08D
    else
      OBS=$OBSM2
      H08=$H08M
    fi
    awk '($1>="'$YEARMIN'"&&$1<="'$YEARMAX'"){print $0}' $OBS > $TMP
    YMAX1=`htstattxt max ${TMP}${TRESO} | awk '{print $1*1}' | \
	sed s/\.[0-9,]*$//g`
    awk '($1>="'$YEARMIN'"&&$1<="'$YEARMAX'"){print $0}' $H08 > $TMP
    YMAX2=`htstattxt max ${TMP}${TRESO} | \
	awk -v "irgeff=$IRGEFF" '{print $1/irgeff}' | sed s/\.[0-9,]*$//g`
    if [ $YMAX1 -ge $YMAX2 ]; then
      YMAX=$YMAX1
    else
      YMAX=$YMAX2
    fi
#
    if [ $YMAX -le 1 ]; then
      YMAX=1
      YINT=0.2
    else
      YINT=1
      YMAX=`expr $YMAX + 1`
    fi
    if [ $YMAX -ge 7 -a $YMAX -lt 15 ]; then
      YINT=2
    elif [ $YMAX -ge 15 -a $YMAX -lt 30 ]; then
      YINT=5
    elif [ $YMAX -ge 30 -a $YMAX -lt 80 ]; then
      YINT=10
    elif [ $YMAX -ge 80 ]; then
      YINT=20
    fi
    if [ $TRESO = "DY" ]; then
      YINTD=$YINT
      YMAXD=$YMAX
    else
      YINTM=$YINT
      YMAXM=$YMAX
    fi
  done
  XMAXD=`expr \( $YEARMAX - $YEARMIN + 1 \) \* 365`
  RFLAGDY=-R0.5/${XMAXD}.5/0/${YMAXD}
  BFLAGDY=-Ba180::/a${YINTD}::neWS    #a for annotation
#
  RFLAGYR=-R0.5/360.5/0/${YMAXD}
  BFLAGYR=-Ba30::/a${YINTD}::neWS    #a for annotation
  JFLAGYR=-JX13/5
#
  XMAXM=`expr \( $YEARMAX - $YEARMIN + 1 \) \* 12`
  RFLAGMO=-R0.5/${XMAXM}.5/0/${YMAXM}
  BFLAGMO=-Ba6::/a${YINTM}::neWS    #a for annotation
#
  RFLAGMM=-R0.5/12.5/0/${YMAXM}
  BFLAGMM=-Ba1::/a${YINTM}::neWS    #a for annotation
  JFLAGMM=-JX9/5
#
  echo $PNGD
  echo $PNGM
  echo $PNGMM
  TITLE=${ID}_daily_[${YEARMIN}_${YEARMAX}]_\(${IRGEFF}\)
#
### day ###
  echo $RFLAGDY
  htcatts ${OBSD2}DY ${H08D}DY > $TMP
  awk '($1>="'$YEARMIN'"&&$1<="'$YEARMAX'"){print $0}' $TMP | \
      awk -v "irgeff=$IRGEFF" '{print $1,$2,$3,$4,$5/irgeff}' > $ASC
  htdrawts $ASC $EPS $RFLAGDY $JFLAG $BFLAGDY $TITLE $OPT >> /dev/null
  htconv $EPS $PNGD $FIGSIZ
#
  YR=$YEARMIN
  while [ $YR -le $YEARMAX ]; do
    TITLE=${ID}_daily_[${YR}]_\(${IRGEFF}\)
    PNGY=$DIRIDD/${PRJ}${RUNFIG}${YR}00${ID}.png
#
    echo $PNGY
#    htcatts ${OBSD2}DY ${H08D}DY > $TMP
    awk '($1>="'$YR'"&&$1<="'$YR'"){print $0}' $TMP | \
	awk -v "irgeff=$IRGEFF" '{print $1,$2,$3,$4,$5/irgeff}' > $ASC
    htdrawts $ASC $EPS $RFLAGYR $JFLAGYR $BFLAGYR ${TITLE} $OPT \
	> /dev/null
    htconv $EPS $PNGY $FIGSIZ
#
    YR=`expr $YR + 1`
  done
#
### mon ###
  TITLE=${ID}_monthly_[${YEARMIN}-${YEARMAX}]_\(${IRGEFF}\)
  awk '($1>="'$YEARMIN'"&&$1<="'$YEARMAX'"){print $0}' $OBSM2 > $ASC
#  awk '{print $1,$2,$3,-9999}' $OBSM2 > $TMP
  awk -v "irgeff=$IRGEFF" '{print $1,$2,$3,$4/irgeff}' $H08M > $TMP
  htcatts ${ASC}MO ${TMP}MO > $TMP2
#  htcatts ${ASC}MO ${H08M}MO > $TMP2
#
  htdrawts $TMP2 $EPS $RFLAGMO $JFLAG $BFLAGMO $TITLE $OPT >> /dev/null
  htconv $EPS $PNGM $FIGSIZ
#
### monthly mean ###
  TITLE=${ID}_monthly_mean_${IRGEFF}
  htmeantxt ${OBSM}MO ${OBSMM}MO
  sed -e 's/-9999/NaN/g' $OBSMM | \
      awk -v "tyle=$TYLE" '{print $1,$2,$3,$4-tyle}' | \
      sed -e 's/-\[0-9\].*/0/g' > $OBSM2
  awk '{print 2000,$2,$3,$4}' $OBSM2 > temp3.txt
  htmeantxt ${H08M}MO ${H08MM}MO
  awk -v "irgeff=$IRGEFF" '{print 2000,$2,$3,$4/irgeff}' $H08MM > temp4.txt
  htcatts temp3.txtMO temp4.txtMO > $TMP2
  htdrawts $TMP2 $EPS $RFLAGMM $JFLAGMM $BFLAGMM $TITLE $OPT #>> /dev/null
  htconv $EPS $PNGMM $FIGSIZ
done