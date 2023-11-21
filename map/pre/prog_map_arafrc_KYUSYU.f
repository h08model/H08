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
      program prog_map_arafrc_KYUSYU
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c
      integer           n0l
      character*128     c0temp
      real              p0mis
      integer           i0ldbg
c      parameter        (n0l=32400) 
      parameter        (p0mis=1.0E20) 
c      data              i0ldbg/31964/ 
c      data              i0ldbg/119/ 
c index
      integer           i0l
c in
      real,allocatable::r1lndara(:)     !! from calculation
      real,allocatable::r1padara(:)     !! from Kohyama 2003
      real,allocatable::r1fldara(:)     !! from Kohyama 2003
      real,allocatable::r1barara(:)     !! from Kohyama 2003
      real,allocatable::r1irgara(:)     !! from Siebert et al. 2005
      real              r0lndara
      real              r0padara
      real              r0fldara
      real              r0barara
      real              r0irgara
      character*128     c0lndara
      character*128     c0padara
      character*128     c0fldara
      character*128     c0barara
      character*128     c0irgara
c out
      character*128     c0irg2frcP
      real,allocatable::r1irg2frcP(:)
      character*128     c0irg_frcP
      real,allocatable::r1irg_frcP(:)
      character*128     c0irg_frcF
      real,allocatable::r1irg_frcF(:)
      character*128     c0rfd_frcF
      real,allocatable::r1rfd_frcF(:)
      character*128     c0non_frc_
      real,allocatable::r1non_frc_(:)
c local
      real              r0irg2araP
      real,allocatable::r1irg2araP(:)
      real              r0irg_araP
      real,allocatable::r1irg_araP(:)
      real              r0irg_araF
      real,allocatable::r1irg_araF(:)
      real              r0rfd_araF
      real,allocatable::r1rfd_araF(:)
      real              r0non_ara_
      real,allocatable::r1non_ara_(:)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(iargc().ne.12)then
        write(*,*) 'prog_crpfrc_KYUSYU '
        stop
      end if
c
      call getarg(1,c0lndara)
      call getarg(2,c0padara)
      call getarg(3,c0fldara)
      call getarg(4,c0barara)
      call getarg(5,c0irgara)
      call getarg(6,c0irg2frcP)
      call getarg(7,c0irg_frcP)
      call getarg(8,c0irg_frcF)
      call getarg(9,c0rfd_frcF)
      call getarg(10,c0non_frc_)
      call getarg(11,c0temp)
      read(c0temp,*)n0l
      call getarg(12,c0temp)
      read(c0temp,*)i0ldbg
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      allocate(r1lndara(n0l))
      allocate(r1padara(n0l))
      allocate(r1fldara(n0l))
      allocate(r1barara(n0l))
      allocate(r1irgara(n0l))
c
      allocate(r1irg2frcP(n0l))
      allocate(r1irg_frcP(n0l))
      allocate(r1irg_frcF(n0l))
      allocate(r1rfd_frcF(n0l))
      allocate(r1non_frc_(n0l))
