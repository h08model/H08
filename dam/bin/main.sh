#!/bin/sh
############################################################
#to   run reservoir operation model
#by   2010/03/31,hanasaki, NIES: H08ver1.0
############################################################
# Edit here (job)
############################################################
JOBS="Fig3a  Fig3b  Fig3c  Fig3d  Fig3e"
JOBS="Fig4a  Fig4b  Fig4c  Fig4d  Fig4e"
JOBS="Fig7a  Fig7b  Fig7c"
JOBS="Fig8a  Fig8b  Fig8c"
JOBS="Fig9a  Fig9b  Fig9c  Fig9d"
JOBS="Fig10a Fig10b Fig10c Fig10d"
############################################################
# Edit here (basic)
############################################################
SUF=.txt              # Suffix
PROG=./main           #
############################################################
# Edit here (in)
############################################################
LIST=../../dam/dat/obs_lst_/obsdat.txt
############################################################
# Job
############################################################
for JOB in $JOBS; do
  if   [ $JOB = Fig3a  -o $JOB = Fig3b  -o $JOB = Fig3c  -o $JOB = Fig3d -o $JOB = Fig3e ]; then
    IDS=3256
  elif [ $JOB = Fig4a  -o $JOB = Fig4b  -o $JOB = Fig4c  -o $JOB = Fig4d -o $JOB = Fig4e ]; then
    IDS=3236
  elif [ $JOB = Fig7a  -o $JOB = Fig7b  -o $JOB = Fig7c ]; then
    IDS=3256
  elif [ $JOB = Fig8a  -o $JOB = Fig8b  -o $JOB = Fig8c ]; then
    IDS=3297
  elif [ $JOB = Fig9a  -o $JOB = Fig9b  -o $JOB = Fig9c  -o $JOB = Fig9d ]; then
    IDS=2237
  elif [ $JOB = Fig10a -o $JOB = Fig10b -o $JOB = Fig10c -o $JOB = Fig10d ]; then
 #   IDS=2237
    IDS=5140 
    IDS="3667 5146 5140 710 712 705 702 1307 1320 411 884 338 451 307 753 597 310 297 870 148 396 355"

  fi 
  for ID in $IDS; do
  ID4=`echo $ID | awk '{printf("%4.4d",$1)}'`
