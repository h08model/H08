       program main_ai
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cto   run crop model to estimate crop calendar
cby   2010/03/31, hanasaki, NIES: H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      implicit none
c parameter (array)
      integer           n0lall             !! all grids
      integer           n0llnd             !! land grids only
      integer           n0swim             !! Crop type (SWIM,Krysanova 2000)
      integer           n0ram              !! Crop type (Leff et al., 2004)
      integer           n0doy
      integer           n0t
      parameter        (n0lall=720*360) 
      parameter        (n0llnd=67209) 
      parameter        (n0swim=71) 
      parameter        (n0ram=19) 
      parameter        (n0doy=366) 
      parameter        (n0t=3) 
c parameter (physical)
      real              p0icepnt           !! freezing point
      parameter        (p0icepnt=273.15)
c parameter (default)
      integer           n0if                !!
      real              p0mis
      parameter        (n0if=15) 
      parameter        (p0mis=1.0E20) 
c index (array)
      integer           i0l                 !!
      integer           i0swim              !! Crop type (SWIM,Krydanova 2000)
      integer           i0ram               !! Crop type (Leff et al., 2004)
c index (time)
      integer           i0mon               !! month
      integer           i0day               !! day
      integer           i0hour              !! hour
      integer           i0sec               !! second
      integer           i0doy               !! Day Of Year
      integer           i0doymav            !! doy for moving average
      integer           i0pltdoy            !! planting daty of year
      integer           i0crpday            !! cropping days
c temporary
      integer           i0tmp
      real              r1tmp(n0lall)
      character*128     c0tmp
      character*128     c0opt
      character*128     c0ifname
      character*128     c0ofname
c function
      integer           iargc      !! Default function
      integer           igetday    !! Function to get number of days in a month
      integer           igetdoy    !! Function to obtain DOY
      integer           igetymd
      character*128     cgetfnt    !! Function to obtain Hformat file
c input (set)
      integer           i0year              !! year
      integer           i0secint            !! interval
      integer           i0ldbg              !! Debuging point
      integer           i0ramdbg            !! Debuging point
      integer           i0daymav            !! day for moving average
      integer           i0crpdaymax     !! maximum cropping day
      real              r0regfmin       !! minimum regf to report
      real              r0tdorm         !! dormancy temperature for winter crop
      real              r0tfrz          !! freezing temperature for winter crop
      real              r0hunmax        !! maximum daily heat unit
      real              r0ihunmat       !! heat unit for maturity
      real              r0tsaw          !! sawing temperature
      real              r0thvs          !! harvesting minimum temperature
      character*128     c0optts
      character*128     c0optws
      character*128     c0optns
      character*128     c0optps
c ai202111start
      character*128     c0optlai        !! option of LAI adjusement
      character*128     c0optce         !! option of co2 effect
      character*128     c0optve         !! option of VPD effect
c ai202111end
      character*128     c0optfrz          !! Option for freeze killer
c input (file: map)
      integer           i1lndmsk(n0lall)    !! land mask
      integer           i1crptyp(n0lall)    !! crop type
      integer           i1doyocuini(n0lall) !! occupied period ini DOY
      integer           i1doyocuend(n0lall) !! occupied period end DOY
      integer           i1ram2swim(n0ram)
      integer           i1swim2ram(n0swim)
      real              r2crppar(24,n0swim)
      character*128     c0lndmsk
      character*128     c0crptyp
      character*128     c0doyocuini
      character*128     c0doyocuend
      character*128     c0ram2swim
      character*128     c0swim2ram
      character*128     c0crppar
c input (file: met)
      real              r1tair(n0lall)            !! temperature   [K]
      real              r2tair(0:n0llnd,n0doy)    !! temperature   [K]   
      real              r1swdown(n0lall)          !! short wave [W/m2]
      real              r2swdown(0:n0llnd,n0doy)  !! short wave [W/m2]
      real              r1potevap(n0lall)         !! potential evap [kg/m2/s]
      real              r2potevap(0:n0llnd,n0doy) !! potential evap [kg/m2/s]
      real              r1evap(n0lall)            !! evap [kg/m2/s]
      real              r2evap(0:n0llnd,n0doy)    !! evap [kg/m2/s]
c ai202111start
      real              r1fer(n0lall)             !! fer [0-1]
      real              r1car(n0lall)             !! co2 [ppmv]
      real              r2car(0:n0llnd,n0doy)     !! co2 [ppmv]
      real              r1vpd(n0lall)             !! vpd [kPa]
      real              r2vpd(0:n0llnd,n0doy)     !! vpd [kPa]
c ai202111end
      real              r1tcor(n0lall)            !! temperature correction
      character*128     c0tair
      character*128     c0swdown
      character*128     c0potevap
      character*128     c0evap
      character*128     c0tcor             !! temperature correction
c ai202111start
      character*128     c0fer
      character*128     c0car
      character*128     c0vpd
c ai202111end

