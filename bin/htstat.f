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
      program htstat
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cto   statistically calculate a binary
cby   2010/03/31, hanasaki: H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      implicit none
c parameter (array)
      integer              n0l
      integer              n0x
      integer              n0y
      real                 p0lonmin
      real                 p0lonmax
      real                 p0latmin
      real                 p0latmax
c parameter (default)
      integer              n0if
      real                 p0inimin
      real                 p0inimax
      real                 p0mis
      parameter           (n0if=15) 
      parameter           (p0inimin=9.9E20) 
      parameter           (p0inimax=-9.9E20) 
      parameter           (p0mis=1.0E20) 
c index (array)
      integer              i0l
      integer              i0x
      integer              i0y
c temporary
      character*128        c0tmp
c function
      integer              iargc
      real                 rgetlon
      real                 rgetlat
c in (set)
      real                 r0lon
      real                 r0lat
      character*128        c0opt
c in (map)
      integer,allocatable::i1l2x(:)
      integer,allocatable::i1l2y(:)
      character*128        c0l2x
      character*128        c0l2y
c in (flux)
      real,allocatable::   r1dat(:)
      character*128        c0ifname
c out
      real                 r0out
c local
      integer              i0cnt
      integer              i0out
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Argument
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(iargc().ne.11)then
        write(*,*) 'Usage: htstat n0l n0x n0y c0l2x c0l2y'
        write(*,*) '              p0lonmin p0lonmax p0latmin p0latmax'
        write(*,*) '              OPTION c0bin'
        write(*,*) 'OPTION: ["sum","ave","max","min"]'
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
      call getarg(10,c0opt)
      call getarg(11,c0ifname)
c
      allocate(r1dat(n0l))
      allocate(i1l2x(n0l))
      allocate(i1l2y(n0l))
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c initialize
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Read
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      call read_binary(n0l,c0ifname,r1dat)
      call read_i1l2xy(n0l,c0l2x,c0l2y,i1l2x,i1l2y)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Calculation
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(c0opt.eq.'sum')then
        r0out=0.0
        i0cnt=0
        do i0l=1,n0l
          if(r1dat(i0l).ne.p0mis)then
            r0out=r0out+r1dat(i0l)
            i0cnt=i0cnt+1
          end if
        end do
      else if(c0opt.eq.'ave')then
        r0out=0.0
        i0cnt=0
        do i0l=1,n0l
          if(r1dat(i0l).ne.p0mis)then
            r0out=r0out+r1dat(i0l)
            i0cnt=i0cnt+1
          end if
        end do
        if(i0cnt.ne.0)then
          r0out=r0out/real(i0cnt)
        else
          r0out=p0mis
        end if
      else if(c0opt.eq.'max')then
        r0out=p0inimax
        i0cnt=0
        do i0l=1,n0l
          if(r1dat(i0l).ne.p0mis)then
            r0out=max(r0out,r1dat(i0l))
            if(r0out.eq.r1dat(i0l))then
              i0out=i0l
              i0x=i1l2x(i0l)
              i0y=i1l2y(i0l)
              c0tmp='none'
              r0lon=rgetlon(n0x,p0lonmin,p0lonmax,i0x,c0tmp)
              r0lat=rgetlat(n0y,p0latmin,p0latmax,i0y,c0tmp)
            end if
          end if
        end do
      else if(c0opt.eq.'min')then
        r0out=p0inimin
        i0cnt=0
        do i0l=1,n0l
          if(r1dat(i0l).ne.p0mis)then
            r0out=min(r0out,r1dat(i0l))
            if(r0out.eq.r1dat(i0l))then
              i0out=i0l
              i0x=i1l2x(i0l)
              i0y=i1l2y(i0l)
              c0tmp='none'
              r0lon=rgetlon(n0x,p0lonmin,p0lonmax,i0x,c0tmp)
              r0lat=rgetlat(n0y,p0latmin,p0latmax,i0y,c0tmp)
            end if
          end if
        end do
      end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Write file
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(c0opt.eq.'sum'.or.c0opt.eq.'ave')then
        write(*,*) r0out,i0cnt
      else if(c0opt.eq.'min'.or.c0opt.eq.'max')then
        write(*,'(es16.8,i8,i8,i8,f16.4,f16.4)')
     $       r0out,i0out,i0x,i0y,r0lon,r0lat
      end if
c
      end