############################################################
# Edit here (basic)
############################################################
    if   [ $JOB = Fig3a ]; then
      PRJ=JH06; RUN=3065; KNORM=0.65; FACTOR=1.00; 
      OPTKRLS=yes; OPTDAMRLS=H06; OPTDAMWBC=yes
    elif [ $JOB = Fig3b ]; then
      PRJ=JH06; RUN=3075; KNORM=0.75; FACTOR=1.00; 
      OPTKRLS=yes; OPTDAMRLS=H06; OPTDAMWBC=yes
    elif [ $JOB = Fig3c ]; then
      PRJ=JH06; RUN=3085; KNORM=0.85; FACTOR=1.00; 
      OPTKRLS=yes; OPTDAMRLS=H06; OPTDAMWBC=yes
    elif [ $JOB = Fig3d ]; then
      PRJ=JH06; RUN=3095; KNORM=0.95; FACTOR=1.00; 
      OPTKRLS=yes; OPTDAMRLS=H06; OPTDAMWBC=yes
    elif [ $JOB = Fig3e ]; then
      PRJ=JH06; RUN=3000; KNORM=0.85; FACTOR=1.00; 
      OPTKRLS=no;  OPTDAMRLS=H06; OPTDAMWBC=yes
    elif [ $JOB = Fig4a ]; then
      PRJ=JH06; RUN=4050; KNORM=0.85; FACTOR=0.50; 
      OPTKRLS=yes; OPTDAMRLS=H06; OPTDAMWBC=yes
    elif [ $JOB = Fig4b ]; then
      PRJ=JH06; RUN=4075; KNORM=0.85; FACTOR=0.75; 
      OPTKRLS=yes; OPTDAMRLS=H06; OPTDAMWBC=yes
    elif [ $JOB = Fig4c ]; then
      PRJ=JH06; RUN=4100; KNORM=0.85; FACTOR=1.00; 
      OPTKRLS=yes; OPTDAMRLS=H06; OPTDAMWBC=yes
    elif [ $JOB = Fig4d ]; then
      PRJ=JH06; RUN=4200; KNORM=0.85; FACTOR=2.00; 
      OPTKRLS=yes; OPTDAMRLS=H06; OPTDAMWBC=yes
    elif [ $JOB = Fig4e ]; then
      PRJ=JH06; RUN=4400; KNORM=0.85; FACTOR=4.00; 
      OPTKRLS=yes; OPTDAMRLS=H06; OPTDAMWBC=yes
    elif [ $JOB = Fig7a ]; then
      PRJ=JH06; RUN=7M98; KNORM=0.85; FACTOR=1.00; 
      OPTKRLS=yes; OPTDAMRLS=M98; OPTDAMWBC=yes
    elif [ $JOB = Fig7b ]; then
      PRJ=JH06; RUN=7CST; KNORM=0.85; FACTOR=1.00; 
      OPTKRLS=yes; OPTDAMRLS=nokrls; OPTDAMWBC=yes
    elif [ $JOB = Fig7c ]; then
      PRJ=JH06; RUN=7H06; KNORM=0.85; FACTOR=1.00; 
      OPTKRLS=yes; OPTDAMRLS=H06; OPTDAMWBC=yes
    elif [ $JOB = Fig8a ]; then
      PRJ=JH06; RUN=8M98; KNORM=0.85; FACTOR=1.00; 
      OPTKRLS=yes; OPTDAMRLS=M98; OPTDAMWBC=yes
    elif [ $JOB = Fig8b ]; then
      PRJ=JH06; RUN=8CST; KNORM=0.85; FACTOR=1.00; 
      OPTKRLS=yes; OPTDAMRLS=nokrls; OPTDAMWBC=yes
    elif [ $JOB = Fig8c ]; then
      PRJ=JH06; RUN=8H06; KNORM=0.85; FACTOR=1.00; 
      OPTKRLS=yes; OPTDAMRLS=H06; OPTDAMWBC=yes
    elif [ $JOB = Fig9a ]; then
      PRJ=JH06; RUN=9M98; KNORM=0.85; FACTOR=1.00; 
      OPTKRLS=yes; OPTDAMRLS=M98; OPTDAMWBC=yes
    elif [ $JOB = Fig9b ]; then
      PRJ=JH06; RUN=9CST; KNORM=0.85; FACTOR=1.00; 
      OPTKRLS=yes; OPTDAMRLS=nokrls; OPTDAMWBC=yes
    elif [ $JOB = Fig9c ]; then
      PRJ=JH06; RUN=9H06; KNORM=0.85; FACTOR=1.00; 
      OPTKRLS=yes; OPTDAMRLS=H06; OPTDAMWBC=yes
    elif [ $JOB = Fig9d ]; then
      PRJ=JH06; RUN=9IRG; KNORM=0.85; FACTOR=1.00; 
      OPTKRLS=yes; OPTDAMRLS=H06; OPTDAMWBC=yes
    elif [ $JOB = Fig10a ]; then
      PRJ=JH06; RUN=0M98; KNORM=0.85; FACTOR=1.00; 
      OPTKRLS=yes; OPTDAMRLS=M98; OPTDAMWBC=yes
    elif [ $JOB = Fig10b ]; then
      PRJ=JH06; RUN=0CST; KNORM=0.85; FACTOR=1.00; 
      OPTKRLS=yes; OPTDAMRLS=nokrls; OPTDAMWBC=yes
    elif [ $JOB = Fig10c ]; then
      PRJ=JH06; RUN=0H06; KNORM=0.85; FACTOR=1.00; 
      OPTKRLS=yes; OPTDAMRLS=H06; OPTDAMWBC=yes
    elif [ $JOB = Fig10d ]; then
      PRJ=JH06; RUN=0IRG; KNORM=0.85; FACTOR=1.00; 
      OPTKRLS=yes; OPTDAMRLS=H06; OPTDAMWBC=yes
    fi
#
    if   [ $ID = 3279 ]; then
      YEARMIN=1981; YEARMAX=1990
    elif [ $ID = 3297 ]; then
      YEARMIN=1995; YEARMAX=2004
    elif [ $ID = 3063 ]; then
      YEARMIN=1993; YEARMAX=2002
    else
      YEARMIN=1987; YEARMAX=1996
      YEARMIN=1980; YEARMAX=1996
    fi
#
    if [ $JOB = Fig9a  -o $JOB = Fig9b  -o $JOB = Fig9c  -o $JOB = Fig9d ]; then
      YEARMIN=1987; YEARMAX=1988
      YEARMIN=1979; YEARMAX=1979
    fi
    if [ $JOB = Fig10a -o $JOB = Fig10b -o $JOB = Fig10c -o $JOB = Fig10d ]; then
      YEARMIN=1987; YEARMAX=1988
    fi
