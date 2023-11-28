cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Copyright (c) 2023 Dr. Naota HANASAKI, NIES
c
c Licensed under the Apache License, Version 2.0 (the "License");
c   You may not use this file except in compliance with the License.
c   You may obtain a copy of the License at:
c
c     http://www.apache.org/licenses/LICENSE-2.0
c
c Unless required by applicable law or agreed to in writing, software
c distributed under the License is distributed on an "AS IS" BASIS,
c WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
c either express or implied.
c See the License for the specific language governing permissions and
c limitations under the License.
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      program main
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cto   run land surface model
cby   2010/03/31, hanasaki, NIES: H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      implicit none
c parameter (array)
      integer           n0l              
      integer           n0t              
c     parameter        (n0l=64800)
      parameter        (n0l=259200)
c     parameter        (n0l=11088)
c      parameter        (n0l=32400)
      parameter        (n0t=3) 
c parameter (physical)      
      integer           n0secday         !! seconds in a day [s]
      real              p0sigma          !! Stefan Boltzman const [W m-2 K-4]
      real              p0omega          !! anglular speed of Earth rot [s-1] 
      real              p0icepnt         !! ice point [K]
      real              p0l              !! latent heat water -> vapor [J kg-1]
      real              p0lf             !! latent heat ice -> water [J kg-1]
      real              p0cp             !! heat capacity of air [J kg-1]
      parameter        (n0secday=86400)
      parameter        (p0sigma=5.67e-8)
      parameter        (p0omega=7.27e-5)
      parameter        (p0icepnt=273.15)
      parameter        (p0l=2.50e6)
      parameter        (p0lf=0.333e6)
      parameter        (p0cp=1005)
c parameter (default)
      integer           n0if
      integer           n0of
      real              p0mis            !! missing value
      parameter        (n0if=15) 
      parameter        (n0of=16) 
      parameter        (p0mis=1.0E20) 
c index (array)
      integer           i0l
c index (time)
      integer           i0year           !! year
      integer           i0mon            !! month
      integer           i0day            !! day
      integer           i0sec            !! second
c temporary
      real              r1tmp(n0l)
      character*128     c0opt
c function
      integer           iargc
      integer           igetday
c in (set)
      integer           i0yearmin        !! starting year
      integer           i0yearmax        !! ending year
      integer           i0secint         !! interval [s]
      integer           i0ldbg           !! debugging point
      integer           i0cntc           !! maximum iteration
      integer           i0spnflg         !! spinup flag
      real              r0spnerr         !! spinup error
      real              r0spnrat         !! spinup ratio
      real              r1spn(n0l)
      real              r0engbalc        !! energy inbalance tolerance [W/m2]
      real              r0watbalc        !! water inbalance tolerance [mm/dy]
c in (file: map)
      integer           i1lndmsk(n0l)    !! land mask [-]
      real              r1soildepth(n0l) !! soil depth [m]
      real              r1w_fieldcap(n0l)!! field capacity [m3 m-3]
      real              r1w_wilt(n0l)    !! wilting point [m3 m-3]
      real              r1cg(n0l)        !! volumetric dry soil heat capacity
      real              r1cd(n0l)        !! bulk transfer coefficient [-]
      real              r1gamma(n0l)     !! gamma of subsurface runoff [-]
      real              r1tau(n0l)       !! tau of subsurface runoff [dy]
      real              r1balbedo(n0l)   !! base albedo [-]
cnew start
      real              r1gwdepth(n0l)   !! groundwater depth [m]
      real              r1w_gwyield(n0l) !! groundwater yield [-]
      real              r1gwgamma(n0l)   !! gamma for groundwater [-]
      real              r1gwtau(n0l)     !! tau for groundwater [dy]
      real              r1gwrcf(n0l)     !! groundwater recharge fraction [-]
      real              r1gwrcmax(n0l)   !! groundwater maxim. recharge [-]
cnew end
      character*128     c0lndmsk
      character*128     c0soildepth
      character*128     c0w_fieldcap
      character*128     c0w_wilt
      character*128     c0cg
      character*128     c0cd
      character*128     c0gamma
      character*128     c0tau
      character*128     c0balbedo
cnew start
      character*128     c0gwdepth
      character*128     c0w_gwyield
      character*128     c0gwgamma
      character*128     c0gwtau
      character*128     c0gwrcf
      character*128     c0gwrcmax