c state variable (crop)
      real              r1huna(n0lall)     !! heat unit 
      real              r1swu(n0lall)      !! plant transp in latter half
      real              r1swp(n0lall)      !! poten transp in latter half
      real              r1regfw(n0lall)    !! regulating factor is water
      real              r1regfl(n0lall)    !! regulating factor is low temp
      real              r1regfh(n0lall)    !! regulating factor is high temp
      real              r1regfn(n0lall)    !! regulating factor is nitrogen
      real              r1regfp(n0lall)    !! regulating factor is phosphor
      character*128     c0hunaini
      character*128     c0swuini
      character*128     c0swpini
      character*128     c0regfwini
      character*128     c0regflini
      character*128     c0regfhini
      character*128     c0regfnini
      character*128     c0regfpini
c state variable (C)
      real              r1rsd(n0lall)      !! Residual       B [kg/ha]
      real              r1outb(n0lall)     !! Out of system  B [kg/ha]
      character*128     c0rsdini           !! Residual       C [kg/ha]
      character*128     c0outbini          !! Out of system  C [kg/ha]
c out (met)
      real              r2tairout(n0lall,0:n0t)      !! temperature   [K]
      character*128     c0tairout          !! temperature (corrected)
c out (crop calendar)
      real              r1pltdoy(n0lall)        !! planting day of year
      real              r1pltdoymax(n0lall)     !! planting day of year (out)
      real              r2hvsdoy(0:n0llnd,n0doy)!! harvesting day of year (all)
      real              r1hvsdoymax(n0lall)     !! harvesting day of year (out)
      integer           i1crpday(n0lall)        !! cropping days 
      real              r2crpday(0:n0llnd,n0doy)!! cropping days (all)
      real              r1crpdaymax(n0lall)     !! cropping days (out)
      character*128     c0pltdoymax
      character*128     c0hvsdoymax
      character*128     c0crpdaymax
c out (crop model)
      integer           i1flgmat(n0lall)        !! maturity flag
      integer           i2flgmat(0:n0llnd,n0doy)!! maturity flag (all)
      real              r1yld(n0lall)           !! crop yield
      real              r2yld(0:n0llnd,n0doy)   !! crop yield (all )
      real              r1yldmav(n0lall)        !! crop yield (mov avg)
      real              r1yldmax(n0lall)        !! crop yield (out)
      real              r1bt(n0lall)           !! total biomass  B [kg/ha]
      real              r2bt(0:n0llnd,n0doy)   !! total biomass (all )
      real              r1btmav(n0lall)        !! total biomass (mov avg)
      real              r1btmax(n0lall)        !! total biomass (out)
      real              r1cwd(n0lall)           !! crop water demand
      real              r2cwd(0:n0llnd,n0doy)     !! crop water demand (all)
      real              r1cws(n0lall)           !! crop water supply
      real              r2cws(0:n0llnd,n0doy)     !! crop water supply (all)
      real              r1regfd(n0lall)         !! domin regulat factor
      real              r2regfd(0:n0llnd,n0doy)   !! domin regulat factor (all)
      real              r1regfdmax(n0lall)      !! domin regulat factor (out)
      character*128     c0yldmav
      character*128     c0yldmax
      character*128     c0btmav
      character*128     c0btmax
      character*128     c0regfdmax
c
      character*128     c0btini            !! total biomass  C [kg/ha]
c local
      integer           i1all2lnd(n0lall)     !! all grids to land grids
      integer           i1flgcul(n0lall)      !! cultivation flag
      integer           i1flgend(n0lall)
      integer           i1flgocu(n0lall)
c local (crop parameter)
      real              r1icnum(n0ram)     !! id
      real              r1ird(n0ram)       !! land cover category
      real              r1be(n0ram)        !! biomass-energy ratio
      real              r1hvsti(n0ram)     !! harvest index
      real              r1to(n0ram)        !! optimal temperature
      real              r1tb(n0ram)        !! base temperature
      real              r1blai(n0ram)      !! maximum potential LAI
      real              r1dlai(n0ram)      !! fraction of growing season
      real              r1dlp1(n0ram)      !! LAI curve
      real              r1dlp2(n0ram)      !! LAI curve
      real              r1bn1(n0ram)       !! nitrogen
      real              r1bn2(n0ram)       !! nitrogen
      real              r1bn3(n0ram)       !! nitrogen
      real              r1bp1(n0ram)       !! phosphorus
      real              r1bp2(n0ram)       !! phosphorus
      real              r1bp3(n0ram)       !! phosphorus
      real              r1cnyld(n0ram)     !! fraction of N in crop yield
      real              r1cpyld(n0ram)     !! fraction of P in crop yield
      real              r1rdmx(n0ram)      !! maximum plant rooting depth
      real              r1cvm(n0ram)       !! C factor
      real              r1almn(n0ram)      !! minimum LAI
      real              r1sla(n0ram)       !! specific leaf area
      real              r1pt2(n0ram)       !! 2nd point ??
      real              r1phun(n0ram)      !! Potential heat unit
c local (water source)
      real              r1evapgrn(n0lall)
      real              r1evapblu(n0lall)
      real              r1cwsgrn(n0lall)
      real              r1cwsblu(n0lall)
      real              r2cwsgrn(0:n0llnd,n0doy)
      real              r2cwsblu(0:n0llnd,n0doy)
      real              r1cwsgrnmax(n0lall)
      real              r1cwsblumax(n0lall)
      character*128     c0cwsgrnmax
      character*128     c0cwsblumax
