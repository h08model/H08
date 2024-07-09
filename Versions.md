# Update Note: H08 v24

## Versions (2024.07.09)
Latest GitHub branch (main) is v24.0.1

## Updates in v24.0.1 (2024.07.09)
- All of the small bugs below have been fixed.
    1. File: map/pre/prep_map_cstlin.sh
         - Line 60(corrected): gmt makecpt -T-0.5/1.5/1 > temp.cpt
    2. File: map/pre/prep_map_cstlin_region.sh
         - Line 71(corrected): gmt makecpt -T-0.5/1.5/1 > temp.cpt
    3. File: met/pre/prep_wfdei_DataServer.sh
         - Line 40(added):  DIRORG=../../met/org/WFDEI/daily
	                          NCORG=${DIRORG}/${VAR}_wfde_____${YEAR}01-${YEAR}12_DY.nc.tar.gz
	                          tar xf $NCORG -C $DIRORG
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
         - Line 1169(corrected): if (r1tmp(i01).ne.p0mis)then
                                      r1despot(i0l)=int(r1tmp(i0l))
                                 end if

## Updates in v24.0.0 (2024.04.16)
- The explicit method (FTCS) can now be selected for the river model. The traditional semi-implicit method is also available.
  The explicit code was developed and provided by Naho Yoden. We appriciate her kindness.
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