cnew end
c in (file: met)
      real              r1wind(n0l)      !! wind speed [m s-1]
      real              r1rainf(n0l)     !! rainfall rate [kg m-2 s-1]
      real              r1snowf(n0l)     !! snowfall rate [kg m-2 s-1]
      real              r1tair(n0l)      !! air temperature [K]
      real              r1qair(n0l)      !! specific humidity [kg kg-1]
      real              r1psurf(n0l)     !! surface pressure [Pa]
      real              r1swdown(n0l)    !! downward shortwave rad [W m-2]
      real              r1lwdown(n0l)    !! downward longwave rad [W m-2]
      real              r1rh(n0l)        !! relative humidity [-]
      real              r1tcor(n0l)       !! temperature correction
      real              r1pcor(n0l)       !! precipitation correction
      real              r1lcor(n0l)      !! longwave correction
      character*128     c0wind
      character*128     c0rainf
      character*128     c0snowf
      character*128     c0tair
      character*128     c0qair
      character*128     c0psurf
      character*128     c0swdown
      character*128     c0lwdown
      character*128     c0rh
      character*128     c0tcor
      character*128     c0pcor
      character*128     c0lcor
c state variables
      real              r1soilmoist(n0l)   !! ave layer soil moisture [kg m-2]
      real              r2soilmoist(n0l,0:n0t)
      real              r1soilmoist_pr(n0l)
      real              r1soiltemp(n0l)   !! ave layer soil temp [K]
      real              r2soiltemp(n0l,0:n0t)
      real              r1soiltemp_pr(n0l)
      real              r1avgsurft(n0l)   !! average surface temperature [K]
      real              r2avgsurft(n0l,0:n0t)
      real              r1avgsurft_pr(n0l)
      real              r1swe(n0l)        !! snow water equivalent [kg m-2]
      real              r2swe(n0l,0:n0t)
      real              r1swe_pr(n0l)
cnew start
      real              r1gw(n0l)         !! ave layer groundwater [kg m-2]
      real              r2gw(n0l,0:n0t)
      real              r1gw_pr(n0l)
cnew end
      character*128     c0soilmoist
      character*128     c0soilmoistini
      character*128     c0soiltemp
      character*128     c0soiltempini
      character*128     c0avgsurft
      character*128     c0avgsurftini
      character*128     c0swe
      character*128     c0sweini
cnew start
      character*128     c0gw
      character*128     c0gwini
cnew end
c out (0:bias correction)
      real              r2rainf(n0l,0:n0t)  !! rainfall rate [kg m-2 s-1]
      real              r2snowf(n0l,0:n0t)  !! snowfall rate [kg m-2 s-1]
      real              r2tair(n0l,0:n0t)   !! air temperature [K]
      real              r2lwdown(n0l,0:n0t) !! longwave [W m-2]
      character*128     c0rainfout          !! Rainf (corrected)
      character*128     c0snowfout          !! Snowf (corrected)
      character*128     c0tairout           !! Tair (corrected)
      character*128     c0lwdownout         !! LWdown (corrected)
c out (1:general energy balance components)
      real              r1swnet(n0l)      !! Net shortwave rad [W m-2] down
      real              r2swnet(n0l,0:n0t)
      real              r1lwnet(n0l)      !! Net longwave rad [W m-2] down
      real              r2lwnet(n0l,0:n0t)
      real              r1qle(n0l)        !! Latent heat flux [W m-2] up
      real              r2qle(n0l,0:n0t)  
      real              r1qh(n0l)         !! Sensible heat flux [W m-2] up
      real              r2qh(n0l,0:n0t)   
      real              r1qg(n0l)         !! Ground heat flux [W m-2] down
      real              r2qg(n0l,0:n0t)   
      real              r1qf(n0l)         !! Energy of fusion [W m-2] s<l
      real              r2qf(n0l,0:n0t)     
      real              r1qv(n0l)         !! Energy of sublimation [W m-2] s<v
      real              r2qv(n0l,0:n0t)     
      character*128     c0swnet
      character*128     c0lwnet
      character*128     c0qle
      character*128     c0qh
      character*128     c0qg
      character*128     c0qf
      character*128     c0qv
