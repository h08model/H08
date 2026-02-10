      subroutine conv_tarhtovpd(
     $     n0l,
     $     r1tair,r1rh,
     $     r1vpd)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cto   calculate vpd
cby   2021/12/01, ai,       NIES: modified
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      implicit none
c parameter (array)
      integer           n0l
c parameter (physical)
      real              p0icepnt
      parameter        (p0icepnt=273.15)
c parameter (default)
      real              p0mis
      parameter        (p0mis=1.0E20)
c index (array)
      integer           i0l
c in
c      real              r1qair(n0l)    !! specific humidity
c      real              r1psurf(n0l)   !! surface air pressure
      real              r1tair(n0l)    !! air temperature
      real              r1rh(n0l)
c out
c      real              r1rh(n0l)      !! relative humidity
      real              r1vpd(n0l)    !! vapor pressure deficit
c local
c      real              r1e(n0l)       !! evap pressure
      real              r1esat(n0l)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Initialize
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      r1rh=0.0
      r1vpd=0.0
      r1esat=0.0
c      r1e=0.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Calculation
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0l=1,n0l
        if(r1tair(i0l).ne.p0mis.and.r1tair(i0l).ne.0.0.and.
     $      r1rh(i0l).ne.p0mis.and.r1rh(i0l).ne.0.0)then
          if(r1tair(i0l).gt.p0icepnt)then
            r1esat(i0l)=6.1078*10**
     $           ((7.5*(r1tair(i0l)-p0icepnt))/
     $           (237.3+r1tair(i0l)-p0icepnt))*100.0 !! hPa->Pa
          else
            r1esat(i0l)=6.1078*10**
     $           ((9.5*(r1tair(i0l)-p0icepnt))/
     $           (265.3+r1tair(i0l)-p0icepnt))*100.0 !! hPa->Pa
          end if
          r1vpd(i0l)=r1esat(i0l)/1000.0*(1-r1rh(i0l))!!Pa->KPa
        else
          r1vpd(i0l)=p0mis
        end if
      end do
c
      end
