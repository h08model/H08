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
      program htcatts
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   combine time series data in Hformat1D
cby   2010/03/31, hanasaki: H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter (array)
      integer           n0yearmin
      integer           n0yearmax
      integer           n0mis
      real              p0mis
      integer           n0nof   !! number of files
      parameter        (n0yearmin=1800)
      parameter        (n0yearmax=2300)
      parameter        (n0mis=-9999)
      parameter        (p0mis=1.0E20)
      parameter        (n0nof=100)  
      integer           n0minini
      integer           n0maxini
      parameter        (n0minini=999999999) 
      parameter        (n0maxini=-999999999) 
c index (array)
      integer           i0nof
      integer           i0nofmax
      integer           i0dat
      integer           i0datmax
c index (time)
      integer           i0year
      integer           i0yearmin
      integer           i0yearmin2
      integer           i0yearminout
      integer           i0yearmindummy
      integer           i0yearmax
      integer           i0yearmax2
      integer           i0yearmaxout
      integer           i0yearmaxdummy
      integer           i0mon
      integer           i0monmin
      integer           i0monmax
      integer           i0day
      integer           i0daymin
      integer           i0daymax
c function
      integer           iargc
      integer           igetday
      integer           is_char
c temporary
      integer           i0tmp
      character*128     c0tmp
c in
      real              r3dat(0:n0yearmax-n0yearmin+1,0:12,0:31)
      character*128     c1ifname(n0nof)   !! input file name
c local
      real              r4dat(0:n0yearmax-n0yearmin+1,0:12,0:31,n0nof)
      real              r1dat(n0nof)
      character*128     c0idx
      integer           i0in
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c get argument
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if (iargc().eq.0) then
        write(*,*) 'htcatts c0ascts, c0ascts,.... (max 100)'
        stop
      end if
c
      i0nofmax=iargc()
c
      if(i0nofmax.le.2)then
        do i0nof=1,iargc()  
          call getarg(i0nof,c1ifname(i0nof))
        end do
        i0yearmaxout=n0mis
        i0yearminout=n0mis
      else
        do i0nof=1,iargc()-2
          call getarg(i0nof,c1ifname(i0nof))
        end do
        call getarg(iargc()-1,c0tmp)
        if(is_char(c0tmp).eq.1)then
          c1ifname(iargc()-1)=c0tmp
          call getarg(iargc(),c1ifname(iargc()))
          i0yearmaxout=n0mis
          i0yearminout=n0mis
        else
          read(c0tmp,*) i0yearminout
          call getarg(iargc(),c0tmp)
          read(c0tmp,*) i0yearmaxout
          i0nofmax=iargc()-2
        end if
c

      end if
c
      c0tmp=c1ifname(1)
      i0in=len_trim(c0tmp)
      c0idx=c0tmp(i0in-1:i0in)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c read
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      r4dat=p0mis
c
      i0yearmin=n0minini
      i0yearmax=n0maxini
c
      do i0nof=1,i0nofmax
        call read_ascii4(c1ifname(i0nof),r3dat,i0yearmin2,i0yearmax2)

        do i0year=n0yearmin,n0yearmax
          do i0mon=1,12
            do i0day=1,igetday(i0year,i0mon)
              r4dat(i0year-n0yearmin+1,i0mon,i0day,i0nof)
     $       =r3dat(i0year-n0yearmin+1,i0mon,i0day)
            end do
            r4dat(i0year-n0yearmin+1,i0mon,0,i0nof)
     $     =r3dat(i0year-n0yearmin+1,i0mon,0)
            r4dat(i0year-n0yearmin+1,0,0,i0nof)
     $     =r3dat(i0year-n0yearmin+1,0,0)
          end do
        end do
        do i0mon=1,12
          do i0day=1,igetday(i0year,i0mon)
            r4dat(0,i0mon,i0day,i0nof)
     $     =r3dat(0,i0mon,i0day)
          end do
          r4dat(0,i0mon,0,i0nof)
     $   =r3dat(0,i0mon,0)
          r4dat(0,0,0,i0nof)
     $   =r3dat(0,0,0)
        end do

        if(i0yearmin2.lt.i0yearmin)then
          i0yearmin=i0yearmin2
        end if
        if(i0yearmax2.gt.i0yearmax)then
          i0yearmax=i0yearmax2
        end if
      end do
c     write(*,*) 'htcatts: i0yearmin',i0yearmin
c     write(*,*) 'htcatts: i0yearmax',i0yearmax
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Write
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      write(c0tmp,*) i0nofmax
c      write(6,'(a2,x1,a2,x1,a2,x1,'//c0tmp//'a)')
c     $     'yr','mo','dy',(c1ifname(i0nof),i0nof=1,i0nofmax)
      if(i0yearmaxout.eq.n0mis)then
        i0yearmindummy=i0yearmin
        i0yearmaxdummy=i0yearmax
      else
        i0yearmindummy=i0yearminout
        i0yearmaxdummy=i0yearmaxout
      end if
c
      do i0year=i0yearmindummy,i0yearmaxdummy
        if(c0idx.eq.'YR')then
          i0monmin=0
          i0monmax=0
        else
          i0monmin=1
          i0monmax=12
        end if
        do i0mon=i0monmin,i0monmax
          if(c0idx.eq.'DY')then
            i0daymin=1
            i0daymax=igetday(i0year,i0mon)
          else
            i0daymin=0
            i0daymax=0
          end if
          do i0day=i0daymin,i0daymax
            do i0nof=1,i0nofmax
              r1dat(i0nof)=r4dat(i0year-n0yearmin+1,i0mon,i0day,i0nof)
              if(r1dat(i0nof).eq.p0mis)then
                r1dat(i0nof)=real(n0mis)
              end if
            end do
            write(6,'(i4,i4,i4,'//c0tmp//'es16.8)')
     $           i0year,i0mon,i0day,(r1dat(i0nof),i0nof=1,i0nofmax)
          end do
        end do
      end do
c
      end
