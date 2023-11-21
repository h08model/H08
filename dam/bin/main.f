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
      program main
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cto   simulate dam operation
cby   2011/03/31, hanasaki
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      implicit none
c parameter(default)
      integer           n0secday
      integer           n0yearmin
      integer           n0yearmax
      parameter        (n0secday=86400)
      parameter        (n0yearmin=1800) 
      parameter        (n0yearmax=2300) 
c index(time)
      integer           i0year       !! year
      integer           i0mon        !! month
      integer           i0day        !! day
      integer           i0daymin     !! day min
      integer           i0daymax     !! day max
      integer           i0secint     !! interval in second
c function
      integer           igetday
c temporary
      integer           i0tmp
c input(set)
      integer           i0yearmin    !! start year
      integer           i0yearmax    !! end year
      real              r0knorm      !! the coefficient of judgement
      real              r0factor     !! for sensitivity test
      character*128     c0optkrls
      character*128     c0optdamrls
      character*128     c0optdamwbc
c input(file: map)
      integer           i0damid_     !! dam id      
      integer           i0damprp     !! primary purpose of the dam
      integer           i01stmon     !! 1st month of hydrological year
      real              r0anudis     !! mean annual inflow
      real              r0damcap     !! dam storage capacity
      real              r0damsrf     !! dam surface area
c input(file: flux)
      real              r3damstoobs(0:n0yearmax-n0yearmin+1,0:12,0:31)
      real              r3daminfobs(0:n0yearmax-n0yearmin+1,0:12,0:31)
      real              r3damrlsobs(0:n0yearmax-n0yearmin+1,0:12,0:31)
      real              r3damdemcal(0:n0yearmax-n0yearmin+1,0:12,0:31)
      character*128     c0damstoobs  !! dam storage
      character*128     c0daminfobs  !! dam inflow 
      character*128     c0damrlsobs  !! dam outflow
      character*128     c0damdemcal  !! irrigation demand directory
c output
      real              r3damstocal(0:n0yearmax-n0yearmin+1,0:12,0:31)
      real              r3daminfcal(0:n0yearmax-n0yearmin+1,0:12,0:31)
      real              r3damrlscal(0:n0yearmax-n0yearmin+1,0:12,0:31)
      character*128     c0damstocal  !! dam storage
      character*128     c0daminfcal  !! dam inflow 
      character*128     c0damrlscal  !! dam outflow
c local
      integer           i0flgkrls    !! flag for krls
      real              r0krls       !! the coefficient of release
      real              r0damsto     !! dam storage
      real              r0daminf     !! dam inflow
      real              r0damrls     !! dam outflow
      real              r0damdem     !! dam water demand
      real              r0damdemfix  !! dam water demand (annual mean)
c
      character*128     c0setdam     !! initial file
      character*128     c0idx
      namelist           /setdam/
     $     i0yearmin,  i0yearmax,  i0damid_,
     $     r0knorm,    r0factor,
     $     c0optkrls,  c0optdamrls,c0optdamwbc,
     $     i0damprp,   i01stmon,   r0anudis,   r0damcap,   r0damsrf,
     $     c0damstocal,c0daminfcal,c0damrlscal,c0damdemcal,
     $     c0damstoobs,c0daminfobs,c0damrlsobs,r0damdemfix
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Get arguments
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(iargc().ne.1) then
        write(*,*) 'main c0setdam'
        stop
      end if
c
      call getarg(1,c0setdam)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Read namelist
c - read c0setdam
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      open(15,file=c0setdam)
      read(15,nml=setdam)
      close(15)
      write(*,*) 'main: --- Read namelist ---------------------------'
      write(*,nml=setdam)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Get idx
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      i0tmp=len_trim(c0daminfobs)
      c0idx=c0daminfobs(i0tmp-1:i0tmp)
c
      if(c0idx.ne.'MO'.and.c0idx.ne.'DY')then
        write(*,*) 'main: c0idx: ',c0idx,' not supported.'
        stop
      end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Read input
