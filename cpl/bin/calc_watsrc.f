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
      subroutine calc_watsrc(
     $     n0l,              r0dt,             r1lndara,r1arafrc,
     $     r1soilmoist_pr,   r1rainf,r1qsm,    r1supagr,
     $     r1frcsupagrriv,   r1frcsupagrpnd,   r1frcsupagrnnb,
     $     r1frcsoilmoistgrn,r1frcsoilmoistriv,
     $     r1frcsoilmoistpnd,r1frcsoilmoistnnb)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c
      integer           n0l
c
      real              p0mis
      parameter        (p0mis=1.0E20) 
c
      integer           i0l
c
      real              r0dt
      real              r1lndara(n0l)
      real              r1arafrc(n0l)
c in
      real              r1soilmoist_pr(n0l)
      real              r1rainf(n0l)
      real              r1qsm(n0l)
      real              r1supagr(n0l)
      real              r1frcsupagrriv(n0l)
      real              r1frcsupagrpnd(n0l)
      real              r1frcsupagrnnb(n0l)
c in/out
      real              r1frcsoilmoistgrn(n0l)
      real              r1frcsoilmoistriv(n0l)
      real              r1frcsoilmoistpnd(n0l)
      real              r1frcsoilmoistnnb(n0l)
c local
      real              r1ara(n0l)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      r1ara=p0mis
      do i0l=1,n0l
        if(r1lndara(i0l).ne.p0mis.and.r1arafrc(i0l).ne.p0mis)then
          r1ara(i0l)=r1lndara(i0l)*r1arafrc(i0l)
        end if
      end do
      do i0l=1,n0l
        if(r1ara(i0l).eq.0.0)then
          r1ara(i0l)=p0mis
        end if
      end do
c
      do i0l=1,n0l
cbugfix17/04/26        if(r1ara(i0l).ne.p0mis)then
        if(r1ara(i0l).ne.p0mis.and.r1soilmoist_pr(i0l).gt.0.001)then
c          write(*,*) i0l,r1rainf(i0l),r1qsm(i0l),r1soilmoist_pr(i0l)
          r1frcsoilmoistgrn(i0l)
     $         =(r1frcsoilmoistgrn(i0l)*r1soilmoist_pr(i0l)
     $         +r1rainf(i0l) *r0dt
     $         +r1qsm(i0l)   *r0dt)
     $         /(r1soilmoist_pr(i0l)
     $         +r1supagr(i0l)*r1frcsupagrriv(i0l)*r0dt/r1ara(i0l)
     $         +r1supagr(i0l)*r1frcsupagrpnd(i0l)*r0dt/r1ara(i0l)
     $         +r1supagr(i0l)*r1frcsupagrnnb(i0l)*r0dt/r1ara(i0l)
     $         +r1rainf(i0l) *r0dt
     $         +r1qsm(i0l)   *r0dt)
          r1frcsoilmoistriv(i0l)
     $         =(r1frcsoilmoistriv(i0l)*r1soilmoist_pr(i0l)
     $         +r1supagr(i0l)*r1frcsupagrriv(i0l)*r0dt/r1ara(i0l))
     $         /(r1soilmoist_pr(i0l)
     $         +r1supagr(i0l)*r1frcsupagrriv(i0l)*r0dt/r1ara(i0l)
     $         +r1supagr(i0l)*r1frcsupagrpnd(i0l)*r0dt/r1ara(i0l)
     $         +r1supagr(i0l)*r1frcsupagrnnb(i0l)*r0dt/r1ara(i0l)
     $         +r1rainf(i0l) *r0dt
     $         +r1qsm(i0l)   *r0dt)
          r1frcsoilmoistpnd(i0l)
     $         =(r1frcsoilmoistpnd(i0l)*r1soilmoist_pr(i0l)
     $         +r1supagr(i0l)*r1frcsupagrpnd(i0l)*r0dt/r1ara(i0l))
     $         /(r1soilmoist_pr(i0l)
     $         +r1supagr(i0l)*r1frcsupagrriv(i0l)*r0dt/r1ara(i0l)
     $         +r1supagr(i0l)*r1frcsupagrpnd(i0l)*r0dt/r1ara(i0l)
     $         +r1supagr(i0l)*r1frcsupagrnnb(i0l)*r0dt/r1ara(i0l)
     $         +r1rainf(i0l) *r0dt
     $         +r1qsm(i0l)   *r0dt)
          r1frcsoilmoistnnb(i0l)
     $         =(r1frcsoilmoistnnb(i0l)*r1soilmoist_pr(i0l)
     $         +r1supagr(i0l)*r1frcsupagrnnb(i0l)*r0dt/r1ara(i0l))
     $         /(r1soilmoist_pr(i0l)
     $         +r1supagr(i0l)*r1frcsupagrriv(i0l)*r0dt/r1ara(i0l)
     $         +r1supagr(i0l)*r1frcsupagrpnd(i0l)*r0dt/r1ara(i0l)
     $         +r1supagr(i0l)*r1frcsupagrnnb(i0l)*r0dt/r1ara(i0l)
     $         +r1rainf(i0l) *r0dt
     $         +r1qsm(i0l)   *r0dt)
        end if
      end do
c
      end
