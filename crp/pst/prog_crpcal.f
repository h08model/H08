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
      program calc_crpcal
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   prepare maps for crop calendar calculation
cby   2010/09/30, hanasaki, NIES, H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter
      integer              n0l
      integer              n0crptyp
      parameter           (n0crptyp=19)
c index (array)
      integer              i0l
      integer              i0crptyp
c temporary
      real,allocatable::   r1tmp(:)
c in (set)
      integer              i0margin             !! days of fallow
      integer              i0ldbg
      data                 i0ldbg/57261/
c      data                 i0ldbg/13105/ 
c in (map)
      integer,allocatable::i1crptyp1st(:)       !! 1st crop type
      integer,allocatable::i1crptyp2nd(:)       !! 2nd crop type
      character*128        c0crptyp1st
      character*128        c0crptyp2nd
c in (flux)
      real,allocatable::   r2plt(:,:)           !! planting day of year
      real,allocatable::   r2hvs(:,:)           !! harvesting day of year
      real,allocatable::   r2crp(:,:)           !! cropping days
      real,allocatable::   r2yld(:,:)           !! yield
      real,allocatable::   r2reg(:,:)           !! regulating factor
      character*128        c1plt(n0crptyp)
      character*128        c1hvs(n0crptyp)
      character*128        c1crp(n0crptyp)
      character*128        c1yld(n0crptyp)
      character*128        c1reg(n0crptyp)
c out
      real,allocatable::   r1doyocuini(:)       !! occupied period start
      real,allocatable::   r1doyocuend(:)       !! occupied period end
      real,allocatable::   r1plt1st(:)          !! planting date of 1st crop
      real,allocatable::   r1hvs1st(:)          !! harvesting date of 1st crop
      real,allocatable::   r1crp1st(:)          !! cropping days of 1st crop
      real,allocatable::   r1yld1st(:)          !! yield of 1st crop
      real,allocatable::   r1reg1st(:)          !! regulating fact of 1st crop
      character*128        c0doyocuini
      character*128        c0doyocuend
      character*128        c0plt1st
      character*128        c0hvs1st
      character*128        c0crp1st
      character*128        c0yld1st
      character*128        c0reg1st
c namelist
      character*128        c0setcal
      namelist /setcal/
     $     n0l,
     $     i0margin,   c0crptyp1st,c0crptyp2nd,
     $     c1plt,      c1hvs,      c1crp,      c1yld,      c1reg,      
     $     c0plt1st,   c0hvs1st,   c0crp1st,   c0yld1st,   c0reg1st,   
     $     c0doyocuini,c0doyocuend
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
c Allocate
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      open(15,file=c0setcal)
      read(15,nml=setcal)
      close(15)
      write(6,nml=setcal)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Allocate
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      allocate(r1tmp(n0l))
      allocate(i1crptyp1st(n0l))
      allocate(i1crptyp2nd(n0l))
      allocate(r2plt(n0l,n0crptyp))
      allocate(r2hvs(n0l,n0crptyp))
      allocate(r2crp(n0l,n0crptyp))
      allocate(r2yld(n0l,n0crptyp))
      allocate(r2reg(n0l,n0crptyp))
      allocate(r1doyocuini(n0l))
      allocate(r1doyocuend(n0l))
      allocate(r1plt1st(n0l))
      allocate(r1hvs1st(n0l))
      allocate(r1crp1st(n0l))
      allocate(r1yld1st(n0l))
      allocate(r1reg1st(n0l))
d     write(*,*) 'calc_crpcal: Array allocated'
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Read file
c - crop type of 1st crop
c - crop type of 2nd crop
c - planting day of year of all crops
c - harvesting day of year of all crops
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call read_binary(n0l,c0crptyp1st,r1tmp)
      do i0l=1,n0l
        i1crptyp1st(i0l)=int(r1tmp(i0l))
      end do
c
      call read_binary(n0l,c0crptyp2nd,r1tmp)
      do i0l=1,n0l
        i1crptyp2nd(i0l)=int(r1tmp(i0l))
      end do
c      
      do i0crptyp=1,n0crptyp
        write(*,*) c1plt(i0crptyp)
        call read_binary(n0l,c1plt(i0crptyp),r1tmp)
        do i0l=1,n0l
          r2plt(i0l,i0crptyp)=r1tmp(i0l)
        end do
      end do      
c
      do i0crptyp=1,n0crptyp
        write(*,*) c1hvs(i0crptyp)
        call read_binary(n0l,c1hvs(i0crptyp),r1tmp)
        do i0l=1,n0l
          r2hvs(i0l,i0crptyp)=r1tmp(i0l)
        end do
      end do      