c out (2:general water balance components)
      real              r1evap(n0l)      !! evapotranspiration [kg m-2 s-1]
      real              r2evap(n0l,0:n0t)
      real              r1qs(n0l)        !! surface runoff [kg m-2 s-1]
      real              r2qs(n0l,0:n0t)  
      real              r1qsb(n0l)       !! subsurface runoff [kg m-2 s-1]
      real              r2qsb(n0l,0:n0t) 
      real              r1qtot(n0l)      !! total runoff [kg m-2 s-1]
      real              r2qtot(n0l,0:n0t)
      real              r1qsm(n0l)       !! snow melt [kg m-2 s-1]
      real              r2qsm(n0l,0:n0t) 
      real              r1qst(n0l)       !! wat flow out from snow [kg m-2 s-1]
      real              r2qst(n0l,0:n0t) 
      character*128     c0evap
      character*128     c0qs
      character*128     c0qsb
      character*128     c0qtot
      character*128     c0qsm
      character*128     c0qst
c out (3:surface state variables)
      real              r1albedo(n0l)     !! surface albedo [-]
      real              r2albedo(n0l,0:n0t)
      character*128     c0albedo
c out (4:subsurface state variables)
      real              r1soilwet(n0l)    !! soil wetness (wilt=0,sat=1) [-]
      real              r2soilwet(n0l,0:n0t)
      character*128     c0soilwet
c out (5:evaporation components)
      real              r1potevap(n0l)    !! potential evaporation [kg m-2 s-1]
      real              r2potevap(n0l,0:n0t)
      real              r1et(n0l)         !! evapotranspiration [kg m-2 s-1]
      real              r2et(n0l,0:n0t)     
      real              r1subsnow(n0l)    !! snow sublimation [kg m-2 s-1]
      real              r2subsnow(n0l,0:n0t)
      character*128     c0potevap
      character*128     c0subsnow
c out (7:cold season processes)
      real              r1salbedo(n0l)    !! snow albedo [-]
      real              r2salbedo(n0l,0:n0t)
      character*128     c0salbedo
cnew start
c out (8:groundwater processes)
      real              r1qrc(n0l)    !! snow albedo [-]
      real              r2qrc(n0l,0:n0t)
      real              r1qbf(n0l)    !! snow albedo [-]
      real              r2qbf(n0l,0:n0t)
      character*128     c0qrc
      character*128     c0qbf
cnew end
c local
      integer           i1engnotbal(n0l) !!
      integer           i1watnotbal(n0l)
      integer           i1notfin(n0l)
      integer           i0yearmin_dummy
      integer           i0yearmax_dummy
c namelist
      character*128     c0setlnd         !! initial setting file
      namelist         /setlnd/
     $     i0yearmin,     i0yearmax,     i0secint,      i0ldbg,
     $     i0cntc,        i0spnflg,      r0spnerr,      r0spnrat,
     $     r0engbalc,     r0watbalc,     
     $     c0lndmsk,      c0soildepth,   c0w_fieldcap,  c0w_wilt,
     $     c0gwdepth,     c0w_gwyield,
     $     c0cg,          c0cd,
     $     c0gamma,       c0tau,         c0balbedo,
     $     c0gwgamma,     c0gwtau,       c0gwrcf,       c0gwrcmax,
     $     c0wind,        c0rainf,       c0snowf,       c0psurf,
     $     c0tair,        c0qair,        c0lwdown,      c0swdown,
     $     c0rh,          c0tcor,        c0pcor,        c0lcor,
     $     c0tairout,     c0rainfout,    c0snowfout,    c0lwdownout,
     $     c0soilmoist,   c0soiltemp,    c0avgsurft,    c0swe,
     $     c0soilmoistini,c0soiltempini, c0avgsurftini, c0sweini,
     $     c0gw,
     $     c0gwini,
     $     c0swnet,       c0lwnet,       c0qle,         c0qh,
     $     c0qg,          c0qf,          c0qv,
     $     c0evap,        c0qs,          c0qsb,         c0qtot,
     $
     $     
     $     c0potevap,     c0subsnow,     c0salbedo,
     $     c0qrc,         c0qbf
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Get arguments
c - check the number of arguments
c - get arguments
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(iargc().ne.1) then
        write(6, *) 'USAGE: main c0setlnd'
        stop
      end if
c      
      call getarg(1,c0setlnd)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Read namelist
