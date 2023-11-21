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
      program htrank
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   sort time series data and show as a ranking table
cby   2010/05/18, hanasaki: H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c
      integer           n0l
      integer           n0x
      integer           n0y

      real              p0lonmin
      real              p0lonmax
      real              p0latmin
      real              p0latmax
      integer           n0rec
      integer           n0secday
      parameter        (n0rec=366*100) 
      parameter        (n0secday=86400) 
c
      integer,allocatable::i1l2x(:)
      integer,allocatable::i1l2y(:)
      character*128     c0l2x
      character*128     c0l2y
c index (array)
      integer           i0l
      integer           i0rec
      integer           i0recmax
c index (time)
      integer           i0year
      integer           i0yearmin
      integer           i0yearmax
      integer           i0mon
      integer           i0monmin
      integer           i0monmax
      integer           i0day
      integer           i0daymin
      integer           i0daymax
c local
      integer,allocatable::i1rnk2org(:)           
      integer,allocatable::i1org2rnk(:)           
      integer,allocatable::i1year(:)           
      integer,allocatable::i1mon(:)           
      integer,allocatable::i1day(:)           
      integer           i0lenin
c temporary
      real              r0tmp
      real,allocatable::r1tmp(:)
      character*128     c0tmp
c in
      real,allocatable::r1dat(:)
      character*128     c0in
c in
      integer           i0x
      integer           i0y
      real              r0lon
      real              r0lat
      character*128     c0optout
c out
      real,allocatable::r1out(:)
      character*128     c0out
c
      character*128     c0idx
      character*128     c0opt
c function
      character*128     cgetfnt
      integer           igetday
      integer           iargc
      integer           igeti0l
      integer           igeti0x
      integer           igeti0y
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(iargc().ne.15.and.iargc().ne.16)then
 10     write(*,*) 'Usage: htrank n0l n0x n0y c0l2x c0l2y'
        write(*,*) '              p0lonmin p0lonmax p0latmin p0latmax'
        write(*,*) '              OPTION1 OPTION2'
        write(*,*) 'OPTION1: [largest10 smallest10 decord incord]'
        write(*,*) '  largest10  to show largest  10 records'
        write(*,*) '  smallest10 to show smallest 10 records'
        write(*,*) '  decord     to show records in decreasing order'
        write(*,*) '  incord     to show records in increasing order'
        write(*,*) 'OPTION2:'
        write(*,*) '[{"l"     c0bints i0yearmin i0yearmax i0l}'
        write(*,*) ' {"xy"    c0bints i0yearmin i0yearmax i0x i0y}'
        write(*,*) ' {"lonlat"c0bints i0yearmin i0yearmax r0lon r0lat}]'
        stop
      end if
c
      call getarg(1,c0tmp)
      read(c0tmp,*) n0l
      call getarg(2,c0tmp)
      read(c0tmp,*) n0x
      call getarg(3,c0tmp)
      read(c0tmp,*) n0y
      call getarg(4,c0l2x)
      call getarg(5,c0l2y)
      call getarg(6,c0tmp)
      read(c0tmp,*) p0lonmin
      call getarg(7,c0tmp)
      read(c0tmp,*) p0lonmax
      call getarg(8,c0tmp)
      read(c0tmp,*) p0latmin
      call getarg(9,c0tmp)
      read(c0tmp,*) p0latmax
      call getarg(10,c0optout)
      call getarg(11,c0opt)
      call getarg(12,c0in)
      call getarg(13,c0tmp)
      read(c0tmp,*) i0yearmin
      call getarg(14,c0tmp)
      read(c0tmp,*) i0yearmax