#
#    if [ $ID = 2232 -o $ID = 2237 -o $ID = 3288 ]; then
    if [ $ID = 2232 -o $ID = 5140 -o $ID = 3288 ]; then
      DAMPRP=4
      if [ $JOB = Fig9c -o $JOB = Fig10c ]; then
        DAMPRP=1
      fi
    else
      DAMPRP=1
    fi
############################################################
# Parameters
############################################################
    LINE=`awk '($1=='"$ID"'){print $2,$5,$6,$7,$9,$10,$11,$12}' $LIST`
    NAME=`echo $LINE | awk '{print $1}'`
    AREA=`echo $LINE | awk '{print $2*1000*1000}'`       # km2 --> m2
    CAPA=`echo $LINE | awk '{print $3*1000*1000*1000}'`  # MCM --> kg
    IAVE=`echo $LINE | awk '{print $4*1000}'`            # CMS --> kg/s
    FSTM=`echo $LINE | awk '{print $7}'`
    DURA=`echo $LINE | awk '{print $8}'`
############################################################
# Edit here (in)
############################################################
    if [ $DAMPRP = 4 ]; then
      DAMDEM=../../dam/dat/off_dem_/WFDEN_C_0000${ID4}.txtMO
      DAMDEMFIX=`htstattxt ave $DAMDEM | tail -1`
    else
      DAMDEM=NO
      DAMDEMFIX=0.0
    fi
    DAMSTOOBS=../../dam/dat/obs_sto_/____mon_0000${ID4}.txtMO
    DAMINFOBS=../../dam/dat/obs_inf_/____mon_0000${ID4}.txtMO
    DAMRLSOBS=../../dam/dat/obs_rls_/____mon_0000${ID4}.txtMO
############################################################
# Edit here (out)
############################################################
    DIRDAMSTO=../../dam/out/off_sto_
    DIRDAMINF=../../dam/out/off_inf_
    DIRDAMRLS=../../dam/out/off_rls_
    DAMSTOCAL=${DIRDAMSTO}/${PRJ}${RUN}0000${ID4}${SUF}MO
    DAMINFCAL=${DIRDAMINF}/${PRJ}${RUN}0000${ID4}${SUF}MO
    DAMRLSCAL=${DIRDAMRLS}/${PRJ}${RUN}0000${ID4}${SUF}MO
############################################################
# make directory
############################################################
    if [ ! -d $DIRDAMSTO ]; then
      mkdir -p $DIRDAMSTO
    fi
    if [ ! -d $DIRDAMINF ]; then
      mkdir -p $DIRDAMINF
    fi
    if [ ! -d $DIRDAMRLS ]; then
      mkdir -p $DIRDAMRLS
    fi
############################################################
# make set file
############################################################
    DIRSET=../../dam/set
    if [ ! -d $DIRSET ]; then
      mkdir -p $DIRSET
    fi
#
    SETFILE="${DIRSET}/${PRJ}${RUN}0000${ID4}.txt"
    if [ -f $SETFILE ]; then
      rm $SETFILE
    fi
#
    cat << EOF >> $SETFILE
    &setdam
    i0damid_=$ID4
    i0yearmin=$YEARMIN
    i0yearmax=$YEARMAX
    r0knorm=$KNORM
    r0factor=$FACTOR
    c0optkrls='$OPTKRLS'
    c0optdamrls='$OPTDAMRLS'
    c0optdamwbc='$OPTDAMWBC'
    i0damprp=$DAMPRP
    i01stmon=$FSTM
    r0anudis=$IAVE
    r0damcap=$CAPA
    r0damsrf=$AREA
    c0damstoobs='$DAMSTOOBS'
    c0daminfobs='$DAMINFOBS'
    c0damrlsobs='$DAMRLSOBS'
    c0damdemcal='$DAMDEM'
    r0damdemfix=$DAMDEMFIX
    c0damstocal='$DAMSTOCAL'
    c0daminfcal='$DAMINFCAL'
    c0damrlscal='$DAMRLSCAL'
    &end
EOF
############################################################
# Run Reservoir Operation Model
############################################################
    if [ $AREA -eq -9 -a $OPTDAMRLS = "M98" ]; then
      echo Skip $ID because area is $AREA
    else
      echo Call program $PROG for $ID
      $PROG $SETFILE
    fi
  done
done


