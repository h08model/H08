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
      program calc_crptyp
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   prepare maps for crop calendar calculation
cby   2010/03/31, hanasaki, NIES
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter (array)
      integer           n0l
      integer           n0crptyp
      parameter        (n0crptyp=19) 
c index (array)
      integer           i0l
      integer           i0crptyp
c temporary
      real,allocatable::r1tmp(:)
c in
      real,allocatable::r2hvsara(:,:)           !! harvested area (HA)
      character*128     c1hvsara(n0crptyp)
c out
      integer,allocatable::i1crptyp1st(:)       !! 1st crop type
      integer,allocatable::i1crptyp2nd(:)       !! 2nd crop type
      character*128     c0crptyp1st
      character*128     c0crptyp2nd
c local
      real              r1dat(n0crptyp)       !! temp array for input
      real              r1out(n0crptyp)       !! temp array for output
      integer           i1rnk2org(n0crptyp)   !! rank to original order LUT
      integer           i1org2rnk(n0crptyp)   !! original order to rank LUT
      integer,allocatable::i1flgwin1st(:)     !! flag of winter crop
      integer,allocatable::i1flgwin2nd(:)     !! flag of winter crop
      integer,allocatable::i1crptyp1stlar(:)  !! crop type of largest HA
      integer,allocatable::i1crptyp2ndlar(:)  !! crop type of second largest HA
c namelist
      character*128     c0setcal
      namelist /setcal/
     $     n0l,     
     $     c1hvsara,
     $     c0crptyp1st,c0crptyp2nd
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Get argument
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(iargc().ne.1)then
        write(*,*) 'calc_crpcal c0setcal'
        stop
      end if
c
      call getarg(1,c0setcal)
d     write(*,*) 'calc_crpcal: c0setcal:',c0setcal
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Read namelist
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      open(15,file=c0setcal)
      read(15,nml=setcal)
      close(15)
      write(6,nml=setcal)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Allocate
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      allocate(r1tmp(n0l))
      allocate(r2hvsara(n0l,n0crptyp))
      allocate(i1crptyp1st(n0l))
      allocate(i1crptyp2nd(n0l))
      allocate(i1flgwin1st(n0l))
      allocate(i1flgwin2nd(n0l))
      allocate(i1crptyp1stlar(n0l))
      allocate(i1crptyp2ndlar(n0l))
d     write(*,*) 'calc_crpcal: Array allocated'
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Initialize
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      r1dat=0.0
      r1out=0.0
      i1rnk2org=0
      i1org2rnk=0
      i1flgwin1st=0
      i1flgwin2nd=0
      i1crptyp1stlar=0
      i1crptyp2ndlar=0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Read file
c - read harvested area
c - planting day of year
c - harvesting day of year
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0crptyp=1,n0crptyp
        write(*,*) c1hvsara(i0crptyp)
        call read_binary(n0l,c1hvsara(i0crptyp),r1tmp)
        do i0l=1,n0l
          r2hvsara(i0l,i0crptyp)=r1tmp(i0l)
        end do
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Calculate
c - find the crop type with largest and second largest area
c - judge winter crop
c - judge winter crop
c - find 1st crop type (basically, crop type of largest harvest area is 
c   the 1st crop type.
c   But when 1st crop type is summer crop and 2nd crop type is winter crop,
c   2nd largest harvest area becomes the 1st crop type.)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0l=1,n0l
        do i0crptyp=1,n0crptyp
          r1dat(i0crptyp)=r2hvsara(i0l,i0crptyp)
        end do                  
        call sort_decord(
     $       n0crptyp,
     $       r1dat,
     $       r1out,i1org2rnk,i1rnk2org)
        if(r2hvsara(i0l,i1rnk2org(2)).gt.0.0)then
          i1crptyp1stlar(i0l)=i1rnk2org(1)
          i1crptyp2ndlar(i0l)=i1rnk2org(2)
        else
          i1crptyp1stlar(i0l)=0
          i1crptyp2ndlar(i0l)=0
        end if
      end do
c
      do i0l=1,n0l
        if(i1crptyp1stlar(i0l).eq.1.or.
     $     i1crptyp1stlar(i0l).eq.13.or.
     $     i1crptyp1stlar(i0l).eq.19)then
          i1flgwin1st(i0l)=1
        end if
      end do
c
      do i0l=1,n0l
        if(i1crptyp2ndlar(i0l).eq.1.or.
     $     i1crptyp2ndlar(i0l).eq.13.or.
     $     i1crptyp2ndlar(i0l).eq.19)then
          i1flgwin2nd(i0l)=1
        end if
      end do
c
      do i0l=1,n0l
        if(i1flgwin1st(i0l).eq.0.and.i1flgwin2nd(i0l).eq.1)then
          i1crptyp1st(i0l)=i1crptyp2ndlar(i0l)
          i1crptyp2nd(i0l)=i1crptyp1stlar(i0l)
        else
          i1crptyp1st(i0l)=i1crptyp1stlar(i0l)
          i1crptyp2nd(i0l)=i1crptyp2ndlar(i0l)
        end if
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Write
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0l=1,n0l
        r1tmp(i0l)=real(i1crptyp1st(i0l))
      end do
      call wrte_binary(n0l,r1tmp,c0crptyp1st)
c
      do i0l=1,n0l
        r1tmp(i0l)=real(i1crptyp2nd(i0l))
      end do
      call wrte_binary(n0l,r1tmp,c0crptyp2nd)
c
      end