c namelist
      character*128     c0setcrp
      namelist           /setcrp/
     $     i0year,     i0secint,   i0ldbg,     i0ramdbg,
     $     i0daymav,   i0crpdaymax,r0regfmin,  r0tdorm,   r0tfrz,
     $     r0hunmax,   r0ihunmat,  r0tsaw,     r0thvs,    c0optts,
     $     c0optws,    c0optns,    c0optps,    c0optlai,
     $     c0optce,    c0optve,    c0optfrz,
     $     c0lndmsk,   c0crptyp,   c0doyocuini,c0doyocuend,
     $     c0ram2swim, c0swim2ram, c0crppar,
     $     c0tair,     c0swdown,   c0potevap,
     $     c0evap,     c0fer,      c0car,      c0vpd,
     $     c0tcor,     c0tairout,
     $     c0hunaini,  c0swuini,   c0swpini,   c0regfwini,
     $     c0regflini, c0regfhini, c0regfnini, c0regfpini,
     $     c0btini,    c0rsdini,   c0outbini,
     $     c0yldmav,   c0yldmax,   c0btmav,    c0btmax,
     $     c0regfdmax,    
     $     c0pltdoymax,c0hvsdoymax,c0crpdaymax,
     $     c0cwsgrnmax,c0cwsblumax
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c state variable (N)
c      real              ranor(n0lall)     !! Active organic N [kg/ha]
c      real              rsnor(n0lall)     !! Stable organic N [kg/ha]
c      real              rfon(n0lall)      !! Fresh  organic N [kg/ha]
c      real              rnmin(n0lall)     !! Mineral        N [kg/ha]
c      real              rvegn(n0lall)     !! Vegetation     N [kg/ha]
c      real              routn(n0lall)     !! Out of system  N [kg/ha]
c      character*128     c0anorini(n0lall) !! Active organic N [kg/ha]
c      character*128     c0snorini(n0lall) !! Stable organic N [kg/ha]
c      character*128     c0fonini(n0lall)  !! Fresh  organic N [kg/ha]
c      character*128     c0nminini(n0lall) !! Mineral        N [kg/ha]
c      character*128     c0vegnini(n0lall) !! Vegetation     N [kg/ha]
c      character*128     c0outnini(n0lall) !! Out of system  N [kg/ha]
c state variable (P)
c      real              rplab(n0lall)     !! Labile mineral P [kg/ha]
c      real              rfop(n0lall)      !! Fresh organic  P [kg/ha]
c      real              rpor(n0lall)      !! Organic        P [kg/ha]
c      real              rpma(n0lall)      !! Active mineral P [kg/ha]
c      real              rpms(n0lall)      !! Stable mineral P [kg/ha]
c      real              rvegp(n0lall)     !! Vegetation     P [kg/ha]
c      real              routp(n0lall)     !! Out of system  P [kg/ha]
c      character*128     c0plabini(n0lall)!! Labile mineral P [kg/ha]
c      character*128     c0fopini(n0lall) !! Fresh organic  P [kg/ha]
c      character*128     c0porini(n0lall) !! Organic        P [kg/ha]
c      character*128     c0pmaini(n0lall) !! Active mineral P [kg/ha]
c      character*128     c0pmsini(n0lall) !! Stable mineral P [kg/ha]
c      character*128     c0vegpini(n0lall)!! Vegetation     P [kg/ha]
c      character*128     c0outpini(n0lall)!! Out of system  P [kg/ha]
c misc (N&P)
c      real              rcnb_pre(n0lall)  !! Optimum N in biomass  [-]
c      real              rcpb_pre(n0lall)  !! Optimum P in biomass  [-]
c fertilizer
c      real              rfertn(n0lall)    !! fertilizer     N [kg/ha/d]
c      real              rfertp(n0lall)    !! fertilizer     P [kg/ha/d]
c      character*128     c0fertn
c      character*128     c0fertp
c misc (H2O)
c      real              r1qtot(n0lall)     !! total runoff        [kg/m2/d]
c      real              r1soiltemp(n0lall) !! ground temp         [K]
c      real              r1soilmoist(n0lall)!! soil moist          [kg/m2]
c      character*128     c0qtot
c      character*128     c0soiltemp
c      character*128     c0soilmoist
c
c      real              r1fc(n0lall)       !! field capacity      [m3/m3]
c      real              r1po(n0lall)       !! saturation capacity [m3/m3]
c      real              r1wp(n0lall)       !! wilting point       [m3/m3]
c      real              r1sd(n0lall)       !! soil depth          [m]
c
c namelist
c     $     c0anorini,c0snorini,c0fonini, c0nminini,
c     $     c0vegnini,c0outnini,
c     $     c0plabini,c0fopini, c0porini,
c     $     c0pmaini, c0pmsini, c0vegpini,c0outpini,
c     $     c0fertn,
c     $     c0fertp,
c     $     r1po,r1fc,r1wp,r1sd
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Get arguments
c - check the number of arguments
c - get arguments
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(iargc().ne.1) then
        write(*,*) 'main_1st c0setcrp'
        stop
      end if
