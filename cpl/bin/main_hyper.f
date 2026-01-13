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
      program main_hyper
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cto   run coupled model
cby   2010/03/31, hanasaki, NIES: H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      implicit none
c parameter (array)
      integer           n0l              
      integer           n0t
      integer           n0m
      integer           n0c
      integer           n0swim             !! Crop type (SWIM,Krysanova 2000)
      integer           n0ram              !! Crop type (Leff et al., 2004)
      integer           n0rec
      parameter        (n0l=32400)
c      parameter        (n0l=64800)
c      parameter        (n0l=5040)
      parameter        (n0t=3) 
      parameter        (n0m=5) 
      parameter        (n0c=2) 
      parameter        (n0swim=71)
      parameter        (n0ram=19)
c      parameter        (n0rec=20)        !! # grids to deliver river water
c      parameter        (n0rec=40)        !! # grids to deliver river water
      parameter        (n0rec=10)        !! # grids to deliver river water
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
      integer           n0if             !! input file
      integer           n0of             !! output file
      real              p0mis            !! missing value
      parameter        (n0if=15) 
      parameter        (n0of=16) 
      parameter        (p0mis=1.0E20) 
c index (array)
      integer           i0l
      integer           i0t
      integer           i0m
      integer           i0c
      integer           i0swim              !! Crop type (SWIM,Krysanova 2000)
      integer           i0ram               !! Crop type (Leff et al., 2004)
      integer           i0rec
c index (time)
      integer           i0year           !! year
      integer           i0mon            !! month
      integer           i0day            !! day
      integer           i0sec            !! second
      integer           i0doy
c temporary
      real              r0tmp
      real              r1tmp(n0l)
      real              r1tmp10(n0l*n0rec)
      character*128     c0tmp
      character*128     s0ave            !! string "ave" (average)
      character*128     s0sta            !! string "sta" (state variables)
      character*128     s0spn            !! string "spn" (spin up)
      character*128     s0sum            !! string "sum" (summation)
      data              s0ave/'ave'/ 
      data              s0sta/'sta'/ 
      data              s0spn/'spn'/ 
      data              s0sum/'sum'/ 
c function
      integer           iargc
      integer           igetday
      integer           igetdoy    !! Function to obtain DOY
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c land
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c in (set of lnd)
      integer           i0yearmin        !! starting year
      integer           i0yearmax        !! ending year
      integer           i0secint         !! interval [s]
      integer           i0ldbg           !! debugging point
      integer           i0cntc           !! maximum iteration
      integer           i0spnflg        !! spinup flag
      real              r0spnerr        !! spinup error
      real              r0spnrat        !! spinup ratio
      real              r1spn(n0l)      !! storage to check spinup
      real              r0engbalc        !! energy inbalance tolerance [W/m2]
      real              r0watbalc        !! water inbalance tolerance [mm/dy]
c in (file: map of lnd)
      integer           i1lndmsk(n0l)    !! land mask [-]
      real              r1soildepth(n0l) !! soil depth [m]
      real              r1w_fieldcap(n0l)!! field capacity [m3 m-3]
      real              r1w_wilt(n0l)    !! wilting point [m3 m-3]
      real              r1cg(n0l)        !! volumetric dry soil heat capacity
      real              r1cd(n0l)        !! bulk transfer coefficient
      real              r1gamma(n0l)     !! gamma of subsurface runoff [-]
      real              r1tau(n0l)       !! tau of subsurface runoff [dy]
      real              r1balbedo(n0l)   !! base albedo [-]
      real              r1rgwdepth(n0l)   !! groundwater depth [m]
      real              r1w_rgwyield(n0l) !! groundwater yield [-]
      real              r1rgwgamma(n0l)   !! gamma for groundwater [-]
      real              r1rgwtau(n0l)     !! tau for groundwater [dy]
      real              r1rgwrcf(n0l)     !! groundwater recharge fraction [-]
      real              r1rgwrcmax(n0l)!! maximum recharge
      character*128     c0lndmsk
      character*128     c0soildepth
      character*128     c0w_fieldcap
      character*128     c0w_wilt
      character*128     c0cg
      character*128     c0cd
      character*128     c0gamma
      character*128     c0tau
      character*128     c0balbedo
      character*128     c0rgwdepth
      character*128     c0w_rgwyield
      character*128     c0rgwgamma
      character*128     c0rgwtau
      character*128     c0rgwrcf
      character*128     c0rgwrcmax
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
      real              r1tcor(n0l)      !! temperature correction
      real              r1pcor(n0l)      !! precipitation correction
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
c state variables (lnd)
      real              r1soilmoist(n0l)  !! ave layer soil moisture [kg m-2]
      real              r3soilmoist(n0l,0:n0t,0:n0m)
      real              r1soilmoist_pr(n0l)
      real              r1soiltemp(n0l)   !! ave layer soil temp [K]
      real              r3soiltemp(n0l,0:n0t,0:n0m)
      real              r1soiltemp_pr(n0l)
      real              r1avgsurft(n0l)   !! average surface temperature [K]
      real              r3avgsurft(n0l,0:n0t,0:n0m)
      real              r1avgsurft_pr(n0l)
      real              r1swe(n0l)        !! snow water equivalent [kg m-2]
      real              r3swe(n0l,0:n0t,0:n0m)
      real              r1swe_pr(n0l)
      real              r1rgw(n0l)         !! ave layer groundwater [kg m-2]
      real              r3rgw(n0l,0:n0t,0:n0m)
      real              r1rgw_pr(n0l)
      character*128     c1soilmoist(0:n0m)
      character*128     c1soilmoistini(0:n0m)
      character*128     c1soiltemp(0:n0m)
      character*128     c1soiltempini(0:n0m)
      character*128     c1avgsurft(0:n0m)
      character*128     c1avgsurftini(0:n0m)
      character*128     c1swe(0:n0m)
      character*128     c1sweini(0:n0m)
      character*128     c1rgw(0:n0m)
      character*128     c1rgwini(0:n0m)
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
      real              r3swnet(n0l,0:n0t,0:n0m)
      real              r1lwnet(n0l)      !! Net longwave rad [W m-2] down
      real              r3lwnet(n0l,0:n0t,0:n0m)
      real              r1qle(n0l)        !! Latent heat flux [W m-2] up
      real              r3qle(n0l,0:n0t,0:n0m)
      real              r1qh(n0l)         !! Sensible heat flux [W m-2] up
      real              r3qh(n0l,0:n0t,0:n0m)
      real              r1qg(n0l)         !! Ground heat flux [W m-2] down
      real              r3qg(n0l,0:n0t,0:n0m)
      real              r1qf(n0l)         !! Energy of fusion [W m-2] s<l
      real              r3qf(n0l,0:n0t,0:n0m)
      real              r1qv(n0l)         !! Energy of sublimation [W m-2] s<v
      real              r3qv(n0l,0:n0t,0:n0m)
      character*128     c1swnet(0:n0m)
      character*128     c1lwnet(0:n0m)
      character*128     c1qle(0:n0m)
      character*128     c1qh(0:n0m)
      character*128     c1qg(0:n0m)
      character*128     c1qf(0:n0m)
      character*128     c1qv(0:n0m)
c out (2:general water balance components)
      real              r1evap(n0l)       !! evapotranspiration [kg m-2 s-1]
      real              r3evap(n0l,0:n0t,0:n0m)
      real              r1qs(n0l)         !! surface runoff [kg m-2 s-1]
      real              r3qs(n0l,0:n0t,0:n0m)
      real              r1qsb(n0l)        !! subsurface runoff [kg m-2 s-1]
      real              r3qsb(n0l,0:n0t,0:n0m)
      real              r1qtot(n0l)       !! total runoff [kg m-2 s-1]
      real              r3qtot(n0l,0:n0t,0:n0m)
      real              r1qsm(n0l)        !! snow melt [kg m-2 s-1]
      real              r3qsm(n0l,0:n0t,0:n0m)
      real              r1qst(n0l)        !! wat flow out from snow[kg m-2 s-1]
      real              r3qst(n0l,0:n0t,0:n0m)
      character*128     c1evap(0:n0m)
      character*128     c1qs(0:n0m)
      character*128     c1qsb(0:n0m)
      character*128     c1qtot(0:n0m)
      character*128     c1qsm(0:n0m)
      character*128     c1qst(0:n0m)
c out (3:surface state variables)
      real              r1albedo(n0l)      !! surface albedo [-]
      real              r3albedo(n0l,0:n0t,0:n0m)
      character*128     c1albedo(0:n0m)
c out (4: subsurface state variables)
      real              r1soilwet(n0l)     !! soil wetness (wilt=0,sat=1) [-]
      real              r3soilwet(n0l,0:n0t,0:n0m)
      character*128     c1soilwet(0:n0m)
c out (5:evaporation components)
      real              r1potevap(n0l)     !! potential evap [kg m-2 s-1]
      real              r3potevap(n0l,0:n0t,0:n0m)
      real              r1et(n0l)          !! evapotranspiration [kg m-2 s-1]
      real              r3et(n0l,0:n0t,0:n0m)
      real              r1subsnow(n0l)     !! snow sublimation [kg m-2 s-1]
      real              r3subsnow(n0l,0:n0t,0:n0m)
      character*128     c1potevap(0:n0m)
      character*128     c1et(0:n0m)
      character*128     c1subsnow(0:n0m)
c out (7:cold season processes)
      real              r1salbedo(n0l)     !! snow albedo [-]
      real              r3salbedo(n0l,0:n0t,0:n0m)
      character*128     c1salbedo(0:n0m)
c out (8:groundwater processes)
      real              r1qrc(n0l)    !! rgw recharge
      real              r3qrc(n0l,0:n0t,0:n0m)
      real              r1qbf(n0l)    !! baseflow
      real              r3qbf(n0l,0:n0t,0:n0m)
      character*128     c1qrc(0:n0m)
      character*128     c1qbf(0:n0m)
c local (lnd)
      integer           i1engnotbal(n0l) !! counter for energy inbalance
      integer           i1watnotbal(n0l) !! counter for water inbalance
      integer           i1notfin(n0l)    !! counter for iteration exceed cntmax
      integer           i0yearmin_dummy  !! year
      integer           i0yearmax_dummy  !! year
c namelist (lnd)
      character*128     c0setlnd         !! initial setting file
      namelist         /setlnd/
     $     i0yearmin,     i0yearmax,     i0secint,      i0ldbg,
     $     i0cntc,        i0spnflg,      r0spnerr,      r0spnrat,
     $     r0engbalc,     r0watbalc,
     $     c0lndmsk,      c0soildepth,   c0w_fieldcap,  c0w_wilt,
     $     c0rgwdepth,     c0w_rgwyield,
     $     c0cg,          c0cd,
     $     c0gamma,       c0tau,         c0balbedo,
     $     c0rgwgamma,     c0rgwtau,       c0rgwrcf,       c0rgwrcmax,
     $     c0wind,        c0rainf,       c0snowf,       c0psurf,
     $     c0tair,        c0qair,        c0lwdown,      c0swdown,
     $     c0rh,          c0tcor,        c0pcor,        c0lcor,
     $     c0tairout,     c0rainfout,    c0snowfout,    c0lwdownout,
     $     c1soilmoist,   c1soiltemp,    c1avgsurft,    c1swe,
     $     c1soilmoistini,c1soiltempini, c1avgsurftini, c1sweini,
     $     c1rgw,
     $     c1rgwini,
     $     c1swnet,       c1lwnet,       c1qle,         c1qh,
     $     c1qg,          c1qf,          c1qv,
     $     c1evap,        c1qs,          c1qsb,         c1qtot,
     $     c1qsm,         c1qst,
     $     c1albedo,      c1soilwet,     
     $     c1potevap,     c1et,          c1subsnow,     c1salbedo,
     $     c1qrc,         c1qbf
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c river 
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c in (file of riv)
      real              r1rivseq(n0l)   !! river sequence [-]
      real              r1rivnxl(n0l)   !! next grid [-]
      real              r1rivnxd(n0l)   !! distance to next grid [m]

      real              r1flwvel(n0l)   !! flow velocity [m/s]
      real              r1medrat(n0l)   !! meandering ratio [-]

      character*128     c0rivseq        !! river sequence
      character*128     c0rivnxl        !! index of next grid
      character*128     c0rivnxd        !! distance to next grid

      character*128     c0flwvel        !! flow velocity
      character*128     c0medrat        !! meandering ratio
      character*128     c0qtot          !! not used except for namelist
c state variables (riv)
      real              r1rivsto(n0l)   !! river storage [kg]
      real              r2rivsto(n0l,0:n0t)!! river storage [kg]
      real              r1rivsto_pr(n0l)!! river storage of previous ts [kg]
      character*128     c0rivsto        !! river storage
      character*128     c0rivstoini     !! initial river storage
c out (flux of riv)
      real              r1rivout(n0l)   !! discharge [kg/s]
      real              r2rivout(n0l,0:n0t)!! discharge [kg/s]
      character*128     c0dis           !! river discharge
c local (riv)

      integer           i0rivnxl
      real              r0rivseqmax     !! river sequence maximum [-]
      real              r1paramc(n0l)   !! parameter c [1/s]
      real              r1rivinf(n0l)   !! river inflow [kg/s]

c namelist
      character*128     c0setriv        !! setting file for river model
      character*128     c0lndara
      namelist         /setriv/ c0qtot,   c0rivstoini,
     $                          c0rivsto, c0dis,
     $                          c0rivseq, c0rivnxl,
     $                          c0rivnxd, c0lndara,
     $                          c0flwvel, c0medrat,
     $                          i0ldbg,   i0secint,
     $                          i0yearmin,i0yearmax,
     $                          i0spnflg, r0spnerr,
     $                          r0spnrat
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c crop
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c input (set)
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
      character*128     c0optfrz          !! Option for freeze killer
c input (file: map)
      integer           i1ram2swim(n0ram)
      integer           i1swim2ram(n0swim)
      real              r2crppar(24,n0swim)
      character*128     c0ram2swim
      character*128     c0swim2ram
      character*128     c0crppar
c input (file: met)
      integer           i1flgcul(n0l)
      integer           i1crptyp(n0l)
      real              r2swdown(n0l,0:n0t)  !! short wave [W/m2]
c state variable (crop)
      real              r1huna(n0l)       !! heat unit
      real              r2huna(n0l,0:n0m) !! heat unit
      real              r1swu(n0l)        !! plant transp in latter half
      real              r2swu(n0l,0:n0m)  !! plant transp in latter half
      real              r1swp(n0l)        !! poten transp in latter half
      real              r2swp(n0l,0:n0m)  !! poten transp in latter half
      real              r1regfw(n0l)      !! regulating factor is water
      real              r2regfw(n0l,0:n0m)!! regulating factor is water
      real              r1regfl(n0l)      !! regulating factor is low temp
      real              r2regfl(n0l,0:n0m)!! regulating factor is low temp
      real              r1regfh(n0l)      !! regulating factor is high temp
      real              r2regfh(n0l,0:n0m)!! regulating factor is high temp
      real              r1regfn(n0l)      !! regulating factor is nitrogen
      real              r2regfn(n0l,0:n0m)!! regulating factor is nitrogen
      real              r1regfp(n0l)      !! regulating factor is phosphor
      real              r2regfp(n0l,0:n0m)!! regulating factor is phosphor
      character*128     c1hunaini(0:n0m)
      character*128     c1swuini(0:n0m)
      character*128     c1swpini(0:n0m)
      character*128     c1regfwini(0:n0m)
      character*128     c1regflini(0:n0m)
      character*128     c1regfhini(0:n0m)
      character*128     c1regfnini(0:n0m)
      character*128     c1regfpini(0:n0m)
c state variable (C)
      real              r1bt(n0l)         !! total biomass  B [kg/ha]
      real              r2bt(n0l,0:n0m)   !! total biomass  B [kg/ha]
      real              r1rsd(n0l)        !! Residual       B [kg/ha]
      real              r2rsd(n0l,0:n0m)  !! Residual       B [kg/ha]
      real              r1outb(n0l)       !! Out of system  B [kg/ha]
      real              r2outb(n0l,0:n0m) !! Out of system  B [kg/ha]
      character*128     c1btini(0:n0m)    !! total biomass  C [kg/ha]
      character*128     c1rsdini(0:n0m)   !! Residual       C [kg/ha]
      character*128     c1outbini(0:n0m)  !! Out of system  C [kg/ha]