c - read c0setlnd
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      open(15,file=c0setlnd)
      read(15,nml=setlnd)
      close(15)
      write(*,*) 'main: --- Read namelist ---------------------------'
      write(*,nml=setlnd) 
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Read fixed fieleds
c - read land mask
c - read 
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call read_binary(n0l,c0lndmsk,r1tmp)
      do i0l=1,n0l
        i1lndmsk(i0l)=int(r1tmp(i0l))
      end do
      call read_binary(n0l,c0soildepth,r1soildepth)
      call read_binary(n0l,c0w_fieldcap,r1w_fieldcap)
      call read_binary(n0l,c0w_wilt,r1w_wilt)
      call read_binary(n0l,c0cg,r1cg)
      call read_binary(n0l,c0cd,r1cd)
      call read_binary(n0l,c0gamma,r1gamma)
      call read_binary(n0l,c0tau,r1tau)
cnew start
      call read_binary(n0l,c0w_gwyield,r1w_gwyield)
      call read_binary(n0l,c0gwgamma,r1gwgamma)
      call read_binary(n0l,c0gwtau,r1gwtau)
      call read_binary(n0l,c0gwrcf,r1gwrcf)
      call read_binary(n0l,c0gwrcmax,r1gwrcmax)
      call read_binary(n0l,c0gwdepth,r1gwdepth)
