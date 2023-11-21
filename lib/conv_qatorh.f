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
      subroutine conv_qatorh(
     $     n0l,
     $     r1qair,r1psurf,r1tair,
     $     r1rh)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   convert specific humidity (Qair) to relative humidty (RH)
cby   2010/03/31, hanasaki, NIES: H08 ver1.0
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
      real              r1qair(n0l)    !! specific humidity
      real              r1psurf(n0l)   !! surface air pressure
      real              r1tair(n0l)    !! air temperature
c out
      real              r1rh(n0l)      !! relative humidity
c local
      real              r1esat(n0l)    !! saturation evap pressure
      real              r1e(n0l)       !! evap pressure
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Initialize
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      r1rh=0.0
      r1esat=0.0
      r1e=0.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Calculation
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0l=1,n0l
        if(r1tair(i0l).ne.p0mis.and.r1psurf(i0l).ne.p0mis.and.
     $     r1qair(i0l).ne.p0mis.and.r1tair(i0l).ne.0.0.and.
     $     r1psurf(i0l).ne.0.0)then
          if(r1tair(i0l).gt.p0icepnt)then
            r1esat(i0l)=6.1078*10**
     $           ((7.5*(r1tair(i0l)-p0icepnt))/
     $           (237.3+r1tair(i0l)-p0icepnt))*100.0 !! hPa->Pa
          else
            r1esat(i0l)=6.1078*10**
     $           ((9.5*(r1tair(i0l)-p0icepnt))/
     $           (265.3+r1tair(i0l)-p0icepnt))*100.0 !! hPa->Pa
          end if
          r1e(i0l)=r1qair(i0l)*r1psurf(i0l)/0.622
          r1rh(i0l)=max(min(r1e(i0l)/r1esat(i0l),1.0),0.0)
        else
          r1rh(i0l)=p0mis
        end if
      end do
c
      end
