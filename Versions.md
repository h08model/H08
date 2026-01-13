# Update Note: H08 v24

## Versions (2026.01.13)
Latest GitHub branch (main) is v24.1.7

## Updates in v24.1.7 (2026.01.13)
#### Major bug fix
- A moderately severe bug in the reservoir operation code in cpl/bin/main_hyper.f has been fixed (same as cpl/bin/main.f in v24.1.6).
  1. File: cpl/bin/main_hyper.f
        - Line 1817(corrected): r0daminf=r2daminf(i0l,1)
        - Line 2385(added):               call wrte_bints2(n0l,n0t,
        - Line 2386(added):      $             r1daminf,       r2daminf,     c0daminf,
        - Line 2387(added):      $             i0year,i0mon,i0day,i0sec,i0secint,
        - Line 2388(added):      $             s0ave)

## Updates in v24.1.6 (2026.01.06)
#### Major bug fix
- A moderately severe bug in the reservoir operation code in cpl/bin/main.f has been fixed.
  1. File: cpl/bin/main.f
        - Line 1811(corrected): r0daminf=r2daminf(i0l,1)
        - Line 2504(added):               call wrte_bints2(n0l,n0t,
        - Line 2505(added):      $             r1daminf,       r2daminf,     c0daminf,
        - Line 2506(added):      $             i0year,i0mon,i0day,i0sec,i0secint,
        - Line 2507(added):      $             s0ave)

