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
      program calc_rivnum
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cto   calculate rivnum
cby   2010/08/23, hanasaki, NIES: H08ver1.0
c     Copyright (C) 2010,2011 Naota Hanasaki
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
      integer              n0rec         !! num of records (basins)
      parameter           (n0rec=20000)
c index (array)
      integer              i0l
      integer              i0x
      integer              i0y
c function
      integer              iargc
      real                 rgetara
      real                 rgetlon
      real                 rgetlat
c temporary
      integer              i0tmp
      real                 r0tmp
      real,allocatable::   r1tmp(:)        !! temporary
      character*128        c0tmp
c in (set)
      integer              i0ldbg
c in (map)
      integer,allocatable::i1flwdir(:)     !! flow direction
      integer,allocatable::i1nxl(:)        !! downstream l coordinate
      integer,allocatable::i1l2x(:)
      integer,allocatable::i1l2y(:)
      character*128        c0flwdir
      character*128        c0nxl
      character*128        c0l2x
      character*128        c0l2y
c out
      integer,allocatable::i1rivnum(:)     !! river id
      character*128        c0rivnum
c local
      integer              i0cnt           !! iteration counter
      integer              i0numdef        !! num of defined cells
      integer              i0numudf        !! num of undefined cells
      integer              i0numudfpre     !! num of undefined cells previous
      integer              i0numbsn        !! num of basins in the world
      integer,allocatable::i1org2rnk(:)    !! original order --> sorted order
      integer,allocatable::i1rnk2org(:)    !! sorted order --> original order
      real,allocatable::   r1araorg(:)     !! catchment area (original order)
      real,allocatable::   r1aranew(:)     !! catchment area (sorted by area)
c local (temporal)
      real                 r0lonmin
      real                 r0lonmax
      real                 r0latmin
      real                 r0latmax
      character*128        s0north
      character*128        s0south
      character*128        s0east
      character*128        s0west
      data                 s0north/'north'/ 
      data                 s0south/'south'/ 
      data                 s0east/'east'/ 
      data                 s0west/'west'/ 
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Get arguments
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(iargc().ne.13)then
        write(*,*) 'calc_rivnum n0l n0x n0y c0l2x c0l2y'
        write(*,*) '            p0lonmin p0lonmax p0latmin p0latmax'
        write(*,*) '            c0flwdir c0nxl c0rivnum i0ldbg'
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
      call getarg(10,c0flwdir)
      call getarg(11,c0nxl)
      call getarg(12,c0rivnum)
      call getarg(13,c0tmp)
      read(c0tmp,*) i0ldbg
c
      allocate(i1l2x(n0l))
      allocate(i1l2y(n0l))
      allocate(i1flwdir(n0l))
      allocate(i1nxl(n0l))
      allocate(i1rivnum(n0l))
      allocate(r1tmp(n0l))
      allocate(r1araorg(n0rec))
      allocate(r1aranew(n0rec))
      allocate(i1org2rnk(n0rec))
      allocate(i1rnk2org(n0rec))
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Initialize
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c out
      i1rivnum=0
c local
      i0cnt=0
      i0numdef=0
      i0numudf=0
      i0numudfpre=0
      i0numbsn=0
      i1org2rnk=0
      i1rnk2org=0
      r1araorg=0.0
      r1aranew=0.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Read
c - read l2x, l2y
c - read nxl
c - convert nxl into integer
c - read flwdir
c - convert flwdir into integer
c - find 9 in flwdir (i.e. number of basins in flwdir)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      call read_i1l2xy(n0l,c0l2x,c0l2y,i1l2x,i1l2y)
c
      call read_binary(n0l,c0nxl,r1tmp)
c
      do i0l=1,n0l
        i1nxl(i0l)=int(r1tmp(i0l))
      end do
c
      call read_binary(n0l,c0flwdir,r1tmp)
c
      do i0l=1,n0l
        i1flwdir(i0l)=int(r1tmp(i0l))
      end do
c
      i0tmp=0
      do i0l=1,n0l
        if(i1flwdir(i0l).eq.9)then
          i0tmp=i0tmp+1
        end if
      end do
      write(*,*) 'calc_rivnum: i1flwdirmax: ',i0tmp
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Initialize
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      i0numbsn=0
      i0numudf=0
      i1rivnum=0
c
      do i0l=1,n0l
        if(i1flwdir(i0l).eq.0) then
          i1rivnum(i0l)=0
        else if(i1flwdir(i0l).eq.9)then
          i0numbsn=i0numbsn+1
          i1rivnum(i0l)=i0numbsn
        else
          i1rivnum(i0l)=-1
          i0numudf=i0numudf+1
        end if
      end do
c
      write(*,*) 'calc_rivnum: i0numbsn: ',i0numbsn
      write(*,*) 'calc_rivnum: i0numudf: ',i0numudf
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Calc (2)
c - fill land cells with the basin id allocated for the river mouth cells
c - iterate until no undefined cells remain
c - calc catchment area of each basins
c - sort by catchment area
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      i0cnt=1
      i0numudfpre=i0numudf
 100  i0numudf=0
      i0numdef=0
      do i0l=1,n0l
        if(i1flwdir(i0l).ge.1.and.i1flwdir(i0l).le.8) then
          i0tmp=i1rivnum(i1nxl(i0l))
          if(i0tmp.ne.-1)then
            i1rivnum(i0l)=i0tmp
            i0numdef=i0numdef+1
          else
            i0numudf=i0numudf+1
          end if
        end if
      end do
      write(*,*) 'calc_rivnum: i0cnt,i0numudf:',i0cnt,i0numudf,i0numdef
      write(*,*) 'calc_rivnum: i1rivnum:',i1rivnum(i0ldbg)
c
      if (i0numudf.ne.0) then
        i0numudfpre=i0numudf
        i0cnt=i0cnt+1
        go to 100
      end if
c
      do i0l=1,n0l
        i0x=i1l2x(i0l)
        i0y=i1l2y(i0l)
        r0lonmin=rgetlon(n0x,p0lonmin,p0lonmax,i0x,s0west)
        r0lonmax=rgetlon(n0x,p0lonmin,p0lonmax,i0x,s0east)
        r0latmin=rgetlat(n0y,p0latmin,p0latmax,i0y,s0south)
        r0latmax=rgetlat(n0y,p0latmin,p0latmax,i0y,s0north)
        r0tmp=rgetara(r0lonmin,r0lonmax,r0latmin,r0latmax)
        if(i1rivnum(i0l).ge.1) then
          r1araorg(i1rivnum(i0l))=r1araorg(i1rivnum(i0l))+r0tmp
        end if
      end do
c
      call sort_decord(
     $     n0rec,
     $     r1araorg,
     $     r1aranew,i1org2rnk,i1rnk2org)
c
      do i0l=1,n0l
        if(i1rivnum(i0l).ne.0)then
          i1rivnum(i0l)=i1org2rnk(i1rivnum(i0l))
        end if
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Write out
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0l=1,n0l
        r1tmp(i0l)=real(i1rivnum(i0l))
      end do
c
      call wrte_binary(n0l,r1tmp,c0rivnum)
c
      end