c
      if(c0opt.eq.'l')then
        if(iargc().ne.15) then
          goto 10
        else
          call getarg(15,c0tmp)
          read(c0tmp,*) i0l
        end if
      else if(c0opt.eq.'xy')then
        if(iargc().ne.16) then
          goto 10
        else
          call getarg(15,c0tmp)
          read(c0tmp,*) i0x
          call getarg(16,c0tmp)
          read(c0tmp,*) i0y
        end if
      else if(c0opt.eq.'lonlat')then
        if(iargc().ne.16) then
          goto 10
        else
          call getarg(15,c0tmp)
          read(c0tmp,*) r0lon
          call getarg(16,c0tmp)
          read(c0tmp,*) r0lat
        end if
      else
        write(*,*) 'Your typed option ',c0opt,' not supported. Abort.'
        stop
      end if
c
      allocate(r1tmp(n0l))
      allocate(r1dat(n0rec))
      allocate(r1out(n0rec))
      allocate(i1org2rnk(n0rec))
      allocate(i1rnk2org(n0rec))
      allocate(i1year(n0rec))
      allocate(i1mon(n0rec))
      allocate(i1day(n0rec))
      allocate(i1l2x(n0l))
      allocate(i1l2y(n0l))
c
      i0lenin=len_trim(c0in)
      c0idx=c0in(i0lenin-1:i0lenin)
c
      call read_i1l2xy(n0l,c0l2x,c0l2y,i1l2x,i1l2y)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c read
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(c0idx.eq.'YR')then
        i0monmin=0
        i0monmax=0
      else
        i0monmin=1
        i0monmax=12
      end if
      i0rec=0
      do i0year=i0yearmin,i0yearmax
        do i0mon=i0monmin,i0monmax
          if(c0idx.eq.'DY')then
            i0daymin=1
            i0daymax=igetday(i0year,i0mon)
          else
            i0daymin=0
            i0daymax=0
          end if
          do i0day=i0daymin,i0daymax
            call read_result(n0l,c0in,i0year,i0mon,i0day,
     $                       n0secday,n0secday,r1tmp)
            i0rec=i0rec+1

            if(c0opt.eq.'xy')then
              i0l=igeti0l(n0l,n0x,n0y,i1l2x,i1l2y,i0x,i0y)
            else if(c0opt.eq.'lonlat')then
              i0x=igeti0x(n0x,p0lonmin,p0lonmax,r0lon)
              i0y=igeti0y(n0y,p0latmin,p0latmax,r0lat)
              i0l=igeti0l(n0l,n0x,n0y,i1l2x,i1l2y,i0x,i0y)
            end if

            r1dat(i0rec)=r1tmp(i0l)
            i1year(i0rec)=i0year
            i1mon(i0rec)=i0mon
            i1day(i0rec)=i0day
          end do
        end do
      end do
      i0recmax=i0rec
      write(*,*) 'htrank: i0recmax: ',i0recmax
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Sort
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call sort_decord(
     $     n0rec,
     $     r1dat,
     $     r1out,i1org2rnk,i1rnk2org)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Write
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(c0optout.eq.'largest10')then
        do i0rec=1,10
          write(*,*) i0rec,r1out(i0rec),i1year(i1rnk2org(i0rec)),
     $          i1mon(i1rnk2org(i0rec)),i1day(i1rnk2org(i0rec))
        end do
      else if(c0optout.eq.'decord')then
        do i0rec=1,i0recmax
          write(*,*) i1year(i0rec),i1mon(i0rec),i1day(i0rec),
     $               i1org2rnk(i0rec),r1dat(i0rec)
        end do        
      else if(c0optout.eq.'smallest10')then
        do i0rec=i0recmax,i0recmax-9,-1
          write(*,*) i0rec,r1out(i0rec),i1year(i1rnk2org(i0rec)),
     $          i1mon(i1rnk2org(i0rec)),i1day(i1rnk2org(i0rec))
        end do
      else if(c0optout.eq.'incord')then
        do i0rec=i0recmax,1,-1
          write(*,*) i1year(i0rec),i1mon(i0rec),i1day(i0rec),
     $               i1org2rnk(i0rec),r1dat(i0rec)
        end do        
      else
        write(*,*) 'htrank: c0optout: ',c0optout,' not supported.'
      end if
c
      end
