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
      program prog_WFDEI
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   convert extended WATCH Forcing Data into hformat
cby   2013/03/14, hanasaki, NIES: H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter (array)
      integer           n0l
      integer           n0x
      integer           n0y
      integer           n0t
      parameter        (n0l=259200)
      parameter        (n0x=720)
      parameter        (n0y=360)
      parameter        (n0t=3) 
c parameter (default)
      integer           n0secday
      parameter        (n0secday=86400) 
      real              p0mis
      parameter        (p0mis=1.0E20) 
c index (array)
      integer           i0l
      integer           i0x
      integer           i0y
c index (time)
      integer           i0day
      integer           i0sec
c temporary
      character*128     c0tmp
c function
      integer           igetday
c in (set)
      integer           i0year
      integer           i0mon
      integer           i0secint
c in (dat)
      real              r1dat(n0l)
      character*128     c0dat
c out
      real              r1out(n0l)
      character*128     c0out
c local
      real              r2out(n0l,0:n0t)
      character*128     s0ave
      data              s0ave/'ave'/ 
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(iargc().ne.5)then
        write(*,*) 'prog_WFDEI c0dat i0year i0mon i0secint c0out'
        stop
      end if
c
      call getarg(1,c0dat)
      call getarg(2,c0tmp)
      read(c0tmp,*) i0year
      call getarg(3,c0tmp)
      read(c0tmp,*) i0mon
      call getarg(4,c0tmp)
      read(c0tmp,*) i0secint
      call getarg(5,c0out)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c process and write
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      open(15,file=c0dat)
      do i0day=1,igetday(i0year,i0mon)
        do i0sec=i0secint,n0secday,i0secint
c          do i0l=1,n0l
c            read(15,*) r1dat(i0l)
c            write(*,*) i0l,r1dat(i0l)
c          end do
          read(15,*) (r1dat(i0l),i0l=1,n0l)
          write(*,*) i0day,i0sec
c          
          r1out=p0mis
          do i0y=1,n0y
            do i0x=1,n0x
              r1out(i0x+n0x*(i0y-1))=r1dat(i0x+n0x*(n0y-i0y))
            end do
          end do
c
            call wrte_bints2(
     $           n0l,n0t,
     $           r1out,r2out,
     $           c0out,i0year,i0mon,i0day,i0sec,i0secint,
     $           s0ave)
c          
        end do
      end do
c     
      end