c
      call getarg(1,c0setcrp)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Read namelist
c - read c0setcrp
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      open(15,file=c0setcrp)
      read(15,nml=setcrp)
      close(15)
      write(*,*) 'main: --- Read namelist ---------------------------'
      write(*,nml=setcrp) 
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Read parameter
c - crop id converter (Ramankutty --> SWIM)
c - crop id converter (SWIM --> Ramankutty)
c - crop parameter of SWIM
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      open(n0if,file=c0ram2swim,status='old')
      read(n0if,*) (i1ram2swim(i0ram),i0ram=1,n0ram)
      close(n0if)
d     write(*,*) 'main: --- i1ram2swim ------------------------------'
d     write(*,*) i1ram2swim
c
      open(n0if,file=c0swim2ram,status='old')
      read(n0if,*) (i1swim2ram(i0swim),i0swim=1,n0swim)
      close(n0if)
d     write(*,*) 'main: --- i1swim2ram ------------------------------'
d     write(*,*) i1swim2ram
c
      open(n0if,file=c0crppar,status='old')
      read(n0if,*)
      do i0swim=1,n0swim
        read(n0if,*)
     $    r2crppar(1,i0swim), c0tmp,              r2crppar(2,i0swim),
     $    r2crppar(3,i0swim), r2crppar(4,i0swim), r2crppar(5,i0swim),
     $    r2crppar(6,i0swim), r2crppar(7,i0swim), r2crppar(8,i0swim),
     $    r2crppar(9,i0swim), r2crppar(10,i0swim),r2crppar(11,i0swim),
     $    r2crppar(12,i0swim),r2crppar(13,i0swim),r2crppar(14,i0swim),
     $    r2crppar(15,i0swim),r2crppar(16,i0swim),r2crppar(17,i0swim),
     $    r2crppar(18,i0swim),r2crppar(19,i0swim),r2crppar(20,i0swim),
     $    r2crppar(21,i0swim),r2crppar(22,i0swim),r2crppar(23,i0swim),
     $    r2crppar(24,i0swim),c0tmp
      end do
      close(n0if)
c
      do i0ram=1,n0ram
        r1icnum(i0ram)=r2crppar(1,i1ram2swim(i0ram))
        r1ird(i0ram)=r2crppar(2,i1ram2swim(i0ram))
        r1be(i0ram)=r2crppar(3,i1ram2swim(i0ram))
        r1hvsti(i0ram)=r2crppar(4,i1ram2swim(i0ram))
        r1to(i0ram)=r2crppar(5,i1ram2swim(i0ram))
        r1tb(i0ram)=r2crppar(6,i1ram2swim(i0ram))
        r1blai(i0ram)=r2crppar(7,i1ram2swim(i0ram))
        r1dlai(i0ram)=r2crppar(8,i1ram2swim(i0ram))
        r1dlp1(i0ram)=r2crppar(9,i1ram2swim(i0ram))
        r1dlp2(i0ram)=r2crppar(10,i1ram2swim(i0ram))
        r1bn1(i0ram)=r2crppar(11,i1ram2swim(i0ram))
        r1bn2(i0ram)=r2crppar(12,i1ram2swim(i0ram))
        r1bn3(i0ram)=r2crppar(13,i1ram2swim(i0ram))
        r1bp1(i0ram)=r2crppar(14,i1ram2swim(i0ram))
        r1bp2(i0ram)=r2crppar(15,i1ram2swim(i0ram))
        r1bp3(i0ram)=r2crppar(16,i1ram2swim(i0ram))
        r1cnyld(i0ram)=r2crppar(17,i1ram2swim(i0ram))
        r1cpyld(i0ram)=r2crppar(18,i1ram2swim(i0ram))
        r1rdmx(i0ram)=r2crppar(19,i1ram2swim(i0ram))
        r1cvm(i0ram)=r2crppar(20,i1ram2swim(i0ram))
        r1almn(i0ram)=r2crppar(21,i1ram2swim(i0ram))
        r1sla(i0ram)=r2crppar(22,i1ram2swim(i0ram))
        r1pt2(i0ram)=r2crppar(23,i1ram2swim(i0ram))
        r1phun(i0ram)=r2crppar(24,i1ram2swim(i0ram))
      end do