c
      allocate(r1irg2araP(n0l))
      allocate(r1irg_araP(n0l))
      allocate(r1irg_araF(n0l))
      allocate(r1rfd_araF(n0l))
      allocate(r1non_ara_(n0l))
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c read
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call read_binary(n0l,c0lndara,r1lndara) 
      call read_binary(n0l,c0padara,r1padara)
      call read_binary(n0l,c0fldara,r1fldara)
      call read_binary(n0l,c0barara,r1barara)
      call read_binary(n0l,c0irgara,r1irgara)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c summary
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0l=1,n0l
        if(r1lndara(i0l).ne.p0mis)then
          r0lndara=r0lndara+r1lndara(i0l)
        end if
        if(r1padara(i0l).ne.p0mis)then
          r0padara=r0padara+r1padara(i0l)
        end if
        if(r1fldara(i0l).ne.p0mis)then
          r0fldara=r0fldara+r1fldara(i0l)
        end if
        if(r1barara(i0l).ne.p0mis)then
          r0barara=r0barara+r1barara(i0l)
        end if
        if(r1irgara(i0l).ne.p0mis)then
          r0irgara=r0irgara+r1irgara(i0l)
        end if
      end do
      write(*,*) r0lndara/1.0E6,'km2 lndara',r1lndara(i0ldbg)
      write(*,*) r0padara/1.0E6,'km2 padara',r1padara(i0ldbg)
      write(*,*) r0fldara/1.0E6,'km2 fldara',r1fldara(i0ldbg)
      write(*,*) r0barara/1.0E6,'km2 barara',r1barara(i0ldbg)
      write(*,*) r0irgara/1.0E6,'km2 irgara',r1irgara(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c fraction estimation
c
c priority lndara > padara,fldara > irgara > barara
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0l=1,n0l
        if(r1padara(i0l).ne.p0mis.and.r1barara(i0l).ne.p0mis)then
          if(r1padara(i0l).gt.r1barara(i0l))then
            r1irg2araP(i0l)=r1barara(i0l)
            r1irg_araP(i0l)=r1padara(i0l)-r1barara(i0l)
          else
            r1irg2araP(i0l)=r1padara(i0l)            
            r1irg_araP(i0l)=0.0
          end if
          if(r1fldara(i0l).ne.p0mis.and.r1irgara(i0l).ne.p0mis.and.
     $       r1padara(i0l).ne.p0mis.and.r1lndara(i0l).ne.p0mis)then
             if(r1irgara(i0l).gt.r1padara(i0l))then
               r1irg_araF(i0l)=r1irgara(i0l)-r1padara(i0l)
               if(r1irg_araF(i0l).gt.r1fldara(i0l))then
                 r1irg_araF(i0l)=r1fldara(i0l)
               end if
             else
               r1irg_araF(i0l)=0.0
             end if
             r1rfd_araF(i0l)=r1fldara(i0l)-r1irg_araF(i0l)
             r1non_ara_(i0l)=r1lndara(i0l)-r1padara(i0l)-r1fldara(i0l)
           end if
        end if
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c summary
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0l=1,n0l
        if(r1irg2araP(i0l).ne.p0mis)then
          r0irg2araP=r0irg2araP+r1irg2araP(i0l)
        end if
        if(r1irg_araP(i0l).ne.p0mis)then
          r0irg_araP=r0irg_araP+r1irg_araP(i0l)
        end if
        if(r1irg_araF(i0l).ne.p0mis)then
          r0irg_araF=r0irg_araF+r1irg_araF(i0l)
        end if
        if(r1rfd_araF(i0l).ne.p0mis)then
          r0rfd_araF=r0rfd_araF+r1rfd_araF(i0l)
        end if
        if(r1non_ara_(i0l).ne.p0mis)then
          r0non_ara_=r0non_ara_+r1non_ara_(i0l)
        end if
      end do
c
      write(*,*) r0irg2araP/1.0E6,'km2 irg2araP',r1irg2araP(i0ldbg)
      write(*,*) r0irg_araP/1.0E6,'km2 irg_araP',r1irg_araP(i0ldbg)
      write(*,*) r0irg_araF/1.0E6,'km2 irg_araF',r1irg_araF(i0ldbg)
      write(*,*) r0rfd_araF/1.0E6,'km2 rfd_araF',r1rfd_araF(i0ldbg)
      write(*,*) r0non_ara_/1.0E6,'km2 non_ara_',r1non_ara_(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0l=1,n0l
        if(r1irg2araP(i0l).ne.p0mis)then
          r1irg2frcP(i0l)=r1irg2araP(i0l)/r1lndara(i0l)
        end if
        if(r1irg_araP(i0l).ne.p0mis)then
          r1irg_frcP(i0l)=r1irg_araP(i0l)/r1lndara(i0l)
        end if
        if(r1irg_araF(i0l).ne.p0mis)then
          r1irg_frcF(i0l)=r1irg_araF(i0l)/r1lndara(i0l)
        end if
        if(r1rfd_araF(i0l).ne.p0mis)then
          r1rfd_frcF(i0l)=r1rfd_araF(i0l)/r1lndara(i0l)
        end if
        if(r1non_ara_(i0l).ne.p0mis)then
          r1non_frc_(i0l)=r1non_ara_(i0l)/r1lndara(i0l)
        end if
      end do
c
      call wrte_binary(n0l,r1irg2frcP,c0irg2frcP)
      call wrte_binary(n0l,r1irg_frcP,c0irg_frcP)
      call wrte_binary(n0l,r1irg_frcF,c0irg_frcF)
      call wrte_binary(n0l,r1rfd_frcF,c0rfd_frcF)
      call wrte_binary(n0l,r1non_frc_,c0non_frc_)
c
      end
          
        
