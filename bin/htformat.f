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
      program htformat
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   convert file format
cby   hanasaki, 20100331: H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter (array)
      integer           n0l
      integer           n0x
      integer           n0y
      real              p0lonmin
      real              p0lonmax
      real              p0latmin
      real              p0latmax
c parameter (default)
      integer           n0if
      integer           n0of
      parameter        (n0if=15) 
      parameter        (n0of=16) 
c index (array)
      integer           i0l
      integer           i0x
      integer           i0y
c temporary
      character*128     c0tmp
c in (set)
      character*128     c0optin
      character*128     c0optout
c in (map)
      integer,dimension(:),allocatable :: i1l2x
      integer,dimension(:),allocatable :: i1l2y
      character*128     c0l2x
      character*128     c0l2y
c in (flux)
      real,dimension(:),allocatable :: r1dat
      real,dimension(:,:),allocatable :: r2dat
      character*128     c0ifname
c out
      character*128     c0ofname
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Argument
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(iargc().ne.13)then
        write(*,*) 'Usage: htformat n0l n0x n0y c0l2x c0l2y'
        write(*,*) '                p0lonmin p0lonmax p0latmin p0latmax'
        write(*,*) '                OPTION1 OPTION2'
        write(*,*) '                IN OUT'
        write(*,*) 'OPTION1: [binary,bytswp,asciiu,ascii3]'
        write(*,*) 'OPTION2: [binary,bytswp,asciiu,ascii3,xls]'
        write(*,*) '  binary: in binary'
        write(*,*) '  bytswp: in bynary (byte swap)'
        write(*,*) '  asciiu: in ascii unofrmatted'
        write(*,*) '  ascii3: in ascii lon,lat,data format'
        write(*,*) '  xls:    in ascii tuned for MS Excel'
        write(*,*) 'IN:  [c0bin,c0asc,c0xyz]'
        write(*,*) 'OUT: [c0bin,c0asc,c0xyz]'
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
      call getarg(10,c0optin)
      call getarg(11,c0optout)
      call getarg(12,c0ifname)
      call getarg(13,c0ofname)
c
      allocate(r1dat(n0l))
      allocate(r2dat(n0x,n0y))
      allocate(i1l2x(n0l))
      allocate(i1l2y(n0l))
c
      call read_i1l2xy(n0l,c0l2x,c0l2y,i1l2x,i1l2y)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Read
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(c0optin.eq.'binary')then
        call read_binary(n0l,c0ifname,r1dat)
      else if(c0optin.eq.'bytswp')then
        call read_bytswp(n0l,c0ifname,r1dat)
      else if(c0optin.eq.'asciiu')then
        call read_asciiu(n0l,c0ifname,r1dat)
      else if(c0optin.eq.'ascii3')then
        call read_ascii3(
     $       n0l,n0x,n0y,i1l2x,i1l2y,
     $       p0lonmin,p0lonmax,p0latmin,p0latmax,
     $       c0ifname,
     $       r1dat)
      else
        write(*,*) 'htformat: OPTin not valid: ',c0optin
      end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Write
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(c0optout.eq.'binary')then
        call wrte_binary(n0l,r1dat,c0ofname)
      else if(c0optout.eq.'bytswp')then
        call wrte_bytswp(n0l,r1dat,c0ofname)
      else if(c0optout.eq.'asciiu')then
        call wrte_asciiu(n0l,r1dat,c0ofname)
      else if(c0optout.eq.'xls')then
        call conv_r2tor1(
     $     n0l,n0x,n0y,i1l2x,i1l2y,
     $     r1dat,
     $     r2dat)
        write(c0tmp,*) n0x
        open(16,file=c0ofname)
        do i0y=1,n0y
          write(16,'('//c0tmp//'es16.8)') (r2dat(i0x,i0y),i0x=1,n0x)
        end do
        close(16)
      else if(c0optout.eq.'ascii3')then
        call wrte_ascii3(
     $       n0l,n0x,n0y,i1l2x,i1l2y,
     $       p0lonmin,p0lonmax,p0latmin,p0latmax,
     $       r1dat,
     $       c0ofname)
      else
        write(*,*) 'htformat: OPTout not valid: ',c0optout
      end if      
c
      end
