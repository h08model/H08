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
      subroutine calc_leakyb(
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
     $     r1potevap,    r1et,    r1subsnow,
     $     r1salbedo,
     $     i1engnotbal,  i1watnotbal,i1notfin)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     to   calculate leaky bucket with simple groundwater
c     by   2014/05/14, hanasaki
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      implicit none
c     parameter (array)
      integer           n0l
c     parameter (physical)
      integer           n0secday !! second of a day
      real              p0icepnt !! ice point [K]
      real              p0cp    !! heat capacity of air [J kg-1]
      real              p0l     !! latent heat of water to vap [J kg-1]
      real              p0lf    !! latent heat of ice to water [J kg-1]
      real              p0sigma !! Stefan Boltzman const [W m-2 K-4]
      real              p0omega !! angular speed of the Earth rot [s-1]
      parameter        (n0secday=86400)
      parameter        (p0icepnt=273.15)
      parameter        (p0cp=1005.0) 
      parameter        (p0l=2.50E6)     
      parameter        (p0lf=0.333E6) 
      parameter        (p0sigma=5.67E-8) 
      parameter        (p0omega=7.27E-5)
c     parameter (default)
      real              p0mis
      parameter        (p0mis=1.0E20) 
c     index (array)
      integer           i0l
c     in (set)
      integer           i0secint !! time interval [s]
      integer           i0ldbg  !! debugging point
      integer           i0cntc  !! counter
      real              r0engbalc !! energy balance threshold
      real              r0watbalc !! water balance threshold
c     in (map)
      integer           i1lndmsk(n0l) !! land mask [-]
      real              r1soildepth(n0l)
      real              r1w_fieldcap(n0l)
      real              r1w_wilt(n0l)
      real              r1cg(n0l) !! heat capacity [J/K/m2]
      real              r1cd(n0l) !! bulk transfer coefficient
      real              r1w_gwyield(n0L) !! groundwater yield
      real              r1gwdepth(n0l)!! !! groundwater tank depth
      real              r1gwrcf(n0l)!! recharge fraction (qrc/(qs+qsb))
      real              r1gwrcmax(n0l)!! maximum recharge 
c     in (parameter)
      real              r1gamma(n0l) !! parameter gamma for qsb [-]
      real              r1tau(n0l) !! parameter tau for qsb [day]
      real              r1balbedo(n0l) !! base albedo [-]
      real              r1gwgamma(n0l) !! gamma for groundwater storage
      real              r1gwtau(n0l) !! gamma for groundwater storage
c     in (flux)
      real              r1wind(n0l) !! wind [m/s]
      real              r1rainf(n0l) !! rainfall [kg/m2/s]
      real              r1snowf(n0l) !! snowfall [kg/m2/s]
      real              r1tair(n0l) !! air temperature [K]
      real              r1qair(n0l) !! specific humidity [kg/kg]
      real              r1psurf(n0l) !! surface pressure [Pa]
      real              r1swdown(n0l) !! shortwave downward radiation [W/m2]
      real              r1lwdown(n0l) !! longwave downward radiation [W/m2]
c     in (state variables of previous timestep)
      real              r1avgsurft(n0l) !! surface temperature [K]
      real              r1avgsurft_pr(n0l) !! surface temperature [K]
      real              r1soilmoist_pr(n0l) !! soil moisture [kg/m2]
      real              r1soiltemp_pr(n0l) !! soil temperature [K]
      real              r1soilwet_pr(n0l) !! soil wetness [-]
      real              r1gw_pr(n0l) !! groundwater [kg/m2]
c     out (1: general energy balance components)
      real              r1swnet(n0l) !! short wave net radiation [W/m2]
      real              r1lwnet(n0l) !! long wave net radiation [W/m2]
      real              r1qle(n0l) !! latent heat [W/m2]
      real              r1qh(n0l) !! sensible heat [W/m2]
      real              r1qg(n0l) !! ground heat [W/m2]
      real              r1qf(n0l) !! energy of fusion [W/m2]
      real              r1qv(n0l) !! energy of sublimation [W/m2]
c     out (2: general water balance components)
      real              r1evap(n0l) !! evapotranspiration [kg/m2/s]
      real              r1qs(n0l) !! surface runoff [kg/m2/s]
      real              r1qsb(n0l) !! subsurface runoff [kg/m2/s]
      real              r1qtot(n0l) !! total runoff [kg/m2/s]
      real              r1qsm(n0l) !! snowmelt [kg/m2/s]
      real              r1qst(n0l) !! snow throughfall [kg/m2/s]
c     out (3: surface state variables)
      real              r1swe_pr(n0l) !! snow water equivalent [kg/m2]
      real              r1albedo(n0l) !! albedo [-]
      real              r1swe(n0l) !! snow water equivalent [kg/m2]
c     out (4: subsurface state variables)
      real              r1soilmoist(n0l) !! soil moisture [kg/m2]
      real              r1soiltemp(n0l) !! soil temperature [K]
      real              r1soilwet(n0l) !! soil wetness [-]
c     out (5: evaporation components)
      real              r1potevap(n0l) !! potential ET [kg/m2/s]
      real              r1et(n0l) !! evapotranspiration [kg/m2/s]
      real              r1subsnow(n0l) !! snow sublimation [kg/m2/s]
      real              r1subsnow_fx(n0l) !! snow sublimation [kg/m2/s]