c out (crop calendar)
c      real              r2hvsdoy(n0l,0:n0m)!! hvst day of year (all)
      real              r2hvsdoyout1st(n0l,0:n0m)!! hvst day of year (all)
      real              r3hvsdoyout1st(n0l,0:n0t,0:n0m)!! hvst day of year (all
      real              r2hvsdoyout2nd(n0l,0:n0m)!! hvst day of year (all)
      real              r3hvsdoyout2nd(n0l,0:n0t,0:n0m)!! hvst day of year (all
      integer           i1crpday(n0l)        !! cropping days
      real              r2crpday(n0l,0:n0m)!! cropping days (all)
      real              r2crpdayout1st(n0l,0:n0m)!! cropping days (all)
      real              r3crpdayout1st(n0l,0:n0t,0:n0m)!! cropping days (all)
      real              r2crpdayout2nd(n0l,0:n0m)!! cropping days (all)
      real              r3crpdayout2nd(n0l,0:n0t,0:n0m)!! cropping days (all)
      character*128     c1hvsdoyout1st(0:n0m)
      character*128     c1crpdayout1st(0:n0m)
      character*128     c1hvsdoyout2nd(0:n0m)
      character*128     c1crpdayout2nd(0:n0m)
c out (crop model)
      integer           i1flgmat(n0l)        !! maturity flag
      integer           i1flgend(n0l)        !! cropping end flag
      integer           i1flgocu(n0l)        !! cropping period overlap
      real              r1yld(n0l)           !! crop yield
      real              r2yld(n0l,0:n0m)     !! crop yield
      real              r2yldout1st(n0l,0:n0m)  !! crop yield
      real              r3yldout1st(n0l,0:n0t,0:n0m)  !! crop yield
      real              r2yldout2nd(n0l,0:n0m)  !! crop yield
      real              r3yldout2nd(n0l,0:n0t,0:n0m)  !! crop yield
      real              r1cwd(n0l)           !! crop water demand
      real              r2cwd(n0l,0:n0m)     !! crop water demand
      real              r2cwdout1st(n0l,0:n0m)  !! crop water demand
      real              r3cwdout1st(n0l,0:n0t,0:n0m)  !! crop water demand
      real              r2cwdout2nd(n0l,0:n0m)  !! crop water demand
      real              r3cwdout2nd(n0l,0:n0t,0:n0m)  !! crop water demand
      real              r1cws(n0l)           !! crop water supply
      real              r2cws(n0l,0:n0m)     !! crop water supply
      real              r2cwsout1st(n0l,0:n0m)  !! crop water supply
      real              r3cwsout1st(n0l,0:n0t,0:n0m)  !! crop water supply
      real              r2cwsout2nd(n0l,0:n0m)  !! crop water supply
      real              r3cwsout2nd(n0l,0:n0t,0:n0m)  !! crop water supply
      real              r1regfd(n0l)         !! domin regulat factor
      real              r2regfd(n0l,0:n0m)   !! domin regulat factor
      real              r2regfdout1st(n0l,0:n0m)!! domin regulat factor
      real              r3regfdout1st(n0l,0:n0t,0:n0m)!! domin regulat factor
      real              r2regfdout2nd(n0l,0:n0m)!! domin regulat factor
      real              r3regfdout2nd(n0l,0:n0t,0:n0m)!! domin regulat factor
      character*128     c1yldout1st(0:n0m)
      character*128     c1cwdout1st(0:n0m)
      character*128     c1cwsout1st(0:n0m)
      character*128     c1regfdout1st(0:n0m)
      character*128     c1yldout2nd(0:n0m)
      character*128     c1cwdout2nd(0:n0m)
      character*128     c1cwsout2nd(0:n0m)
      character*128     c1regfdout2nd(0:n0m)
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
      real              r1cwsgrn(n0l)
      real              r2cwsgrn(n0l,0:n0m)
      real              r2cwsout1stgrn(n0l,0:n0m)
      real              r3cwsout1stgrn(n0l,0:n0t,0:n0m)
      real              r2cwsout2ndgrn(n0l,0:n0m)
      real              r3cwsout2ndgrn(n0l,0:n0t,0:n0m)
      character*128     c1cwsout1stgrn(0:n0m)
      character*128     c1cwsout2ndgrn(0:n0m)
      real              r1cwsblu(n0l)
      real              r2cwsblu(n0l,0:n0m)
      real              r2cwsout1stblu(n0l,0:n0m)
      real              r3cwsout1stblu(n0l,0:n0t,0:n0m)
      real              r2cwsout2ndblu(n0l,0:n0m)
      real              r3cwsout2ndblu(n0l,0:n0t,0:n0m)
      character*128     c1cwsout1stblu(0:n0m)
      character*128     c1cwsout2ndblu(0:n0m)
c namelist
      character*128     c0setcrp
      namelist           /setcrp/
     $     i0crpdaymax,  r0regfmin,    r0tdorm,      r0tfrz,
     $     r0hunmax,     r0ihunmat,    r0tsaw,       r0thvs,
     $     c0optts,
     $     c0optws,      c0optns,      c0optps,      c0optfrz,
     $     c0ram2swim,   c0swim2ram,   c0crppar,
     $     c1hunaini,    c1swuini,     c1swpini,     c1regfwini,
     $     c1regflini,   c1regfhini,   c1regfnini,   c1regfpini,
     $     c1btini,      c1rsdini,     c1outbini,
     $     c1yldout1st,  c1cwdout1st,  c1cwsout1st,  c1regfdout1st,
     $     c1yldout2nd,  c1cwdout2nd,  c1cwsout2nd,  c1regfdout2nd,
     $     c1hvsdoyout1st, c1crpdayout1st,
     $     c1hvsdoyout2nd, c1crpdayout2nd,
     $     c1cwsout1stgrn,c1cwsout1stblu,
     $     c1cwsout2ndgrn,c1cwsout2ndblu
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c dam and original
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c in (set, irrigation)
      integer           i0dayadvirg
      real              r0fctpad
      real              r0fctnonpad
      character*128     c1optlnduse(n0m)
c in (set, dam)
      real              r0knorm
      character*128     c0optkrls
      character*128     c0optdamrls
      character*128     c0optdamwbc
      character*128     c0damalc
c in (set, withdrawal)
      character*128     c0optnnb     !! option (source separation)
      character*128     c0optriv     !! option (river)
      character*128     c0optrgw      !! option (groundwater)
      character*128     c0optdes     !! option (desalination)
      character*128     c0optrcl     !! option (recycle water)
      character*128     c0opthvsdoy
c in (map, irrigation)
      integer           i2pltdoyp(n0l,n0c)  !! for paddy
      integer           i2hvsdoyp(n0l,n0c)  !! for paddy
      integer           i2crptypp(n0l,n0c)  !! for paddy
      integer           i2pltdoyf(n0l,n0c)  !! for field
      integer           i2hvsdoyf(n0l,n0c)  !! for field
      integer           i2crptypf(n0l,n0c)  !! for field

      real              r1lndara(n0l)
      real              r2arafrc(n0l,n0m)!! areal fraction
      character*128     c1pltdoyp(n0c)
      character*128     c1hvsdoyp(n0c)
      character*128     c1crptypp(n0c)
      character*128     c1pltdoyf(n0c)
      character*128     c1hvsdoyf(n0c)
      character*128     c1crptypf(n0c)
c
      character*128     c1arafrc(n0m)
c in (map, withdrawal)
      real              r1msrcap(n0l)
      real              r1msrafc(n0l)
      real              r1demind(n0l)
      real              r1demdom(n0l)
      real              r1envflw(n0l)
      character*128     c0msrcap     !! capacity of medium sized reservoirs
      character*128     c0msrafc     !! areal fraction of medium sized res.
      character*128     c0demind     !! industrial water demand
      character*128     c0demdom     !! domestic water demand
      character*128     c0envflw     !! environmental flow
c in (map, dam)
      integer           i1damid_(n0l)
      integer           i1damprp(n0l)
      integer           i11stmon(n0l)
      real              r1damcap(n0l)
      real              r1damsrf(n0l)
      real              r1demagrfix(n0l)
      real              r1rivoutfix(n0l)
      character*128     c0damid_     !! id of large reservoir
      character*128     c0damprp     !! purpose of large reservoir
      character*128     c01stmon     !! 1st month of operating year
      character*128     c0damcap     !! capacity of large reservoir
      character*128     c0damsrf
      character*128     c0demagrfix  !! agricultural water demand
      character*128     c0rivoutfix
c in (map, Hanasaki et al. 2018)
      integer           i2lcan(n0l,n0rec)
      integer           i1despot(n0l)
      integer           i1rclpot(n0l)
      real              r1irgeffs(n0l)
      real              r1irgeffg(n0l)
      real              r1irglos(n0l)
      real              r1indeff(n0l)
      real              r1domeff(n0l)
      character*128     c0lcan
      character*128     c0despot
      character*128     c0rclpot
      character*128     c0irgeffs
      character*128     c0irgeffg
      character*128     c0irglos
      character*128     c0indeff
      character*128     c0domeff
c state variables (withdrawal)
      real              r1msrsto(n0l)
      real              r2msrsto(n0l,0:n0t)
      character*128     c0msrsto      !! storage of  medium sized reservoirs
      character*128     c0msrstoini
c state variables (dam)
      real              r1damsto(n0l) !! reservoir storage
      real              r2damsto(n0l,0:n0t)
      character*128     c0damsto      !! reservoir storage
      character*128     c0damstoini
c out (irrigation)
      real              r1supagr(n0l)
      real              r2supagr(n0l,0:n0t)
      real              r1demagr(n0l)
      real              r3demagr(n0l,0:n0t,0:n0m)
      character*128     c0supagr
      character*128     c1demagr(0:n0m)
c out (withdrawal)
      real              r1msrinf(n0l) !! medium size reservoir inflow
      real              r2msrinf(n0l,0:n0t)
      real              r1msrout(n0l) !! medium size reservoir outflow
      real              r2msrout(n0l,0:n0t)
      character*128     c0msrinf      !! inflow of  medium sized reservoirs
      character*128     c0msrout      !! outflow of medium sized reservoirs
c out (dam)
      real              r1daminf(n0l) !! reservoir inflow
      real              r2daminf(n0l,0:n0t)
      real              r1damout(n0l) !! reservoir outflow
      real              r2damout(n0l,0:n0t)
      real              r1damdem(n0l)
      real              r2damdem(n0l,0:n0t)
      character*128     c0daminf      !! reservoir inflow
      character*128     c0damout      !! reservoir outflow
      character*128     c0damdem      !! water demand for individual res.
c out (withdrawal)
      real              r1supind(n0l)     !! industrial water supply
      real              r2supind(n0l,0:n0t)
      real              r1supdom(n0l)     !! domestic water supply
      real              r2supdom(n0l,0:n0t)
      real              r1supagrriv(n0l)  !! agricultural water supply (river)
      real              r2supagrriv(n0l,0:n0t)
      real              r1supindriv(n0l)  !! industrial water supply (river)
      real              r2supindriv(n0l,0:n0t)
      real              r1supdomriv(n0l)  !! domestic water supply (river)
      real              r2supdomriv(n0l,0:n0t)
      real              r1supagrcan(n0l)  !! agricultural water supply (can)
      real              r2supagrcan(n0l,0:n0t)
      real              r1supindcan(n0l)  !! industrial water supply (can)
      real              r2supindcan(n0l,0:n0t)
      real              r1supdomcan(n0l)  !! domestic water supply (can)
      real              r2supdomcan(n0l,0:n0t)
      real              r1supagrrgw(n0l)   !! agricultural water supply (rgw)
      real              r2supagrrgw(n0l,0:n0t)
      real              r1supindrgw(n0l)   !! industrial water supply (rgw)
      real              r2supindrgw(n0l,0:n0t)
      real              r1supdomrgw(n0l)   !! domestic water supply (rgw)
      real              r2supdomrgw(n0l,0:n0t)
      real              r1supagrmsr(n0l)  !! agricult water supply (medium)
      real              r2supagrmsr(n0l,0:n0t)
      real              r1supindmsr(n0l)  !! industrial water supply (medium)
      real              r2supindmsr(n0l,0:n0t)
      real              r1supdommsr(n0l)  !! domestic water supply (medium)
      real              r2supdommsr(n0l,0:n0t)
      real              r1supagrnnbs(n0l)  !! agricult water supply (NNBW)
      real              r2supagrnnbs(n0l,0:n0t)
      real              r1supindnnbs(n0l)  !! industrial water supply (NNBW)
      real              r2supindnnbs(n0l,0:n0t)
      real              r1supdomnnbs(n0l)  !! domestic water supply (NNBW)
      real              r2supdomnnbs(n0l,0:n0t)
      real              r1supagrnnbg(n0l)  !! agricult water supply (NNBW)
      real              r2supagrnnbg(n0l,0:n0t)
      real              r1supindnnbg(n0l)  !! industrial water supply (NNBW)
      real              r2supindnnbg(n0l,0:n0t)
      real              r1supdomnnbg(n0l)  !! domestic water supply (NNBW)
      real              r2supdomnnbg(n0l,0:n0t)
      real              r1frcgwagr(n0l)
      real              r1frcgwind(n0l)
      real              r1frcgwdom(n0l)
      character*128     c0frcgwagr
      character*128     c0frcgwind
      character*128     c0frcgwdom
      real              r1supagrdes(n0l)  !! agricultural water supply (desal)
      real              r2supagrdes(n0l,0:n0t)
      real              r1supinddes(n0l)  !! industrial water supply (desal)
      real              r2supinddes(n0l,0:n0t)
      real              r1supdomdes(n0l)  !! domestic water supply (desal)
      real              r2supdomdes(n0l,0:n0t)
      real              r1supagrrcl(n0l)  !! agricultural water supply (recyl)
      real              r2supagrrcl(n0l,0:n0t)
      real              r1supindrcl(n0l)  !! industrial water supply (recyl)
      real              r2supindrcl(n0l,0:n0t)
      real              r1supdomrcl(n0l)  !! domestic water supply (recyl)
      real              r2supdomrcl(n0l,0:n0t)
      real              r1supagrdef(n0l)  !! agricultural water supply (def)
      real              r2supagrdef(n0l,0:n0t)
      real              r1supinddef(n0l)  !! industrial water supply (def)
      real              r2supinddef(n0l,0:n0t)
      real              r1supdomdef(n0l)  !! domestic water supply (deficit)
      real              r2supdomdef(n0l,0:n0t)
      real              r1losagr(n0l)
      real              r2losagr(n0l,0:n0t)
      real              r1rtfagr(n0l)
      real              r2rtfagr(n0l,0:n0t)
      real              r1rtfind(n0l)
      real              r2rtfind(n0l,0:n0t)
      real              r1rtfdom(n0l)
      real              r2rtfdom(n0l,0:n0t)
      character*128     c0supind     !! industrial water supply
      character*128     c0supdom     !! domestic water supply
      character*128     c0supagrriv  !! agricultural water supply (river)
      character*128     c0supindriv  !! industrial water supply (river)
      character*128     c0supdomriv  !! domestic water supply (river)
      character*128     c0supagrcan  !! agricultural water supply (canal)
      character*128     c0supindcan  !! industrial water supply (canal)
      character*128     c0supdomcan  !! domestic water supply (canal)
      character*128     c0supagrrgw  !! agricultural water supply (rgw)
      character*128     c0supindrgw  !! industrial water supply (rgw)
      character*128     c0supdomrgw  !! domestic water supply (rgw)
      character*128     c0supagrmsr  !! agricultural water supply (medium)
      character*128     c0supindmsr  !! industrial water supply (medium)
      character*128     c0supdommsr  !! domestic water supply (medium)
      character*128     c0supagrnnbs  !! agricultural water supply (NNBW)
      character*128     c0supindnnbs  !! industrial water supply (NNBW)
      character*128     c0supdomnnbs  !! domestic water supply (NNBW)
      character*128     c0supagrnnbg  !! agricultural water supply (NNBW)
      character*128     c0supindnnbg  !! industrial water supply (NNBW)
      character*128     c0supdomnnbg  !! domestic water supply (NNBW)
      character*128     c0supagrdes  !! agricultural water supply (desal)
      character*128     c0supinddes  !! industrial water supply (desal)
      character*128     c0supdomdes  !! domestic water supply (desal)
      character*128     c0supagrrcl  !! agricultural water supply (recycle)
      character*128     c0supindrcl  !! industrial water supply (recycle)
      character*128     c0supdomrcl  !! domestic water supply (recycle)
      character*128     c0supagrdef  !! agricultural water supply (deficit)
      character*128     c0supinddef  !! industrial water supply (deficit)
      character*128     c0supdomdef  !! domestic water supply (deficit)
      character*128     c0losagr     !! loss during delivery
      character*128     c0rtfagr     !! returnflow (agriculture)
      character*128     c0rtfind     !! returnflow (industry
      character*128     c0rtfdom     !! returnflow (domestic)
c local (dam)
      integer           i0damid_
      integer           i0damprp
      integer           i01stmon
      integer           i0flgkrls
      real              r0rivout
      real              r0damcap
      real              r0damsrf
      real              r0daminf
      real              r0damdem
      real              r0damdemfix
      real              r0damsto
      real              r0damout
      real              r0krls
      real              r1damdemfix(n0l)
      real              r1krls(n0l)

      real              r2krls(n0l,0:n0t)
      character*128     c0krls
c local (irrigation)
      integer           i2flgculp(n0l,n0c)       !! flgcul is not mosaic-wise
      integer           i2flgculf(n0l,n0c)       !! flgcul is not mosaic-wise
c
      integer           i2flgculkillerp(n0l,n0c) !! flgculkiller reset flgcul 
      integer           i2flgculkillerf(n0l,n0c) !! flgculkiller reset flgcul 
c
      integer           i2flgirgp(n0l,n0c)       !! after the mosaic-loop.
      integer           i2flgirgf(n0l,n0c)       !! after the mosaic-loop.
      integer           i1flg2nd(n0l)
      real              r2target(n0l,n0c)
      real              r2targetp(n0l,n0c)
      real              r2targetf(n0l,n0c)
c local (soil moisture)
      real              r1frcsoilmoistgrn(n0l)
      real              r3frcsoilmoistgrn(n0l,0:n0t,0:n0m)
      real              r1frcsoilmoistriv(n0l)
      real              r3frcsoilmoistriv(n0l,0:n0t,0:n0m)
      real              r1frcsoilmoistmsr(n0l)
      real              r3frcsoilmoistmsr(n0l,0:n0t,0:n0m)
      real              r1frcsoilmoistnnb(n0l)
      real              r3frcsoilmoistnnb(n0l,0:n0t,0:n0m)
      character*128     c1frcsoilmoistgrn(0:n0m) !! fraction of green SM
      character*128     c1frcsoilmoistriv(0:n0m) !! fraction of river SM
      character*128     c1frcsoilmoistmsr(0:n0m) !! fraction of MSR SM
      character*128     c1frcsoilmoistnnb(0:n0m) !! fraction of NNBW SM
c out
      real              r1evapgrn(n0l)
      real              r3evapgrn(n0l,0:n0t,0:n0m)
      real              r1evapblu(n0l)
      real              r3evapblu(n0l,0:n0t,0:n0m)
      character*128     c1evapgrn(0:n0m) !! evaporation originated from green
      character*128     c1evapblu(0:n0m) !! evaporation originated from river
c local
      real              r1zero(n0l) !! array filled with zero
      real              r1supagr_df(n0l)
      real              r1supagr_pr(n0l)
      real              r1frcsupagrriv(n0l)
      real              r3frcsupagrriv(n0l,0:n0t,0:n0m)
      real              r1frcsupagrrgw(n0l)
      real              r3frcsupagrrgw(n0l,0:n0t,0:n0m)
      real              r1frcsupagrmsr(n0l)
      real              r3frcsupagrmsr(n0l,0:n0t,0:n0m)
      real              r1frcsupagrnnb(n0l)
      real              r3frcsupagrnnb(n0l,0:n0t,0:n0m)
      real              r1supagrg(n0l)  !! agr supply assigned to gw
      real              r1supindg(n0l)  !! ind supply assigned to gw
      real              r1supdomg(n0l)  !! dom supply assigned to gw
      real              r1supagrs(n0l)  !! agr supply assigned to sw
      real              r1supinds(n0l)  !! ind supply assigned to sw
      real              r1supdoms(n0l)  !! dom supply assigned to sw
      real              r1demagrg(n0l)  !! agr demand assigned to gw
      real              r1demindg(n0l)  !! ind demand assigned to gw
      real              r1demdomg(n0l)  !! dom demand assigned to gw
      real              r1demagrs(n0l)  !! agr demand assigned to sw
      real              r1deminds(n0l)  !! ind demand assigned to sw
      real              r1demdoms(n0l)  !! dom demand assigned to sw
c F18
      integer           i0tmp
      integer           n0damid_
      parameter        (n0damid_=24)
      real              r0targetmin
      real              r0targetmax
      real              r1targetmin(n0l)
      real              r1targetmax(n0l)
      real              r1factor(n0damid_)
      real              r2minsto(n0damid_,4)
      integer           i2mindoy(n0damid_,4)
      real              r2maxsto(n0damid_,4)
      integer           i2maxdoy(n0damid_,4)
      real              r2rlsrls(n0damid_,4)
      integer           i2rlsdoy(n0damid_,4)
      character*128     c0factor      
      character*128     c0minsto
      character*128     c0mindoy
      character*128     c0maxsto
      character*128     c0maxdoy
      character*128     c0rlsrls
      character*128     c0rlsdoy
c namelist
      character*128     c0sethum        !! setting file for human models
      namelist         /sethum/
     $     i0dayadvirg,   r0fctpad,      r0fctnonpad,   c1optlnduse,
     $     r0knorm,       c0optkrls,     c0optdamrls,   c0optdamwbc,
     $     c0damalc,      c0optnnb,      c0opthvsdoy,
     $     c1pltdoyp,      c1hvsdoyp,      c1crptypp,      c0lndara,
     $     c1pltdoyf,      c1hvsdoyf,      c1crptypf,
     $     c1arafrc,      c0optriv,
     $     c0optrgw,      c0optdes,      c0optrcl,
     $     c0lcan,        c0despot,      c0rclpot,
     $     c0msrcap,      c0demind,      c0demdom,      c0envflw,
     $     c0damid_,      c0damprp,      c01stmon,      c0damcap,
     $     c0damsrf,      c0demagrfix,   c0rivoutfix,
     $     c0damsto,      c0damstoini,   c0msrsto,    c0msrstoini,
     $     c0supagr,      c1demagr,
     $     c0daminf,      c0damout,      c0damdem,
     $     c0msrinf,      c0msrout,
     $     c0supind,      c0supdom,
     $     c0supagrriv,   c0supindriv,   c0supdomriv,
     $     c0supagrcan,   c0supindcan,   c0supdomcan,
     $     c0supagrrgw,   c0supindrgw,   c0supdomrgw,
     $     c0supagrmsr,   c0supindmsr,   c0supdommsr,
     $     c0supagrnnbs,  c0supindnnbs,  c0supdomnnbs,
     $     c0supagrnnbg,  c0supindnnbg,  c0supdomnnbg,
     $     c0supagrdes,   c0supinddes,   c0supdomdes,
     $     c0supagrrcl,   c0supindrcl,   c0supdomrcl,
     $     c0supagrdef,   c0supinddef,   c0supdomdef,
     $     c0frcgwagr,    c0frcgwind,    c0frcgwdom,
     $     c0rtfagr,      c0rtfind,      c0rtfdom,
     $     c1frcsoilmoistgrn,            c1frcsoilmoistriv,
     $     c1frcsoilmoistmsr,            c1frcsoilmoistnnb,
     $     c1evapgrn,     c1evapblu,
     $     c0msrafc,      c0krls,
     $     c0irgeffs,     c0irgeffg,     c0indeff,      c0domeff,
     $     c0irglos,      c0losagr,
     $     c0factor,      c0minsto,      c0mindoy,
     $     c0maxsto,      c0maxdoy,      c0rlsrls,        c0rlsdoy
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Get arguments
c - check the number of arguments
c - get arguments
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(iargc().ne.4) then
        write(6, *) 'USAGE: main c0setlnd c0setriv c0sethum c0setcrp'
        stop
      end if
c      
      call getarg(1,c0setlnd)
      call getarg(2,c0setriv)
      call getarg(3,c0sethum)
      call getarg(4,c0setcrp)
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
c Read namelists
c - read c0setriv
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      open(15,file=c0setriv)
      read(15,nml=setriv)
      close(15)
      write(*,*) 'main: --- Read namelist ----------------------------'
      write(*,nml=setriv)
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
c Read namelists
c - read c0sethum
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      open(15,file=c0sethum)
      read(15,nml=sethum)
      close(15)
      write(*,*) 'main_human: --- Read namelist ---------------------'
      write(*,nml=sethum)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc   
c F18 read dam operation files                                           
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc      
        open(15,file=c0factor)
        do i0damid_=1,n0damid_
          read(15,*) r1factor(i0damid_)
        end do
        close(15)
c                                                                              
        open(15,file=c0rlsrls)
        do i0damid_=1,n0damid_
          read(15,*) (r2rlsrls(i0damid_,i0tmp),i0tmp=1,4)
        end do
        close(15)
c                                                                              
        open(15,file=c0rlsdoy)
        do i0damid_=1,n0damid_
          read(15,*) (i2rlsdoy(i0damid_,i0tmp),i0tmp=1,4)
        end do
        close(15)
c                                                                              
        open(15,file=c0maxsto)
        do i0damid_=1,n0damid_
          read(15,*) (r2maxsto(i0damid_,i0tmp),i0tmp=1,4)
        end do
        close(15)
c
       open(15,file=c0maxdoy)
        do i0damid_=1,n0damid_
          read(15,*) (i2maxdoy(i0damid_,i0tmp),i0tmp=1,4)
        end do
        close(15)
c                                                                            
        open(15,file=c0minsto)
        do i0damid_=1,n0damid_
          read(15,*) (r2minsto(i0damid_,i0tmp),i0tmp=1,4)
        end do
        close(15)
c                                                                              
        open(15,file=c0mindoy)
        do i0damid_=1,n0damid_
          read(15,*) (i2mindoy(i0damid_,i0tmp),i0tmp=1,4)
        end do
        close(15)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Read fixed fieleds (fraction)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call read_binary(n0l,c0frcgwagr,r1frcgwagr)
      call read_binary(n0l,c0frcgwind,r1frcgwind)
      call read_binary(n0l,c0frcgwdom,r1frcgwdom)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Read fixed fieleds (lnd)
c - read land mask
c - read soil depth
c - read field capacity
c - read wilting point
c - read heat capacity
c - read parameter gamma
c - read parameter tau
c - read mosaic area fraction
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call read_binary(n0l,c0lndmsk,r1tmp)
      do i0l=1,n0l
        i1lndmsk(i0l)=int(r1tmp(i0l))
      end do
c
      call read_binary(n0l,c0soildepth,r1soildepth)
c
      call read_binary(n0l,c0w_fieldcap,r1w_fieldcap)
c
      call read_binary(n0l,c0w_wilt,r1w_wilt)
c
      call read_binary(n0l,c0cg,r1cg)
c
      call read_binary(n0l,c0cd,r1cd)
c
      call read_binary(n0l,c0gamma,r1gamma)
c
      call read_binary(n0l,c0tau,r1tau)
      call read_binary(n0l,c0w_rgwyield,r1w_rgwyield)
      call read_binary(n0l,c0rgwgamma,r1rgwgamma)
      call read_binary(n0l,c0rgwtau,r1rgwtau)
      call read_binary(n0l,c0rgwrcf,r1rgwrcf)
      call read_binary(n0l,c0rgwrcmax,r1rgwrcmax)
      call read_binary(n0l,c0rgwdepth,r1rgwdepth)
c
      do i0m=1,n0m
        call read_binary(n0l,c1arafrc(i0m),r1tmp)
        do i0l=1,n0l
          r2arafrc(i0l,i0m)=r1tmp(i0l)
        end do
      end do
      
d     write(*,*) 'main: --- Read fixed fields -----------------------'
d     write(*,*) 'main: ilndmsk:     ',i1lndmsk(i0ldbg)
d     write(*,*) 'main: r1soildepth: ',r1soildepth(i0ldbg)
d     write(*,*) 'main: r1w_fieldcap:',r1w_fieldcap(i0ldbg)
d     write(*,*) 'main: r1w_wilt:    ',r1w_wilt(i0ldbg)
d     write(*,*) 'main: r1cg:        ',r1cg(i0ldbg)
d     write(*,*) 'main: r1cd:        ',r1cd(i0ldbg)
d     write(*,*) 'main: r1gamma:     ',r1gamma(i0ldbg)
d     write(*,*) 'main: r1tau:       ',r1tau(i0ldbg)
d     write(*,*) 'main: r2arafrc(1): ',r2arafrc(i0ldbg,1)
d     write(*,*) 'main: r2arafrc(2): ',r2arafrc(i0ldbg,2)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Read fixed fields (irg)
c - read planting date 
c - read harvesting date 
c - read crop type
c -
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0c=1,n0c
        call read_binary(n0l,c1pltdoyp(i0c),r1tmp)
        do i0l=1,n0l
          i2pltdoyp(i0l,i0c)=int(r1tmp(i0l))
        end do
      end do
      do i0c=1,n0c
        call read_binary(n0l,c1pltdoyf(i0c),r1tmp)
        do i0l=1,n0l
          i2pltdoyf(i0l,i0c)=int(r1tmp(i0l))
        end do
      end do
cc
      do i0c=1,n0c
        call read_binary(n0l,c1hvsdoyp(i0c),r1tmp)
        do i0l=1,n0l
          i2hvsdoyp(i0l,i0c)=int(r1tmp(i0l))
        end do
      end do
      do i0c=1,n0c
        call read_binary(n0l,c1hvsdoyf(i0c),r1tmp)
       do i0l=1,n0l
         i2hvsdoyf(i0l,i0c)=int(r1tmp(i0l))
        end do
      end do

      do i0c=1,n0c
        call read_binary(n0l,c1crptypp(i0c),r1tmp)
        do i0l=1,n0l
          i2crptypp(i0l,i0c)=int(r1tmp(i0l))
        end do
      end do
      do i0c=1,n0c
        call read_binary(n0l,c1crptypf(i0c),r1tmp)
        do i0l=1,n0l
          i2crptypf(i0l,i0c)=int(r1tmp(i0l))
        end do
      end do
      call read_binary(n0l,c0lndara,r1lndara)
d     write(*,*) 'main: --- Read fixed fields -----------------------'
d     write(*,*) 'main: i2pltdoy: ',i2pltdoyp(i0ldbg,1)
d     write(*,*) 'main: i2hvsdoy: ',i2hvsdoyp(i0ldbg,1)
d     write(*,*) 'main: i2crptyp: ',i2crptypp(i0ldbg,1)

c     write(*,*) 'main: --- Read fixed fields -----------------------'
c    write(*,*) 'main: i2pltdoy: ',i2pltdoy(i0ldbg,1)
c     write(*,*) 'main: i2hvsdoy: ',i2hvsdoy(i0ldbg,1)
c     write(*,*) 'main: i2crptyp: ',i2crptyp(i0ldbg,1)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Read fixed fields (riv)
c - read river sequence
c - read downward L coordinate
c - read distance to downward grid cell
c - read land area
c - read flow velocity
c - read meandering ratio
c - set r0rivseqmax by finding the maximum value of r1rivseq
c - set r1paramc by calculation
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      call read_binary(n0l,c0rivseq,r1rivseq)
c
      call read_binary(n0l,c0rivnxl,r1rivnxl)
c
      call read_binary(n0l,c0rivnxd,r1rivnxd)
c
      call read_binary(n0l,c0lndara,r1lndara)
c
      call read_binary(n0l,c0flwvel,r1flwvel)
c
      call read_binary(n0l,c0medrat,r1medrat)
c
      r0rivseqmax=0.0
      do i0l=1,n0l
        r0rivseqmax=max(r1rivseq(i0l),r0rivseqmax)
      end do
c
      do i0l=1,n0l
        if (r1rivnxd(i0l).gt.0.0) then
          r1paramc(i0l)=r1flwvel(i0l)/(r1rivnxd(i0l)*r1medrat(i0l))
        else
          r1paramc(i0l)=p0mis
        end if
      end do
d     write(*,*) 'main: r1rivseq    ',r1rivseq(i0ldbg)
d     write(*,*) 'main: r1rivnxl    ',r1rivnxl(i0ldbg)
d     write(*,*) 'main: r1rivnxd    ',r1rivnxd(i0ldbg)
d     write(*,*) 'main: r1lndara    ',r1lndara(i0ldbg)
d     write(*,*) 'main: r1flwvel    ',r1flwvel(i0ldbg)
d     write(*,*) 'main: r1medrat    ',r1medrat(i0ldbg)
d     write(*,*) 'main: r0rivseqmax ',r0rivseqmax
d     write(*,*) 'main: r1paramc    ',r1paramc(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Read fixed fields (hum)
c - read reservoir (dam) ID
c - read reservoir (dam) capacity
c - read medium-sized reservoir (pond) capacity
c - read agricultral water demand
c - read industrial water demand
c - read domestic water demand
c - read environmental flow
c - read river discharge
c - calculate annual water demand for reservoirs
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(c0damid_.ne.'NO')then
        call read_binary(n0l,c0damid_,r1tmp)
        do i0l=1,n0l
          i1damid_(i0l)=int(r1tmp(i0l))
        end do
      else
        i1damid_=0
      end if
c
      if(c0damprp.ne.'NO')then
        call read_binary(n0l,c0damprp,r1tmp)
        do i0l=1,n0l
          i1damprp(i0l)=int(r1tmp(i0l))
        end do
      else
        i1damprp=0
      end if
c
      if(c01stmon.ne.'NO')then
        call read_binary(n0l,c01stmon,r1tmp)
        do i0l=1,n0l
          i11stmon(i0l)=int(r1tmp(i0l))
        end do
      else
        i11stmon=0
      end if
c
      if(c0damcap.ne.'NO')then
        call read_binary(n0l,c0damcap,r1damcap)
      else
        r1damcap=0.0
      end if
c
      if(c0msrcap.ne.'NO')then
        call read_binary(n0l,c0msrcap,r1msrcap)
      else
        r1msrcap=0.0
      end if
c
      if(c0msrafc.ne.'NO')then
        call read_binary(n0l,c0msrafc,r1msrafc)
      else
        r1msrafc=1.0
      end if
c 
      if(c0demagrfix.ne.'NO')then
        call read_binary(n0l,c0demagrfix,r1demagrfix)
      else
        r1demagrfix=0.0
      end if
c
      if(c0demind.ne.'NO')then
      call read_binary(n0l,c0demind,r1demind)
      else
        r1demind=0.0
      end if
c
      if(c0demdom.ne.'NO')then
      call read_binary(n0l,c0demdom,r1demdom)
      else
        r1demdom=0.0
      end if
c 
      if(c0rivoutfix.ne.'NO')then
        call read_binary(n0l,c0rivoutfix,r1rivoutfix)
      else
        r1rivoutfix=0.0
      end if
c
      r1tmp=0.0
      do i0l=1,n0l
        if(r1demagrfix(i0l).ne.p0mis)then
          r1tmp(i0l)=r1tmp(i0l)+r1demagrfix(i0l)
        end if
      end do
      do i0l=1,n0l
        if(r1demind(i0l).ne.p0mis)then
          r1tmp(i0l)=r1tmp(i0l)+r1demind(i0l)
        end if
      end do
      do i0l=1,n0l
        if(r1demdom(i0l).ne.p0mis)then
          r1tmp(i0l)=r1tmp(i0l)+r1demdom(i0l)
        end if
      end do
      call calc_damdem(
     $     n0l,
     $     i1damid_, r1tmp, c0damalc,
     $     r1damdemfix)
d     write(*,*) 'main: i1damid_(i0ldbg)',i1damid_(i0ldbg)
d     write(*,*) 'main: r1damcap(i0ldbg)',r1damcap(i0ldbg)
d     write(*,*) 'main: r1msrcap(i0ldbg)',r1msrcap(i0ldbg)
d     write(*,*) 'main: r1msrafc(i0ldbg)',r1msrafc(i0ldbg)
d     write(*,*) 'main: r1demagrfix(i0ldbg)',r1demagrfix(i0ldbg)
d     write(*,*) 'main: r1demind(i0ldbg)',r1demind(i0ldbg)
d     write(*,*) 'main: r1demdom(i0ldbg)',r1demdom(i0ldbg)
d     write(*,*) 'main: r1envflw(i0ldbg)',r1envflw(i0ldbg)
d     write(*,*) 'main: r1rivoutfix(i0ldbg)',r1rivoutfix(i0ldbg)
d     write(*,*) 'main: r1tmp(i0ldbg)      ',r1tmp(i0ldbg)
d     write(*,*) 'main: r1damdemfix(i0ldbg)',r1damdemfix(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Read parameter
c - Canal intake point in the L coordinate 
c - Desalination potential
c - Recycling water potential
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(c0lcan.ne.'NO')then
        open(15,file=c0lcan,access='DIRECT',recl=n0l*4,status='old')
        do i0rec=1,n0rec
          read(15,rec=i0rec)(r1tmp(i0l),i0l=1,n0l)
          do i0l=1,n0l
            i2lcan(i0l,i0rec)=int(r1tmp(i0l))
          end do
        end do
        close(15)
      else
        i2lcan=0
      end if
c
      if(c0despot.ne.'NO')then
        call read_binary(n0l,c0despot,r1tmp)
        do i0l=1,n0l
          i1despot(i0l)=int(r1tmp(i0l))
        end do
      else
        i1despot=0
      end if
c
      if(c0rclpot.ne.'NO')then
        call read_binary(n0l,c0rclpot,r1tmp)
        do i0l=1,n0l
          if(r1tmp(i0l).ne.p0mis)then
            i1rclpot(i0l)=int(r1tmp(i0l))
          end if
        end do
      else
        i1rclpot=0
      end if
c
      if(c0irgeffs.ne.'NO')then
        call read_binary(n0l,c0irgeffs,r1irgeffs)
      else
        r1irgeffs=0.0
      end if
c
      if(c0irgeffg.ne.'NO')then
        call read_binary(n0l,c0irgeffg,r1irgeffg)
      else
        r1irgeffg=0.0
      end if
c
      if(c0irglos.ne.'NO')then
        call read_binary(n0l,c0irglos,r1irglos)
      else
        r1irglos=0.0
      end if
c
      if(c0indeff.ne.'NO')then
        call read_binary(n0l,c0indeff,r1indeff)
      else
        r1indeff=0.0
      end if
c
      if(c0domeff.ne.'NO')then
        call read_binary(n0l,c0domeff,r1domeff)
      else
        r1domeff=0.0
      end if
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
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Initialize state variables (lnd)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0m=1,n0m
        call read_binary(n0l,c1soilmoistini(i0m),r1tmp)
        do i0l=1,n0l
          r3soilmoist(i0l,0,i0m)=r1tmp(i0l)
        end do
      end do
      do i0m=1,n0m
        call read_binary(n0l,c1soiltempini(i0m),r1tmp)
        do i0l=1,n0l
          r3soiltemp(i0l,0,i0m)=r1tmp(i0l)
        end do
      end do
      do i0m=1,n0m
        call read_binary(n0l,c1avgsurftini(i0m),r1tmp)
        do i0l=1,n0l
          r3avgsurft(i0l,0,i0m)=r1tmp(i0l)
        end do
      end do
      do i0m=1,n0m
        call read_binary(n0l,c1sweini(i0m),r1tmp)
        do i0l=1,n0l
          r3swe(i0l,0,i0m)=r1tmp(i0l)
        end do
      end do
      do i0m=1,n0m
        call read_binary(n0l,c1rgwini(i0m),r1tmp)
        do i0l=1,n0l
          r3rgw(i0l,0,i0m)=r1tmp(i0l)
        end do
      end do
d     write(*,*) 'main: --- Initialize state variables --------------'
d     write(*,*) 'main: r3soilmoist(1):',r3soilmoist(i0ldbg,0,1)
d     write(*,*) 'main: r3soilmoist(2):',r3soilmoist(i0ldbg,0,2)
d     write(*,*) 'main: r3soiltemp(1): ',r3soiltemp(i0ldbg,0,1)
d     write(*,*) 'main: r3soiltemp(2): ',r3soiltemp(i0ldbg,0,2)
d     write(*,*) 'main: r3avgsurft(1): ',r3avgsurft(i0ldbg,0,1)
d     write(*,*) 'main: r3avgsurft(2): ',r3avgsurft(i0ldbg,0,2)
d     write(*,*) 'main: r3swe(1):      ',r3swe(i0ldbg,0,1)
d     write(*,*) 'main: r3swe(2):      ',r3swe(i0ldbg,0,2)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Initialize state variables (riv)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      call read_binary(n0l,c0rivstoini,r1rivsto)
      call read_binary(n0l,c0rivstoini,r1rivsto_pr)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Initialize state variables (hum)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call read_binary(n0l,c0damstoini,r1damsto)
      call read_binary(n0l,c0msrstoini,r1msrsto)
d     write(*,*) 'main: r1damsto',r1damsto(i0ldbg)
d     write(*,*) 'main: r1msrsto',r1msrsto(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Initialize state variables
c - biomass
c - nitrogen
c - phosphorus
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0m=1,n0m
        call read_binary(n0l,c1btini(i0m),r1tmp)
        do i0l=1,n0l
          r2bt(i0l,i0m)=r1tmp(i0l)
        end do
      end do
      do i0m=1,n0m
        call read_binary(n0l,c1rsdini(i0m),r1tmp)
        do i0l=1,n0l
          r2rsd(i0l,i0m)=r1tmp(i0l)
        end do
      end do
      do i0m=1,n0m
        call read_binary(n0l,c1outbini(i0m),r1tmp)
        do i0l=1,n0l
          r2outb(i0l,i0m)=r1tmp(i0l)
        end do
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Initialize
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      r1frcsupagrriv=0.0
      r1frcsupagrrgw=0.0
      r1frcsupagrmsr=0.0
      r1frcsupagrnnb=0.0
      r1frcsoilmoistgrn=1.0
      r1frcsoilmoistriv=0.0
      r1frcsoilmoistmsr=0.0
      r1frcsoilmoistnnb=0.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     Loop (year,mon,it)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
d     write(*,*) 'main: --- Calculation -----------------------------'
 10   do i0l=1,n0l
        r1spn(i0l)=r3soilmoist(i0l,0,0)
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
              write(*,*) '------------------------------'
              write(*,'(a6,i4.4,a1,i2.2,a1,i2.2,a1,i5.5)')
     $             ' time:',i0year,'/',i0mon,'/',i0day,':',i0sec
              write(*,*) '------------------------------'
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
     $             i0day,      i0sec,    i0secint,
     $             r1swdown)
c
              call read_result(
     $             n0l,
     $             c0lwdown,   i0year,   i0mon,
     $             i0day,      i0sec,    i0secint,
     $             r1lwdown)
              if(c0lcor.eq.'NO')then
                do i0l=1,n0l
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
              if(c0tcor.ne.'NO')then
                call conv_rstors(
     $               n0l,
     $               r1rainf,r1snowf,r1psurf,r1qair,r1tair)
              end if
d             write(*,*) 'main: Meteorological input'
d             write(*,*) 'main: |-r1rainf:  ',r1rainf(i0ldbg)
d             write(*,*) 'main: |-r1snowf:  ',r1snowf(i0ldbg)
d             write(*,*) 'main: |-r1tair:   ',r1tair(i0ldbg)
d             write(*,*) 'main: |-r1qair:   ',r1qair(i0ldbg)
d             write(*,*) 'main: |-r1lwdown: ',r1lwdown(i0ldbg)
d             write(*,*) 'main: |-r1swdown: ',r1swdown(i0ldbg)
d             write(*,*) 'main: |-r1psurf:  ',r1psurf(i0ldbg)
d             write(*,*) 'main: |-r1wind:   ',r1wind(i0ldbg)
d             write(*,*) 'main: |-r1balbedo:',r1balbedo(i0ldbg)
c 
              if(c0envflw.ne.'NO')then
                call read_result(
     $               n0l,
     $               c0envflw,   i0year,   i0mon,
     $               i0day,      i0sec,    i0secint,
     $               r1envflw)
              else
                r1envflw=0.0
              end if
c

              if(i0sec.eq.n0secday)then
                call calc_flgcrp(
     $               n0l,n0c,
     $               i0year,i0mon,i0day,
     $               i0ldbg,i0dayadvirg,
     $               i2pltdoyp,i2hvsdoyp,
     $               i2flgculp, i2flgirgp, r2targetp,
     $               c0opthvsdoy)
              end if
c
             if(i0sec.eq.n0secday)then
                call calc_flgcrp(
     $               n0l,n0c,
     $               i0year,i0mon,i0day,
     $               i0ldbg,i0dayadvirg,
     $               i2pltdoyf,i2hvsdoyf,
     $               i2flgculf, i2flgirgf, r2targetf,
     $               c0opthvsdoy)
              end if
c end
              if(i0sec.eq.n0secday)then
                do i0m=1,n0m
                  do i0l=1,n0l
                    r1soilmoist(i0l)=r3soilmoist(i0l,0,i0m)
                  end do
                  do i0l=1,n0l
                    r1tmp(i0l)=r2arafrc(i0l,i0m)
                  end do
c     
d                 write(*,*) 'main: Before calc_irgapp'
d                 write(*,*) 'main: |-i0m:        ',i0m
d                 write(*,*) 'main: |-r1soilmoist:',r1soilmoist(i0ldbg)
d                 write(*,*) 'main: |-r1demagr:   ',r1demagr(i0ldbg)
d                 write(*,*) 'main: |-r1supagr:   ',r1supagr(i0ldbg)
c
                  do i0l=1,n0l
                    r1soilmoist_pr(i0l)=r1soilmoist(i0l)
                  end do
                  do i0l=1,n0l
                    r1supagr_pr(i0l)=r1supagr(i0l)
                  end do
c

                  call calc_irgapp_hyper(
     $                 n0l,n0c,
     $                 i0ldbg,n0secday,    r0fctpad,    r0fctnonpad, 
     $                 c1optlnduse(i0m),
     $                 i2crptypp,i2crptypf,  r1soildepth, r1w_fieldcap,
     $                 r1w_wilt,    r1lndara,    r1tmp,
     $                i2flgculp,    i2flgirgp,    r2targetp,
     $                 i2flgculf,    i2flgirgf,    r2targetf,
     $                 r1soilmoist, r1supagr,
     $                 r1demagr)
d                 write(*,*) 'main: After calc_irgapp'
d                 write(*,*) 'main: |-i0m:        ',i0m
d                 write(*,*) 'main: |-r1soilmoist:',r1soilmoist(i0ldbg)
d                 write(*,*) 'main: |-r1demagr:   ',r1demagr(i0ldbg)
d                 write(*,*) 'main: |-r1supagr:   ',r1supagr(i0ldbg)
c
                  r1zero=0.0
                  do i0l=1,n0l
                    r1supagr_df(i0l)=r1supagr_pr(i0l)-r1supagr(i0l)
                  end do
                  do i0l=1,n0l
                    r1frcsoilmoistgrn(i0l)=r3frcsoilmoistgrn(i0l,0,i0m)
                  end do
                  do i0l=1,n0l
                    r1frcsoilmoistriv(i0l)=r3frcsoilmoistriv(i0l,0,i0m)
                  end do
                  do i0l=1,n0l
                    r1frcsoilmoistmsr(i0l)=r3frcsoilmoistmsr(i0l,0,i0m)
                  end do
                  do i0l=1,n0l
                    r1frcsoilmoistnnb(i0l)=r3frcsoilmoistnnb(i0l,0,i0m)
                  end do
c
                  call calc_watsrc(
     $                 n0l,real(n0secday),r1lndara,r1tmp,
     $                 r1soilmoist_pr,r1zero,r1zero, r1supagr_df,
     $                 r1frcsupagrriv,r1frcsupagrmsr,r1frcsupagrnnb,
     $                 r1frcsoilmoistgrn,r1frcsoilmoistriv,
     $                 r1frcsoilmoistmsr,r1frcsoilmoistnnb)
d                 write(*,*) 'main: After calc_watsrc [1st]'
d                 write(*,*) 'main: |-r1lndara',r1lndara(i0ldbg)
d                 write(*,*) 'main: |-r1lndfrc',r1tmp(i0ldbg)
d                 write(*,*) 'main: |-r1soilmo',r1soilmoist_pr(i0ldbg)
d                 write(*,*) 'main: |-r1rainf  --'
d                 write(*,*) 'main: |-r1qsm    --'
d                 write(*,*) 'main: |-r1supagr',r1supagr_df(i0ldbg)
d                 write(*,*) 'main: |-r1supriv',r1frcsupagrriv(i0ldbg)
d                 write(*,*) 'main: |-r1supmsr',r1frcsupagrmsr(i0ldbg)
d                 write(*,*) 'main: |-r1supnnb',r1frcsupagrnnb(i0ldbg)
d                 write(*,*) 'main: |-r1smgrn',r1frcsoilmoistgrn(i0ldbg)
d                 write(*,*) 'main: |-r1smriv',r1frcsoilmoistriv(i0ldbg)
d                 write(*,*) 'main: |-r1smmsr',r1frcsoilmoistmsr(i0ldbg)
d                 write(*,*) 'main: |-r1smnnb',r1frcsoilmoistnnb(i0ldbg)
c
                  do i0l=1,n0l
                    r3frcsoilmoistgrn(i0l,0,i0m)=r1frcsoilmoistgrn(i0l)
                  end do
                  do i0l=1,n0l
                    r3frcsoilmoistriv(i0l,0,i0m)=r1frcsoilmoistriv(i0l)
                  end do
                  do i0l=1,n0l
                    r3frcsoilmoistmsr(i0l,0,i0m)=r1frcsoilmoistmsr(i0l)
                  end do
                  do i0l=1,n0l
                    r3frcsoilmoistnnb(i0l,0,i0m)=r1frcsoilmoistnnb(i0l)
                  end do
c
                  do i0l=1,n0l
                    r3soilmoist(i0l,0,i0m)=r1soilmoist(i0l)
                  end do                  
                  call wrte_bints3(n0l,n0t,
     $                 r1demagr,    r3demagr,   c1demagr,
     $                 i0year,i0mon,i0day,n0secday,n0secday,
     $                 s0ave,n0m,i0m,r2arafrc,s0sum)
c
                end do
                do i0l=1,n0l
                  r1demagr(i0l)=r3demagr(i0l,1,0)
                end do
d               write(*,*) 'main: After mosaic loop'
d               write(*,*) 'main: |-r1demagr:      ',r1demagr(i0ldbg)
              end if
c
              if(i0sec.eq.n0secday)then
                r1tmp=0.0
                do i0l=1,n0l
                  if(r1demagr(i0l).ne.p0mis)then
                    r1tmp(i0l)=r1tmp(i0l)+r1demagr(i0l)
                  end if
                end do
                do i0l=1,n0l
                  if(r1demind(i0l).ne.p0mis)then
                    r1tmp(i0l)=r1tmp(i0l)+r1demind(i0l)
                  end if
                end do
                do i0l=1,n0l
                  if(r1demdom(i0l).ne.p0mis)then
                    r1tmp(i0l)=r1tmp(i0l)+r1demdom(i0l)
                  end if
                end do
                call calc_damdem(
     $               n0l,
     $               i1damid_, r1tmp, c0damalc,
     $               r1damdem)
                call wrte_bints2(n0l,n0t,
     $               r1damdem,       r2damdem,     c0damdem,
     $               i0year,i0mon,i0day,n0secday,n0secday,
     $               s0ave)
              end if
c
              if(i0sec.eq.n0secday)then
                do i0l=1,n0l
                  if(i1damid_(i0l).ne.0)then
                    i0damid_=i1damid_(i0l)
                    i0damprp=i1damprp(i0l)
                    i01stmon=i11stmon(i0l)
                    if(i0mon.eq.i01stmon.and.i0day.eq.1.and.
     $                 i0sec.eq.n0secday)then
                      i0flgkrls=1
                    else
                      i0flgkrls=0
                    end if
                    r0rivout=r1rivoutfix(i0l)
                    r0damcap=r1damcap(i0l)
                    r0damsrf=r1damsrf(i0l)
                    r0daminf=r2daminf(i0l,1)
                    if(i0damprp.eq.4)then
                      r0damdem=r1damdem(i0l)
                    else
                      r0damdem=r1damdemfix(i0l)
                    end if
                    r0damdemfix=r1damdemfix(i0l)
                    r0damout=0.0
                    r0krls=r1krls(i0l)
                    r0damsto=r1damsto(i0l)
                    if(i0l.eq.i0ldbg)then
d                     write(*,*) 'main: Before calc_resope'
d                     write(*,*) 'main: |-i0damid_   ',i0damid_
d                     write(*,*) 'main: |-i01stmon   ',i01stmon
d                     write(*,*) 'main: |-i0secint   ',i0secint
d                     write(*,*) 'main: |-i0l        ',i0l
d                     write(*,*) 'main: |-i0flgkrls  ',i0flgkrls
d                     write(*,*) 'main: |-r0knorm    ',r0knorm
d                     write(*,*) 'main: |-r0rivout   ',r0rivout
d                     write(*,*) 'main: |-r0damcap   ',r0damcap
d                     write(*,*) 'main: |-r0damsrf   ',r0damsrf
d                     write(*,*) 'main: |-r0daminf   ',r0daminf
d                     write(*,*) 'main: |-r0damdem   ',r0damdem
d                     write(*,*) 'main: |-r0damdemfix',r0damdemfix
d                     write(*,*) 'main: |-r0damout   ',r0damout
d                     write(*,*) 'main: |-r0krls     ',r0krls
d                     write(*,*) 'main: |-r0damsto   ',r0damsto
                    end if

c 
                    i0doy=igetdoy(i0year,i0mon,i0day)

                    call calc_resope_hyper(
     $                 i0secint,i0damid_,
     $                 i0flgkrls,r0knorm,
     $                 c0optkrls,c0optdamrls,c0optdamwbc,
     $                 r0rivout, r0damcap,r0damsrf,
     $                 r0daminf,r0damdem, r0damdemfix,
     $                 r0damout,
     $                 r0krls,   r0damsto,
     $                 i0doy,    n0damid_,
     $                 r1factor,r2rlsrls,i2rlsdoy,
     $                 r2maxsto, i2maxdoy,r2minsto,i2mindoy,
     $                 r0targetmax,r0targetmin)

                    r1damout(i0l)=r0damout

                    r1targetmax(i0l)=r0targetmax
                    r1targetmin(i0l)=r0targetmin
c
                    r1krls(i0l)=r0krls
                    r1damsto(i0l)=r0damsto
                  end if
                end do
              end if
c
              do i0m=1,n0m
                do i0l=1,n0l
                  r1avgsurft_pr(i0l)=r3avgsurft(i0l,0,i0m)
                end do
                do i0l=1,n0l
                  r1swe_pr(i0l)=r3swe(i0l,0,i0m)
                end do
                do i0l=1,n0l
                  r1soilmoist_pr(i0l)=r3soilmoist(i0l,0,i0m)
                end do
                do i0l=1,n0l
                  r1soiltemp_pr(i0l)=r3soiltemp(i0l,0,i0m)
                end do
                do i0l=1,n0l
                  r1rgw_pr(i0l)=r3rgw(i0l,0,i0m)
                end do
c
                call calc_leakyb(
     $               n0l,
     $               i0secint,     i0ldbg,     i0cntc,     r0engbalc,
     $               r0watbalc,
     $               i1lndmsk,     r1soildepth,r1w_fieldcap,r1w_wilt,
     $               r1rgwdepth,    r1w_rgwyield,
     $               r1cg,         r1cd,
     $               r1gamma,      r1tau,      r1balbedo,
     $               r1rgwgamma,    r1rgwtau,    r1rgwrcf,  r1rgwrcmax,
     $               r1wind,       r1rainf,    r1snowf,     r1tair,
     $               r1qair,       r1psurf,    r1swdown,    r1lwdown,
     $            r1avgsurft_pr,r1swe_pr,r1soilmoist_pr,r1soiltemp_pr,
     $               r1rgw_pr,
     $               r1swnet,      r1lwnet,    r1qle,       r1qh,
     $               r1qg,         r1qf,       r1qv,
     $               r1evap,       r1qs,       r1qsb,       r1qtot,
     $               r1qsm,        r1qst,
     $               r1qrc,        r1qbf,
     $               r1avgsurft,   r1albedo,   r1swe,
     $               r1soilmoist,  r1soiltemp, r1soilwet,
     $               r1rgw,
     $               r1potevap,    r1et,       r1subsnow,
     $               r1salbedo,
     $               i1engnotbal,  i1watnotbal,i1notfin)
c
d               write(*,*) 'main: r1rgw: ',r1rgw(i0ldbg)
d               write(*,*) 'main: r1qrc: ',r1qrc(i0ldbg)
d               write(*,*) 'main: r1qbf: ',r1qbf(i0ldbg)
d               write(*,*) 'main: r1sm:  ',r1soilmoist(i0ldbg)
d               write(*,*) 'main: r1qtot:',r1qtot(i0ldbg)
                r1zero=0.0
                do i0l=1,n0l
                  r1frcsoilmoistgrn(i0l)=r3frcsoilmoistgrn(i0l,0,i0m)
                end do
                do i0l=1,n0l
                  r1frcsoilmoistriv(i0l)=r3frcsoilmoistriv(i0l,0,i0m)
                end do
                do i0l=1,n0l
                  r1frcsoilmoistmsr(i0l)=r3frcsoilmoistmsr(i0l,0,i0m)
                end do
                do i0l=1,n0l
                  r1frcsoilmoistnnb(i0l)=r3frcsoilmoistnnb(i0l,0,i0m)
                end do
                do i0l=1,n0l
                  r1tmp(i0l)=r2arafrc(i0l,i0m)
                end do
c
                call calc_watsrc(
     $               n0l,real(i0secint),r1lndara,r1tmp,
     $               r1soilmoist_pr,r1rainf,r1qsm,r1zero,
     $               r1frcsupagrriv,r1frcsupagrmsr,r1frcsupagrnnb,
     $               r1frcsoilmoistgrn,r1frcsoilmoistriv,
     $               r1frcsoilmoistmsr,r1frcsoilmoistnnb)
d               write(*,*) 'main: After calc_watsrc [2nd]'
d               write(*,*) 'main: |-r1lndara',r1lndara(i0ldbg)
d               write(*,*) 'main: |-r1lndfrc',r1tmp(i0ldbg)
d               write(*,*) 'main: |-r1soilmo',r1soilmoist_pr(i0ldbg)
d               write(*,*) 'main: |-r1rainf ',r1rainf(i0ldbg)
d               write(*,*) 'main: |-r1qsm   ',r1qsm(i0ldbg)
d               write(*,*) 'main: |-r1supagr --'
d               write(*,*) 'main: |-r1supriv',r1frcsupagrriv(i0ldbg)
d               write(*,*) 'main: |-r1supmsr',r1frcsupagrmsr(i0ldbg)
d               write(*,*) 'main: |-r1supnnb',r1frcsupagrnnb(i0ldbg)
d               write(*,*) 'main: |-r1smgrn',r1frcsoilmoistgrn(i0ldbg)
d               write(*,*) 'main: |-r1smriv',r1frcsoilmoistriv(i0ldbg)
d               write(*,*) 'main: |-r1smmsr',r1frcsoilmoistmsr(i0ldbg)
d               write(*,*) 'main: |-r1smnnb',r1frcsoilmoistnnb(i0ldbg)
c
                do i0l=1,n0l
                  r1evapgrn(i0l)=r1evap(i0l)*r1frcsoilmoistgrn(i0l)
                r1evapblu(i0l)=r1evap(i0l)*(1.0-r1frcsoilmoistgrn(i0l))
                end do
c
                call wrte_bints3(n0l,n0t,
     $           r1frcsoilmoistgrn,r3frcsoilmoistgrn,c1frcsoilmoistgrn,
     $               i0year,i0mon,i0day,i0sec,i0secint,
     $               s0sta,n0m,i0m,r2arafrc,s0ave)
                call wrte_bints3(n0l,n0t,
     $           r1frcsoilmoistriv,r3frcsoilmoistriv,c1frcsoilmoistriv,
     $               i0year,i0mon,i0day,i0sec,i0secint,
     $               s0sta,n0m,i0m,r2arafrc,s0ave)
                call wrte_bints3(n0l,n0t,
     $           r1frcsoilmoistmsr,r3frcsoilmoistmsr,c1frcsoilmoistmsr,
     $               i0year,i0mon,i0day,i0sec,i0secint,
     $               s0sta,n0m,i0m,r2arafrc,s0ave)
                call wrte_bints3(n0l,n0t,
     $           r1frcsoilmoistnnb,r3frcsoilmoistnnb,c1frcsoilmoistnnb,
     $               i0year,i0mon,i0day,i0sec,i0secint,
     $               s0sta,n0m,i0m,r2arafrc,s0ave)
c
                call wrte_bints3(n0l,n0t,
     $               r1evapgrn,   r3evapgrn, c1evapgrn,
     $               i0year,i0mon,i0day,i0sec,i0secint,
     $               s0ave,n0m,i0m,r2arafrc,s0ave)
                call wrte_bints3(n0l,n0t,
     $               r1evapblu,   r3evapblu, c1evapblu,
     $               i0year,i0mon,i0day,i0sec,i0secint,
     $               s0ave,n0m,i0m,r2arafrc,s0ave)
c state variables
                call wrte_bints3(n0l,n0t,
     $               r1soilmoist,   r3soilmoist, c1soilmoist,
     $               i0year,i0mon,i0day,i0sec,i0secint,
     $               s0sta,n0m,i0m,r2arafrc,s0ave)
                call wrte_bints3(n0l,n0t,
     $               r1soiltemp,    r3soiltemp,  c1soiltemp,
     $               i0year,i0mon,i0day,i0sec,i0secint,
     $               s0sta,n0m,i0m,r2arafrc,s0ave)
                call wrte_bints3(n0l,n0t,
     $               r1avgsurft,   r3avgsurft, c1avgsurft,
     $               i0year,i0mon,i0day,i0sec,i0secint,
     $               s0sta,n0m,i0m,r2arafrc,s0ave)
                call wrte_bints3(n0l,n0t,
     $               r1swe,         r3swe,       c1swe,
     $               i0year,i0mon,i0day,i0sec,i0secint,
     $               s0sta,n0m,i0m,r2arafrc,s0ave)
                call wrte_bints3(n0l,n0t,
     $               r1rgw,          r3rgw,        c1rgw,
     $               i0year,i0mon,i0day,i0sec,i0secint,
     $               s0sta,n0m,i0m,r2arafrc,s0ave)
d               write(*,*) 'main: State variables'
d               write(*,*) 'main: |-r1soilmoist:  ',r1soilmoist(i0ldbg)
d               write(*,*) 'main: |-r1soiltemp:   ',r1soiltemp(i0ldbg)
d               write(*,*) 'main: |-r1avgsurft:   ',r1avgsurft(i0ldbg)
d               write(*,*) 'main: |-r1swe:        ',r1swe(i0ldbg)
d               write(*,*) 'main: |-r1rgw:         ',r1rgw(i0ldbg)
c out1
                call wrte_bints3(n0l,n0t,
     $               r1swnet,         r3swnet,       c1swnet,
     $               i0year,i0mon,i0day,i0sec,i0secint,
     $               s0ave,n0m,i0m,r2arafrc,s0ave)
                call wrte_bints3(n0l,n0t,
     $               r1lwnet,         r3lwnet,       c1lwnet,
     $               i0year,i0mon,i0day,i0sec,i0secint,
     $               s0ave,n0m,i0m,r2arafrc,s0ave)
                call wrte_bints3(n0l,n0t,
     $               r1qle,         r3qle,       c1qle,
     $               i0year,i0mon,i0day,i0sec,i0secint,
     $               s0ave,n0m,i0m,r2arafrc,s0ave)
                call wrte_bints3(n0l,n0t,
     $               r1qh,          r3qh,        c1qh,
     $               i0year,i0mon,i0day,i0sec,i0secint,
     $               s0ave,n0m,i0m,r2arafrc,s0ave)
                call wrte_bints3(n0l,n0t,
     $               r1qg,          r3qg,        c1qg,
     $               i0year,i0mon,i0day,i0sec,i0secint,
     $               s0ave,n0m,i0m,r2arafrc,s0ave)
                call wrte_bints3(n0l,n0t,
     $               r1qf,          r3qf,        c1qf,
     $               i0year,i0mon,i0day,i0sec,i0secint,
     $               s0ave,n0m,i0m,r2arafrc,s0ave)
                call wrte_bints3(n0l,n0t,
     $               r1qv,          r3qv,        c1qv,
     $               i0year,i0mon,i0day,i0sec,i0secint,
     $               s0ave,n0m,i0m,r2arafrc,s0ave)
d               write(*,*) 'main: Output'
d               write(*,*) 'main: |-r1swnet:  ',r1swnet(i0ldbg)
d               write(*,*) 'main: |-r1lwnet:  ',r1lwnet(i0ldbg)
d               write(*,*) 'main: |-r1qle:    ',r1qle(i0ldbg)
d               write(*,*) 'main: |-r1qh:     ',r1qh(i0ldbg)
d               write(*,*) 'main: |-r1qg:     ',r1qg(i0ldbg)
d               write(*,*) 'main: |-r1qf:     ',r1qf(i0ldbg)
d               write(*,*) 'main: |-r1qv:     ',r1qv(i0ldbg)
c out2
                call wrte_bints3(n0l,n0t,
     $               r1evap,        r3evap,      c1evap,
     $               i0year,i0mon,i0day,i0sec,i0secint,
     $               s0ave,n0m,i0m,r2arafrc,s0ave)
                call wrte_bints3(n0l,n0t,
     $               r1qs,          r3qs,        c1qs,
     $               i0year,i0mon,i0day,i0sec,i0secint,
     $               s0ave,n0m,i0m,r2arafrc,s0ave)
                call wrte_bints3(n0l,n0t,
     $               r1qsb,         r3qsb,       c1qsb,
     $               i0year,i0mon,i0day,i0sec,i0secint,
     $               s0ave,n0m,i0m,r2arafrc,s0ave)
                call wrte_bints3(n0l,n0t,
     $               r1qtot,        r3qtot,      c1qtot,
     $               i0year,i0mon,i0day,i0sec,i0secint,
     $               s0ave,n0m,i0m,r2arafrc,s0ave)
                call wrte_bints3(n0l,n0t,
     $               r1qsm,        r3qsm,      c1qsm,
     $               i0year,i0mon,i0day,i0sec,i0secint,
     $               s0ave,n0m,i0m,r2arafrc,s0ave)
d               write(*,*) 'main: |-r1snowf:  ',r1snowf(i0ldbg)
d               write(*,*) 'main: |-r1rainf:  ',r1rainf(i0ldbg)
d               write(*,*) 'main: |-r1evap:   ',r1evap(i0ldbg)
d               write(*,*) 'main: |-r1qs:     ',r1qs(i0ldbg)
d               write(*,*) 'main: |-r1qsb:    ',r1qsb(i0ldbg)
d               write(*,*) 'main: |-r1qtot:   ',r1qtot(i0ldbg)
d               write(*,*) 'main: |-r1qsm:    ',r1qsm(i0ldbg)
c out3
                call wrte_bints3(n0l,n0t,
     $               r1albedo,      r3albedo,    c1albedo,
     $               i0year,i0mon,i0day,i0sec,i0secint,
     $               s0sta,n0m,i0m,r2arafrc,s0ave)
d               write(*,*) 'main: |-r1albedo:    ',r1albedo(i0ldbg)
c out4
                call wrte_bints3(n0l,n0t,
     $               r1soilwet,    r3soilwet,  c1soilwet,
     $               i0year,i0mon,i0day,i0sec,i0secint,
     $               s0sta,n0m,i0m,r2arafrc,s0ave)
d               write(*,*) 'main: |-r1soilwet:    ',r1soilwet(i0ldbg)
c out5
                call wrte_bints3(n0l,n0t,
     $               r1potevap,     r3potevap,   c1potevap,
     $               i0year,i0mon,i0day,i0sec,i0secint,
     $               s0ave,n0m,i0m,r2arafrc,s0ave)
                call wrte_bints3(n0l,n0t,
     $               r1subsnow,     r3subsnow,   c1subsnow,
     $               i0year,i0mon,i0day,i0sec,i0secint,
     $               s0ave,n0m,i0m,r2arafrc,s0ave)
d               write(*,*) 'main: |-r1potevap:  ',r1potevap(i0ldbg)
d               write(*,*) 'main: |-r1subsnow:  ',r1subsnow(i0ldbg)
c out 7
                call wrte_bints3(n0l,n0t,
     $               r1salbedo,     r3salbedo,   c1salbedo,
     $               i0year,i0mon,i0day,i0sec,i0secint,
     $               s0sta,n0m,i0m,r2arafrc,s0ave)
d               write(*,*) 'main: |-r1salbedo:  ',r1salbedo(i0ldbg)
c out 8
                call wrte_bints3(n0l,n0t,
     $               r1qrc,     r3qrc,   c1qrc,
     $               i0year,i0mon,i0day,i0sec,i0secint,
     $               s0ave,n0m,i0m,r2arafrc,s0ave)
                call wrte_bints3(n0l,n0t,
     $               r1qbf,     r3qbf,   c1qbf,
     $               i0year,i0mon,i0day,i0sec,i0secint,
     $               s0ave,n0m,i0m,r2arafrc,s0ave)
d               write(*,*) 'main: |-r1qrc:  ',r1qrc(i0ldbg)
d               write(*,*) 'main: |-r1qbf:  ',r1qbf(i0ldbg)
              end do
c
              call wrte_bints2(n0l,n0t,
     $               r1snowf,       r2snowf,     c0snowfout,
     $               i0year,i0mon,i0day,i0sec,i0secint,
     $               s0ave)
              call wrte_bints2(n0l,n0t,
     $               r1rainf,       r2rainf,     c0rainfout,
     $               i0year,i0mon,i0day,i0sec,i0secint,
     $               s0ave)
              call wrte_bints2(n0l,n0t,
     $               r1tair,        r2tair,      c0tairout,
     $               i0year,i0mon,i0day,i0sec,i0secint,
     $               s0ave)
              call wrte_bints2(n0l,n0t,
     $               r1lwdown,      r2lwdown,    c0lwdownout,
     $               i0year,i0mon,i0day,i0sec,i0secint,
     $               s0ave)
c
              c0tmp='NO'   !! needed for crop calculation
              call wrte_bints2(n0l,n0t,
     $               r1swdown,      r2swdown,    c0tmp,
     $               i0year,i0mon,i0day,i0sec,i0secint,
     $               s0ave)
c update rgw
              do i0l=1,n0l
                r1rgw(i0l)=r3rgw(i0l,0,0)
                r1rgw_pr(i0l)=r3rgw(i0l,0,0)
              end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Surface/Ground water separation
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
              do i0l=1,n0l
                if(r1demagr(i0l).ne.p0mis.and.
     $             r1frcgwind(i0l).ne.p0mis)then
                  r1demagrg(i0l)=r1demagr(i0l)*r1frcgwagr(i0l)
     $                          /r1irgeffg(i0l)
                else
                  r1demagrg(i0l)=p0mis
                end if
              end do
              do i0l=1,n0l
                if(r1demind(i0l).ne.p0mis.and.
     $             r1frcgwind(i0l).ne.p0mis)then
                  r1demindg(i0l)=r1demind(i0l)*r1frcgwind(i0l)
     $                          /r1indeff(i0l)
                else
                  r1demindg(i0l)=p0mis
                end if
              end do
              do i0l=1,n0l
                if(r1demdom(i0l).ne.p0mis.and.
     $             r1frcgwdom(i0l).ne.p0mis)then
                  r1demdomg(i0l)=r1demdom(i0l)*r1frcgwdom(i0l)
     $                          /r1domeff(i0l)
                else
                  r1demdomg(i0l)=p0mis
                end if
              end do
c     
              do i0l=1,n0l
                if(r1demagr(i0l).ne.p0mis)then
                  r1demagrs(i0l)=r1demagr(i0l)*(1.0-r1frcgwagr(i0l))
     $                          /r1irgeffs(i0l)
                else
                  r1demagrs(i0l)=p0mis
                end if
              end do
              do i0l=1,n0l
                if(r1demind(i0l).ne.p0mis.and.
     $             r1frcgwind(i0l).ne.p0mis)then
                  r1deminds(i0l)=r1demind(i0l)*(1.0-r1frcgwind(i0l))
     $                          /r1indeff(i0l)
                else
                  r1deminds(i0l)=p0mis
                end if
              end do
              do i0l=1,n0l
                if(r1demdom(i0l).ne.p0mis.and.
     $             r1frcgwdom(i0l).ne.p0mis)then
                  r1demdoms(i0l)=r1demdom(i0l)*(1.0-r1frcgwdom(i0l))
     $                          /r1domeff(i0l)
                else
                  r1demdoms(i0l)=p0mis
                end if
              end do
c
d     write(*,*) 'main r1demagrg ',r1demagrg(i0ldbg)
d     write(*,*) 'main r1demindg ',r1demindg(i0ldbg)
d     write(*,*) 'main r1demdomg ',r1demdomg(i0ldbg)
d     write(*,*) 'main r1demagrs ',r1demagrs(i0ldbg)
d     write(*,*) 'main r1deminds ',r1deminds(i0ldbg)
d     write(*,*) 'main r1demdoms ',r1demdoms(i0ldbg)
c

              call calc_humact_hyper(
     $             n0l,         i0ldbg,
     $             i0secint,    r1rivseq,    r0rivseqmax,
     $             r1rivnxl,    r1lndara,    r1paramc,
     $             r1rivsto_pr, r1qtot,
     $             r1rivsto,    r1rivinf,    r1rivout,
     $             r1damsto,    r1daminf,    r1damout,
     $             r1demagrs,   r1deminds,   r1demdoms,
     $             r1demagrg,   r1demindg,   r1demdomg,
     $             r1supagrs,   r1supinds,   r1supdoms,
     $             r1supagrg,   r1supindg,   r1supdomg,
     $             r1supagrriv, r1supindriv, r1supdomriv,
     $             r1supagrcan, r1supindcan, r1supdomcan,
     $             r1supagrrgw, r1supindrgw,  r1supdomrgw,
     $             r1supagrmsr, r1supindmsr, r1supdommsr,
     $             r1supagrnnbs, r1supindnnbs, r1supdomnnbs,
     $             r1supagrnnbg, r1supindnnbg, r1supdomnnbg,
     $             r1supagrdes, r1supinddes, r1supdomdes,
     $             r1supagrrcl, r1supindrcl, r1supdomrcl,
     $             r1supagrdef, r1supinddef, r1supdomdef,
     $             r1frcgwagr,  r1frcgwind,  r1frcgwdom,
     $             c0optnnb,    c0optriv,
     $             c0optrgw,    c0optdes,    c0optrcl,
     $             i2lcan,      n0rec,       i1despot,    i1rclpot,
     $             r1envflw,
     $             i1damid_,    r1damcap,    r1msrcap,
     $             r1msrsto,    r1msrinf,    r1msrout,
     $             r1msrafc,    r1rgw,
     $             r1targetmax, r1targetmin)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c aggregation
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
              do i0l=1,n0l
                if(r1supagr(i0l).ne.p0mis)then
                  r1losagr(i0l)
     $           =r1supagrs(i0l)*(1.0-r1irgeffs(i0l))*r1irglos(i0l)
     $           +r1supagrg(i0l)*(1.0-r1irgeffg(i0l))*r1irglos(i0l)
                  r1rtfagr(i0l)
     $          =r1supagrs(i0l)*(1.0-r1irgeffs(i0l))*(1.0-r1irglos(i0l))
     $          +r1supagrg(i0l)*(1.0-r1irgeffg(i0l))*(1.0-r1irglos(i0l))
                  r1supagr(i0l)
     $           =r1supagrs(i0l)*r1irgeffs(i0l)
     $           +r1supagrg(i0l)*r1irgeffg(i0l)
                else
                  r1supagr(i0l)=p0mis
                end if
              end do
d             write(*,*) 'main r1supagr ',r1supagr(i0ldbg)
c
              do i0l=1,n0l
                if(r1supdom(i0l).ne.p0mis)then
                  r1supdom(i0l)=r1supdoms(i0l)+r1supdomg(i0l)
                end if
              end do
c
              do i0l=1,n0l
                if(r1supind(i0l).ne.p0mis)then
                  r1supind(i0l)=r1supinds(i0l)+r1supindg(i0l)
                end if
              end do
c
              do i0l=1,n0l
                if(r1demind(i0l).ne.p0mis)then
                  r1rtfind(i0l)=r1supind(i0l)*(1.0-r1indeff(i0l))
                  r1supind(i0l)=r1supind(i0l)*r1indeff(i0l)
                else
                  r1supind(i0l)=p0mis
                end if
              end do
d             write(*,*) 'main r1supind ',r1supind(i0ldbg)
c
              do i0l=1,n0l
                if(r1demdom(i0l).ne.p0mis)then
                  r1rtfdom(i0l)=r1supdom(i0l)*(1.0-r1domeff(i0l))
                  r1supdom(i0l)=r1supdom(i0l)*r1domeff(i0l)
                else
                  r1supdom(i0l)=p0mis
                end if
              end do
d             write(*,*) 'main r1supdom ',r1supdom(i0ldbg)
c
              r1rivinf=0.0
              do i0l=1,n0l
                i0rivnxl=int(r1rivnxl(i0l))
                if(i0l.ne.i0rivnxl)then
                  if(r1rtfagr(i0l).ne.p0mis.and.i0rivnxl.ne.0)then
                    r1rivinf(i0rivnxl)
     $             =r1rivinf(i0rivnxl)+r1rtfagr(i0l)
                  end if
                else
                  if(r1rtfagr(i0l).ne.p0mis)then
                    r1rivout(i0l)
     $             =r1rivout(i0l)+r1rtfagr(i0l)
                  end if                  
                end if
              end do
              do i0l=1,n0l
                i0rivnxl=int(r1rivnxl(i0l))
                if(i0l.ne.i0rivnxl)then
                  if(r1rtfind(i0l).ne.p0mis.and.i0rivnxl.ne.0)then
                    r1rivinf(i0rivnxl)
     $             =r1rivinf(i0rivnxl)+r1rtfind(i0l)
                  end if
                else
                  if(r1rtfind(i0l).ne.p0mis)then
                    r1rivout(i0l)
     $             =r1rivout(i0l)+r1rtfind(i0l)
                  end if
                end if
              end do
              do i0l=1,n0l
                i0rivnxl=int(r1rivnxl(i0l))
                if(i0l.ne.i0rivnxl)then
                  if(r1rtfdom(i0l).ne.p0mis.and.i0rivnxl.ne.0)then
                    r1rivinf(i0rivnxl)
     $             =r1rivinf(i0rivnxl)+r1rtfdom(i0l)
                  end if
                else
                  if(r1rtfdom(i0l).ne.p0mis)then
                    r1rivout(i0l)
     $             =r1rivout(i0l)+r1rtfdom(i0l)
                  end if
                end if
              end do
c
              do i0l=1,n0l
                r1rivsto_pr(i0l)=r1rivsto(i0l)
              end do
c update rgw
              do i0m=1,n0m
                do i0l=1,n0l
                  if(r3rgw(i0l,0,i0m).ne.p0mis)then
                    r1tmp(i0l)=r1rgw(i0l)-r1rgw_pr(i0l)
                    r3rgw(i0l,0,i0m)=r3rgw(i0l,0,i0m)+r1tmp(i0l)
                  end if
                end do
              end do
c              write(*,*) 'main: r3rgw(1):',r3rgw(i0ldbg,0,1)
c              write(*,*) 'main: r3rgw(2):',r3rgw(i0ldbg,0,2)
c              write(*,*) 'main: r3rgw(3):',r3rgw(i0ldbg,0,3)
c              write(*,*) 'main: r3rgw(4):',r3rgw(i0ldbg,0,4)
c
              do i0l=1,n0l
                r1tmp(i0l)=r1supagrriv(i0l)+r1supagrrgw(i0l)
     $                    +r1supagrmsr(i0l)
     $                    +r1supagrnnbs(i0l)+r1supagrnnbg(i0l)
              end do
              do i0l=1,n0l
                if(r1tmp(i0l).ne.0.0)then
                  r1frcsupagrriv(i0l)=r1supagrriv(i0l)/r1tmp(i0l)
                  r1frcsupagrrgw(i0l)=r1supagrrgw(i0l)/r1tmp(i0l)
                  r1frcsupagrmsr(i0l)=r1supagrmsr(i0l)/r1tmp(i0l)
                  r1frcsupagrnnb(i0l)=(r1supagrnnbs(i0l)
     $                                +r1supagrnnbg(i0l))/r1tmp(i0l)
                end if
              end do
c riv
              call wrte_bints2(n0l,n0t,
     $             r1rivout,       r2rivout,     c0dis,
     $             i0year,i0mon,i0day,i0sec,i0secint,
     $             s0ave)
              call wrte_bints2(n0l,n0t,
     $             r1rivsto,       r2rivsto,     c0rivsto,
     $             i0year,i0mon,i0day,i0sec,i0secint,
     $             s0sta)
c dam
              call wrte_bints2(n0l,n0t,
     $             r1damout,       r2damout,     c0damout,
     $             i0year,i0mon,i0day,i0sec,i0secint,
     $             s0ave)
              call wrte_bints2(n0l,n0t,
     $             r1daminf,       r2daminf,     c0daminf,
     $             i0year,i0mon,i0day,i0sec,i0secint,
     $             s0ave)
              call wrte_bints2(n0l,n0t,
     $             r1damsto,       r2damsto,     c0damsto,
     $             i0year,i0mon,i0day,i0sec,i0secint,
     $             s0sta)
c 
              call wrte_bints2(n0l,n0t,
     $             r1krls,         r2krls,       c0krls,
     $             i0year,i0mon,i0day,i0sec,i0secint,
     $             s0sta)
c
        
c msr
              call wrte_bints2(n0l,n0t,
     $             r1msrout,       r2msrout,     c0msrout,
     $             i0year,i0mon,i0day,i0sec,i0secint,
     $             s0ave)
              call wrte_bints2(n0l,n0t,
     $             r1msrsto,       r2msrsto,     c0msrsto,
     $             i0year,i0mon,i0day,i0sec,i0secint,
     $             s0sta)
c sup (total)
              call wrte_bints2(n0l,n0t,
     $             r1supagr,       r2supagr,     c0supagr,
     $             i0year,i0mon,i0day,i0sec,i0secint,
     $             s0ave)
              call wrte_bints2(n0l,n0t,
     $             r1supind,       r2supind,     c0supind,
     $             i0year,i0mon,i0day,i0sec,i0secint,
     $             s0ave)
              call wrte_bints2(n0l,n0t,
     $             r1supdom,       r2supdom,     c0supdom,
     $             i0year,i0mon,i0day,i0sec,i0secint,
     $             s0ave)
c sup (riv)
              call wrte_bints2(n0l,n0t,
     $             r1supagrriv,       r2supagrriv,     c0supagrriv,
     $             i0year,i0mon,i0day,i0sec,i0secint,
     $             s0ave)
              call wrte_bints2(n0l,n0t,
     $             r1supindriv,       r2supindriv,     c0supindriv,
     $             i0year,i0mon,i0day,i0sec,i0secint,
     $             s0ave)
              call wrte_bints2(n0l,n0t,
     $             r1supdomriv,       r2supdomriv,     c0supdomriv,
     $             i0year,i0mon,i0day,i0sec,i0secint,
     $             s0ave)
c sup (can)
              call wrte_bints2(n0l,n0t,
     $             r1supagrcan,       r2supagrcan,     c0supagrcan,
     $             i0year,i0mon,i0day,i0sec,i0secint,
     $             s0ave)
              call wrte_bints2(n0l,n0t,
     $             r1supindcan,       r2supindcan,     c0supindcan,
     $             i0year,i0mon,i0day,i0sec,i0secint,
     $             s0ave)
              call wrte_bints2(n0l,n0t,
     $             r1supdomcan,       r2supdomcan,     c0supdomcan,
     $             i0year,i0mon,i0day,i0sec,i0secint,
     $             s0ave)
c sup (rgw)
              call wrte_bints2(n0l,n0t,
     $             r1supagrrgw,       r2supagrrgw,     c0supagrrgw,
     $             i0year,i0mon,i0day,i0sec,i0secint,
     $             s0ave)
              call wrte_bints2(n0l,n0t,
     $             r1supindrgw,       r2supindrgw,     c0supindrgw,
     $             i0year,i0mon,i0day,i0sec,i0secint,
     $             s0ave)
              call wrte_bints2(n0l,n0t,
     $             r1supdomrgw,       r2supdomrgw,     c0supdomrgw,
     $             i0year,i0mon,i0day,i0sec,i0secint,
     $             s0ave)
c sup (msr)
              call wrte_bints2(n0l,n0t,
     $             r1supagrmsr,       r2supagrmsr,     c0supagrmsr,
     $             i0year,i0mon,i0day,i0sec,i0secint,
     $             s0ave)
              call wrte_bints2(n0l,n0t,
     $             r1supindmsr,       r2supindmsr,     c0supindmsr,
     $             i0year,i0mon,i0day,i0sec,i0secint,
     $             s0ave)
              call wrte_bints2(n0l,n0t,
     $             r1supdommsr,       r2supdommsr,     c0supdommsr,
     $             i0year,i0mon,i0day,i0sec,i0secint,
     $             s0ave)
c sup (nnb-sw)
              call wrte_bints2(n0l,n0t,
     $             r1supagrnnbs,     r2supagrnnbs,   c0supagrnnbs,
     $             i0year,i0mon,i0day,i0sec,i0secint,
     $             s0ave)
              call wrte_bints2(n0l,n0t,
     $             r1supindnnbs,     r2supindnnbs,   c0supindnnbs,
     $             i0year,i0mon,i0day,i0sec,i0secint,
     $             s0ave)
              call wrte_bints2(n0l,n0t,
     $             r1supdomnnbs,     r2supdomnnbs,   c0supdomnnbs,
     $             i0year,i0mon,i0day,i0sec,i0secint,
     $             s0ave)
c sup (nnb-gw)
              call wrte_bints2(n0l,n0t,
     $             r1supagrnnbg,     r2supagrnnbg,   c0supagrnnbg,
     $             i0year,i0mon,i0day,i0sec,i0secint,
     $             s0ave)
              call wrte_bints2(n0l,n0t,
     $             r1supindnnbg,     r2supindnnbg,   c0supindnnbg,
     $             i0year,i0mon,i0day,i0sec,i0secint,
     $             s0ave)
              call wrte_bints2(n0l,n0t,
     $             r1supdomnnbg,     r2supdomnnbg,   c0supdomnnbg,
     $             i0year,i0mon,i0day,i0sec,i0secint,
     $             s0ave)
c sup (des)
              call wrte_bints2(n0l,n0t,
     $             r1supagrdes,       r2supagrdes,     c0supagrdes,
     $             i0year,i0mon,i0day,i0sec,i0secint,
     $             s0ave)
              call wrte_bints2(n0l,n0t,
     $             r1supinddes,       r2supinddes,     c0supinddes,
     $             i0year,i0mon,i0day,i0sec,i0secint,
     $             s0ave)
              call wrte_bints2(n0l,n0t,
     $             r1supdomdes,       r2supdomdes,     c0supdomdes,
     $             i0year,i0mon,i0day,i0sec,i0secint,
     $             s0ave)
c sup (rcl)
              call wrte_bints2(n0l,n0t,
     $             r1supagrrcl,       r2supagrrcl,     c0supagrrcl,
     $             i0year,i0mon,i0day,i0sec,i0secint,
     $             s0ave)
              call wrte_bints2(n0l,n0t,
     $             r1supindrcl,       r2supindrcl,     c0supindrcl,
     $             i0year,i0mon,i0day,i0sec,i0secint,
     $             s0ave)
              call wrte_bints2(n0l,n0t,
     $             r1supdomrcl,       r2supdomrcl,     c0supdomrcl,
     $             i0year,i0mon,i0day,i0sec,i0secint,
     $             s0ave)
c sup (def)
              call wrte_bints2(n0l,n0t,
     $             r1supagrdef,       r2supagrdef,     c0supagrdef,
     $             i0year,i0mon,i0day,i0sec,i0secint,
     $             s0ave)
              call wrte_bints2(n0l,n0t,
     $             r1supinddef,       r2supinddef,     c0supinddef,
     $             i0year,i0mon,i0day,i0sec,i0secint,
     $             s0ave)
              call wrte_bints2(n0l,n0t,
     $             r1supdomdef,       r2supdomdef,     c0supdomdef,
     $             i0year,i0mon,i0day,i0sec,i0secint,
     $             s0ave)
c return flow/loss
              call wrte_bints2(n0l,n0t,
     $             r1rtfagr,       r2rtfagr,     c0rtfagr,
     $             i0year,i0mon,i0day,i0sec,i0secint,
     $             s0ave)
              call wrte_bints2(n0l,n0t,
     $             r1rtfind,       r2rtfind,     c0rtfind,
     $             i0year,i0mon,i0day,i0sec,i0secint,
     $             s0ave)
              call wrte_bints2(n0l,n0t,
     $             r1rtfdom,       r2rtfdom,     c0rtfdom,
     $             i0year,i0mon,i0day,i0sec,i0secint,
     $             s0ave)
              call wrte_bints2(n0l,n0t,
     $             r1losagr,       r2losagr,     c0losagr,
     $             i0year,i0mon,i0day,i0sec,i0secint,
     $             s0ave)
c
              if(i0sec.eq.n0secday)then
                i0doy=igetdoy(i0year,i0mon,i0day)
                do i0m=1,n0m
c

                  if(c1optlnduse(i0m).eq.'dpi'.or.
     $               c1optlnduse(i0m).eq.'dpr')then
                    do i0l=1,n0l
                      if(i2flgculp(i0l,1).eq.1)then
                        i1flgcul(i0l)=1
                        i1flg2nd(i0l)=0
                        i1crptyp(i0l)=i2crptypp(i0l,1)
                        i1crpday(i0l)=int(r2crpday(i0l,i0m))+1
                      else if(i2flgculp(i0l,2).eq.1)then
                        i1flgcul(i0l)=1
                        i1flg2nd(i0l)=1
                        i1crptyp(i0l)=i2crptypp(i0l,2)
                        i1crpday(i0l)=int(r2crpday(i0l,i0m))+1
                      else
                        i1flgcul(i0l)=0
                        i1flg2nd(i0l)=0
                        i1crptyp(i0l)=0
                        i1crpday(i0l)=0
                      end if
                    end do
ccc

                  else if(c1optlnduse(i0m).eq.'sci'.or.
     $                    c1optlnduse(i0m).eq.'scr')then
                    do i0l=1,n0l
                      if(i2flgculf(i0l,1).eq.1)then
                        i1flgcul(i0l)=1
                        i1flg2nd(i0l)=0
                        i1crptyp(i0l)=i2crptypf(i0l,1)
                        i1crpday(i0l)=int(r2crpday(i0l,i0m))+1
                      else
                        i1flgcul(i0l)=0
                        i1flg2nd(i0l)=0
                        i1crptyp(i0l)=0
                        i1crpday(i0l)=0                        
                      end if
                    end do
c
                  else if(c1optlnduse(i0m).eq.'spi')then
                    do i0l=1,n0l
                      if(i2flgculp(i0l,1).eq.1)then
                        i1flgcul(i0l)=1
                        i1flg2nd(i0l)=0
                        i1crptyp(i0l)=i2crptypp(i0l,1)
                        i1crpday(i0l)=int(r2crpday(i0l,i0m))+1
                      else
                        i1flgcul(i0l)=0
                        i1flg2nd(i0l)=0
                        i1crptyp(i0l)=0
                        i1crpday(i0l)=0                        
                      end if
                    end do
ccc
                  else if(c1optlnduse(i0m).eq.'non')then
                    do i0l=1,n0l
                      i1flgcul(i0l)=0
                      i1flg2nd(i0l)=0
                      i1crptyp(i0l)=0
                      i1crpday(i0l)=0
                    end do
                  else
                    write(*,*) 'main: i0m:        ',i0m
                    write(*,*) 'main: c1optlnduse:',c1optlnduse(i0m)
                    stop
                  end if
c
                  do i0l=1,n0l
                    r1tair(i0l)=r2tair(i0l,1)
                  end do
                  do i0l=1,n0l
                    r1swdown(i0l)=r2swdown(i0l,1)
                  end do
                  do i0l=1,n0l
                    r1evap(i0l)=r3evap(i0l,1,i0m)
                  end do
                  do i0l=1,n0l
                    r1evapgrn(i0l)=r3evapgrn(i0l,1,i0m)
                  end do
                  do i0l=1,n0l
                    r1evapblu(i0l)=r3evapblu(i0l,1,i0m)
                  end do
                  do i0l=1,n0l
                    r1potevap(i0l)=r3potevap(i0l,1,i0m)
                  end do
c
                  do i0l=1,n0l
                    r1huna(i0l)=r2huna(i0l,i0m)
                  end do
                  do i0l=1,n0l
                    r1swu(i0l)=r2swu(i0l,i0m)   
                  end do
                  do i0l=1,n0l  
                    r1swp(i0l)=r2swp(i0l,i0m)   
                  end do
                  do i0l=1,n0l   
                    r1regfw(i0l)=r2regfw(i0l,i0m) 
                  end do
                  do i0l=1,n0l  
                    r1regfl(i0l)=r2regfl(i0l,i0m) 
                  end do
                  do i0l=1,n0l  
                    r1regfh(i0l)=r2regfh(i0l,i0m)
                  end do
                  do i0l=1,n0l
                    r1regfn(i0l)=r2regfn(i0l,i0m) 
                  end do
                  do i0l=1,n0l   
                    r1regfp(i0l)=r2regfp(i0l,i0m)
                  end do
                  do i0l=1,n0l
                    r1bt(i0l)=r2bt(i0l,i0m)    
                  end do
                  do i0l=1,n0l   
                    r1rsd(i0l)=r2rsd(i0l,i0m)   
                  end do
                  do i0l=1,n0l  
                    r1outb(i0l)=r2outb(i0l,i0m)
                  end do
                  do i0l=1,n0l  
                    r1cwd(i0l)=r2cwd(i0l,i0m)
                  end do
                  do i0l=1,n0l
                    r1cws(i0l)=r2cws(i0l,i0m)   
                  end do
                  do i0l=1,n0l
                    r1cwsgrn(i0l)=r2cwsgrn(i0l,i0m)   
                  end do
                  do i0l=1,n0l
                    r1cwsblu(i0l)=r2cwsblu(i0l,i0m)   
                  end do
c
d                 write(*,*) 'main: Before calc_crpyld'
d                 write(*,*) 'main: |-i0m:        ',i0m
d                 write(*,*) 'main: |-c1optlnduse:',c1optlnduse(i0m)
d                 write(*,*) 'main: |-i0crpdaymax:',i0crpdaymax
d                 write(*,*) 'main: |-r0regfmin:  ',r0regfmin
d                 write(*,*) 'main: |-r0tdorm:    ',r0tdorm
d                 write(*,*) 'main: |-r0tfrz:     ',r0tfrz
d                 write(*,*) 'main: |-r0thvs:     ',r0thvs
d                 write(*,*) 'main: |-r0hunmax:   ',r0hunmax
d                 write(*,*) 'main: |-r1ihunmat:  ',r0ihunmat
d                 write(*,*) 'main: |-i1flgcul:   ',i1flgcul(i0ldbg)
d                 write(*,*) 'main: |-i1crptyp:   ',i1crptyp(i0ldbg)
d                 write(*,*) 'main: |-i1crpday:   ',i1crpday(i0ldbg)
d                 write(*,*) 'main: |-r1tair:     ',r1tair(i0ldbg)
d                 write(*,*) 'main: |-r1swdown:   ',r1swdown(i0ldbg)
d                 write(*,*) 'main: |-r1potevap:  ',r1potevap(i0ldbg)
d                 write(*,*) 'main: |-r1evap:     ',r1evap(i0ldbg)
d                 write(*,*) 'main: |-r1evapgrn:  ',r1evapgrn(i0ldbg)
d                 write(*,*) 'main: |-r1evapblu:  ',r1evapblu(i0ldbg)
d                 write(*,*) 'main: |-r1huna:     ',r1huna(i0ldbg)
d                 write(*,*) 'main: |-r1swu :     ',r1swu(i0ldbg)
d                 write(*,*) 'main: |-r1swp :     ',r1swp(i0ldbg)
d                 write(*,*) 'main: |-r1regfw:    ',r1regfw(i0ldbg)
d                 write(*,*) 'main: |-r1regfl:    ',r1regfl(i0ldbg)
d                 write(*,*) 'main: |-r1regfh:    ',r1regfh(i0ldbg)
d                 write(*,*) 'main: |-r1regfn:    ',r1regfn(i0ldbg)
d                 write(*,*) 'main: |-r1regfp:    ',r1regfp(i0ldbg)
d                 write(*,*) 'main: |-r1bt:       ',r1bt(i0ldbg)
d                 write(*,*) 'main: |-r1rsd:      ',r1rsd(i0ldbg)
d                 write(*,*) 'main: |-r1outb:     ',r1outb(i0ldbg)
d                 write(*,*) 'main: |-r1cwd:      ',r1cwd(i0ldbg)
d                 write(*,*) 'main: |-r1cws:      ',r1cws(i0ldbg)
d                 write(*,*) 'main: |-r1cwsgrn:   ',r1cwsgrn(i0ldbg)
d                 write(*,*) 'main: |-r1cwsblu:   ',r1cwsblu(i0ldbg)

c
                  i1flgocu=0
cdebug2020/09/11
                  write(*,*) 'main: doy=',i0doy,i0m,i1crptyp(i0ldbg)
                  call calc_crpyld(
     $                 n0l,        n0ram,
     $                 i0ldbg,
     $                 i0crpdaymax,r0regfmin,  r0tdorm,    r0tfrz,
     $                 r0thvs,     r0hunmax,   r0ihunmat,  c0optts,
     $                 c0optws,    c0optns,    c0optps,    c0optfrz,
     $                 r1icnum,    r1ird,      r1be,       r1hvsti,
     $                 r1to,       r1tb,       r1blai,     r1dlai,
     $                 r1dlp1,     r1dlp2,     r1bn1,      r1bn2,
     $                 r1bn3,      r1bp1,      r1bp2,      r1bp3,
     $                 r1cnyld,    r1cpyld,    r1rdmx,     r1cvm,
     $                 r1almn,     r1sla,      r1pt2,      r1phun,
     $                 i1flgcul,   i1crptyp,   i1crpday,
     $                 r1tair,     r1swdown,   r1potevap,  r1evap,
     $                 r1evapgrn,  r1evapblu,
     $                 r1huna,     r1swu,      r1swp,      r1regfw,
     $                 r1regfl,    r1regfh,    r1regfn,    r1regfp,
     $                 r1bt,       r1rsd,      r1outb,
     $                 r1cwd,      r1cws,      r1yld,      r1regfd,
     $                 r1cwsgrn,   r1cwsblu,
     $                 i1flgmat,   i1flgend,   i1flgocu)
c
d                 write(*,*) 'main: After calc_crpyld'
d                 write(*,*) 'main: |-r1huna:     ',r1huna(i0ldbg)
d                 write(*,*) 'main: |-r1swu :     ',r1swu(i0ldbg)
d                 write(*,*) 'main: |-r1swp :     ',r1swp(i0ldbg)
d                 write(*,*) 'main: |-r1regfw:    ',r1regfw(i0ldbg)
d                 write(*,*) 'main: |-r1regfl:    ',r1regfl(i0ldbg)
d                 write(*,*) 'main: |-r1regfh:    ',r1regfh(i0ldbg)
d                 write(*,*) 'main: |-r1regfn:    ',r1regfn(i0ldbg)
d                 write(*,*) 'main: |-r1regfp:    ',r1regfp(i0ldbg)
d                 write(*,*) 'main: |-r1bt:       ',r1bt(i0ldbg)
d                 write(*,*) 'main: |-r1rsd:      ',r1rsd(i0ldbg)
d                 write(*,*) 'main: |-r1outb:     ',r1outb(i0ldbg)
d                 write(*,*) 'main: |-r1cwd:      ',r1cwd(i0ldbg)
d                 write(*,*) 'main: |-r1cws:      ',r1cws(i0ldbg)
d                 write(*,*) 'main: |-r1cwsgrn:   ',r1cwsgrn(i0ldbg)
d                 write(*,*) 'main: |-r1cwsblu:   ',r1cwsblu(i0ldbg)
d                 write(*,*) 'main: |-r1yld:      ',r1yld(i0ldbg)
d                 write(*,*) 'main: |-r1regfd:    ',r1regfd(i0ldbg)
d                 write(*,*) 'main: |-i1flgmat:   ',i1flgmat(i0ldbg)
c output
                  do i0l=1,n0l
                    if(i1flgmat(i0l).eq.1)then
                      if(i1flg2nd(i0l).eq.1)then
                        r2cwdout2nd(i0l,i0m)=r1cwd(i0l)
                        r2cwsout2nd(i0l,i0m)=r1cws(i0l)
                        r2cwsout2ndgrn(i0l,i0m)=r1cwsgrn(i0l)
                        r2cwsout2ndblu(i0l,i0m)=r1cwsblu(i0l)
                        r2yldout2nd(i0l,i0m)=r1yld(i0l)
                        r2regfdout2nd(i0l,i0m)=r1regfd(i0l)
                        r2crpdayout2nd(i0l,i0m)=real(i1crpday(i0l))
                        r2hvsdoyout2nd(i0l,i0m)=real(i0doy)
                      else
                        r2cwdout1st(i0l,i0m)=r1cwd(i0l)
                        r2cwsout1st(i0l,i0m)=r1cws(i0l)
                        r2cwsout1stgrn(i0l,i0m)=r1cwsgrn(i0l)
                        r2cwsout1stblu(i0l,i0m)=r1cwsblu(i0l)
                        r2yldout1st(i0l,i0m)=r1yld(i0l)
                        r2regfdout1st(i0l,i0m)=r1regfd(i0l)
                        r2crpdayout1st(i0l,i0m)=real(i1crpday(i0l))
                        r2hvsdoyout1st(i0l,i0m)=real(i0doy)
                      end if
c     
d                     if(i0l.eq.i0ldbg)then
d                       write(*,*) 'main: i1flgmat: ',i1flgmat(i0ldbg)
d                       write(*,*) 'main: r1cwd:    ',r1cwd(i0ldbg)
d                       write(*,*) 'main: r1cws:    ',r1cws(i0ldbg)
d                       write(*,*) 'main: r1cwsgrn: ',r1cwsgrn(i0ldbg)
d                       write(*,*) 'main: r1cwsblu: ',r1cwsblu(i0ldbg)
d                       write(*,*) 'main: r1yld:    ',r1yld(i0ldbg)
d                       write(*,*) 'main: r1regfd:  ',r1regfd(i0ldbg)
d                       write(*,*) 'main: i1crpday: ',i1crpday(i0ldbg)
d                       write(*,*) 'main: i0doy:    ',i0doy
d                     end if
c
                    end if
c
                    if(i1flgend(i0l).eq.1)then
                      if(i1flg2nd(i0l).eq.1)then
                        if(c1optlnduse(i0m).eq.'dpi'.or.
     $                     c1optlnduse(i0m).eq.'spi'.or.
     $                     c1optlnduse(i0m).eq.'dpr')then
                          i2flgculkillerp(i0l,2)=1
                        else
                          i2flgculkillerf(i0l,2)=1
                        end if
                      else
                        if(c1optlnduse(i0m).eq.'dpi'.or.
     $                     c1optlnduse(i0m).eq.'spi'.or.
     $                     c1optlnduse(i0m).eq.'dpr')then
                          i2flgculkillerp(i0l,1)=1
                        else
                          i2flgculkillerf(i0l,1)=1
                        end if
                      end if
                      r1cwd(i0l)=0.0
                      r1cws(i0l)=0.0
                      r1cwsgrn(i0l)=0.0
                      r1cwsblu(i0l)=0.0
                      r1yld(i0l)=0.0
                      r1regfd(i0l)=0.0
                      r1bt(i0l)=0.0
                      r1rsd(i0l)=0.0
                      r1outb(i0l)=0.0
                      i1crpday(i0l)=0
                    end if
                  end do
c save
                  do i0l=1,n0l
                    r2crpday(i0l,i0m)=real(i1crpday(i0l))
                  end do
c save
                  do i0l=1,n0l
                    r2huna(i0l,i0m)=r1huna(i0l)
                  end do
                  do i0l=1,n0l
                    r2swu(i0l,i0m)=r1swu(i0l)
                  end do
                  do i0l=1,n0l  
                    r2swp(i0l,i0m)=r1swp(i0l)
                  end do
                  do i0l=1,n0l   
                    r2regfw(i0l,i0m)=r1regfw(i0l)
                  end do
                  do i0l=1,n0l  
                    r2regfl(i0l,i0m)=r1regfl(i0l)
                  end do
                  do i0l=1,n0l  
                    r2regfh(i0l,i0m)=r1regfh(i0l)
                  end do
                  do i0l=1,n0l
                    r2regfn(i0l,i0m)=r1regfn(i0l)
                  end do
                  do i0l=1,n0l   
                    r2regfp(i0l,i0m)=r1regfp(i0l)
                  end do
                  do i0l=1,n0l
                    r2bt(i0l,i0m)=r1bt(i0l)
                  end do
                  do i0l=1,n0l   
                    r2rsd(i0l,i0m)=r1rsd(i0l)
                  end do
                  do i0l=1,n0l  
                    r2outb(i0l,i0m)=r1outb(i0l)
                  end do
                  do i0l=1,n0l  
                    r2cwd(i0l,i0m)=r1cwd(i0l)
                  end do
                  do i0l=1,n0l
                    r2cws(i0l,i0m)=r1cws(i0l)
                  end do
                  do i0l=1,n0l
                    r2cwsgrn(i0l,i0m)=r1cwsgrn(i0l)
                  end do
                  do i0l=1,n0l
                    r2cwsblu(i0l,i0m)=r1cwsblu(i0l)
                  end do
c write
                  if(i0mon.eq.12.and.i0day.eq.31)then
                    do i0l=1,n0l
                      r1tmp(i0l)=r2yldout1st(i0l,i0m)
                    end do
                    call wrte_bints3(n0l,n0t,
     $                   r1tmp,    r3yldout1st,   c1yldout1st,
     $                   i0year,i0mon,i0day,n0secday,n0secday,
     $                   s0sta,n0m,i0m,r2arafrc,s0sum)

                    do i0l=1,n0l
                      r1tmp(i0l)=r2cwdout1st(i0l,i0m)
                    end do
                    call wrte_bints3(n0l,n0t,
     $                   r1tmp,    r3cwdout1st,   c1cwdout1st,
     $                   i0year,i0mon,i0day,n0secday,n0secday,
     $                   s0sta,n0m,i0m,r2arafrc,s0ave)

                    do i0l=1,n0l
                      r1tmp(i0l)=r2cwsout1st(i0l,i0m)
                    end do
                    call wrte_bints3(n0l,n0t,
     $                   r1tmp,    r3cwsout1st,   c1cwsout1st,
     $                   i0year,i0mon,i0day,n0secday,n0secday,
     $                   s0sta,n0m,i0m,r2arafrc,s0ave)

                    do i0l=1,n0l
                      r1tmp(i0l)=r2cwsout1stgrn(i0l,i0m)
                    end do
                    call wrte_bints3(n0l,n0t,
     $                   r1tmp, r3cwsout1stgrn,c1cwsout1stgrn,
     $                   i0year,i0mon,i0day,n0secday,n0secday,
     $                   s0sta,n0m,i0m,r2arafrc,s0ave)

                    do i0l=1,n0l
                      r1tmp(i0l)=r2cwsout1stblu(i0l,i0m)
                    end do
                    call wrte_bints3(n0l,n0t,
     $                   r1tmp, r3cwsout1stblu,c1cwsout1stblu,
     $                   i0year,i0mon,i0day,n0secday,n0secday,
     $                   s0sta,n0m,i0m,r2arafrc,s0ave)

                    do i0l=1,n0l
                      r1tmp(i0l)=r2regfdout1st(i0l,i0m)
                    end do
                    call wrte_bints3(n0l,n0t,
     $                   r1tmp,  r3regfdout1st, c1regfdout1st,
     $                   i0year,i0mon,i0day,n0secday,n0secday,
     $                   s0sta,n0m,i0m,r2arafrc,s0sum)

                    do i0l=1,n0l
                      r1tmp(i0l)=r2crpdayout1st(i0l,i0m)
                    end do
                    call wrte_bints3(n0l,n0t,
     $                   r1tmp, r3crpdayout1st,c1crpdayout1st,
     $                   i0year,i0mon,i0day,n0secday,n0secday,
     $                   s0sta,n0m,i0m,r2arafrc,s0sum)

                    do i0l=1,n0l
                      r1tmp(i0l)=r2hvsdoyout1st(i0l,i0m)
                    end do
                    call wrte_bints3(n0l,n0t,
     $                   r1tmp, r3hvsdoyout1st,c1hvsdoyout1st,
     $                   i0year,i0mon,i0day,n0secday,n0secday,
     $                   s0sta,n0m,i0m,r2arafrc,s0sum)
                    
                    do i0l=1,n0l
                      r1tmp(i0l)=r2yldout2nd(i0l,i0m)
                    end do
                    call wrte_bints3(n0l,n0t,
     $                   r1tmp,    r3yldout2nd,   c1yldout2nd,
     $                   i0year,i0mon,i0day,n0secday,n0secday,
     $                   s0sta,n0m,i0m,r2arafrc,s0sum)

                    do i0l=1,n0l
                      r1tmp(i0l)=r2cwdout2nd(i0l,i0m)
                    end do
                    call wrte_bints3(n0l,n0t,
     $                   r1tmp,    r3cwdout2nd,   c1cwdout2nd,
     $                   i0year,i0mon,i0day,n0secday,n0secday,
     $                   s0sta,n0m,i0m,r2arafrc,s0sum)

                    do i0l=1,n0l
                      r1tmp(i0l)=r2cwsout2nd(i0l,i0m)
                    end do
                    call wrte_bints3(n0l,n0t,
     $                   r1tmp,    r3cwsout2nd,   c1cwsout2nd,
     $                   i0year,i0mon,i0day,n0secday,n0secday,
     $                   s0sta,n0m,i0m,r2arafrc,s0ave)

                    do i0l=1,n0l
                      r1tmp(i0l)=r2cwsout2ndgrn(i0l,i0m)
                    end do
                    call wrte_bints3(n0l,n0t,
     $                   r1tmp, r3cwsout2ndgrn,c1cwsout2ndgrn,
     $                   i0year,i0mon,i0day,n0secday,n0secday,
     $                   s0sta,n0m,i0m,r2arafrc,s0ave)

                    do i0l=1,n0l
                      r1tmp(i0l)=r2cwsout2ndblu(i0l,i0m)
                    end do
                    call wrte_bints3(n0l,n0t,
     $                   r1tmp, r3cwsout2ndblu,c1cwsout2ndblu,
     $                   i0year,i0mon,i0day,n0secday,n0secday,
     $                   s0sta,n0m,i0m,r2arafrc,s0ave)

                    do i0l=1,n0l
                      r1tmp(i0l)=r2regfdout2nd(i0l,i0m)
                    end do
                    call wrte_bints3(n0l,n0t,
     $                   r1tmp,  r3regfdout2nd, c1regfdout2nd,
     $                   i0year,i0mon,i0day,n0secday,n0secday,
     $                   s0sta,n0m,i0m,r2arafrc,s0sum)

                    do i0l=1,n0l
                      r1tmp(i0l)=r2crpdayout2nd(i0l,i0m)
                    end do
                    call wrte_bints3(n0l,n0t,
     $                   r1tmp, r3crpdayout2nd,c1crpdayout2nd,
     $                   i0year,i0mon,i0day,n0secday,n0secday,
     $                   s0sta,n0m,i0m,r2arafrc,s0sum)

                    do i0l=1,n0l
                      r1tmp(i0l)=r2hvsdoyout2nd(i0l,i0m)
                    end do
                    call wrte_bints3(n0l,n0t,
     $                   r1tmp, r3hvsdoyout2nd,c1hvsdoyout2nd,
     $                   i0year,i0mon,i0day,n0secday,n0secday,
     $                   s0sta,n0m,i0m,r2arafrc,s0sum)
c
                    if(i0m.eq.n0m)then
                      r2yldout1st=0.0
                      r2cwdout1st=0.0
                      r2cwsout1st=0.0
                      r2cwsout1stgrn=0.0
                      r2cwsout1stblu=0.0
                      r2regfdout1st=0.0
                      r2crpdayout1st=0.0
                      r2hvsdoyout1st=0.0
                      r2yldout2nd=0.0
                      r2cwdout2nd=0.0
                      r2cwsout2nd=0.0
                      r2cwsout2ndgrn=0.0
                      r2cwsout2ndblu=0.0
                      r2regfdout2nd=0.0
                      r2crpdayout2nd=0.0
                      r2hvsdoyout2nd=0.0
                    end if
c
                  end if
                end do !! i0m
c
                do i0l=1,n0l
                  if(i2flgculkillerp(i0l,1).eq.1)then
                    i2flgculp(i0l,1)=0
                    i2flgculkillerp(i0l,1)=0
                  end if
                  if(i2flgculkillerf(i0l,1).eq.1)then
                    i2flgculf(i0l,1)=0
                    i2flgculkillerf(i0l,1)=0
                  end if
                  if(i2flgculkillerp(i0l,2).eq.1)then
                    i2flgculp(i0l,2)=0
                    i2flgculkillerp(i0l,2)=0
                  end if
                  if(i2flgculkillerf(i0l,2).eq.1)then
                    i2flgculf(i0l,2)=0
                    i2flgculkillerf(i0l,2)=0
                  end if
                end do
c
              end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
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
          do i0m=0,n0m
            call wrte_bints3(n0l,n0t,
     $           r1tmp,        r3soilmoist, c1soilmoist,
     $           i0yearmin-1,12,31,n0secday,i0secint,
     $           s0spn,n0m,i0m,r2arafrc,s0ave)
            call wrte_bints3(n0l,n0t,
     $           r1tmp,       r3soiltemp,   c1soiltemp,
     $           i0yearmin-1,12,31,n0secday,i0secint,
     $           s0spn,n0m,i0m,r2arafrc,s0ave)
            call wrte_bints3(n0l,n0t,
     $           r1tmp,       r3avgsurft,   c1avgsurft,
     $           i0yearmin-1,12,31,n0secday,i0secint,
     $           s0spn,n0m,i0m,r2arafrc,s0ave)
            call wrte_bints3(n0l,n0t,
     $           r1tmp,         r3swe,      c1swe,
     $           i0yearmin-1,12,31,n0secday,i0secint,
     $           s0spn,n0m,i0m,r2arafrc,s0ave)
            call wrte_bints3(n0l,n0t,
     $           r1tmp,         r3rgw,       c1rgw,
     $           i0yearmin-1,12,31,n0secday,i0secint,
     $           s0spn,n0m,i0m,r2arafrc,s0ave)
          end do  
          call wrte_bints2(n0l,n0t,
     $         r1tmp,       r2rivsto,   c0rivsto,
     $         i0yearmin-1,12,31,n0secday,i0secint,
     $         s0spn)
          call wrte_bints2(n0l,n0t,
     $         r1tmp,       r2damsto,   c0damsto,
     $         i0yearmin-1,12,31,n0secday,i0secint,
     $         s0spn)
          call wrte_bints2(n0l,n0t,
     $         r1tmp,       r2msrsto,   c0msrsto,
     $         i0yearmin-1,12,31,n0secday,i0secint,
     $         s0spn)
        end if
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
