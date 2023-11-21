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
      subroutine calc_spinup(
     $     n0l,i0ldbg,
     $     r0spnerr,r0spnrat,r1sto,r1stopre,
     $     i0spnflg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cto   check spin up
cby   nhanasaki,2009/10/09,NIES
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      implicit none
c parameter (array)
      integer           n0l
c parameter (default)
      real              p0mis
      real              p0min
      parameter        (p0mis=1.0E20) 
      parameter        (p0min=1.0E-20) 
c index (array)
      integer           i0l
c in (set)
      integer           i0ldbg
c in
      real              r0spnerr       !! spinup error threshold
      real              r0spnrat       !! spinup ratio threshold
      real              r1sto(n0l)     !! storage of the year
      real              r1stopre(n0l)  !! storage of the previous year
c out
      integer           i0spnflg       !! spinup flag 1:finished, 0:not
c local
      integer           i0cntsuc       !! counter of grids spinup succeeded
      integer           i0cnttot       !! counter of grids in total
      real              r0rat          !! i0cntsuc/i0cnttot
      real              r0err          !! (sto[t]-sto[t-1])/sto[t-1]
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
d     write(*,*) 'calc_spinup: r0spnerr: ',r0spnerr
d     write(*,*) 'calc_spinup: r0spnrat: ',r0spnrat
d     write(*,*) 'calc_spinup: r1sto:    ',r1sto(i0ldbg)
d     write(*,*) 'calc_spinup: r1stopre: ',r1stopre(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c check spin up
c - initialize counter
c - calculate the relative difference of two years, and judge
c   whether it is below the threshold r0spnerr
c - calculate i0cntsuc/i0cnttot, and judge 
c   whether it exceeds the threshold r0spnrat
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      i0cntsuc=0
      i0cnttot=0
      r0rat=0.0
      r0err=0.0
c
      do i0l=1,n0l
        if(r1stopre(i0l).ne.p0mis.and.abs(r1stopre(i0l)).gt.p0min) then
          r0err=abs((r1sto(i0l)-r1stopre(i0l))/r1stopre(i0l))
          if(r0err.le.r0spnerr) then
            i0cntsuc = i0cntsuc + 1
          end if
          i0cnttot = i0cnttot + 1
        end if
      end do
c
      if(i0cnttot.ne.0)then
        r0rat=real(i0cntsuc)/real(i0cnttot)
      else
        r0rat=0.0
      end if
c
      if(r0rat.gt.r0spnrat)then
        i0spnflg=1
      else
        i0spnflg=0
      end if
c
      write(*,*) 'calc_spinup:---------------------------------------'
      write(*,*) 'calc_spinup: r0spnerr: ',r0spnerr
      write(*,*) 'calc_spinup: i0cnttot: ',i0cnttot
      write(*,*) 'calc_spinup: i0cntsuc: ',i0cntsuc
      write(*,*) 'calc_spinup: r0rat:    ',r0rat
      write(*,*) 'calc_spinup: r0spnrat: ',r0spnrat
      write(*,*) 'calc_spinup: i0spnflg: ',i0spnflg
      write(*,*) 'calc_spinup:---------------------------------------'
c
      end
