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
      subroutine wrte_bints3(
     $     n0l,n0t,
     $     r1dat,r3dat,
     $     c1out,i0year,i0mon,i0day,i0sec,i0secint,
     $     c0optt,n0m,i0mnow,r2arafrc,c0optm)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   write binary time series (for mosaic model)
cby   2010/03/31, hanasaki, NIES: H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter (array)
      integer           n0l     !! land
      integer           n0t     !! time (day, month, year)
      integer           n0m     !! mosaic
c parameter (default)
      real              p0mis
      parameter        (p0mis=1.0E20) 
c index (array)
      integer           i0l
      integer           i0t
      integer           i0m
c index (time)
      integer           i0year
      integer           i0mon
      integer           i0day
      integer           i0sec
      integer           i0secint
c in
      integer           i0mnow   !! current mosaic id
      real              r1dat(n0l)
      real              r3dat(n0l,0:n0t,0:n0m)
      real              r2arafrc(n0l,n0m) !! areal fraction
      character*128     c1out(0:n0m)
      character*128     c0optt   !! option for temporal integration
      character*128     c0optm   !! option for mosaic integration
c local
      real              r2dat(n0l,0:n0t)
      character*128     c0out
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Initialize
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      r2dat=0.0
      c0out=''
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0t=0,n0t
        do i0l=1,n0l
          r2dat(i0l,i0t)=r3dat(i0l,i0t,i0mnow)
        end do
      end do
      c0out=c1out(i0mnow)
c
      call wrte_bints2(
     $     n0l,n0t,
     $     r1dat,r2dat,
     $     c0out,i0year,i0mon,i0day,i0sec,i0secint,
     $     c0optt)
c
      do i0t=0,n0t
        do i0l=1,n0l
          r3dat(i0l,i0t,i0mnow)=r2dat(i0l,i0t)
        end do
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(i0mnow.eq.n0m)then
cbug        do i0t=0,n0t
cbug          do i0l=1,n0l
cbug            r3dat(i0l,i0t,0)=0.0
cbug            do i0m=1,n0m
cbug              r3dat(i0l,i0t,0)
cbug     $             =r3dat(i0l,i0t,0)
cbug     $             +r3dat(i0l,i0t,i0m)*r2arafrc(i0l,i0m)
cbug            end do
cbug          end do
cbug        end do
        if(c0optm.eq.'ave')then
          do i0l=1,n0l
            r1dat(i0l)=0.0
            do i0m=1,n0m
cbug              r3dat(i0l,0,0)
cbug     $             =r3dat(i0l,0,0)
              if(r3dat(i0l,0,i0m).ne.p0mis.and.
     $           r2arafrc(i0l,i0m).ne.p0mis)then
                r1dat(i0l)
     $               =r1dat(i0l)
     $               +r3dat(i0l,0,i0m)*r2arafrc(i0l,i0m)
              end if
            end do
          end do
        else if(c0optm.eq.'sum')then
          do i0l=1,n0l
            r1dat(i0l)=0.0
            do i0m=1,n0m
cbug              r3dat(i0l,0,0)
cbug     $             =r3dat(i0l,0,0)
              if(r3dat(i0l,0,i0m).ne.p0mis)then
                r1dat(i0l)
     $               =r1dat(i0l)
     $               +r3dat(i0l,0,i0m)
              end if
            end do
          end do
        else
          write(*,*) 'wrte_bints3: c0optm',c0optm,'not supported.'
          stop
        end if
c
        do i0t=0,n0t
          do i0l=1,n0l
            r2dat(i0l,i0t)=r3dat(i0l,i0t,0)
          end do
        end do
        c0out=c1out(0)
c
        call wrte_bints2(
     $       n0l,n0t,
     $       r1dat,r2dat,
     $       c0out,i0year,i0mon,i0day,i0sec,i0secint,
     $       c0optt)
c     
        do i0t=0,n0t
          do i0l=1,n0l
            r3dat(i0l,i0t,0)=r2dat(i0l,i0t)
          end do
        end do
      end if
c
      end
