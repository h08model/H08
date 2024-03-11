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
      subroutine calc_outflw_ftcs(
     $     n0l,         
     $     i0secint,    
     $     r1nxtgrd,    r1lndara,    r1paramc,
     $     r1rivstopre, r1qtot,      
     $     r1rivsto,    r1rivinf,    r1rivout)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cto   calculate the storage in the next time step
cby   20100331, hanasaki, NIES: H08 ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      implicit none
c parameter (array)
      integer           n0l
c parameter (default)
      real              p0mis
      parameter        (p0mis=1.0E20) 
c index (array)
      integer           i0l
c in (set)
      integer           i0secint         !! interval [s]
      real              r1nxtgrd(n0l)    !! downstream grid [-]
      real              r1lndara(n0l)    !! land area [m2]
      real              r1paramc(n0l)    !! parameter c
c in 
      real              r1rivstopre(n0l) !! storage of current time step
      real              r1qtot(n0l)      !! runoff of the grid [kg/s]
c out
      real              r1rivsto(n0l)    !! storage of the grid [kg]
      real              r1rivinf(n0l)    !! inflow of the grid  [kg/s]
      real              r1rivout(n0l)    !! outflow of the grid [kg/s]
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Initialize variables
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      r1rivsto=0.0
      r1rivinf=0.0
      r1rivout=0.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Calculation
c - loop starts
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c outflow from each grid 
c flowing into the lower stream
c
      do i0l=1,n0l
        if (r1paramc(i0l).ne.p0mis) then
          r1rivout(i0l)
     $             = r1rivstopre(i0l)*r1paramc(i0l)	!! assume outflow is proportional to storage
          r1rivout(i0l)
     $          = min(r1rivstopre(i0l)/real(i0secint),r1rivout(i0l))	!! avoid negative storage when param c is over 1 or river mouth
c
          if(r1nxtgrd(i0l).ne.p0mis.and.r1nxtgrd(i0l).ne.0.0
     $	.and.r1nxtgrd(i0l).ne.i0l)then	!! flowing into the lower stream except termination or sea
            r1rivinf(int(r1nxtgrd(i0l)))
     $       =r1rivinf(int(r1nxtgrd(i0l)))+r1rivout(i0l)
          end if
        end if
      end do
c
c calculate storage at the next timestep
c
      do i0l=1,n0l
        if (r1lndara(i0l).ne.p0mis) then
          r1rivinf(i0l)
     $    =r1rivinf(i0l)+r1qtot(i0l)*r1lndara(i0l)
        end if
        if (r1paramc(i0l).ne.p0mis)then	!! not calculate at the river network termination
          r1rivsto(i0l)
     $             =r1rivstopre(i0l)
     $             -r1rivout(i0l)*real(i0secint)
     $             +r1rivinf(i0l)*real(i0secint)
        end if
      end do    
c
      end