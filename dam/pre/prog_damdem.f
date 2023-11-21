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
      program prog_damdem
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   allocate water demand for reservoirs
cby   2010/09/30, hanasaki, NIES: H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter (array)
      integer           n0l
c index (array)
      integer           i0l
c index (time)
      integer           i0year
      integer           i0mon
c function
      character*128     cgetfnt
c temporary
      real,allocatable::r1tmp(:)
      character*128     c0tmp
      character*128     c0ifname
      character*128     c0ofname
c in (set)
      integer           i0ldbg
      integer           i0yearmin
      integer           i0yearmax
c in (flux)
      integer,allocatable::i1damid_(:)
      real,allocatable::r1demagr(:)
      real,allocatable::r1demind(:)
      real,allocatable::r1demdom(:)
      real,allocatable::r1demtot(:)
      character*128     c0damid_
      character*128     c0demagr
      character*128     c0demind
      character*128     c0demdom
      character*128     c0damalc
c out
      real,allocatable::r1damdem(:)
      character*128     c0damdem
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(iargc().ne.10)then
        write(*,*) 'prog_damdem n0l i0ldbg i0yearmin i0yearmax'
        write(*,*) '            c0damid_ c0demagr c0demind c0demdom'
        write(*,*) '            c0damalc c0damdem'
        stop
      end if
c
      call getarg(1,c0tmp)
      read(c0tmp,*) n0l
      call getarg(2,c0tmp)
      read(c0tmp,*) i0ldbg
      call getarg(3,c0tmp)
      read(c0tmp,*) i0yearmin
      call getarg(4,c0tmp)
      read(c0tmp,*) i0yearmax
      call getarg(5,c0damid_)
      call getarg(6,c0demagr)
      call getarg(7,c0demind)
      call getarg(8,c0demdom)
      call getarg(9,c0damalc)
      call getarg(10,c0damdem)
c
      allocate(i1damid_(n0l))
      allocate(r1demagr(n0l))
      allocate(r1demind(n0l))
      allocate(r1demdom(n0l))
      allocate(r1demtot(n0l))
      allocate(r1damdem(n0l))
      allocate(r1tmp(n0l))
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c read map
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call read_binary(n0l,c0damid_,r1tmp)
      do i0l=1,n0l
        i1damid_(i0l)=int(r1tmp(i0l))
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c read input, calculate, and write
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0year=i0yearmin,i0yearmax
        do i0mon=1,12
c
          c0ifname=cgetfnt(c0demagr,i0year,i0mon,0,0)
          call read_binary(n0l,c0ifname,r1demagr)
          c0ifname=cgetfnt(c0demind,i0year,i0mon,0,0)
          call read_binary(n0l,c0ifname,r1demind)
          c0ifname=cgetfnt(c0demdom,i0year,i0mon,0,0)
          call read_binary(n0l,c0ifname,r1demdom)
d         write(*,'(a32,i4,3f10.1)') ' prog_damdem: r1demagr,ind,dom: ',
d    $         i0mon,r1demagr(i0ldbg),r1demind(i0ldbg),r1demdom(i0ldbg)
c
          r1demtot=0.0
          do i0l=1,n0l
            r1demtot(i0l)=r1demagr(i0l)+r1demind(i0l)+r1demdom(i0l)
          end do
d         write(*,*) 'prog_damdem: r1demtot: ',i0mon,r1demtot(i0ldbg)
c
          r1damdem=0.0
          call calc_damdem(
     $         n0l,
     $         i1damid_, r1demtot, c0damalc,
     $         r1damdem)
c
          c0ofname=cgetfnt(c0damdem,i0year,i0mon,0,0)
          call wrte_binary(n0l,r1damdem,c0ofname)
d         write(*,*) 'prog_damdem: r1damdem: ',i0mon,r1damdem(i0ldbg)
        end do
      end do
c
      end