d     write(*,*) 'main: --- crop parameter --------------------------'
d     write(*,*) 'main: i0ramdbg:',i0ramdbg
d     write(*,*) 'main: r1icnum: ',r1icnum(i0ramdbg)
d     write(*,*) 'main: r1to:    ',r1to(i0ramdbg)
d     write(*,*) 'main: r1tb:    ',r1tb(i0ramdbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Read fixed fields
c - read land mask
c - read crop type
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call read_binary(n0lall,c0crptyp,r1tmp)
      do i0l=1,n0lall
        i1crptyp(i0l)=int(r1tmp(i0l))
      end do
d     write(*,*) 'main: --- crop type -------------------------------'
d     write(*,*) 'main: crptyp',i1crptyp(i0ldbg)
c
      call read_binary(n0lall,c0lndmsk,r1tmp)
      do i0l=1,n0lall
        i1lndmsk(i0l)=int(r1tmp(i0l))
      end do
d     write(*,*) 'main: --- land mask -------------------------------'
d     write(*,*) 'main: lndmsk',i1lndmsk(i0ldbg)
      call read_binary(n0lall,c0doyocuini,r1tmp)
      do i0l=1,n0lall
        i1doyocuini(i0l)=int(r1tmp(i0l))
      end do
d     write(*,*) 'main: --- initial DOY of occupied period ----------'
d     write(*,*) 'main: doyocuini',i1doyocuini(i0ldbg)
      call read_binary(n0lall,c0doyocuend,r1tmp)
      do i0l=1,n0lall
        i1doyocuend(i0l)=int(r1tmp(i0l))
      end do
d     write(*,*) 'main: --- final DOY of occupied period ------------'
d     write(*,*) 'main: doyocuend',i1doyocuend(i0ldbg)
      call read_binary(n0lall,c0fer,r1tmp)
      do i0l=1,n0lall
        r1fer(i0l)=real(r1tmp(i0l))
      end do
d     write(*,*) 'main: --- Toal N fer ------------------------------'                
d     write(*,*) 'main: fer',r1fer(i0ldbg)                       
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Converter
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      i0tmp=1
      do i0l=1,n0lall
        if(i1lndmsk(i0l).eq.1)then
          i1all2lnd(i0l)=i0tmp
          i0tmp=i0tmp+1
        else
          i1all2lnd(i0l)=0
        end if
      end do
d     write(*,*) 'main: --- all2lnd ---------------------------------'
d     write(*,*) 'main: i1all2lnd',i1all2lnd(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Initialize state variables
c - biomass
c - nitrogen
c - phosphorus
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call read_binary(n0lall,c0btini,r1bt)
      call read_binary(n0lall,c0rsdini,r1rsd)
      call read_binary(n0lall,c0outbini,r1outb)
c
c      call read_binary(n0lall,c0anorini,r1anor)
c      call read_binary(n0lall,c0snorini,r1snor)
c      call read_binary(n0lall,c0fonini,r1fon)
c      call read_binary(n0lall,c0nminini,r1nmin)
c      call read_binary(n0lall,c0vegpini,r1vegp)
c      call read_binary(n0lall,c0outnini,r1outn)
c
c      call read_binary(n0lall,c0plabini,r1plab)
c      call read_binary(n0lall,c0fopini,r1fop)
c      call read_binary(n0lall,c0porini,r1por)
c      call read_binary(n0lall,c0pmaini,r1pma)
c      call read_binary(n0lall,c0pmsini,r1pms)
c      call read_binary(n0lall,c0vegpini,r1vegp)
c      call read_binary(n0lall,c0outpini,r1outp)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Read input data
c - air temperature (daily)
c - air temperature correction (yearly)
c - precipitation (yearly)
c - precipitation correction (yearly)
c - potential evapotranspiration (daily)
c - evapotranspiration (daily)
c - shortwave downward radiation (daily)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0mon=1,12
        do i0day=1,igetday(i0year,i0mon)
          i0doy=igetdoy(i0year,i0mon,i0day)
          call read_result(
     $         n0lall,
     $         c0tair, i0year, i0mon,
     $         i0day,  i0sec,  i0secint,
     $         r1tmp)
          if(c0tcor.eq.'NO')then
            do i0l=1,n0lall
              r1tcor(i0l)=0.0
            end do
          else
            call read_result(
     $           n0lall,
     $           c0tcor, i0year, i0mon,
     $           i0day,  i0sec,  i0secint,
     $           r1tcor)
          end if
          do i0l=1,n0lall
            if(r1tmp(i0l).ne.0.0.and.r1tmp(i0l).ne.p0mis)then
              r1tair(i0l)=r1tmp(i0l)+r1tcor(i0l)
            end if
          end do
          do i0l=1,n0lall
            r2tair(i1all2lnd(i0l),i0doy)=r1tair(i0l)
          end do
          c0opt='ave'
          call wrte_bints2(n0lall,n0t,
     $         r1tair,        r2tairout,   c0tairout,
     $         i0year,i0mon,i0day,i0sec,i0secint,c0opt)
        end do
      end do
d     write(*,*) 'main: --- Read Temperature ------------------------'
d     write(*,*) 'main: r2tair: ',
d    $ (r2tair(i1all2lnd(i0ldbg),i0doy),i0doy=1,331,30)
c
      do i0mon=1,12
        do i0day=1,igetday(i0year,i0mon)
          i0doy=igetdoy(i0year,i0mon,i0day)
          call read_result(
     $         n0lall,
     $         c0potevap, i0year, i0mon,
     $         i0day,     i0sec,  i0secint,
     $         r1tmp)
          do i0l=1,n0lall
            r2potevap(i1all2lnd(i0l),i0doy)=r1tmp(i0l)
          end do
        end do
      end do
d       write(*,*) 'main: --- Read Potential Evapotranspiration------'
d       write(*,*) (r2potevap(i1all2lnd(i0ldbg),i0doy),i0doy=1,331,30)
c
      do i0mon=1,12
        do i0day=1,igetday(i0year,i0mon)
          i0doy=igetdoy(i0year,i0mon,i0day)
          call read_result(
     $         n0lall,
     $         c0evap, i0year, i0mon,
     $         i0day,  i0sec,  i0secint,
     $         r1tmp)
          do i0l=1,n0lall
            r2evap(i1all2lnd(i0l),i0doy)=r1tmp(i0l)
          end do
        end do
      end do
d     write(*,*) 'main: --- Read Evapotranspiration -----------------'
d     write(*,*) (r2evap(i1all2lnd(i0ldbg),i0doy),i0doy=1,331,30)
c
      do i0mon=1,12
        do i0day=1,igetday(i0year,i0mon)
          i0doy=igetdoy(i0year,i0mon,i0day)
          call read_result(
     $         n0lall,
     $         c0swdown, i0year, i0mon,
     $         i0day,    i0sec,  i0secint,
     $         r1tmp)
          do i0l=1,n0lall
            r2swdown(i1all2lnd(i0l),i0doy)=r1tmp(i0l)
          end do
        end do
      end do
d     write(*,*) 'main: --- Read Shortwave downward radiation------'
d     write(*,*) (r2swdown(i1all2lnd(i0ldbg),i0doy),i0doy=1,331,30)
      do i0mon=1,12
        do i0day=1,igetday(i0year,i0mon)
          i0doy=igetdoy(i0year,i0mon,i0day)
          call read_result(
     $         n0lall,
     $         c0car, i0year, i0mon,
     $         i0day,    i0sec,  i0secint,
     $         r1tmp)
          do i0l=1,n0lall
            r2car(i1all2lnd(i0l),i0doy)=r1tmp(i0l)
          end do
        end do
      end do
d     write(*,*) 'main: --- Read Co2 concentration-----------------'
d     write(*,*) (r2car(i1all2lnd(i0ldbg),i0doy),i0doy=1,331,30)
      do i0mon=1,12
        do i0day=1,igetday(i0year,i0mon)
          i0doy=igetdoy(i0year,i0mon,i0day)
          call read_result(
     $         n0lall,
     $         c0vpd, i0year, i0mon,
     $         i0day,    i0sec,  i0secint,
     $         r1tmp)
          do i0l=1,n0lall
            r2vpd(i1all2lnd(i0l),i0doy)=r1tmp(i0l)
          end do
        end do
      end do
d     write(*,*) 'main: --- Read vpd--------------------------------'
d     write(*,*) (r2vpd(i1all2lnd(i0ldbg),i0doy),i0doy=1,331,30)  
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Nitrogen fertilizer
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c      if(c0fertn.eq.'NO')then
c        do i0l=1,n0lall
c          r1fertn(i0l)=0.0
c        end do
c      else
c        call read_binary(n0lall,c0fertn,r1fertn)
c      end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Phosphorus fertilizer
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c      if(c0fertp.eq.'NO')then
c        do i0l=1,n0lall
c          r1fertp(i0l)=0.0
c        end do
c      else
c        call read_binary(n0lall,c0fertp,r1fertp)
c      end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Initialize fluxes
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0doy=1,n0doy
        do i0l=1,n0lall
          i2flgmat(i1all2lnd(i0l),i0doy)=0
          r2hvsdoy(i1all2lnd(i0l),i0doy)=0.0
          r2yld(i1all2lnd(i0l),i0doy)=0.0
          r2bt(i1all2lnd(i0l),i0doy)=0.0
          r2crpday(i1all2lnd(i0l),i0doy)=0.0
        end do
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Calculation
c - Loop of planting date
c - Set cultivation flag (1 for cultivating)
c - Loop of cropping date
c - Set day of year (DOY)
c - Cultivation flag
c - Set Tair, PotEvap, Evap, SWdown
c - Call calc_crpyld
c -
c - Special treatment not to allow more than 365 days cropping period
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0pltdoy=1,365
c
        do i0l=1,n0lall
          if(r2tair(i1all2lnd(i0l),i0pltdoy)-p0icepnt.gt.r0tsaw.and.
     $       i1crptyp(i0l).ne.0)then
            i1flgcul(i0l)=1
          else
            i1flgcul(i0l)=0
          end if
        end do
c
        do i0crpday=0,364
c
          do i0l=1,n0lall
            i1crpday(i0l)=i0crpday+1.0
          end do
c
          i0doy=i0pltdoy+i0crpday
          if(i0doy.gt.365)then
            i0doy=i0doy-365
          end if
          write(*,*) 'time:',i0pltdoy,i0crpday,i0doy
c
          i1flgocu=0
          do i0l=1,n0lall
            if(i1doyocuend(i0l).lt.i1doyocuini(i0l))then
              if(i0doy.le.i1doyocuend(i0l).or.
     $           i0doy.ge.i1doyocuini(i0l))then
                i1flgocu(i0l)=1
                if(i0l.eq.i0ldbg)then
                  write(*,*) '[A-1] stop cropping due to overlap'
                end if
              end if
            else if(i1doyocuini(i0l).lt.i1doyocuend(i0l))then
              if(i0doy.ge.i1doyocuini(i0l).and.
     $           i0doy.le.i1doyocuend(i0l))then
                i1flgocu(i0l)=1
                if(i0l.eq.i0ldbg)then
                  write(*,*) '[B-1] stop cropping due to overlap'
                end if
              end if
            end if
          end do
c
          do i0l=1,n0lall
            r1tair(i0l)=r2tair(i1all2lnd(i0l),i0doy)
            r1potevap(i0l)=r2potevap(i1all2lnd(i0l),i0doy)
            r1evap(i0l)=r2evap(i1all2lnd(i0l),i0doy)
            r1swdown(i0l)=r2swdown(i1all2lnd(i0l),i0doy)
            r1car(i0l)=r2car(i1all2lnd(i0l),i0doy)
            r1vpd(i0l)=r2vpd(i1all2lnd(i0l),i0doy)
          end do
d         write(*,*) 'main: r1tair:            ',r1tair(i0ldbg)
d         write(*,*) 'main: r1swdown:          ',r1swdown(i0ldbg)
d         write(*,*) 'main: r1potevap:         ',r1potevap(i0ldbg)
d         write(*,*) 'main: r1evap:            ',r1evap(i0ldbg)
c
          do i0l=1,n0lall
            r1evapgrn(i0l)=r1evap(i0l)
            r1evapblu(i0l)=max(r1potevap(i0l)-r1evap(i0l),0.0)
          end do
c
c
          call calc_crpyld_ai(
     $     n0lall,     n0ram,
     $     i0ldbg,     
     $     i0crpdaymax,r0regfmin, r0tdorm,   r0tfrz,
     $     r0thvs,     r0hunmax,  r0ihunmat, c0optts,
     $     c0optws,    c0optns,   c0optps,   c0optlai,
     $     c0optce,    c0optve,   c0optfrz,
     $     r1icnum,    r1ird,     r1be,      r1hvsti,
     $     r1to,       r1tb,      r1blai,    r1dlai,
     $     r1dlp1,     r1dlp2,    r1bn1,     r1bn2,
     $     r1bn3,      r1bp1,     r1bp2,     r1bp3,
     $     r1cnyld,    r1cpyld,   r1rdmx,    r1cvm,
     $     r1almn,     r1sla,     r1pt2,     r1phun,
     $     i1flgcul,   i1crptyp,  i1crpday,   
     $     r1tair,     r1swdown,  r1potevap, r1evap,
     $     r1car,      r1vpd,      r1fer,    
     $     r1evapgrn,  r1evapblu, 
     $     r1huna,     r1swu,     r1swp,     r1regfw,
     $     r1regfl,    r1regfh,   r1regfn,   r1regfp,
     $     r1bt,       r1rsd,     r1outb,
     $     r1cwd,      r1cws,     r1yld,     r1regfd,
     $     r1cwsgrn,   r1cwsblu,
     $     i1flgmat,   i1flgend,  i1flgocu)
c     
          do i0l=1,n0lall
            if(i1flgmat(i0l).eq.1)then
              r2cwd(i1all2lnd(i0l),i0pltdoy)=r1cwd(i0l)
              r2cws(i1all2lnd(i0l),i0pltdoy)=r1cws(i0l)
              r2cwsgrn(i1all2lnd(i0l),i0pltdoy)=r1cwsgrn(i0l)
              r2cwsblu(i1all2lnd(i0l),i0pltdoy)=r1cwsblu(i0l)
              r2yld(i1all2lnd(i0l),i0pltdoy)=r1yld(i0l)
              r2bt(i1all2lnd(i0l),i0pltdoy)=r1bt(i0l)
              r2regfd(i1all2lnd(i0l),i0pltdoy)=r1regfd(i0l)
              i2flgmat(i1all2lnd(i0l),i0pltdoy)=i1flgmat(i0l)
              r2crpday(i1all2lnd(i0l),i0pltdoy)=real(i1crpday(i0l))
              r2hvsdoy(i1all2lnd(i0l),i0pltdoy)=real(i0doy)
c
              if(i0l.eq.i0ldbg)then
                write(*,*) 'main: i0doy:    ',i0doy
                write(*,*) 'main: r1cwd:    ',r1cwd(i0ldbg)
                write(*,*) 'main: r1cws:    ',r1cws(i0ldbg)
                write(*,*) 'main: r1yld:    ',r1yld(i0ldbg)
                write(*,*) 'main: r1regfd:  ',r1regfd(i0ldbg)
                write(*,*) 'main: i1flgmat: ',i1flgmat(i0ldbg)
                write(*,*) 'main: i1crpday: ',i1crpday(i0ldbg)
              end if
            end if
c
            if(i1flgend(i0l).eq.1)then
              r1cwd(i0l)=0.0
              r1cws(i0l)=0.0
              r1cwsgrn(i0l)=0.0
              r1cwsblu(i0l)=0.0
              r1yld(i0l)=0.0
              r1regfd(i0l)=0.0
              r1bt(i0l)=0.0
              r1rsd(i0l)=0.0
              r1outb(i0l)=0.0
c
              i1crpday(i0l)=0
              i1flgcul(i0l)=0
            end if
          end do
c          
        end do  !! cropping day
      end do    !! planting day
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Moving average
c - initialize arrays
c - moving average (add, divide, write)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0l=1,n0lall
        r1yldmax(i0l)=0.0
        r1btmax(i0l)=0.0
        r1pltdoymax(i0l)=0.0
        r1hvsdoymax(i0l)=0.0
        r1crpdaymax(i0l)=0.0
      end do
c
        do i0l=1,n0lall
          r1yldmav(i0l)=0.0
        end do
        do i0l=1,n0lall
          r1btmav(i0l)=0.0
        end do
c     
      do i0doy=1,365
        do i0day=i0daymav*(-1),i0daymav
          i0doymav=i0doy+i0day
          if(i0doymav.le.0)then
            i0doymav=i0doymav+365
          else if(i0doymav.gt.365)then
            i0doymav=i0doymav-365                  
          end if
          do i0l=1,n0lall
            r1yldmav(i0l)
     $           =r1yldmav(i0l)
     $           +r2yld(i1all2lnd(i0l),i0doymav)
          end do
          do i0l=1,n0lall
            r1btmav(i0l)
     $           =r1btmav(i0l)
     $           +r2bt(i1all2lnd(i0l),i0doymav)
          end do
        end do
c
        do i0l=1,n0lall
          r1yldmav(i0l)=r1yldmav(i0l)/real(i0daymav*2+1)
        end do
        do i0l=1,n0lall
          r1btmav(i0l)=r1btmav(i0l)/real(i0daymav*2+1)
        end do
c
        c0opt='mon'
        i0mon=igetymd(0,i0doy,c0opt)
        c0opt='day'
        i0day=igetymd(0,i0doy,c0opt)
        i0hour=0
        c0ofname=cgetfnt(c0yldmav,i0year,i0mon,i0day,i0hour)
        write(*,*) c0ofname
        call wrte_binary(n0lall,r1yldmav,c0ofname)
        c0ofname=cgetfnt(c0btmav,i0year,i0mon,i0day,i0hour)
        write(*,*) c0ofname
        call wrte_binary(n0lall,r1btmav,c0ofname)
c
        do i0l=1,n0lall
          if(r1yldmav(i0l).gt.r1yldmax(i0l).and.
     $       i2flgmat(i1all2lnd(i0l),i0doy).eq.1)then
            r1yldmax(i0l)=r1yldmav(i0l)
            r1btmax(i0l)=r1btmav(i0l)
            r1pltdoymax(i0l)=real(i0doy)
            r1hvsdoymax(i0l)=r2hvsdoy(i1all2lnd(i0l),i0doy)
            r1crpdaymax(i0l)=r2crpday(i1all2lnd(i0l),i0doy)
            r1cwsgrnmax(i0l)=r2cwsgrn(i1all2lnd(i0l),i0doy)
            r1cwsblumax(i0l)=r2cwsblu(i1all2lnd(i0l),i0doy)
          end if
        end do
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Write
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      i0mon=0
      i0day=0
      i0hour=0
c
c      c0ofname=cgetfnt(c0regfd,i0year,i0mon,i0day,i0hour)
c      write(*,*) c0ofname
c      call wrte_binary(n0lall,r1regfd,c0ofname)
c
      c0ofname=cgetfnt(c0yldmax,i0year,i0mon,i0day,i0hour)
      write(*,*) c0ofname
      call wrte_binary(n0lall,r1yldmax,c0ofname)
c
      c0ofname=cgetfnt(c0btmax,i0year,i0mon,i0day,i0hour)
      write(*,*) c0ofname
      call wrte_binary(n0lall,r1btmax,c0ofname)
c
      c0ofname=cgetfnt(c0pltdoymax,i0year,i0mon,i0day,i0hour)
      write(*,*) c0ofname
      call wrte_binary(n0lall,r1pltdoymax,c0ofname)
c
      c0ofname=cgetfnt(c0hvsdoymax,i0year,i0mon,i0day,i0hour)
      write(*,*) c0ofname
      call wrte_binary(n0lall,r1hvsdoymax,c0ofname)
c
      c0ofname=cgetfnt(c0crpdaymax,i0year,i0mon,i0day,i0hour)
      write(*,*) c0ofname
      call wrte_binary(n0lall,r1crpdaymax,c0ofname)

      c0ofname=cgetfnt(c0cwsgrnmax,i0year,i0mon,i0day,i0hour)
      write(*,*) c0ofname
      call wrte_binary(n0lall,r1cwsgrnmax,c0ofname)
c
      c0ofname=cgetfnt(c0cwsblumax,i0year,i0mon,i0day,i0hour)
      write(*,*) c0ofname
      call wrte_binary(n0lall,r1cwsblumax,c0ofname)
c
      end
