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
      program htedit
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cto   edit single data of binary
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
c index (array)
      integer              i0l
      integer              i0x
      integer              i0y
c temporary
      character*128        c0tmp             !! dummy
c function
      integer              iargc
      integer              igeti0l
      integer              igeti0x
      integer              igeti0y
c in (map)
      integer,allocatable::i1l2x(:)
      integer,allocatable::i1l2y(:)
      character*128        c0l2x
      character*128        c0l2y
c in (set)
      real                 r0lon            !! longitude
      real                 r0lat            !! latitude
      real                 r0dat
      character*128        c0opt 
c in (flux)
      real,allocatable::   r1dat(:)         !! 
      character*128        c0ifname         !! Input File NAME
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Get arguments
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(iargc().lt.12) then
        write(*,*) 'Usage: htedit n0l n0x n0y c0l2x c0l2y'
        write(*,*) '              p0lonmin p0lonmax p0latmin p0latmax'
        write(*,*) '              OPTION'
        write(*,*) 'OPTION: [{"l"      c0bin r0dat i0l},'
        write(*,*) '         {"xy"     c0bin r0dat i0x i0y},'
        write(*,*) '         {"lonlat" c0bin r0dat r0lon r0lat}]'
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
      call getarg(12,c0tmp)
      read(c0tmp,*) r0dat
c
      if(c0opt.eq.'l')then
        if(iargc().ne.13) then
          write(*,*) 'Usage: htpoint n0l n0x n0y c0l2x c0l2y'
          write(*,*) '       p0lonmin p0lonmax p0latmin p0latmax'
          write(*,*) '       c0opt c0if i0l'
          stop
        else
          call getarg(13,c0tmp)
          read(c0tmp,*) i0l
        end if
      else if(c0opt.eq.'xy')then
        if(iargc().ne.14) then
          write(*,*) 'Usage: htpoint n0l n0x n0y c0l2x c0l2y'
          write(*,*) '       p0lonmin p0lonmax p0latmin p0latmax'
          write(*,*) '       c0opt c0if i0x i0y'
          stop
        else
          call getarg(13,c0tmp)
          read(c0tmp,*) i0x
          call getarg(14,c0tmp)
          read(c0tmp,*) i0y
        end if
      else if(c0opt.eq.'lonlat')then
        if(iargc().ne.14) then
          write(*,*) 'Usage: htpoint n0l n0x n0y c0l2x c0l2y'
          write(*,*) '       p0lonmin p0lonmax p0latmin p0latmax'
          write(*,*) '       c0opt c0if r0lon r0lat'
          stop
        else
          call getarg(13,c0tmp)
          read(c0tmp,*) r0lon
          call getarg(14,c0tmp)
          read(c0tmp,*) r0lat
        end if
      else
        write(*,*) 'Your typed option ',c0opt,' not supported. Abort.'
        stop
      end if
c
      allocate(r1dat(n0l))
      allocate(i1l2x(n0l))
      allocate(i1l2y(n0l))
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Read file
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      call read_binary(n0l,c0ifname,r1dat)
      call read_i1l2xy(n0l,c0l2x,c0l2y,i1l2x,i1l2y)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Write results
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(c0opt.eq.'l')then
        write(*,*) 'htedit: original r1dat(',i0l,')=',r1dat(i0l)
        r1dat(i0l)=r0dat
        write(*,*) 'htedit: revised  r1dat(',i0l,')=',r1dat(i0l)
      else if(c0opt.eq.'xy')then
        i0l=igeti0l(n0l,n0x,n0y,i1l2x,i1l2y,i0x,i0y)
        write(*,*) 'htedit: original r1dat(',i0l,')=',r1dat(i0l)
        r1dat(i0l)=r0dat
        write(*,*) 'htedit: revised  r1dat(',i0l,')=',r1dat(i0l)
      else if(c0opt.eq.'lonlat')then
        i0x=igeti0x(n0x,p0lonmin,p0lonmax,r0lon)
        i0y=igeti0y(n0y,p0latmin,p0latmax,r0lat)
        i0l=igeti0l(n0l,n0x,n0y,i1l2x,i1l2y,i0x,i0y)
        write(*,*) 'htedit: original r1dat(',i0l,')=',r1dat(i0l)
        r1dat(i0l)=r0dat
        write(*,*) 'htedit: revised  r1dat(',i0l,')=',r1dat(i0l)
      end if
      call wrte_binary(n0l,r1dat,c0ifname)
c
      end

