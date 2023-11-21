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
      program calc_rivseq
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cto   calculate river sequence (from upper-stream to lower stream)
cby   2010/09/30, hanasaki, NIES: H08ver1.0
c     Copyright (C) 2010,2011 Naota Hanasaki
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      implicit none
c parameter (array)
      integer              n0l
      integer              n0x
      integer              n0y
c parameter (default)
      integer              n0if
      integer              n0of
      parameter           (n0if=15)
      parameter           (n0of=16)
c index (array)
      integer              i0x               !! for loop
      integer              i0y               !! for loop
c temporary

      real,allocatable::   r1tmp(:)          !! temporary array
      character*128        c0tmp
c function
      integer              iargc             !! a built-in function
      integer              igetnxx           !! function to get next x
      integer              igetnxy           !! function to get next y
c in
      real,allocatable::   r2flwdir(:,:)     !! flow direction
      integer,allocatable::i1l2x(:)          !! land to x
      integer,allocatable::i1l2y(:)          !! land to y
      character*128        c0flwdir          !! flow direction file
      character*128        c0l2x             !! land to x file
      character*128        c0l2y             !! land to y file
c out
      real,allocatable::   r2rivseq(:,:)     !! river sequence
      character*128        c0rivseq          !! river sequence file
c local
      integer              i0cnt             !! counter
      integer              i0nxx             !! i0x of lower stream
      integer              i0nxy             !! i0y of lower stream
      integer              i0rivseq          !! river sequence
      integer,allocatable::i2origin(:,:)     !! grids have upper-stream or not
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Get arguments
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(iargc().ne.7)then
        write(*,*) 'Usage: calc_rivseq n0l n0x n0y c0l2x c0l2y'
        write(*,*) '                   c0flwdir c0rivseq'
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
      call getarg(6,c0flwdir)
      call getarg(7,c0rivseq)
d     write(*,*) 'calc_rivseq: n0l      ',n0l
d     write(*,*) 'calc_rivseq: n0x      ',n0x
d     write(*,*) 'calc_rivseq: n0y      ',n0y
d     write(*,*) 'calc_rivseq: n0l2x    ',c0l2x
d     write(*,*) 'calc_rivseq: n0l2y    ',c0l2y
d     write(*,*) 'calc_rivseq: n0flwdir ',c0flwdir
d     write(*,*) 'calc_rivseq: n0rivseq ',c0rivseq      
c

      allocate(r2flwdir(n0x,n0y))
      allocate(r2rivseq(n0x,n0y))
      allocate(r1tmp(n0l))
      allocate(i1l2x(n0l))
      allocate(i1l2y(n0l))
      allocate(i2origin(n0x,n0y))
d     write(*,*) 'calc_rivseq: allocated'
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Initialize
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c out
      r2rivseq=0.0
c local
      i0cnt=0
      i0nxx=0
      i0nxy=0
      i0rivseq=0
      i2origin=0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Read flow direction data
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      call read_i1l2xy(n0l,c0l2x,c0l2y,i1l2x,i1l2y)
      call read_binary(n0l,c0flwdir,r1tmp)
      call conv_r1tor2(n0l,n0x,n0y,i1l2x,i1l2y,r1tmp,r2flwdir)
c
d     write(*,*) 'calc_rivseq: i1l2x ',i1l2x(1),i1l2x(n0l)
d     write(*,*) 'calc_rivseq: i1l2y ',i1l2y(1),i1l2y(n0l)
d     write(*,*) 'calc_rivseq: r1tmp ',r1tmp(1),r1tmp(n0l)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Find the origins of basins
c - initialize (set every grids as origins)
c - remove grids lower than any grids
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      i2origin=1
c
      do i0y=1,n0y
        do i0x=1,n0x
          if((int(r2flwdir(i0x,i0y)).ge.1).and.
     $       (int(r2flwdir(i0x,i0y)).le.8))then
            i0nxx=igetnxx(n0x,i0x,int(r2flwdir(i0x,i0y)))
            i0nxy=igetnxy(n0y,i0y,int(r2flwdir(i0x,i0y)))
            i2origin(i0nxx,i0nxy)=0
          end if
        end do
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Put 0 to sea grids, 1 to grids with no upper-stream
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0y=1,n0y
        do i0x=1,n0x
          if(int(r2flwdir(i0x,i0y)).eq.0)then
            r2rivseq(i0x,i0y)=0.0
          else
            if(i2origin(i0x,i0y).eq.1)then
              r2rivseq(i0x,i0y)=1.0
            else
              r2rivseq(i0x,i0y)=0.0
            end if
          end if
        end do
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Put rivseq from 1 to .... 
c - start from i0rivseq=1
c - counter reset
c - loop start
c - find the grids where r2rivseq(i0x,i0y)=i0rivseq
c - get the x,y coordinate of the lower stream grids
c - the lower stream grids must have bigger r2rivseq(i0x,i0y) than the
c   present grid.
c - add i0rivseq
c - continue loop until counter becomes 0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      i0rivseq=1
c
 100  i0cnt=0
c
      do i0x=1,n0x
        do i0y=1,n0y
c
          if(int(r2rivseq(i0x,i0y)).eq.i0rivseq) then
c
            if((int(r2flwdir(i0x,i0y)).ge.1).and.
     $         (int(r2flwdir(i0x,i0y)).le.8)) then
              i0nxx=igetnxx(n0x,i0x,int(r2flwdir(i0x,i0y)))
              i0nxy=igetnxy(n0y,i0y,int(r2flwdir(i0x,i0y)))
c
              if(int(r2flwdir(i0nxx,i0nxy)).ne.0.and.
     $           int(r2rivseq(i0nxx,i0nxy)).le.
     $          (int(r2rivseq(i0x,i0y))+1))then
                r2rivseq(i0nxx,i0nxy)=r2rivseq(i0x,i0y)+1.0
                i0cnt=i0cnt+1
              end if
            end if
          end if
        end do
      end do
c
      i0rivseq=i0rivseq+1
c
      if (i0cnt.ne.0) go to 100
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Write rivseq
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      call conv_r2tor1(n0l,n0x,n0y,i1l2x,i1l2y,r2rivseq,r1tmp)
      call wrte_binary(n0l,r1tmp,c0rivseq)
c
      end