c     out (7: cold season processes)
      real              r1salbedo(n0l) !! snow albedo [-]
c     out (8: groundwater processes)
      real              r1qrc(n0l)     !! recharge [kg/m2/s]
      real              r1qbf(n0l)     !! baseflow [kg/m2/s]
      real              r1gw(n0l)      !! groundwater [kg/m2]
c     in/out
      integer           i1engnotbal(n0l) !! energy not balanced
      integer           i1watnotbal(n0l) !! water not balanced
      integer           i1qtotnotbal(n0l) !! Qtot not balanced
      integer           i1notfin(n0l) !! calculation not finished
c     local
      real              r1engbal(n0l) !! energy balance [W/m2]
      real              r1engbal_fx(n0l) !! energy balance [W/m2]
      real              r1watbal(n0l) !! water balance [kg/m2/s]
      real              r1qtotbal(n0l) !! Qtot balance [kg/m2/s]
      real              r1snwbal(n0l) !! snow balance [kg/m2/s]
      real              r1rho(n0l) !! density of air
      real              r1esat(n0l) !! saturated humidity
      real              r1qsat(n0l) !! saturated specific humidity
      real              r1beta(n0l) !! evaporation efficiency
      real              r1zeta(n0l) !! Milly (1992)'s zeta
      real              r1delta(n0l) !! Milly (1992)'s delta
      real              r1acond(n0l) !! aerodynamic conductance
c     local (parameter)
      real              r0avgsurftc1 !! critical temperature
      real              r0avgsurftc2 !! critical temperature
      real              r0salbedoc1 !! critical snow albedo
      real              r0salbedoc2 !! critical snow albedo
      real              r0swec  !! critical swe
      real              r0soilwetc !! critical soil wetness
      real              r0windmin !! minimum wind speed
      real              r0swemin !! swe min
      data              r0avgsurftc1/263.15/
      data              r0avgsurftc2/273.15/
      data              r0salbedoc1/0.60/ 
      data              r0salbedoc2/0.45/ 
      data              r0swec/20.0/
      data              r0soilwetc/0.75/
      data              r0windmin/2.0/ 
      data              r0swemin/1.0E-10/
c     local (flags)
      integer           i0flgfix !! calc. mode: fix Ts
      integer           i0flgini !! calc. mode: initial Ts
      integer           i1flgcal(n0l) !! calc. mode: find Ts
      integer           i0flgfin !! flag of calculation
      integer           i0cnt   !! counter
      integer           i0cnttot !! counter
      integer           i0last  !! counter
      real              r0tmp
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     initialize
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      r1swnet=0.0
      r1lwnet=0.0
      r1qle=0.0
      r1qh=0.0
      r1qg=0.0
      r1qf=0.0
      r1qv=0.0
c     
      r1evap=0.0
      r1qs=0.0
      r1qsb=0.0
      r1qtot=0.0
      r1qsm=0.0
      r1qst=0.0
c     
      r1albedo=0.0
c     
      r1potevap=0.0
      r1et=0.0
      r1subsnow=0.0
c     
      r1salbedo=0.0
c     
      r1avgsurft=p0icepnt
c     
      i0flgfix=0
      i0flgini=0
      do i0l=1,n0l
        i1flgcal(i0l)=i1lndmsk(i0l)
      end do
      i0flgfin=0
      i0cnt=0
      i0cnttot=0
      i0last=0
d     write(*,*) 'calc_leakyb: --- Ts fixed at icepoint -------------'
d     write(*,*) 'calc_leakyb: r1avgsurft: ',r1avgsurft(i0ldbg)
d     write(*,*) 'calc_leakyb: --------------------------------------'
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     Calculate snow albedo
c     - See Hanasaki et al., HESS, 12, 1007-1025, 2008a, Eq.B1
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
 10   do i0l=1,n0l
        if(i1flgcal(i0l).eq.1)then
          if(r1swe_pr(i0l).gt.0.0)then
            if(r1avgsurft(i0l).le.r0avgsurftc1)then
              r1salbedo(i0l)=r0salbedoc1
            else if(r1avgsurft(i0l).ge.r0avgsurftc2)then
              r1salbedo(i0l)=r0salbedoc2
            else
              r1salbedo(i0l)
     $             =( r0salbedoc1*(r0avgsurftc2-r1avgsurft(i0l))
     $             +r0salbedoc2*(r1avgsurft(i0l)-r0avgsurftc1))
     $             /
     $             (r0avgsurftc2-r0avgsurftc1)
            end if
          else
            r1salbedo(i0l)=p0mis
          end if
        end if
      end do
