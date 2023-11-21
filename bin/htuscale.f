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
      program htuscale
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   upscale grid data
cby   2014/04/02, hanasaki
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter
      integer           n0x2     !! x of output
      integer           n0y2     !! y of output
      integer           n0xfct   !! in/out ratio for x
      integer           n0yfct   !! in/out ratio for y
c parameter (dummy)
      integer           n0l1
      integer           n0x1
      integer           n0y1
      integer           n0l2
c temporary
      character*128     c0tmp
      character*128     c0opt
c in
      integer,allocatable::i1l2x1(:) !! l2x for in
      integer,allocatable::i1l2y1(:) !! l2y for in
      integer,allocatable::i1l2x2(:) !! l2x for out
      integer,allocatable::i1l2y2(:) !! l2y for out
      character*128     c0l2x1
      character*128     c0l2y1
      character*128     c0l2x2
      character*128     c0l2y2
      real,allocatable::r1dat(:)
      real,allocatable::r2dat(:,:)
      character*128     c0dat
c out
      real,allocatable::r1out(:)
      real,allocatable::r2out(:,:)
      character*128     c0out
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c getarg
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(iargc().ne.11)then
        write(*,*) 'htuscale xfct yfct x2 y2'
        write(*,*) '         c0l2x1 c0l2y1 c0l2x2 c0l2y2'
        write(*,*) '         c0dat  c0out  c0opt'
        write(*,*) 'option:  [sum,avg,frq,max,min]'
        stop
      end if
c
      call getarg(1,c0tmp)
      read(c0tmp,*) n0xfct
      call getarg(2,c0tmp)
      read(c0tmp,*) n0yfct
      call getarg(3,c0tmp)
      read(c0tmp,*) n0x2
      call getarg(4,c0tmp)
      read(c0tmp,*) n0y2
      call getarg(5,c0l2x1)
      call getarg(6,c0l2y1)
      call getarg(7,c0l2x2)
      call getarg(8,c0l2y2)
      call getarg(9,c0dat)
      call getarg(10,c0out)
      call getarg(11,c0opt)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c allocate
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      n0l1=n0xfct*n0x2*n0yfct*n0y2
      n0x1=n0xfct*n0x2
      n0y1=n0yfct*n0y2
      n0l2=n0x2*n0y2
c
      allocate( r1dat(n0x1*n0y1))
      allocate( r2dat(n0x1,n0y1))
      allocate( r1out(n0x2*n0y2))
      allocate( r2out(n0x2,n0y2))
      allocate( i1l2x1(n0l1))
      allocate( i1l2y1(n0l1))
      allocate( i1l2x2(n0l2))
      allocate( i1l2y2(n0l2))
c
      call read_i1l2xy(n0l1,c0l2x1,c0l2y1,i1l2x1,i1l2y1)
      call read_i1l2xy(n0l2,c0l2x2,c0l2y2,i1l2x2,i1l2y2)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c calc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call read_binary(n0l1,c0dat,r1dat)
      call conv_r1tor2(n0l1,n0x1,n0y1,i1l2x1,i1l2y1,r1dat,r2dat)
c
      call calc_uscale(n0x2,n0y2,n0xfct,n0yfct,r2dat,r2out,c0opt)
c
      call conv_r2tor1(n0l2,n0x2,n0y2,i1l2x2,i1l2y2,r2out,r1out)
      call wrte_binary(n0l2,r1out,c0out)
c
      end