## Updates in v24.1.5 (2025.12.16)
#### Bug fixes (Blocking)
- Incorrect program and subroutine reference names that prevented execution were fixed in the following files.
  1. File: cpl/bin/calc_irgapp_hyper.f
        - Line 17(corrected): subroutine calc_irgapp_hyper(
  2. File: cpl/bin/main_hyper.f
        - Line 17(corrected): program main_hyper
        - Line 1692(corrected): call calc_irgapp_hyper(
        - Line 1849(corrected): call calc_resope_hyper(
        - Line 2215(corrected):  call calc_humact_hyper(
  3. File: cpl/bin/main_hyper.sh
        - Line 35(corrected): PROG=./main_hyper
        - Line 379(corrected): #OPTNNB=NO
  4. File: dam/bin/calc_resope_hyper.f
        - Line 17(corrected): subroutine calc_resope_hyper(
        - Line 209(corrected):  write(*,*) 'calc_resope_hyper ',
  5. File: riv/bin/calc_humact_hyper.f
        - Line 17(corrected): subroutine calc_humact_hyper(

#### Minor bug fixes
- A minor bug in map/pre/prep_GIS.sh was fixed by correcting the processing order.
  1. File: map/pre/prep_GIS.sh
        - Line 81(corrected): htmaskrplc $ARG $OUT $OUT eq $RD3 5 $OUT
        - Line 82(corrected): htmaskrplc $ARG $OUT $OUT eq $RD3 6 $OUT
        - Line 83(corrected): htmaskrplc $ARG $OUT $OUT eq $RD3 3 $OUT
        - Line 84(corrected): htmaskrplc $ARG $OUT $OUT eq $RD3 4 $OUT
        - Line 85(corrected): htmaskrplc $ARG $OUT $OUT eq $RD3 7 $OUT
        - Line 86(corrected): htmaskrplc $ARG $OUT $OUT eq $RD3 8 $OUT
        - Line 87(corrected): htmaskrplc $ARG $OUT $OUT eq $RD3 1 $OUT
        - Line 88(corrected): htmaskrplc $ARG $OUT $OUT eq $RD3 2 $OUT
- **[Advanced]** In prep_lnd_2dto1d.sh and prep_cpl_2dto1d.sh, bugs were fixed and additional handling was added for cases where required files were not generated.

## Updates in v24.1.4 (2025.11.11)
#### Minor bug fix
- The minor bugs below have been fixed.
  1. File: adm/Mkinclude.Bak
        - Line 34(corrected): LIB      = -L/usr/lib/x86_64-linux-gnu -lnetcdf -lnetcdff             # for gfortran
        - Line 35(corrected): #LIB      = -L/usr/lib/x86_64-linux-gnu -lnetcdf -lnetcdff -lgomp     # for gfortran parallel computing (openmp)
        - Line 36(corrected): #LIB      = -L/opt/intel/lib/intel64 -lnetcdf -lnetcdff           # for intel fortran compiler
        - Line 37(corrected): #LIB      = -L/opt/intel/lib/intel64 -lnetcdf -lnetcdff -liomp5   # for intel fortran compiler parallel computing (openmp)
  2. File: cpl/bin/main_ftcs.f
        - Line 2400(added): end if
        - Line 2401(added): end if

## Updates in v24.1.3 (2025.11.04)
#### Major bug fix (Groundwater Calculation in cpl/bin/main_ftcs.f)
- Applied the same fix for a bug found in cpl/bin/main_ftcs.f that had previously been corrected in cpl/bin/main.f.
- The issue was resolved by introducing a dummy array (r2arafrc2) for conditional checks, extending the index range and ensuring that all relevant cells are properly processed.

#### Minor bug fix
- The minor bug below has been fixed.
  1. File: cpl/pst/calc_wit.sh
        - Fixed an issue where the L-coordinate value was hard-coded with Kyushu-specific values; it can now be configured through settings.
        - Line 39-42, 67-70, 76-79: $LKS1(bug) → $L(corrected)

## Updates in v24.1.2 (2025.10.14)
#### Major bug fix (Groundwater Calculation in cpl/bin/main.f)
- We identified a moderately severe bug in groundwater calculation, which leads to water imbalance in coupled simulations.
- The issue was resolved by introducing a dummy array (r2arafrc2) for conditional checks, extending the index range and ensuring that all relevant cells are properly processed.

#### Minor bug fixes
- All of the minor bugs below have been fixed.
    1. File: cpl/pst/list_watbal.sh
          - Line 1378, 1379, 1382, 1383, 1438, 1439, 1442, 1443: Corrected water balance list output (degE/degN were reversed).
          - Line 1314, 1318, 1323, 1377, 1381, 1386, 1437, 1441, 1446: Corrected water balance list output (the unit is mm/y).
          - Line 1095(corrected): BALLNDMAXIBNUM=`htmask $ARG $FBALLND $FBALLND gt 1 $TEMP long | tail -1 | awk '{print $1}'`
          - Line 1099(corrected): BALLNDMINIBNUM=`htmask $ARG $FBALLND $FBALLND lt -1 $TEMP long | tail -1 | awk '{print $1}'`
          - Line 1365(corrected): BALSWMAXIBNUM=`htmask $ARG $FBALSW $FBALSW gt 1 $TEMP long | tail -1 | awk '{print $1}'`
          - Line 1369(corrected): BALSWMINIBNUM=`htmask $ARG $FBALSW $FBALSW lt -1 $TEMP long | tail -1 | awk '{print $1}'`
          - Line 1426(corrected): BALGWMAXIBNUM=`htmask $ARG $FBALGW $FBALGW gt 1 $TEMP long | tail -1 | awk '{print $1}'`
          - Line 1430(corrected): BALGWMINIBNUM=`htmask $ARG $FBALGW $FBALGW lt -1 $TEMP long | tail -1 | awk '{print $1}'`
          - Line 1432(added): htmask $ARG $FBALGW $FBALGW lt -1 $TEMP long
    2. File: cpl/pst/draw_all.sh
          - Line 194(corrected): gmt psxy -O -Y${YOFF} $RFLAG $BFLAG $JFLAG $WFLAG -K  >> $EPS
          - Line 198(corrected): gmt psxy -O -Y${YOFF} $RFLAG $BFLAG $JFLAG $WFLAG -K  >> $EPS
          - Line 283(corrected): gmt psxy -O -Y${YOFF} $RFLAG $BFLAG $JFLAG $WFLAG -K  >> $EPS
    3. File: cpl/bin/main.sh
          - Line 19(corrected): LDBG=209746

## Updates in v24.1.1 (2025.07.22)
#### Update to map/pre/prep_GIS.sh
- The previous "ArcGIS Manual for H08 Users" was published in two editions: the first edition for ArcMap and the second edition for ArcGIS. In addition, a separate manual for QGIS has now been released. In response to these updates, the script has been modified to allow users to set flow direction according to the GIS tool they are using.
- Please refer to the respective manuals for detailed instructions.

#### Minor bug fixes
- All of the minor bugs below have been fixed.
    1. File: cpl/bin/main_ftcs.f
         - Line 339(added): character*128 c0lndara
    2. File: cpl/pre/prep_cpl_2dto1d.sh
         - Line 282(corrected): RIVNXLIN=${DIRMAPOUT}/riv_nxl_/rivnxl${MAP}${SUFIN}
    3. File: map/pre/prep_map_despot.sh
         - Line 58(corrected): gmt makecpt -T-0.5/1.5/1.0 > $CPT
    4. File: met/pre/prep_WFDEI.sh
         - Line 54(corrected): DIROUT=../../met/dat/LWdown__
         - Line 55(corrected): VAR2=LWdown_
         - Line 58(corrected): DIROUT=../../met/dat/PSurf___
         - Line 62(corrected): DIROUT=../../met/dat/Qair____
         - Line 66(corrected): DIROUT=../../met/dat/Rainf___
         - Line 70(corrected): DIROUT=../../met/dat/SWdown__
         - Line 74(corrected): DIROUT=../../met/dat/Snowf___
         - Line 78(corrected): DIROUT=../../met/dat/Tair____
         - Line 82(corrected): DIROUT=../../met/dat/Wind____
    5. File: crp/pre/prep.sh
         - Line 11(corrected): L2Y=../../map/dat/l2x_l2y_/l2y.hlf.txt
         - Line 22(corrected): #L2Y=../../map/dat/l2x_l2y_/l2y.ko5.txt
         - Line 30(corrected): #L2Y=../../map/dat/l2x_l2y_/l2y.ks1.txt

## Updates in v24.1.0 (2024.11.30)
#### Add Parallel Calculation Option
- Parallelization is now provided as an option in the land surface process module and in the coupled model calculations. The default setting remains no parallelization.
- The published parallel computation code is based on the code developed by Takahiro Oda. We thank him for his contribution.
- To perform parallel calculations, you need to prepare land-only one-dimensional data and enable the parallelization option in the main calculation.
<br>The relevant codes are as follows;
    1. adm/Mkinclude.bak
    2. bin/Makefile, ht2dto1d.f
    3. lnd/pre/prep_lnd_ht2dto1d.sh
    4. lnd/bin/Makefile, calc_leakyb.f, main.f, main.sh
    5. cpl/pre/prep_cpl_2dto1d.sh
    6. cpl/bin/Makefile, main.f, main.sh
    7. cpl/pst/calc_mean.sh, list_watbal.sh
- The following variables are newly introduced:
   ##### `n0numomp` (in lnd/bin/calc_leakyb.f)
   - Type: Integer
   - Description: Number of OpenMP threads to be used.
   - Default: '1' (parallelization disabled).
   - Note: Users can edit this value according to your computing environment.

   ##### `c0optpara` (in lnd/bin/calc_leakyb.f, main.f, cpl/bin/main.f)
   - Type: Character (string)
   - Description: Flag to enable or disable parallel computation.
      - "yes": Enable parallelization
      - "NO": Disable parallelization
   - Default: "NO" (set in lnd/bin/main.sh, cpl/bin/main.sh)
     
- **Note:** When integrating or merging code from versions before and after this update, please ensure that the new variables (`n0numomp`, `c0optpara`) are properly defined and passed throughout the relevant source files.  
- Please check the Parallel Computing Manual on the H08 website for further information on how to run parallel calculations.

#### Renaming of .bin file used for water transfer scheme
- .bin → .bin+SUF (Suffix: hlf, ko5, ks1) (corrected)
- The relevant codes are as follows;
    1. map/pre/prep_map_K14.sh, prep_map_lcan.sh, prep_map_K14_region.sh, prep_map_lcan_region.sh, prep_map_implicit_KYUSYU.sh, prep_map_merged_KYUSYU.sh
    2. cpl/pre/prep.sh, prep_KYUSYU.sh
    3. cpl/bin/main.f, main.sh, main_ftcs.f, main_ftcs.sh, main_hyper.f main_hyper.sh

## Updates in v24.0.1 (2024.07.30)
- All of the small bugs below have been fixed.
    1. File: map/pre/prep_map_cstlin.sh
         - Line 60(corrected): gmt makecpt -T-0.5/1.5/1 > temp.cpt
    2. File: map/pre/prep_map_cstlin_region.sh
         - Line 71(corrected): gmt makecpt -T-0.5/1.5/1 > temp.cpt
    3. File: met/pre/prep_wfdei_DataServer.sh
         - Line 40(added):
           <br> DIRORG=../../met/org/WFDEI/daily
           <br> NCORG=${DIRORG}/${VAR}_wfde_____${YEAR}01-${YEAR}12_DY.nc.tar.gz
           <br> tar xf $NCORG -C $DIRORG
    4. File: met/pre/prep_mean.sh
         - Enable line 37 and disable line 41
         - Line 37: SUBDIRS="Tair____ Qair____ PSurf___ Wind____ SWdown__ LWdown__ Rainf___ Snowf___"
    5. File: met/pst/prog_koppen.f
         - Line 307(corrected): if(r2tair(i0l,0).eq.p0mis)then
    6. File: dam/bin/Makefile
         - Line 6(added): DIRDAM= ../../dam/bin
    7. File: crp/bin/main.sh
         - Enable line 84 and disable line 86
         - Line 84: CRPTYP2ND=../../map/out/crp_typ2/M08_____20000000${SUF}
    8. File: cpl/bin/main_hyper.f
         - Move the declaration of 'c0lndara' to before the namelist 'setriv'.
    9. File: cpl/bin/Makefile
         - Change the number of targets and components
         - Line 70(corrected): ${DIRDAM)calc_resope_hyper.o
    10. File: cpl/bin/main.f
         - Move the declaration of 'c0lndara' to before the namelist 'setriv'.
         - Line 1169(corrected):
           <br>if (r1tmp(i01).ne.p0mis)then
           <br>   i1despot(i0l)=int(r1tmp(i0l))
           <br>end if

## Updates in v24.0.0 (2024.04.16)
- The explicit method (FTCS) can now be selected for the river model. The traditional semi-implicit method is also available.
- The explicit code was developed and provided by Naho Yoden. We appriciate her kindness.
  <br> For more details, please see the following paper.
  
  Yoden, N., Yamazaki, D., and Hanasaki, N.: Improving river routing algorithms to efficiently implement canal water diversion schemes in global hydrological models, Hydrological   Research Letters, 18, 7-13, 10.3178/hrl.18.7, 2024. 
- The relevant codes are as follows;
     1. riv/bin/main_ftcs.sh, main_ftcs.f, calc_humact_ftcs.f, calc_outflw_ftcs.f
     2. cpl/bin/main_ftcs.sh, main_ftcs.f
- Please check the footnotes(20,29) in the manual for details on usage.
- **Notes: The conventional code remains under the names main.sh and main.f.**

## Updates in v23.0.0 (2024.03.04)
- Replaced geographical data for global domain on website.
     1. File: map/org/GRanD/GRanD_M.txt
- All of the bugs below have been fixed.
     1. File: cpl/bin/main.sh
          - Line 277-278(corrected): OPTNNBS=yes, OPTNNBG=yes
     2. File: crp/bin/main.sh
          - Line 84-86(corrected): CRPTYP2ND=../../map/out/crp_typ2/M08_____20000000${SUF}
                                   #CRPTYP2ND=../../map/org/KYUSYU/crp_typ_second${SUF}
            
## Updates in v23.0.0
- Source code management using GitHub has started.
- Source code for the global, regional, and Japanese versions have been integrated.
- **For H08_20230724 Users** : All of the bugs below have been fixed.
     1. File: met/pre/ptwR2bin_f.f
          - Line 193(corrected): do i0jgrid=1,n0y
          - I thank Josko Troselj for reporting this problem.
     3. File: lnd/pre/prog_gwr_ft.f
          - Line 28-33(corrected):
            <br> integer i1s2d(0:13) 
            <br> data i1s2d/0,1,1,2,2,2,2,2,3,2,3,3,3,4/ 
            <br> real r1optft(0:4) 
            <br> data r1optft/0.0,1.0,0.95,0.7,0.0/ 
            <br> real r1optrgmax(0:4) 
            <br> data r1optrgmax/0.0,5.0,3.0,1.5,0.0/
          - Line 35(corrected): data i0ldbg/1/ 
          - Line 65(corrected):  i1id(i0l)=i1s2d(int(r1soityp(i0l)))
     4. File:lnd/pre/prog_gwr_fa.f
          - Line 48(corrected): data i0dbg/1/
     5. File:lnd/pre/prog_gwr_fp.f
          - Line 57(corrected): data i0dbg/1/
- 20231128 small bugfix (lnd/bin/main.f, bin/htdraw.sh)