c
      do i0crptyp=1,n0crptyp
        write(*,*) c1crp(i0crptyp)
        call read_binary(n0l,c1crp(i0crptyp),r1tmp)
        do i0l=1,n0l
          r2crp(i0l,i0crptyp)=r1tmp(i0l)
        end do
      end do      
c
      do i0crptyp=1,n0crptyp
        write(*,*) c1yld(i0crptyp)
        call read_binary(n0l,c1yld(i0crptyp),r1tmp)
        do i0l=1,n0l
          r2yld(i0l,i0crptyp)=r1tmp(i0l)
        end do
      end do      
c
c      do i0crptyp=1,n0crptyp
c        write(*,*) c1reg(i0crptyp)
c        call read_binary(n0l,c1reg(i0crptyp),r1tmp)
c        do i0l=1,n0l
c          r2reg(i0l,i0crptyp)=r1tmp(i0l)
c        end do
c      end do      
d     write(*,*) 'calc_crpcal: i1crptyp1st:',i1crptyp1st(i0ldbg)
d     write(*,*) 'calc_crpcal: i1crptyp2nd:',i1crptyp2nd(i0ldbg)
d     write(*,*) 'calc_crpcal: r2plt:   ',r2plt(i0ldbg,1)
d     write(*,*) 'calc_crpcal: r2hvs:   ',r2hvs(i0ldbg,1)
d     write(*,*) 'calc_crpcal: r2crp:   ',r2crp(i0ldbg,1)
d     write(*,*) 'calc_crpcal: r2reg:   ',r2reg(i0ldbg,1)
d     write(*,*) 'calc_crpcal: r2yld:   ',r2yld(i0ldbg,1)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Calculate
c - planting date of year of 1st crop
c - harvesting date of year of 1st crop
c - cropping dayes of 1st crop
c - regulating factor of 1st crop
c - yield of 1st crop
c - starting date of occupation (to calculate 2nd crop calendar)
c - ending date of occupation (to calculate 2nd crop calendar)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0l=1,n0l
        if(i1crptyp1st(i0l).ne.0)then
          r1plt1st(i0l)=r2plt(i0l,i1crptyp1st(i0l))
        else
          r1plt1st(i0l)=0.0
        end if
      end do
c
      do i0l=1,n0l
        if(i1crptyp1st(i0l).ne.0)then
          r1hvs1st(i0l)=r2hvs(i0l,i1crptyp1st(i0l))
        else
          r1hvs1st(i0l)=0.0
        end if
      end do
c
      do i0l=1,n0l
        if(i1crptyp1st(i0l).ne.0)then
          r1crp1st(i0l)=r2crp(i0l,i1crptyp1st(i0l))
        else
          r1crp1st(i0l)=0.0
        end if
      end do
c
      do i0l=1,n0l
        if(i1crptyp1st(i0l).ne.0)then
          r1reg1st(i0l)=r2reg(i0l,i1crptyp1st(i0l))
        else
          r1reg1st(i0l)=0.0
        end if
      end do
c
      do i0l=1,n0l
        if(i1crptyp1st(i0l).ne.0)then
          r1yld1st(i0l)=r2yld(i0l,i1crptyp1st(i0l))
        else
          r1yld1st(i0l)=0.0
        end if
      end do
c
      do i0l=1,n0l
        if(i1crptyp1st(i0l).ne.0)then
          if(r2plt(i0l,i1crptyp1st(i0l)).ne.0.0)then
            r1doyocuini(i0l)=r2plt(i0l,i1crptyp1st(i0l))-real(i0margin)
            if(r1doyocuini(i0l).lt.1.0)then
              r1doyocuini(i0l)=r1doyocuini(i0l)+365.0
            end if
          else
            r1doyocuini(i0l)=1.0
          end if
        else
          r1doyocuini(i0l)=0.0
        end if
      end do
c
      do i0l=1,n0l
        if(i1crptyp1st(i0l).ne.0)then
          if(r2hvs(i0l,i1crptyp1st(i0l)).ne.0.0)then
            r1doyocuend(i0l)=r2hvs(i0l,i1crptyp1st(i0l))+real(i0margin)
            if(r1doyocuend(i0l).gt.365.0)then
              r1doyocuend(i0l)=r1doyocuend(i0l)-365.0
            end if
          else
            r1doyocuend(i0l)=365.0
          end if
        else
          r1doyocuend(i0l)=0.0
        end if
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Write
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call wrte_binary(n0l,r1doyocuini,c0doyocuini)
      call wrte_binary(n0l,r1doyocuend,c0doyocuend)
      call wrte_binary(n0l,r1plt1st,c0plt1st)
      call wrte_binary(n0l,r1hvs1st,c0hvs1st)
      call wrte_binary(n0l,r1crp1st,c0crp1st)
      call wrte_binary(n0l,r1reg1st,c0reg1st)
      call wrte_binary(n0l,r1yld1st,c0yld1st)
c
      end