cnew end
d     write(*,*) 'main: --- Read fixed fields -----------------------'
d     write(*,*) 'main: ilndmsk:     ',i1lndmsk(i0ldbg)
d     write(*,*) 'main: r1soildepth: ',r1soildepth(i0ldbg)
d     write(*,*) 'main: r1w_fieldcap:',r1w_fieldcap(i0ldbg)
d     write(*,*) 'main: r1w_wilt:    ',r1w_wilt(i0ldbg)
d     write(*,*) 'main: r1gamma:     ',r1gamma(i0ldbg)
d     write(*,*) 'main: r1tau:       ',r1tau(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Initialize state variables
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call read_binary(n0l,c0soilmoistini,r1soilmoist)
      call read_binary(n0l,c0soilmoistini,r1soilmoist_pr)
      call read_binary(n0l,c0soiltempini,r1soiltemp)
      call read_binary(n0l,c0soiltempini,r1soiltemp_pr)
      call read_binary(n0l,c0avgsurftini,r1avgsurft)
      call read_binary(n0l,c0avgsurftini,r1avgsurft_pr)
      call read_binary(n0l,c0sweini,r1swe)
      call read_binary(n0l,c0sweini,r1swe_pr)
cnew start
      call read_binary(n0l,c0gwini,r1gw)
      call read_binary(n0l,c0gwini,r1gw_pr)
cnew end
d     write(*,*) 'main: --- Initialize state variables --------------'
d     write(*,*) 'main: r1soilmoist:',r1soilmoist(i0ldbg)
d     write(*,*) 'main: r1soiltemp: ',r1soiltemp(i0ldbg)
d     write(*,*) 'main: r1avgsurft: ',r1avgsurft(i0ldbg)
d     write(*,*) 'main: r1swe:      ',r1swe(i0ldbg)
cnew start
d     write(*,*) 'main: r1gw:       ',r1gw(i0ldbg)
cnew end
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     Loop (year,mon,it)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
d     write(*,*) 'main: --- Calculation -----------------------------'
 10   do i0l=1,n0l
        r1spn(i0l)=r1soilmoist(i0l)
      end do
c
      if(i0spnflg.eq.0)then
        i0yearmin_dummy=i0yearmin
        i0yearmax_dummy=i0yearmin
      else
        i0yearmin_dummy=i0yearmin
        i0yearmax_dummy=i0yearmax
      end if
c
      do i0year=i0yearmin_dummy,i0yearmax_dummy
        do i0mon=1,12
          do i0day=1,igetday(i0year,i0mon)
            do i0sec=i0secint,n0secday,i0secint
              write(*,*) 'time:',i0year,i0mon,i0day,i0sec
c
              call read_result(
     $             n0l,
     $             c0wind,     i0year,   i0mon,
     $             i0day,      i0sec,    i0secint,
     $             r1wind)
c
              call read_result(
     $             n0l,
     $             c0rainf,    i0year,   i0mon,
     $             i0day,      i0sec,    i0secint,
     $             r1rainf)
              if(c0pcor.eq.'NO')then
                do i0l=1,n0l
                  r1pcor(i0l)=1.0
                end do
              else
                call read_result(
     $               n0l,
     $               c0pcor, i0year, i0mon,
     $               i0day,  i0sec,  i0secint,
     $               r1pcor)
              end if
              do i0l=1,n0l
                if(r1rainf(i0l).ne.p0mis.and.
     $             r1pcor(i0l).ne.p0mis)then
                  r1rainf(i0l)=r1rainf(i0l)*r1pcor(i0l)
                end if
              end do
c
              call read_result(
     $             n0l,
     $             c0snowf,    i0year,   i0mon,
     $             i0day,      i0sec,    i0secint,
     $             r1snowf)
              if(c0pcor.eq.'NO')then
                do i0l=1,n0l
                  r1pcor(i0l)=1.0
                end do
              else
                call read_result(
     $               n0l,
     $               c0pcor, i0year, i0mon,
     $               i0day,  i0sec,  i0secint,
     $               r1pcor)
              end if
              do i0l=1,n0l
                if(r1snowf(i0l).ne.p0mis.and.
     $             r1pcor(i0l).ne.p0mis)then
                  r1snowf(i0l)=r1snowf(i0l)*r1pcor(i0l)
                end if
              end do
c
              call read_result(
     $             n0l,
     $             c0psurf,    i0year,   i0mon,
     $             i0day,      i0sec,    i0secint,
     $             r1psurf)
c
              call read_result(
     $             n0l,
     $             c0tair,     i0year,   i0mon,
     $             i0day,      i0sec,    i0secint,
     $             r1tair)
              if(c0tcor.eq.'NO')then
                do i0l=1,n0l
                  r1tcor(i0l)=0.0
                end do
              else
                call read_result(
     $               n0l,
     $               c0tcor, i0year, i0mon,
     $               i0day,  i0sec,  i0secint,
     $               r1tcor)
              end if
              do i0l=1,n0l
                if(r1tair(i0l).ne.0.0.and.r1tair(i0l).ne.p0mis)then
                  r1tair(i0l)=r1tair(i0l)+r1tcor(i0l)
                end if
              end do
c
              if(c0qair.ne.'NO'.and.c0rh.ne.'NO')then
                write(*,*) 'main: both qair and rh is specified.'
                stop
              else if(c0qair.ne.'NO')then
                call read_result(
     $               n0l,
     $               c0qair,     i0year,   i0mon,
     $               i0day,      i0sec,    i0secint,
     $               r1qair)
              else if(c0rh.ne.'NO')then
                call read_result(
     $               n0l,
     $               c0rh,       i0year,   i0mon,
     $               i0day,      i0sec,    i0secint,
     $               r1rh)
                call conv_rhtoqa(
     $               n0l,
     $               r1rh,r1psurf,r1tair,
     $               r1qair)
              end if
c 
              call read_result(
     $             n0l,
     $             c0swdown,   i0year,   i0mon,
     $             i0day,       i0sec,    i0secint,
     $             r1swdown)
c
              call read_result(
     $             n0l,
     $             c0lwdown,   i0year,   i0mon,
     $             i0day,      i0sec,    i0secint,
     $             r1lwdown)
              if(c0lcor.eq.'NO')then
                do i0l=1,n0l
cnew del                 r1lcor(i0l)=0.0
                  r1lcor(i0l)=1.0
                end do
              else
                call read_result(
     $               n0l,
     $               c0lcor, i0year, i0mon,
     $               i0day,  i0sec,  i0secint,
     $               r1lcor)
              end if
              do i0l=1,n0l
cnew del                r1lwdown(i0l)=r1lwdown(i0l)+r1lcor(i0l)
                if(r1lwdown(i0l).ne.p0mis.and.
     $             r1lcor(i0l).ne.p0mis)then
                  r1lwdown(i0l)=r1lwdown(i0l)*r1lcor(i0l)
                end if
              end do
c
              call read_result(
     $             n0l,
     $             c0balbedo,   i0year,   i0mon,
     $             i0day,      i0sec,    i0secint,
     $             r1balbedo)
c 
              if(c0tcor.ne.'NO')then
                call conv_rstors(
     $               n0l,
     $               r1rainf,r1snowf,r1psurf,r1qair,r1tair)
              end if
c 
d             write(*,*) 'main: r1rainf:  ',r1rainf(i0ldbg)
d             write(*,*) 'main: r1snowf:  ',r1snowf(i0ldbg)
d             write(*,*) 'main: r1tair:   ',r1tair(i0ldbg)
d             write(*,*) 'main: r1qair:   ',r1qair(i0ldbg)
d             write(*,*) 'main: r1lwdown: ',r1lwdown(i0ldbg)
d             write(*,*) 'main: r1swdown: ',r1swdown(i0ldbg)
d             write(*,*) 'main: r1psurf:  ',r1psurf(i0ldbg)
d             write(*,*) 'main: r1wind:   ',r1wind(i0ldbg)
d             write(*,*) 'main: r1balbedo:',r1balbedo(i0ldbg)
      call calc_leakyb(
     $     n0l,
     $     i0secint,     i0ldbg,     i0cntc,        r0engbalc,
     $     r0watbalc,
     $     i1lndmsk,     r1soildepth,r1w_fieldcap,  r1w_wilt,
     $     r1gwdepth,    r1w_gwyield,
     $     r1cg,         r1cd,
     $     r1gamma,      r1tau,      r1balbedo,
     $     r1gwgamma,    r1gwtau,    r1gwrcf,       r1gwrcmax,
     $     r1wind,       r1rainf,    r1snowf,       r1tair,
     $     r1qair,       r1psurf,    r1swdown,      r1lwdown,
     $     r1avgsurft_pr,r1swe_pr,   r1soilmoist_pr,r1soiltemp_pr,
     $     r1gw_pr,
     $     r1swnet,      r1lwnet,    r1qle,         r1qh,
     $     r1qg,         r1qf,       r1qv,
     $     r1evap,       r1qs,       r1qsb,         r1qtot,
     $     r1qsm,        r1qst,
     $     r1qrc,        r1qbf,
     $     r1avgsurft,   r1albedo,   r1swe,
     $     r1soilmoist,  r1soiltemp, r1soilwet,
     $     r1gw,
     $     r1potevap,    r1et,       r1subsnow,
     $     r1salbedo,
     $     i1engnotbal,  i1watnotbal,i1notfin)
c statevariable
              c0opt='sta'
              call wrte_bints2(n0l,n0t,
     $             r1soilmoist,   r2soilmoist, c0soilmoist,
     $             i0year,i0mon,i0day,i0sec,i0secint,c0opt)
              c0opt='sta'
              call wrte_bints2(n0l,n0t,
     $             r1soiltemp,    r2soiltemp,  c0soiltemp,
     $             i0year,i0mon,i0day,i0sec,i0secint,c0opt)
              c0opt='sta'
              call wrte_bints2(n0l,n0t,
     $             r1avgsurft,   r2avgsurft,   c0avgsurft,
     $             i0year,i0mon,i0day,i0sec,i0secint,c0opt)
              c0opt='sta'
              call wrte_bints2(n0l,n0t,
     $             r1swe,         r2swe,       c0swe,
     $             i0year,i0mon,i0day,i0sec,i0secint,c0opt)
cnew start
              c0opt='sta'
              call wrte_bints2(n0l,n0t,
     $             r1gw,          r2gw,        c0gw,
     $             i0year,i0mon,i0day,i0sec,i0secint,c0opt)
cnew end
d             write(*,*) 'main: r1soilmoist:  ',r1soilmoist(i0ldbg)
d             write(*,*) 'main: r1soiltemp:   ',r1soiltemp(i0ldbg)
d             write(*,*) 'main: r1avgsurft:   ',r1avgsurft(i0ldbg)
d             write(*,*) 'main: r1swe:        ',r1swe(i0ldbg)
cnew start
d             write(*,*) 'main: r1gw:         ',r1gw(i0ldbg)
cnew end
c out1
              c0opt='ave'
              call wrte_bints2(n0l,n0t,
     $             r1swnet,       r2swnet,     c0swnet,
     $             i0year,i0mon,i0day,i0sec,i0secint,c0opt)
              c0opt='ave'
              call wrte_bints2(n0l,n0t,
     $             r1lwnet,       r2lwnet,     c0lwnet,
     $             i0year,i0mon,i0day,i0sec,i0secint,c0opt)
              c0opt='ave'
              call wrte_bints2(n0l,n0t,
     $             r1qle,         r2qle,       c0qle,
     $             i0year,i0mon,i0day,i0sec,i0secint,c0opt)
              c0opt='ave'
              call wrte_bints2(n0l,n0t,
     $             r1qh,          r2qh,        c0qh,
     $             i0year,i0mon,i0day,i0sec,i0secint,c0opt)
              c0opt='ave'
              call wrte_bints2(n0l,n0t,
     $             r1qg,          r2qg,        c0qg,
     $             i0year,i0mon,i0day,i0sec,i0secint,c0opt)
              c0opt='ave'
              call wrte_bints2(n0l,n0t,
     $             r1qf,          r2qf,        c0qf,
     $             i0year,i0mon,i0day,i0sec,i0secint,c0opt)
              c0opt='ave'
              call wrte_bints2(n0l,n0t,
     $             r1qv,          r2qv,        c0qv,
     $             i0year,i0mon,i0day,i0sec,i0secint,c0opt)
d             write(*,*) 'main: r1swnet:  ',r1swnet(i0ldbg)
d             write(*,*) 'main: r1lwnet:  ',r1lwnet(i0ldbg)
d             write(*,*) 'main: r1qle:    ',r1qle(i0ldbg)
d             write(*,*) 'main: r1qh:     ',r1qh(i0ldbg)
d             write(*,*) 'main: r1qg:     ',r1qg(i0ldbg)
d             write(*,*) 'main: r1qf:     ',r1qf(i0ldbg)
d             write(*,*) 'main: r1qv:     ',r1qv(i0ldbg)
c out0
              c0opt='ave'
              call wrte_bints2(n0l,n0t,
     $             r1snowf,       r2snowf,     c0snowfout,
     $             i0year,i0mon,i0day,i0sec,i0secint,c0opt)
              c0opt='ave'
              call wrte_bints2(n0l,n0t,
     $             r1rainf,       r2rainf,     c0rainfout,
     $             i0year,i0mon,i0day,i0sec,i0secint,c0opt)
              c0opt='ave'
              call wrte_bints2(n0l,n0t,
     $             r1tair,        r2tair,      c0tairout,
     $             i0year,i0mon,i0day,i0sec,i0secint,c0opt)
              c0opt='ave'
              call wrte_bints2(n0l,n0t,
     $             r1lwdown,      r2lwdown,    c0lwdownout,
     $             i0year,i0mon,i0day,i0sec,i0secint,c0opt)
d             write(*,*) 'main: r1snowf:  ',r1snowf(i0ldbg)
d             write(*,*) 'main: r1rainf:  ',r1rainf(i0ldbg)
c out2
              c0opt='ave'
              call wrte_bints2(n0l,n0t,
     $             r1evap,        r2evap,      c0evap,
     $             i0year,i0mon,i0day,i0sec,i0secint,c0opt)
              c0opt='ave'
              call wrte_bints2(n0l,n0t,
     $             r1qs,          r2qs,        c0qs,
     $             i0year,i0mon,i0day,i0sec,i0secint,c0opt)
              c0opt='ave'
              call wrte_bints2(n0l,n0t,
     $             r1qsb,         r2qsb,       c0qsb,
     $             i0year,i0mon,i0day,i0sec,i0secint,c0opt)
              c0opt='ave'
              call wrte_bints2(n0l,n0t,
     $             r1qtot,        r2qtot,      c0qtot,
     $             i0year,i0mon,i0day,i0sec,i0secint,c0opt)
              c0opt='ave'
              call wrte_bints2(n0l,n0t,
     $             r1qsm,         r2qsm,       c0qsm,
     $             i0year,i0mon,i0day,i0sec,i0secint,c0opt)
d             write(*,*) 'main: r1evap:   ',r1evap(i0ldbg)
d             write(*,*) 'main: r1qs:     ',r1qs(i0ldbg)
d             write(*,*) 'main: r1qsb:    ',r1qsb(i0ldbg)
d             write(*,*) 'main: r1qtot:   ',r1qtot(i0ldbg)
d             write(*,*) 'main: r1qsm:    ',r1qsm(i0ldbg)
c out3
              c0opt='sta'
              call wrte_bints2(n0l,n0t,
     $             r1albedo,      r2albedo,    c0albedo,
     $             i0year,i0mon,i0day,i0sec,i0secint,c0opt)
d             write(*,*) 'main: r1albedo:    ',r1albedo(i0ldbg)
c out4
              c0opt='sta'
              call wrte_bints2(n0l,n0t,
     $             r1soilwet,     r2soilwet,   c0soilwet,
     $             i0year,i0mon,i0day,i0sec,i0secint,c0opt)
d             write(*,*) 'main: r1soilwet:    ',r1soilwet(i0ldbg)
c out5
              c0opt='ave'
              call wrte_bints2(n0l,n0t,
     $             r1potevap,     r2potevap,   c0potevap,
     $             i0year,i0mon,i0day,i0sec,i0secint,c0opt)
              c0opt='ave'
              call wrte_bints2(n0l,n0t,
     $             r1subsnow,     r2subsnow,   c0subsnow,
     $             i0year,i0mon,i0day,i0sec,i0secint,c0opt)
d             write(*,*) 'main: r1potevap:  ',r1potevap(i0ldbg)
d             write(*,*) 'main: r1subsnow:  ',r1subsnow(i0ldbg)
c out 7
              c0opt='sta'
              call wrte_bints2(n0l,n0t,
     $             r1salbedo,     r2salbedo,   c0salbedo,
     $             i0year,i0mon,i0day,i0sec,i0secint,c0opt)
d             write(*,*) 'main: r1salbedo:  ',r1salbedo(i0ldbg)
cnew start
c out 8
              c0opt='ave'
              call wrte_bints2(n0l,n0t,
     $             r1qrc,     r2qrc,   c0qrc,
     $             i0year,i0mon,i0day,i0sec,i0secint,c0opt)
              c0opt='ave'
              call wrte_bints2(n0l,n0t,
     $             r1qbf,     r2qbf,   c0qbf,
     $             i0year,i0mon,i0day,i0sec,i0secint,c0opt)
d             write(*,*) 'main: r1qrc:  ',r1qrc(i0ldbg)
d             write(*,*) 'main: r1qbf:  ',r1qbf(i0ldbg)
cnew end
c
              do i0l=1,n0l
                r1avgsurft_pr(i0l)=r1avgsurft(i0l)
                r1swe_pr(i0l)=r1swe(i0l)
                r1soiltemp_pr(i0l)=r1soiltemp(i0l)
                r1soilmoist_pr(i0l)=r1soilmoist(i0l)
cnew start
                r1gw_pr(i0l)=r1gw(i0l)
cnew end
              end do
c
            end do   !! sec
          end do     !! day
        end do       !! mon
      end do         !! year
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Spinup
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(i0spnflg.eq.0)then
        call calc_spinup(
     $       n0l,         i0ldbg,
     $       r0spnerr,    r0spnrat,
     $       r1soilmoist, r1spn,
     $       i0spnflg)
        if (i0spnflg.eq.0) then
          write(*,*) 'main: Again spin up'
        else
          write(*,*) 'main: End spin up.'
          c0opt='spn'
          call wrte_bints2(n0l,n0t,
     $         r1tmp,       r2soilmoist,  c0soilmoist,
     $         i0yearmin-1,12,31,n0secday,i0secint,
     $         c0opt)
          call wrte_bints2(n0l,n0t,
     $         r1tmp,       r2soiltemp,   c0soiltemp,
     $         i0yearmin-1,12,31,n0secday,i0secint,
     $         c0opt)
          call wrte_bints2(n0l,n0t,
     $         r1tmp,       r2avgsurft,   c0avgsurft,
     $         i0yearmin-1,12,31,n0secday,i0secint,
     $         c0opt)
          call wrte_bints2(n0l,n0t,
     $         r1tmp,       r2swe,        c0swe,
     $         i0yearmin-1,12,31,n0secday,i0secint,
     $         c0opt)
cnew start
          call wrte_bints2(n0l,n0t,
     $         r1tmp,       r2gw,         c0gw,
     $         i0yearmin-1,12,31,n0secday,i0secint,
     $         c0opt)
        end if
cnew end
        go to 10
      end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Message
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0l=1,n0l
        if(i1watnotbal(i0l).gt.0)then
          write(*,*) 'main: i1watnotbal: ',i0l,i1watnotbal(i0l)
        end if
      end do
c
      do i0l=1,n0l
        if(i1engnotbal(i0l).gt.0)then
          write(*,*) 'main: i1engnotbal: ',i0l,i1engnotbal(i0l)
        end if
      end do
c
      do i0l=1,n0l
        if(i1notfin(i0l).gt.0)then
          write(*,*) 'main: i1notfin:    ',i0l,i1notfin(i0l)
        end if
      end do
c
      end
