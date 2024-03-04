# Update Note: H08 v23

## Versions (2023.11.21)
Latest GitHub branch (main) is v23.0.0

## Latest updates in v23.0.0 (2024.03.04)
- Replaced geographical data for global domain on website.
     1. File: map/org/GRanD/GRanD_M.txt
- All of the bugs below have been fixed.
     1. File: cpl/bin/main.sh
          - Line 277-278(corrected): OPTNNBS=yes, OPTNNBG=yes
     2. File: crp/bin/main.sh
          - Line 84-86(corrected): CRPTYP2ND=../../map/out/crp_typ2/M08_____20000000${SUF}
                                   #CRPTYP2ND=../../map/org/KYUSYU/crp_typ_second${SUF}
            
## Update in v23.0.0
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