d     write(*,*) 'calc_leakyb: r1salbedo: ',r1salbedo(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     Calculate albedo
c     - See Hanasaki et al., HESS, 12, 1007-1025, 2008a, Eq.B2
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0l=1,n0l
        if(i1flgcal(i0l).eq.1)then
          if(r1swe_pr(i0l).le.r0swec)then
            r1albedo(i0l)
     $           =r1balbedo(i0l)
     $           +(r1swe_pr(i0l)/r0swec)**0.5
     $           *(r1salbedo(i0l)-r1balbedo(i0l))
          else
            r1albedo(i0l)=r1salbedo(i0l)
          end if
        end if
      end do
d     write(*,*) 'calc_leakyb: r1albedo: ',r1albedo(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     Calculate aerodynamic conductance
c     - See Hanasaki et al., HESS, 12, 1007-1025, 2008a, Eq.B3
c     - Caution!! Minimum wind speed (r0windmin)is assumed!!
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0l=1,n0l
        if(i1flgcal(i0l).eq.1)then
          r1acond(i0l)=r1cd(i0l)*max(r1wind(i0l),r0windmin)
        end if
      end do
d     write(*,*) 'calc_leakyb: r1acond: ',r1acond(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     Calculate density of air (rho)
c     - See Kondo, Asakura Publ., 1994, pp130, Eq6.1
c     - Also, Kondo, Asakura Publ., 1994, pp28, Eq2.19
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0l=1,n0l
        if(i1flgcal(i0l).eq.1)then
          r1rho(i0l)
     $         =1.293*p0icepnt/r1tair(i0l)*r1psurf(i0l)/101325
     $         *(1-0.378/0.622*r1qair(i0l))
        end if
      end do
d     write(*,*) 'calc_leakyb: r1rho: ',r1rho(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     Calculate saturated humidity (esat)
c     - See Kondo, Asakura Publ., 1994, pp26, Eq2.14
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0l=1,n0l
        if(i1flgcal(i0l).eq.1)then
c     debug          if(r1avgsurft(i0l)-p0icepnt.lt.-50)then
c     debug            write(*,*) i0l,r1avgsurft(i0l)
c     debug          end if
          if(r1avgsurft(i0l).ge.p0icepnt)then
            r1esat(i0l)=6.1078*100
     $           *10**((7.5*(r1avgsurft(i0l)-p0icepnt))
     $           /
     $           (237.3+r1avgsurft(i0l)-p0icepnt))
          else
            r1esat(i0l)=6.1078*100
     $           *10**((9.5*(r1avgsurft(i0l)-p0icepnt))
     $           /
     $           (265.3+r1avgsurft(i0l)-p0icepnt))
          end if
        end if
      end do
d     write(*,*) 'calc_leakyb: r1esat: ',r1esat(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     Calculate saturated humidity (qsat)
c     - See Kondo, Asakura Publ., 1994, pp28, Eq2.19
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0l=1,n0l
        if(i1flgcal(i0l).eq.1)then
          r1qsat(i0l)
     $         =(0.622*r1esat(i0l))
     $         /
     $         (r1psurf(i0l)-0.378*r1esat(i0l))
        end if
      end do
d     write(*,*) 'calc_leakyb: r1qsat: ',r1qsat(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     Calculate delta (desat/dT)
c     - See Kondo, Asakura Publ., 1994, pp130, Eq6.8
c     - Caution!! snow/snowfree separation omitted.
c     - Caution!! now esat is calculated for Ts.
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0l=1,n0l
        if(i1flgcal(i0l).eq.1)then
          r1delta(i0l)
     $         =(6.1078*(2500-2.4*(r1tair(i0l)-p0icepnt)))
     $         /
     $         (0.4615*r1tair(i0l)**2)
     $         *10**((7.5*(r1tair(i0l)-p0icepnt))
     $         /
     $         (237.3+r1tair(i0l)-p0icepnt))
     $         *(0.622*r1psurf(i0l)/100)
     $         /
     $         (r1psurf(i0l)/100-0.378*r1esat(i0l)/100)**2
        end if
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     Calculate delta and zeta of Milly (1992)
c     - See Milly, J of Clim, 5, 209-226, 1992, Eq18
c     - Caution!! now esat is calculated for Ts.
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0l=1,n0l
        if(i1flgcal(i0l).eq.1)then
          r1zeta(i0l)=(p0l*r1rho(i0l)*r1acond(i0l)*r1delta(i0l))
     $         /(4*p0sigma*r1tair(i0l)**3+r1rho(i0l)*p0cp*r1acond(i0l))
        end if
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     Calculate soil wetness 
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0l=1,n0l
        if(i1flgcal(i0l).eq.1)then
          r1soilwet_pr(i0l)
     $         =r1soilmoist_pr(i0l)
     $         /(r1soildepth(i0l)*1000.0
     $         *(r1w_fieldcap(i0l)-r1w_wilt(i0l)))
        end if
      end do
d     write(*,*) 'calc_leakyb: r1soilwet_pr: ',r1soilwet_pr(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     Calculate beta
c     - See Hanasaki et al., HESS, 12, 1007-1025, 2008, Eq.B5
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0l=1,n0l
        if(i1flgcal(i0l).eq.1)then
          if(r1swe_pr(i0l).gt.0.0)then
            r1beta(i0l)=1.0
          else
            if(r1soilwet_pr(i0l).ge.r0soilwetc)then
              r1beta(i0l)=1.0
            else
              r1beta(i0l)=r1soilwet_pr(i0l)/r0soilwetc
            end if
          end if
        end if
      end do
d     write(*,*) 'calc_leakyb: r1beta: ',r1beta(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     Calculate potential evapotranspiration
c     - See Hanasaki et al., HESS, 12, 1007-1025, 2008, Eq.B3
c     - See Milly, J of Clim, 5, 209-226, 1992, Eq.22
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0l=1,n0l
        if(i1flgcal(i0l).eq.1)then
          if(r1swe_pr(i0l).gt.0.0)then
            r1potevap(i0l)
     $           =r1rho(i0l)*r1acond(i0l)*(r1qsat(i0l)-r1qair(i0l))
          else
            r1potevap(i0l)
     $           =r1rho(i0l)*r1acond(i0l)*(r1qsat(i0l)-r1qair(i0l))
     $           *(1.0+r1zeta(i0l)*r1beta(i0l))
     $           /
     $           (1.0+r1zeta(i0l))
          end if
        end if
      end do
d     write(*,*) 'calc_leakyb: r1potevap: ',r1potevap(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     Calculate evaporation
c     - See Hanasaki et al., HESS, 12, 1007-1025, 2008, Eq.B4
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0l=1,n0l
        if(i1flgcal(i0l).eq.1)then
          if(r1swe_pr(i0l).gt.0.0)then
            r1subsnow(i0l)=r1potevap(i0l)
            if(r1swe_pr(i0l).lt.r1potevap(i0l)*real(i0secint))then
              r1subsnow(i0l)=r1swe_pr(i0l)/real(i0secint)
            end if
            r1et(i0l)=0.0
          else
            r1et(i0l)=r1beta(i0l)*r1potevap(i0l)
            if(r1soilmoist_pr(i0l).lt.r1et(i0l)*real(i0secint))then
              r1et(i0l)=r1soilmoist_pr(i0l)/real(i0secint)
            end if
            r1subsnow(i0l)=0.0
          end if
          r1evap(i0l)=r1et(i0l)+r1subsnow(i0l)
        end if
      end do
d     write(*,*) 'calc_leakyb: r1et:      ',r1et(i0ldbg)
d     write(*,*) 'calc_leakyb: r1subsnow: ',r1subsnow(i0ldbg)
d     write(*,*) 'calc_leakyb: r1evap:    ',r1evap(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     Calculate latent heat flux
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0l=1,n0l
        if(i1flgcal(i0l).eq.1)then
          if(r1swe_pr(i0l).gt.0.0)then
            r1qle(i0l)=0.0
            r1qv(i0l)=(p0l+p0lf)*r1subsnow(i0l)
          else
c     bug            r1qle(i0l)=p0l*r1evap(i0l)
            r1qle(i0l)=p0l*r1et(i0l)
            r1qv(i0l)=0.0
          end if
        end if
      end do
d     write(*,*) 'calc_leakyb: r1qle: ',r1qle(i0ldbg)
d     write(*,*) 'calc_leakyb: r1qv:  ',r1qv(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     Calculate sensible heat flux
c     - See Hanasaki et al., HESS, 12, 1007-1025, 2008, Eq.B6
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0l=1,n0l
        if(i1flgcal(i0l).eq.1)then
          r1qh(i0l)
     $         =p0cp*r1rho(i0l)*r1acond(i0l)
     $         *(r1avgsurft(i0l)-r1tair(i0l))
        end if
      end do
d     write(*,*) 'calc_leakyb: r1qh:  ',r1qh(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     Calculate shortwave net radiation
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0l=1,n0l
        if(i1flgcal(i0l).eq.1)then
          r1swnet(i0l)=r1swdown(i0l)*(1-r1albedo(i0l))
        end if
      end do
d     write(*,*) 'calc_leakyb: r1swnet:  ',r1swnet(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     Calculate longwave net radiation
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0l=1,n0l
        if(i1flgcal(i0l).eq.1)then
          r1lwnet(i0l)=r1lwdown(i0l)-p0sigma*r1avgsurft(i0l)**4
        end if
      end do
d     write(*,*) 'calc_leakyb: r1lwnet:  ',r1lwnet(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     Calculate soil temperature
c     - See Hanasaki et al., HESS, 12, 1007-1025, 2008, Eq.B8 
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0l=1,n0l
        if(i1flgcal(i0l).eq.1)then
          r1soiltemp(i0l)
     $         =((r1avgsurft(i0l)-r1avgsurft_pr(i0l))
     $         + (r1soiltemp_pr(i0l)*sqrt(365.0))
     $         + (r1avgsurft(i0l)*p0omega*real(i0secint))
     $         )
     $         /
     $         (sqrt(365.0)+p0omega*real(i0secint))
        end if
      end do
d     write(*,*) 'calc_leakyb: r1soiltemp:  ',r1soiltemp(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     Calculate ground heat flux
c     - Caution!! Checking incomplete!! (review FR carefully!)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0l=1,n0l
        if(i1flgcal(i0l).eq.1)then
          r1qg(i0l)
     $         =r1cg(i0l)*(r1avgsurft(i0l)-r1avgsurft_pr(i0l))
     $         /real(i0secint)
     $         +r1cg(i0l)*p0omega*(r1avgsurft(i0l)-r1soiltemp(i0l))
        end if
      end do
d     write(*,*) 'calc_leakyb: r1qg:  ',r1qg(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     Calculate energy balance
c     - See Hanasaki et al., HESS, 12, 1007-1025, 2008, Eq.B7
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0l=1,n0l
        if(i1flgcal(i0l).eq.1)then
          r1engbal(i0l)
     $         =r1swnet(i0l)+r1lwnet(i0l)-r1qle(i0l)-r1qh(i0l)
     $         -r1qg(i0l)-r1qf(i0l)-r1qv(i0l)
        end if
      end do
d     write(*,*) 'calc_leakyb: r1engbal:  ',r1engbal(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     If i0flgfix = 0 
c     - save energy balance
c     - save subsurface snow flux
c     - set Ts = Ts_previous
c     - goto 10
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(i0flgfix.eq.0)then
c     
        i0flgfix=1
c     
        do i0l=1,n0l
          r1engbal_fx(i0l)=r1engbal(i0l)
        end do
        do i0l=1,n0l
          r1subsnow_fx(i0l)=r1subsnow(i0l)
        end do
c     
        do i0l=1,n0l
          r1avgsurft(i0l)=r1avgsurft_pr(i0l)
        end do
d     write(*,*) 'calc_leakyb: --- Ts fixed at previous Ts ----------'
d     write(*,*) 'calc_leakyb: r1avgsurft: ',r1avgsurft(i0ldbg)
d     write(*,*) 'calc_leakyb: --------------------------------------'
c     
        goto 10
      end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     If i0flgini = 0
c     - set Ts = Ts_initial
c     - goto 10
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(i0flgini.eq.0)then
c     
        i0flgini=1
c     
        do i0l=1,n0l
          if(i1flgcal(i0l).eq.1)then
            r1avgsurft(i0l)
     $           =r1tair(i0l)+
     $           ((1.0-r1albedo(i0l))*r1swdown(i0l)
     $           +r1lwdown(i0l)
     $           -p0sigma*r1tair(i0l)**4
     $           -p0l*r1rho(i0l)*r1beta(i0l)*r1acond(i0l)
     $           *(r1qsat(i0l)-r1qair(i0l))
     $           -r1cg(i0l)*(r1tair(i0l)-r1avgsurft_pr(i0l))
     $           /real(i0secint)
     $           -r1cg(i0l)*p0omega*(r1tair(i0l)-r1soiltemp_pr(i0l))
     $           )
     $           /
     $           (4*p0sigma*r1tair(i0l)**3
     $           +p0cp*r1rho(i0l)*r1acond(i0l)
     $           +p0l*r1rho(i0l)*r1beta(i0l)*r1acond(i0l)*r1delta(i0l)
     $           +r1cg(i0l)/real(i0secint)
     $           +r1cg(i0l)*p0omega
     $           )
          end if
        end do
c     
        do i0l=1,n0l
          if(i1flgcal(i0l).eq.1)then
            r1avgsurft(i0l)
     $           =min(max(r1avgsurft(i0l),p0icepnt-50.0),p0icepnt+50.0)
          end if
        end do
d     write(*,*) 'calc_leakyb: --- Estimated initial Ts -------------'
d     write(*,*) 'calc_leakyb: r1avgsurft: ',r1avgsurft(i0ldbg)
d     write(*,*) 'calc_leakyb: --- Estimated initial Ts (nom)--------'
d     write(*,*) 'calc_leakyb: numerator: ',
d    $           ((1.0-r1albedo(i0ldbg))*r1swdown(i0ldbg)
d    $            +r1lwdown(i0ldbg)
d    $            -p0sigma*r1tair(i0ldbg)**4
d    $            -p0l*r1rho(i0ldbg)*r1beta(i0ldbg)*r1acond(i0ldbg)
d    $            *(r1qsat(i0ldbg)-r1qair(i0ldbg))
d    $            -r1cg(i0ldbg)*(r1tair(i0ldbg)-r1avgsurft_pr(i0ldbg))
d    $            /real(i0secint)
d    $            -r1cg(i0ldbg)*p0omega
d    $            *(r1tair(i0ldbg)-r1soiltemp_pr(i0ldbg))
d    $           )
d     write(*,*) 'calc_leakyb: --- Estimated initial Ts (dom)--------'
d     write(*,*) 'calc_leakyb: denominator: ',
d    $           (4*p0sigma*r1tair(i0ldbg)**3
d    $            +p0cp*r1rho(i0ldbg)*r1acond(i0ldbg)
d    $            +p0l*r1rho(i0ldbg)*r1beta(i0ldbg)
d    $            *r1acond(i0ldbg)*r1delta(i0ldbg)
d    $            +r1cg(i0ldbg)/real(i0secint)
d    $            +r1cg(i0ldbg)*p0omega
d    $           )
d     write(*,*) 'calc_leakyb: --- Estimated initial Ts (com)--------'
d     write(*,*) 'calc_leakyb:',r1tair(i0ldbg)
d     write(*,*) 'calc_leakyb:',(1.0-r1albedo(i0ldbg))*r1swdown(i0ldbg)
d     write(*,*) 'calc_leakyb:',r1lwdown(i0ldbg)
d     write(*,*) 'calc_leakyb:',p0sigma*r1tair(i0ldbg)**4
d     write(*,*) 'calc_leakyb:',
d    $ p0l*r1rho(i0ldbg)*r1beta(i0ldbg)*r1acond(i0ldbg)
d    $ *(r1qsat(i0ldbg)-r1qair(i0ldbg))
d     write(*,*) 'calc_leakyb:',
d    $ r1cg(i0ldbg)*(r1tair(i0ldbg)-r1avgsurft_pr(i0ldbg))
d    $ /real(i0secint)
d     write(*,*) 'calc_leakyb:',
d    $ r1cg(i0ldbg)*p0omega*(r1tair(i0ldbg)-r1soiltemp_pr(i0ldbg))
d     write(*,*) 'calc_leakyb:',4*p0sigma*r1tair(i0ldbg)**3
d     write(*,*) 'calc_leakyb:',p0cp*r1rho(i0ldbg)*r1acond(i0ldbg)
d     write(*,*) 'calc_leakyb:',
d    $ p0l*r1rho(i0ldbg)*r1beta(i0ldbg)*r1acond(i0ldbg)*r1delta(i0ldbg)
d     write(*,*) 'calc_leakyb:',r1cg(i0ldbg)/real(i0secint)
d     write(*,*) 'calc_leakyb:',r1cg(i0ldbg)*p0omega

d     write(*,*) 'calc_leakyb: --------------------------------------'
c     
        goto 10
      end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     If i0flgfin = 0 & counter < counter_critical
c     - judge engbal < engbal_critical
c     - set next Ts
c     - calculate qf,qsm,qst
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(i0flgfin.eq.0)then
        if(i0cnt.lt.i0cntc)then
c     
          i0flgfin=1
c     
          do i0l=1,n0l
            if(i1flgcal(i0l).eq.1)then
              if(abs(r1engbal(i0l)).gt.r0engbalc)then
                i1flgcal(i0l)=1
                i0flgfin=0
              else
                i1flgcal(i0l)=0
              end if
            end if
          end do
c     
          call calc_ts_nxt(
     $         n0l,i0ldbg,
     $         i0cnt,i1flgcal,r1engbal,
     $         r1avgsurft)
c     
          do i0l=1,n0l
            if(i1flgcal(i0l).eq.1)then
              i0cnttot=i0cnttot+1
              if(r1swe_pr(i0l).gt.0.0.and.
     $             r1avgsurft(i0l).gt.p0icepnt.and.
     $             r1engbal_fx(i0l).gt.0.0)then
                r1qf(i0l)=r1engbal_fx(i0l)
                r1qsm(i0l)=r1qf(i0l)/p0lf
                r1qst(i0l)=r1qsm(i0l)
                r1snwbal(i0l)
     $               =r1snowf(i0l)-r1qst(i0l)-r1subsnow_fx(i0l)
     $               +r1swe_pr(i0l)/real(i0secint)
                if(r1snwbal(i0l).lt.0.0)then
                  r1qsm(i0l)
     $                 =r1snowf(i0l)-r1subsnow(i0l)
     $                 +r1swe_pr(i0l)/real(i0secint)
                  r1qst(i0l)=r1qsm(i0l)
                  r1qf(i0l)=r1qsm(i0l)*p0lf
                else
                  r1avgsurft(i0l)=p0icepnt
                end if
c     bug                if(r1qsm(i0l).lt.0)then
c     bug                  r1qsm(i0l)=0
c     bug                end if
              else
                r1qf(i0l)=0
                r1qsm(i0l)=0
                r1qst(i0l)=0
              end if
            end if
          end do
d     write(*,*) 'calc_leakyb: r1qf:  ',r1qf(i0ldbg)
d     write(*,*) 'calc_leakyb: r1qsm: ',r1qsm(i0ldbg)
d     write(*,*) 'calc_leakyb: r1qst: ',r1qst(i0ldbg)
c     
          if(i0flgfin.eq.0)then
            i0cnt=i0cnt+1
            do i0l=1,n0l
              if(i1flgcal(i0l).ne.0)then
                i0last=i0l
              end if
            end do
d     write(*,*) 'calc_leakyb: --- Next Ts --------------------------'
d     write(*,*) 'calc_leakyb: r1avgsurft: ',r1avgsurft(i0ldbg)
d     write(*,*) 'calc_leakyb: --------------------------------------'
            goto 10
          end if
        else
          do i0l=1,n0l
            i1notfin(i0l)=i1notfin(i0l)+i1flgcal(i0l)
          end do
          goto 20
        end if
      end if
 20   do i0l=1,n0l
        i1flgcal(i0l)=i1lndmsk(i0l)
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     Calculate snow balance
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0l=1,n0l
        if(i1flgcal(i0l).eq.1)then
          r1swe(i0l)=r1swe_pr(i0l)
     $         +(r1snowf(i0l)-r1qsm(i0l)-r1subsnow(i0l))*real(i0secint)
          if(r1swe(i0l).lt.r0swemin)then
            r1qsm(i0l)=(r1swe_pr(i0l)+(r1snowf(i0l)-r1subsnow(i0l))
     $           *real(i0secint))/real(i0secint)
            r1swe(i0l)=0.0
c     suspended
            if(r1qsm(i0l).lt.0)then
              r1qsm(i0l)=0
            end if
c     suspended
          end if
        end if
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     Calculate Water Balance
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0l=1,n0l
        if(i1flgcal(i0l).eq.1)then
          r1soilmoist(i0l)
     $         =r1soilmoist_pr(i0l)
     $         +(r1rainf(i0l)-r1et(i0l)+r1qsm(i0l))*real(i0secint)
        end if
      end do
c     
      do i0l=1,n0l
        if(i1flgcal(i0l).eq.1)then
          r1soilwet(i0l)
     $         =r1soilmoist(i0l)
     $         /(r1soildepth(i0l)*1000.0
     $         *(r1w_fieldcap(i0l)-r1w_wilt(i0l)))
        end if
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     Calculate surface runoff
c     - 
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0l=1,n0l
        if(i1flgcal(i0l).eq.1)then
          if(r1soilwet(i0l).ge.1)then
            r1qs(i0l)
     $           =(r1soilmoist(i0l)
     $           -r1soildepth(i0l)*1000.0
     $           *(r1w_fieldcap(i0l)-r1w_wilt(i0l)))
     $           /real(i0secint)
            r1soilmoist(i0l)=r1soildepth(i0l)*1000
     $           *(r1w_fieldcap(i0l)-r1w_wilt(i0l))
            r1soilwet(i0l)=1.0
          else
            r1qs(i0l)=0.0
          end if
        end if
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     Calculate subsurface runoff
c     - See Hanasaki et al., HESS, 12, 1007-1025, 2008, Eq.B12
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0l=1,n0l
        if(i1flgcal(i0l).eq.1)then
          r1qsb(i0l)
     $         =(r1soilmoist(i0l)
     $         /
     $         (r1soildepth(i0l)*1000.0
     $         *(r1w_fieldcap(i0l)-r1w_wilt(i0l))))
     $         **r1gamma(i0l)
     $         *r1soildepth(i0l)*1000.0
     $         *(r1w_fieldcap(i0l)-r1w_wilt(i0l))
     $         /(r1tau(i0l)*real(n0secday))
        end if
      end do
c
      do i0l=1,n0l
        if(i1flgcal(i0l).eq.1)then
          r1soilmoist(i0l)=r1soilmoist(i0l)-r1qsb(i0l)*real(i0secint)
        end if
      end do
c
      do i0l=1,n0l
        if(i1flgcal(i0l).eq.1)then
          r1soilwet(i0l)
     $         =r1soilmoist(i0l)
     $         /(r1soildepth(i0l)*1000.0
     $         *(r1w_fieldcap(i0l)-r1w_wilt(i0l)))
        end if
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c     Calculate groundwater recharge and storage, and base flow
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
d      write(*,*) 'calc_leakyb:r1gwrcmax  ',r1gwrcmax(i0ldbg)
d      write(*,*) 'calc_leakyb:r1gwrcf    ',r1gwrcf(i0ldbg)
d      write(*,*) 'calc_leakyb:r1qsb      ',r1qsb(i0ldbg)
d      write(*,*) 'calc_leakyb:r1qs       ',r1qs(i0ldbg)
      do i0l=1,n0l
        if(i1flgcal(i0l).eq.1)then
          r0tmp=r1qs(i0l)+r1qsb(i0l)
          r1qrc(i0l)=min(r1gwrcmax(i0l),
     $                   r1gwrcf(i0l)*r0tmp)
          if(r0tmp.gt.0.0)then
            r1qsb(i0l)
     $           =max(0.0,r1qsb(i0l)-r1qrc(i0l)*r1qsb(i0l)/r0tmp)
            r1qs(i0l)
     $           =max(0.0,r1qs(i0l) -r1qrc(i0l)*r1qs(i0l)/r0tmp)
          else
            r1qsb(i0l)=0.0
            r1qs(i0l)=0.0
          end if
        end if
      end do
c

d      write(*,*) 'calc_leakyb:r1qrc  ',r1qrc(i0ldbg)
d      write(*,*) 'calc_leakyb:r1qsb  ',r1qsb(i0ldbg)
d      write(*,*) 'calc_leakyb:r1qs   ',r1qs(i0ldbg)
      do i0l=1,n0l
        if(i1flgcal(i0l).eq.1)then
          r1gw(i0l)=r1gw_pr(i0l)
        end if
      end do      
d      write(*,*) 'calc_leakyb:r1gw',r1gw(i0ldbg)
c     
      do i0l=1,n0l
        if(i1flgcal(i0l).eq.1)then
          if(r1gw(i0l).gt.0.0)then
            r1qbf(i0l)
     $           =(r1gw(i0l)
     $           /
     $           (r1gwdepth(i0l)*1000.0
     $           *r1w_gwyield(i0l)))
     $           **r1gwgamma(i0l)
     $           *r1gwdepth(i0l)*1000.0
     $           *r1w_gwyield(i0l)
     $           /(r1gwtau(i0l)*real(n0secday))
          else
            r1qbf(i0l)=0.0
          end if
        end if
      end do
d      write(*,*) 'calc_leakyb:r1qbf',r1qbf(i0ldbg)
c
      do i0l=1,n0l
        if(i1flgcal(i0l).eq.1)then
          r1gw(i0l)=r1gw(i0l)+(r1qrc(i0l)-r1qbf(i0l))*real(i0secint)
          if(r1gw(i0l).lt.0.0)then
            r1qbf(i0l)=r1qbf(i0l)+r1gw(i0l)/real(i0secint)
            r1gw(i0l)=0.0
          end if
        end if
      end do      
c continue
c
      do i0l=1,n0l
        if(i1flgcal(i0l).eq.1)then
          r1qtot(i0l)=r1qs(i0l)+r1qsb(i0l)+r1qbf(i0l)
        end if
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Check energy balance
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0l=1,n0l
        r1engbal(i0l)=r1swnet(i0l)+r1lwnet(i0l)-r1qle(i0l)
     $       -r1qh(i0l)-r1qg(i0l)-r1qf(i0l)-r1qv(i0l)
        r1qg(i0l)=r1qg(i0l)+r1engbal(i0l)
c
c try!        if(abs(r1engbal(i0l)).gt.r0engbalc*1.001)then
        if(abs(r1engbal(i0l)).gt.r0engbalc)then
          i1engnotbal(i0l)=i1engnotbal(i0l)+1
          write(*,*) 'cacl_leakyb: ENB: Energy Not Balanced.'
          write(*,*) 'cacl_leakyb: ENB: i0l:      ',i0l
          write(*,*) 'cacl_leakyb: ENB: r1engbal: ',r1engbal(i0l)
d         write(*,*) 'cacl_leakyb: ENB: r1swnet: +',r1swnet(i0l)
d         write(*,*) 'cacl_leakyb: ENB: r1lwnet: +',r1lwnet(i0l)
d         write(*,*) 'cacl_leakyb: ENB: r1qle:   -',r1qle(i0l)
d         write(*,*) 'cacl_leakyb: ENB: r1qh:    -',r1qh(i0l)
d         write(*,*) 'cacl_leakyb: ENB: r1qg:    -',r1qg(i0l)
d         write(*,*) 'cacl_leakyb: ENB: r1qf:    -',r1qf(i0l)
d         write(*,*) 'cacl_leakyb: ENB: r1qv:    -',r1qv(i0l)
d         write(*,*) 'cacl_leakyb: ENB: r1engbal =',r1engbal(i0l)
        end if
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Check Qtot balance
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0l=1,n0l
        if(i1flgcal(i0l).eq.1)then
          r1qtotbal(i0l)=r1qtot(i0l)-r1qs(i0l)-r1qsb(i0l)-r1qbf(i0l)
          if(abs(r1qtotbal(i0l)*real(n0secday)).gt.r0watbalc)then
            i1qtotnotbal(i0l)=i1qtotnotbal(i0l)+1
            write(*,*) 'calc_leakyb: QTB: Qtot Not Balanced.'
            write(*,*) 'calc_leakyb: WNB: i0l:         ',i0l
            write(*,*) 'cacl_leakyb: WNB: r1qtotbal:   ',r1qtotbal(i0l)
            write(*,*) 'calc_leakyb: WNB: r1qtot:     +',r1qtot(i0l)
            write(*,*) 'calc_leakyb: WNB: r1qs:       -',r1qs(i0l)
            write(*,*) 'calc_leakyb: WNB: r1qsb:      -',r1qsb(i0l)
            write(*,*) 'calc_leakyb: WNB: r1qbf:      -',r1qbf(i0l)
          end if
        end if
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Check water balance
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0l=1,n0l
        if(i1flgcal(i0l).eq.1)then
c nogw          r1watbal(i0l)=r1snowf(i0l)+r1rainf(i0l)-r1evap(i0l)-r1qs(i0l)
c nogw     $         -r1qsb(i0l)
c nogw     $         -(r1soilmoist(i0l)-r1soilmoist_pr(i0l))/real(i0secint)
c nogw     $         -(r1swe(i0l)-r1swe_pr(i0l))/real(i0secint)
          r1watbal(i0l)=r1snowf(i0l)+r1rainf(i0l)-r1evap(i0l)-r1qs(i0l)
     $         -r1qsb(i0l)-r1qbf(i0l)
     $         -(r1soilmoist(i0l)-r1soilmoist_pr(i0l))/real(i0secint)
     $         -(r1swe(i0l)-r1swe_pr(i0l))/real(i0secint)
     $         -(r1gw(i0l)-r1gw_pr(i0l))/real(i0secint)
c     
          if(abs(r1watbal(i0l)*real(n0secday)).gt.r0watbalc)then
            i1watnotbal(i0l)=i1watnotbal(i0l)+1
            write(*,*) 'calc_leakyb: WNB: Water Not Balanced.'
            write(*,*) 'calc_leakyb: WNB: i0l:         ',i0l
            write(*,*) 'cacl_leakyb: WNB: r1watbal:    ',r1watbal(i0l)
            write(*,*) 'calc_leakyb: WNB: r1snowf:    +',r1snowf(i0l)
            write(*,*) 'calc_leakyb: WNB: r1rainf:    +',r1rainf(i0l)
            write(*,*) 'calc_leakyb: WNB: r1evap:     -',r1evap(i0l)
            write(*,*) 'calc_leakyb: WNB: r1qs:       -',r1qs(i0l)
            write(*,*) 'calc_leakyb: WNB: r1qsb:      -',r1qsb(i0l)
            write(*,*) 'calc_leakyb: WNB: r1qbf:      -',r1qbf(i0l)
            write(*,*) 'calc_leakyb: WNB: r1soilmoist: ',
     $           (r1soilmoist(i0l)-r1soilmoist_pr(i0l))/real(i0secint)
            write(*,*) 'calc_leakyb: WNB: r1swe:       ',
     $           (r1swe(i0l)-r1swe_pr(i0l))/real(i0secint)
            write(*,*) 'calc_leakyb: WNB: r1gw:        ',
     $           (r1gw(i0l)-r1gw_pr(i0l))/real(i0secint)
          end if
c
          r1evap(i0l)=r1evap(i0l)+r1watbal(i0l)
        end if
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      write(*,*) 'calc_leakyb: i0cnt,i0last:',i0cnt,i0last
      write(*,*) 'calc_leakyb: i0cnttot:    ',i0cnttot
c
      end
