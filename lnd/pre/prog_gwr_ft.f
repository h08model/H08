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
      program prog_gwr_ft
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
c
c
c
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c
      integer           n0l
      real              p0mis
      parameter        (p0mis=1.0E20) 
c index
      integer           i0l
c temporary
      character*128     c0tmp
c in
      real,allocatable::r1soityp(:)     !! soil type by Sujan Koirala
      character*128     c0soityp        
c out
      real,allocatable::r1ft(:)         !! 
      real,allocatable::r1rgmax(:)      !! 
      character*128     c0ft
      character*128     c0rgmax
c local
      integer,allocatable::i1id(:)
c bug      integer           i1s2d(13)
c bug      data              i1s2d/1,1,2,2,2,2,2,3,2,3,3,3,4/
      integer           i1s2d(0:13)
      data              i1s2d/0,1,1,2,2,2,2,2,3,2,3,3,3,4/
c bug      real              r1optft(4)
c bug      data              r1optft/1.0,0.95,0.7,0.0/
c bug      real              r1optrgmax(4)
c bug      data              r1optrgmax/5.0,3.0,1.5,0.0/
      real              r1optft(0:4)
      data              r1optft/0.0,1.0,0.95,0.7,0.0/
      real              r1optrgmax(0:4)
      data              r1optrgmax/0.0,5.0,3.0,1.5,0.0/ 
      integer           i0ldbg
c bug data              i0ldbg/79112/
      data              i0ldbg/1/ 
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c get argument
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if (iargc().ne.4) then
        write(6,*) 'Usage: prog_gwr_ft n0l c0soityp c0ft c0rgmax'
        stop
      end if
c
      call getarg(1,c0tmp)
      read(c0tmp,*) n0l
      call getarg(2,c0soityp)
      call getarg(3,c0ft)
      call getarg(4,c0rgmax)
c
      allocate(r1soityp(n0l))
      allocate(i1id(n0l))
      allocate(r1ft(n0l))
      allocate(r1rgmax(n0l))
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c read
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call read_binary(n0l,c0soityp,r1soityp)
c
      write(*,*) '[prog_gwr_ft] r1soityp(i0l):',r1soityp(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c convert
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0l=1,n0l
c bug   i1id(i0l)=real(i1s2d(int(r1soityp(i0l))))
        i1id(i0l)=i1s2d(int(r1soityp(i0l)))
        r1ft(i0l)=r1optft(i1id(i0l))
        r1rgmax(i0l)=r1optrgmax(i1id(i0l))/86400.0
      end do
c
      write(*,*) '[prog_gwr_ft] i1id(i0l):    ',i1id(i0ldbg)
      write(*,*) '[prog_gwr_ft] r1ft(i0l):    ',r1ft(i0ldbg)
      write(*,*) '[prog_gwr_ft] r1rgmax(i0l): ',r1rgmax(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c write
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call wrte_binary(n0l,r1ft,c0ft)
      call wrte_binary(n0l,r1rgmax,c0rgmax)
c
      end