c - read observed dam storage
c - read observed dam inflow
c - read observed dam release
c - read calculated dam water demand
c  (because observed data was not available)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      call read_ascii4(c0damstoobs,r3damstoobs,i0tmp,i0tmp)
      call read_ascii4(c0daminfobs,r3daminfobs,i0tmp,i0tmp)
      call read_ascii4(c0damrlsobs,r3damrlsobs,i0tmp,i0tmp)
      if(c0optdamrls.eq.'H06')then
        call read_ascii4(c0damdemcal,r3damdemcal,i0tmp,i0tmp)
      end if
d     write(*,*) 'main: r0damstoobs: ',
d    & (r3damstoobs(1987-n0yearmin+1,i0mon,0),i0mon=1,12)
d     write(*,*) 'main: r0damstoobs: ',
d    & (r3daminfobs(1987-n0yearmin+1,i0mon,0),i0mon=1,12)
d     write(*,*) 'main: r0damstoobs: ',
d    & (r3damrlsobs(1987-n0yearmin+1,i0mon,0),i0mon=1,12)
d     write(*,*) 'main: r0damstoobs: ',
d    & (r3damdemcal(1987-n0yearmin+1,i0mon,0),i0mon=1,12)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Set Initial storage
c - Get initial storage from observation
c - Multiply annual discharge by factor for sensitivity test
c - For experiment 4, set storage at reservoir's capacity
c - When initial storage of observation is zero, set at capacity
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      r0damsto=r3damstoobs(i0yearmin-n0yearmin+1,1,0)
c
      r0anudis=r0anudis*r0factor
c
      if(c0optdamrls.eq.'M98')then
        r0damsto=r0damcap
      end if
c
      if(r0damsto.eq.0)then
        r0damsto=r0damcap
      end if
d     write(*,*) 'main: r0damsto: ', r0damsto
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Calculate release and storage
c - Convert array to variable 
c - Call reservoir operation model
c - Convert variable to array
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      i0flgkrls=1
      do i0year=i0yearmin,i0yearmax
        do i0mon=1,12
          if(c0idx.eq.'MO')then
            i0daymin=0
            i0daymax=0
            i0secint=igetday(i0year,i0mon)*n0secday
          else if(c0idx.eq.'DY')then
            i0daymin=1
            i0daymax=igetday(i0year,i0mon)
            i0secint=n0secday
          end if
          do i0day=i0daymin,i0daymax
c 
            r0daminf=r3daminfobs(i0year-n0yearmin+1,i0mon,i0day)
     $           *r0factor
            if(i0damprp.eq.4)then
c              r0damdem=r3damdemcal(i0year-n0yearmin+1,i0mon,i0day)
c     $             *r0factor
              r0damdem=r3damdemcal(0000,i0mon,i0day)
     $             *r0factor
            else
              r0damdem=r0anudis
            end if
d           write(*,*) 'main: r0damdem: ',r0damdem
c
            if(i0mon.eq.i01stmon.and.i0day.eq.i0daymin)then
              i0flgkrls=1
            end if
c
            call calc_resope(
     $           i0secint, i0damid_,
     $           i0flgkrls,r0knorm, 
     $           c0optkrls,c0optdamrls,c0optdamwbc,
     $           r0anudis, r0damcap,r0damsrf,
     $           r0daminf, r0damdem,r0damdemfix,
     $           r0damrls,
     $           r0krls,   r0damsto)
c     
d     write(*,*) 'main: r0damsto: ',
d    $         i0year,i0mon,r0damsto
d     write(*,*) 'main: r0daminf: ',
d    $         i0year,i0mon,r0daminf
d     write(*,*) 'main: r0damrls: ',
d    $         i0year,i0mon,r0damrls
c 
            r3damstocal(i0year-n0yearmin+1,i0mon,i0day)=r0damsto
            r3daminfcal(i0year-n0yearmin+1,i0mon,i0day)=r0daminf
            r3damrlscal(i0year-n0yearmin+1,i0mon,i0day)=r0damrls
          end do
        end do
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Write data
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      call wrte_ascii4(i0yearmin,i0yearmax,r3damstocal,c0damstocal)
      call wrte_ascii4(i0yearmin,i0yearmax,r3daminfcal,c0daminfcal)
      call wrte_ascii4(i0yearmin,i0yearmax,r3damrlscal,c0damrlscal)
c
      end















