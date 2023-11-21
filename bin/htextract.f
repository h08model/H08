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
      program htextract
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   extract and copy binary
cby   2011/10/1, hanasaki: H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c
      real              p0mis
      parameter        (p0mis=1.0E20) 
c
      integer           n0l1          !! original array size (l)
      integer           n0x1          !! original array size (x)
      integer           n0y1          !! original array size (y)
      integer           n0l2          !! new array size (l)
      integer           n0x2          !! new array size (x)
      integer           n0y2          !! new array size (y)
      real              p0lonmin1     !! original array lon min
      real              p0lonmax1     !! original array lon max
      real              p0latmin1     !! original array lat min
      real              p0latmax1     !! original array lat max
      real              p0lonmin2     !! new array lon min
      real              p0lonmax2     !! new array lon max
      real              p0latmin2     !! new array lat min
      real              p0latmax2     !! new array lat max
c index (array)
      integer           i0x2
      integer           i0y2
c in (map)
      integer,allocatable::i1l2x1(:)  !! land --> x converter for original
      integer,allocatable::i1l2x2(:)  !! land --> x converter for original
      integer,allocatable::i1l2y1(:)  !! land --> x converter for original
      integer,allocatable::i1l2y2(:)  !! land --> x converter for original
      character*128     c0l2x1        !! land --> x converter for original
      character*128     c0l2x2        !! land --> x converter for new
      character*128     c0l2y1        !! land --> y converter for original
      character*128     c0l2y2        !! land --> y converter for new
c in (flux)
      real,allocatable::r1dat(:)
      real,allocatable::r2dat(:,:)
      character*128     c0ifname
c out
      real,allocatable::r1out(:)
      real,allocatable::r2out(:,:)
      character*128     c0ofname
c temporary
      character*128     c0tmp
      real              r0tmp
c controler
      integer   i0x1ulcorner
      integer   i0y1ulcorner
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(iargc().ne.22)then
        write(*,*) 'htextract n0l n0x n0y c0l2x c0l2y'
        write(*,*) '          p0lonmin p0lonmax p0latmin p0latmax'
        write(*,*) '          n0l n0x n0y c0l2x c0l2y'
        write(*,*) '          p0lonmin p0lonmax p0latmin p0latmax'
        write(*,*) '          c0ifname c0ofname'
        write(*,*) '          i0x1ulcorner i0y1ulcorner'
        stop
      end if
c
      call getarg(1,c0tmp)
      read(c0tmp,*) n0l1
      call getarg(2,c0tmp)
      read(c0tmp,*) n0x1
      call getarg(3,c0tmp)
      read(c0tmp,*) n0y1
      call getarg(4,c0l2x1)
      call getarg(5,c0l2y1)
      call getarg(6,c0tmp)
      read(c0tmp,*) p0lonmin1
      call getarg(7,c0tmp)
      read(c0tmp,*) p0lonmax1
      call getarg(8,c0tmp)
      read(c0tmp,*) p0latmin1
      call getarg(9,c0tmp)
      read(c0tmp,*) p0latmax1
c
      call getarg(10,c0tmp)
      read(c0tmp,*) n0l2
      call getarg(11,c0tmp)
      read(c0tmp,*) n0x2
      call getarg(12,c0tmp)
      read(c0tmp,*) n0y2
      call getarg(13,c0l2x2)
      call getarg(14,c0l2y2)
      call getarg(15,c0tmp)
      read(c0tmp,*) p0lonmin2
      call getarg(16,c0tmp)
      read(c0tmp,*) p0lonmax2
      call getarg(17,c0tmp)
      read(c0tmp,*) p0latmin2
      call getarg(18,c0tmp)
      read(c0tmp,*) p0latmax2
c
      call getarg(19,c0ifname)
      call getarg(20,c0ofname)
c
      call getarg(21,c0tmp)
      read(c0tmp,*) i0x1ulcorner
      call getarg(22,c0tmp)
      read(c0tmp,*) i0y1ulcorner
c
      allocate(i1l2x1(n0l1))
      allocate(i1l2x2(n0l2))
      allocate(i1l2y1(n0l1))
      allocate(i1l2y2(n0l2))
      allocate(r1dat(n0l1))
      allocate(r2dat(n0x1,n0y1))
      allocate(r1out(n0l2))
      allocate(r2out(n0x2,n0y2))
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Read l2x,l2y lookup table
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      call read_i1l2xy(n0l1,c0l2x1,c0l2y1,i1l2x1,i1l2y1)
      call read_i1l2xy(n0l2,c0l2x2,c0l2y2,i1l2x2,i1l2y2)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c read
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call read_binary(n0l1,c0ifname,r1dat)
      call conv_r1tor2(n0l1,n0x1,n0y1,i1l2x1,i1l2y1,r1dat,r2dat)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c calc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0y2=1,n0y2
        do i0x2=1,n0x2
          r2out(i0x2,i0y2)
     $         =r2dat((i0x2-1)+i0x1ulcorner,(i0y2-1)+i0y1ulcorner)
        end do
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c write
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call conv_r2tor1(n0l2,n0x2,n0y2,i1l2x2,i1l2y2,r2out,r1out)
      call wrte_binary(n0l2,r1out,c0ofname)
c
      end
