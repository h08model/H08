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
      subroutine conv_rstors(
     $     n0l,
     $     r1rainf,r1snowf,r1psurf,r1qair,r1tair)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   convert rainfall and snowfall to rainfall and snowfall
cby   2010/03/31, hanasaki, NIES: H08 ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter (array)
      integer           n0l
c parameter (physical)
      real              p0snwpnt
      parameter        (p0snwpnt=273.15) 
c parameter (misc)
      real              p0mis
      parameter        (p0mis=1.0E20) 
c index (array)
      integer           i0l
c in/out
      real              r1rainf(n0l)
      real              r1snowf(n0l)
c in
      real              r1psurf(n0l)
      real              r1qair(n0l)
      real              r1tair(n0l)
c local
      real              r1prcp(n0l)    !! precipitation (rainf + snowf)
      real              r1e(n0l)       !! evaporation pressure
      real              r1tc(n0l)      !! critical temperature
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Initialize
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      r1prcp=0.0
      r1e=0.0
      r1tc=0.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0l=1,n0l
        if(r1rainf(i0l).ne.p0mis.and.r1snowf(i0l).ne.p0mis)then
          r1prcp(i0l)=r1rainf(i0l)+r1snowf(i0l)
        else
          r1prcp(i0l)=p0mis
        end if
      end do
c
      do i0l=1,n0l
        if(r1qair(i0l).ne.p0mis.and.r1psurf(i0l).ne.p0mis)then
          r1e(i0l)=r1qair(i0l)*r1psurf(i0l)/100.0/0.622
        else
          r1e(i0l)=p0mis
        end if
      end do
c
      do i0l=1,n0l
        if(r1e(i0l).ne.p0mis)then
          r1tc(i0l)=p0snwpnt+11.01-1.5*r1e(i0l)
        else
          r1tc(i0l)=p0mis
        end if
      end do
c
      do i0l=1,n0l
        if(r1prcp(i0l).ne.p0mis.and.r1tair(i0l).ne.p0mis)then
          if(r1tair(i0l).gt.r1tc(i0l))then
            r1rainf(i0l)=r1prcp(i0l)
            r1snowf(i0l)=0.0
          else
            r1rainf(i0l)=0.0
            r1snowf(i0l)=r1prcp(i0l)
          end if
        else
          r1rainf(i0l)=p0mis
          r1snowf(i0l)=p0mis
        end if
      end do
c 
      end
