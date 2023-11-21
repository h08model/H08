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
      program prog_WFD
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   convert WATCH Forcing Data into hformat
cby   2010/09/23, hanasaki, NIES: H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter (array)
      integer           n0lin
      integer           n0lout
      integer           n0x
      integer           n0y
      integer           n0t
      parameter        (n0lin=67420) 
      parameter        (n0lout=259200)
      parameter        (n0x=720)
      parameter        (n0y=360)
      parameter        (n0t=3) 
c parameter (default)
      integer           n0secday
      parameter        (n0secday=86400) 
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
      integer           i1l(n0lin)
      real              r1dat(n0lin)
      character*128     c0l
      character*128     c0dat
c out
      real              r1out(n0lout)
      character*128     c0out
c local
      integer           i0rec
      real              r2out(n0lout,0:n0t)
      character*128     s0ave
      data              s0ave/'ave'/ 
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(iargc().ne.6)then
        write(*,*) 'prog_WFD c0dat c0l i0year i0secint c0out'
        stop
      end if
c
      call getarg(1,c0dat)
      call getarg(2,c0l)
      call getarg(3,c0tmp)
      read(c0tmp,*) i0year
      call getarg(4,c0tmp)
      read(c0tmp,*) i0mon
      call getarg(5,c0tmp)
      read(c0tmp,*) i0secint
      call getarg(6,c0out)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c 
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      open(15,file=c0l)
      read(15,*) (i1l(i0l),i0l=1,n0lin)
      close(15)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c process and write
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      i0rec=0
      open(15,file=c0dat)
      do i0day=1,igetday(i0year,i0mon)
        do i0sec=i0secint,n0secday,i0secint
          read(15,*) (r1dat(i0l),i0l=1,n0lin)
          i0rec=i0rec+1
          write(*,*) i0rec,i0day,i0sec,mod(i0rec,2)
c          
          if(i0secint.eq.21600.or.
     $       i0secint.eq.10800.and.mod(i0rec,2).eq.1)then
            r1out=1.0E20
            do i0l=1,n0lin
              r1out(i1l(i0l))=r1dat(i0l)
            end do
          end if
c
          if(i0secint.eq.10800.and.mod(i0rec,2).eq.0)then
            do i0l=1,n0lin
              r1out(i1l(i0l))=(r1out(i1l(i0l))+r1dat(i0l))/2.0
            end do
          end if
c
          if(i0secint.eq.21600.or.
     $       i0secint.eq.10800.and.mod(i0rec,2).eq.0)then
            call wrte_bints2(
     $           n0lout,n0t,
     $           r1out,r2out,
     $           c0out,i0year,i0mon,i0day,i0sec,21600,
     $           s0ave)
          end if
c          
        end do
      end do
c     
      end
