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
      subroutine calc_irgapp(
     $     n0l,n0c,
     $     i0ldbg,      i0secint,    
     $     r0fctpad,    r0fctnonpad, c0optlnduse,
     $     i2crptyp,    r1soildepth, r1w_fieldcap,r1w_wilt,
     $     r1lndara,    r1arafrc,
     $     i2flgcul,    i2flgirg,    r2target,    
     $     r1soilmoist, r1supagr,    
     $     r1demagr)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   calculate irrigation water demand
cby   2010/09/30, hanasaki, NIES, H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter (array)
      integer           n0l
      integer           n0c
c parameter (default)
      real              p0mis
      parameter        (p0mis=1.0E20) 
c index (array)
      integer           i0l
c in (set)
      integer           i0ldbg
      integer           i0secint           !! interval [second]
      real              r0fctpad           !! factor for paddy
      real              r0fctnonpad        !! factor for nonpaddy
      character*128     c0optlnduse        !! land use
c in (map)     
      integer           i2crptyp(n0l,n0c)  !! crop type
      real              r1soildepth(n0l)   !! soildepth
      real              r1w_fieldcap(n0l)  !! field capacity
      real              r1w_wilt(n0l)      !! wilting point
      real              r1lndara(n0l)      !! land area
      real              r1arafrc(n0l)      !! areal fraction
c in (flux)
      integer           i2flgcul(n0l,n0c)  !! cultivation flag
      integer           i2flgirg(n0l,n0c)  !! irrigation flag
      real              r2target(n0l,n0c)  !! target SoilMoisture
      real              r1supagr(n0l)      !! water supply for agriculture
      real              r1soilmoist(n0l)   !! soil moisture
c out
      real              r1demagr(n0l)      !! agricultural demand
c local
      integer           i1crptyp(n0l)
      integer           i1flgirg(n0l)
      real              r1target(n0l)
      real              r1irgara(n0l)
      real              r0factor
      real              r1soilmoisttarget(n0l)
      real              r1add(n0l)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Initialize
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      i1crptyp=0
      i1flgirg=0
      r1target=0.0
      r1irgara=0.0
      r0factor=0.0
      r1soilmoisttarget=0.0
      r1add=0.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(c0optlnduse.ne.'dci'.and.c0optlnduse.ne.'sci'.and.
     $   c0optlnduse.ne.'scr'.and.c0optlnduse.ne.'non')then
        write(*,*) 'calc_irgapp: c0optlnduse',c0optlnduse,
     $       'not supported. Abort. '
        stop
      end if
c
      if(c0optlnduse.eq.'dci')then
        do i0l=1,n0l
          if(i2flgcul(i0l,1).eq.1)then
            i1crptyp(i0l)=i2crptyp(i0l,1)
          else if(i2flgcul(i0l,2).eq.1)then
            i1crptyp(i0l)=i2crptyp(i0l,2)
          end if
        end do
        do i0l=1,n0l
          if(i2flgirg(i0l,1).eq.1)then
            i1flgirg(i0l)=i2flgirg(i0l,1)
            r1target(i0l)=r2target(i0l,1)
          else if(i2flgirg(i0l,2).eq.1)then
            i1flgirg(i0l)=i2flgirg(i0l,2)
            r1target(i0l)=r2target(i0l,2)
          end if
        end do
        do i0l=1,n0l
          if(r1arafrc(i0l).ne.p0mis)then
            r1irgara(i0l)=r1lndara(i0l)*r1arafrc(i0l)
          end if
        end do
      else if(c0optlnduse.eq.'sci')then
        do i0l=1,n0l
          if(i2flgcul(i0l,1).eq.1)then
            i1crptyp(i0l)=i2crptyp(i0l,1)
          end if
        end do
        do i0l=1,n0l
          if(i2flgirg(i0l,1).eq.1)then
            i1flgirg(i0l)=i2flgirg(i0l,1)
            r1target(i0l)=r2target(i0l,1)
          end if
        end do
        do i0l=1,n0l
          if(r1arafrc(i0l).ne.p0mis)then
            r1irgara(i0l)=r1lndara(i0l)*r1arafrc(i0l)
          end if
        end do
      else if(c0optlnduse.eq.'scr')then
        do i0l=1,n0l
          if(i2flgcul(i0l,1).eq.1)then
            i1crptyp(i0l)=i2crptyp(i0l,1)
          end if
        end do
        i1flgirg=0
        r1target=0.0
        r1irgara=0.0
      else if(c0optlnduse.eq.'non')then
        i1crptyp=0
        i1flgirg=0
        r1target=0.0
        r1irgara=0.0
      end if

d     write(*,*) 'calc_irgapp: before irrig.'
d     write(*,*) 'calc_irgapp: |-i1crptyp   ',i1crptyp(i0ldbg)
d     write(*,*) 'calc_irgapp: |-i1flgirg   ',i1flgirg(i0ldbg)
d     write(*,*) 'calc_irgapp: |-r1target   ',r1target(i0ldbg)
d     write(*,*) 'calc_irgapp: |-r1irgara   ',r1irgara(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c irrigation demand max
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0l=1,n0l
        if(i1flgirg(i0l).eq.1)then
          if(i1crptyp(i0l).eq.12)then
            r0factor=r0fctpad
          else
            r0factor=r0fctnonpad
          end if
          r1soilmoisttarget(i0l)
     $         =r1soildepth(i0l)
     $         *(r1w_fieldcap(i0l)-r1w_wilt(i0l))
     $         *r0factor*1000.0*r1target(i0l)
        end if
      end do
c
d     write(*,*) 'calc_irgapp: |-r1smtarget ',r1soilmoisttarget(i0ldbg)
d     write(*,*) 'calc_irgapp: |-r1soilmoist',r1soilmoist(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c demand/supply
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      r1demagr=0.0
      do i0l=1,n0l
        if(i1flgirg(i0l).eq.1.and.r1irgara(i0l).ne.0.0)then
          if((r1soilmoist(i0l)).lt.r1soilmoisttarget(i0l))then
            r1demagr(i0l)
     $           =(r1soilmoisttarget(i0l)-r1soilmoist(i0l))
     $           *r1irgara(i0l)/real(i0secint)
          end if
        end if
      end do
c
        if(c0optlnduse.eq.'dci')then
          do i0l=1,n0l
            r1add(i0l)=max(min(r1demagr(i0l),r1supagr(i0l)),0.0)
          end do
          do i0l=1,n0l
            r1supagr(i0l)=r1supagr(i0l)-r1add(i0l)
          end do
        else if(c0optlnduse.eq.'sci')then
          do i0l=1,n0l
            r1add(i0l)=r1supagr(i0l)
          end do
          do i0l=1,n0l
            r1supagr(i0l)=r1supagr(i0l)-r1add(i0l)
          end do
        end if
c
      do i0l=1,n0l
        if(r1irgara(i0l).ne.0.0)then !! bug fix
          r1soilmoist(i0l)
     $         =r1soilmoist(i0l)
     $         +r1add(i0l)*real(i0secint)
     $         /r1irgara(i0l)
        end if
      end do
c
d     write(*,*) 'calc_irgapp: after irrig. '
d     write(*,*) 'calc_irgapp: |-i0secint   ',i0secint
d     write(*,*) 'calc_irgapp: |-r1soilmoist',r1soilmoist(i0ldbg)
d     write(*,*) 'calc_irgapp: |-r1demagr   ',r1demagr(i0ldbg)
d     write(*,*) 'calc_irgapp: |-r1supagr   ',r1supagr(i0ldbg)
c
      end
