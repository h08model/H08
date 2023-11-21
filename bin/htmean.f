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
      program htmean
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cto   calculate mean annual/monthly/daily data
cby   2010/03/31, hanasaki: H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      implicit none
c parameter (array)
      integer              n0l
c parameter (physical)
      integer              n0secday
      parameter           (n0secday=86400) 
c parameter (default)
      real                 p0mis
      parameter           (p0mis=1.0E20) 
c index (array)
      integer              i0l
      integer              i0x
      integer              i0y
c index (time)
      integer              i0year
      integer              i0mon
      integer              i0monmin
      integer              i0monmax
      integer              i0day
      integer              i0daymin
      integer              i0daymax
      integer              i0hour
      integer              i0sec
      integer              i0secint
c temporary
      character*128        c0tmp             !! dummy
      real,allocatable::   r1tmp(:)
c function
      integer              iargc
      integer              igeti0l
      integer              igeti0x
      integer              igeti0y
      integer              igetday
      character*128        cgetfnt
c in (set)
      integer              i0yearmin
      integer              i0yearmax
      integer              i0yearout
c in
      real,allocatable::   r1dat(:)         !! 
      character*128        c0in             !!
c out
      real,allocatable::   r1out(:)
      character*128        c0ofname
c local
      integer              i0lenin
      real,allocatable::   r1rec(:)
      character*128        c0idx
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Get arguments
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(iargc().lt.5) then
        write(*,*) 'Usage: htmean n0l'
        write(*,*) '              c0bints i0yearmin i0yearmax i0yearout'
        stop
      end if
c
      call getarg(1,c0tmp)
      read(c0tmp,*) n0l
      call getarg(2,c0in)
      call getarg(3,c0tmp)
      read(c0tmp,*) i0yearmin
      call getarg(4,c0tmp)
      read(c0tmp,*) i0yearmax
      call getarg(5,c0tmp)
      read(c0tmp,*) i0yearout
c
      allocate(r1dat(n0l))
      allocate(r1out(n0l))
      allocate(r1rec(n0l))
      allocate(r1tmp(n0l))
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Read file
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      i0lenin=len_trim(c0in)
      c0idx=c0in(i0lenin-1:i0lenin)
c
      if(c0idx.eq.'YR')then
        i0monmin=0
        i0monmax=0
      else
        i0monmin=1
        i0monmax=12
      end if
      do i0mon=i0monmin,i0monmax
        if(c0idx.eq.'YR'.or.c0idx.eq.'MO')then
          i0daymin=0
          i0daymax=0
        else
          i0daymin=1
          i0daymax=igetday(0,i0mon)
        end if
        do i0day=i0daymin,i0daymax
          if(c0idx.eq.'YR'.or.c0idx.eq.'MO'.or.c0idx.eq.'DY')then
            i0secint=86400
          else if(c0idx.eq.'6H')then
            i0secint=21600
          else if(c0idx.eq.'3H')then
            i0secint=10800
          else if(c0idx.eq.'HR')then
            i0secint=3600
          else
            write(*,*) 'htseries: c0idx: ',c0idx,' not supported.'
            stop
          end if
          do i0sec=i0secint,n0secday,i0secint
            do i0l=1,n0l
              r1out(i0l)=0.0
              r1rec(i0l)=0.0
            end do
            do i0year=i0yearmin,i0yearmax
              call read_result(
     $             n0l,
     $             c0in,i0year,i0mon,i0day,i0sec,i0secint,
     $             r1dat)
              do i0l=1,n0l
                if(r1dat(i0l).ne.p0mis)then
                  r1out(i0l)=r1out(i0l)+r1dat(i0l)
                  r1rec(i0l)=r1rec(i0l)+1.0
                end if
              end do
            end do
            do i0l=1,n0l
              if(r1rec(i0l).ne.0.0)then
                r1out(i0l)=r1out(i0l)/r1rec(i0l)
              else
                r1out(i0l)=p0mis
              end if
            end do
            c0ofname=cgetfnt(c0in,i0yearout,i0mon,i0day,i0hour)
            call wrte_binary(n0l,r1out,c0ofname)
          end do
        end do
      end do
c
      end

