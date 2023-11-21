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
      program calc_envout
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   calclulate environmental flow
cby   2010/09/30, hanasaki, NIES: H08ver1.0
c
c     Model and Concept by Dr. Naoki Shirakawa
c
c     "Global Estimation of Environmental Flow Requirement 
c     Based on River Runoff Seasonality"
c     Annual J of Hydraulics, Vol 49, pp 391-396, 2005
c     (in Japanese, Published by Japan Society of Civil Engineering)
c
c     algorithm changed on 22nd Aug 2007
c     before: calculated from monthly runoff [before routing]
c     after : calculated from monthly streamflow [after routing] 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter (array)
      integer           n0l
c parameter (physical)
      integer           n0secday
      parameter        (n0secday=86400) 
c parameter (default)
      real              p0mis
      real              p0inimin
      real              p0inimax
      parameter        (p0mis=1.0E20) 
      parameter        (p0inimin=9.9E20) 
      parameter        (p0inimax=-9.9E20) 
c index (array)
      integer           i0l
c index (time)
      integer           i0year
      integer           i0mon
c temporary
      real,allocatable::r1tmp(:)
      character*128     c0tmp
      character*128     c0ifname
      character*128     c0ofname
c function
      integer           iargc
      integer           igetday
      character*128     cgetfnt
c input (set)
      integer           i0ldbg
c input (map)
      real,allocatable::r1rivara(:)
      character*128     c0rivara
c input (flux)
      real,allocatable::r2rivout(:,:)     !! discharge [kg/s]
      real,allocatable::r2rivrun(:,:)     !! runoff [kg/m2/mo]
      character*128     c0rivout
c out
      integer,allocatable::i1envtyp(:)    !! environmental flow type [-]
      real,allocatable::r2envout(:,:)     !! environmental flow [kg/s]
      real,allocatable::r2envflg(:,:)     !! perturbation flag [-]
      character*128     c0envtyp
      character*128     c0envout
      character*128     c0envflg
c local
      real,allocatable::r1rivrunmax(:)
      real,allocatable::r1rivrunmin(:)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Get argument
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(iargc().ne.8)then
        write(*,*) 'calc_envout n0l i0year   i0ldbg   c0rivara c0rivout'
        write(*,*) '            c0envtyp c0envout c0envflg'
        stop
      end if
c
      call getarg(1,c0tmp)
      read(c0tmp,*) n0l
      call getarg(2,c0tmp)
      read(c0tmp,*) i0year
      call getarg(3,c0tmp)
      read(c0tmp,*) i0ldbg
      call getarg(4,c0rivara)
      call getarg(5,c0rivout)
      call getarg(6,c0envtyp)
      call getarg(7,c0envout)
      call getarg(8,c0envflg)
c
      allocate(r1tmp(n0l))
      allocate(r1rivara(n0l))
      allocate(r2rivout(n0l,12))
      allocate(r2rivrun(n0l,12))
      allocate(i1envtyp(n0l))
      allocate(r2envout(n0l,12))
      allocate(r2envflg(n0l,12))
      allocate(r1rivrunmax(n0l))
      allocate(r1rivrunmin(n0l))
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Initialize
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      i1envtyp=0
      r2envout=0.0
      r2envflg=0.0
      r1rivrunmax=0.0
      r1rivrunmin=0.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Read input
c - read c0rivara
c - remove zero from array r1rivara
c - river flow, convert unit [kg/s] --> [kg/m2/mo]
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call read_binary(n0l,c0rivara,r1rivara)
c
      do i0l=1,n0l
        if(r1rivara(i0l).eq.0)then
          r1rivara(i0l)=p0mis
        end if
      end do
c
      do i0mon=1,12
        c0ifname=cgetfnt(c0rivout,i0year,i0mon,0,0)
        call read_binary(n0l,c0ifname,r1tmp)
        do i0l=1,n0l
          if(r1tmp(i0l).ne.p0mis.and.r1rivara(i0l).ne.p0mis)then
            r2rivout(i0l,i0mon)=r1tmp(i0l)
            r2rivrun(i0l,i0mon)=r1tmp(i0l)
     $           /r1rivara(i0l)
     $           *real(n0secday)*real(igetday(i0year,i0mon))
          end if
        end do
      end do
c debug
d     do i0mon=1,12
d       write(*,*) 'prog_envout: r2rivout: ',r2rivout(i0ldbg,i0mon)
d     end do
d     do i0mon=1,12
d       write(*,*) 'prog_envout: r2rivrun: ',r2rivrun(i0ldbg,i0mon)
d     end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Get maximum / Get minimum
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      r1rivrunmax=p0inimax
      r1rivrunmin=p0inimin
c
      do i0l=1,n0l
        do i0mon=1,12
          if(r2rivrun(i0l,i0mon).ne.p0mis)then
            if(r2rivrun(i0l,i0mon).gt.r1rivrunmax(i0l))then
              r1rivrunmax(i0l)=r2rivrun(i0l,i0mon)
            end if
            if(r2rivrun(i0l,i0mon).lt.r1rivrunmin(i0l))then
              r1rivrunmin(i0l)=r2rivrun(i0l,i0mon)
            end if
          else
            r1rivrunmax(i0l)=p0mis
            r1rivrunmin(i0l)=p0mis
          end if
        end do
      end do
c debug
d     write(*,*) 'prog_envout: r1rivrunmax: ',r1rivrunmax(i0ldbg)
d     write(*,*) 'prog_envout: r1rivrunmin: ',r1rivrunmin(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Envtyp
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0l=1,n0l
c C1
        if     (r1rivrunmax(i0l).lt.10.0 .and.
     $          r1rivrunmin(i0l).lt.1.0)then
          i1envtyp(i0l)=1
c C2
        else if(r1rivrunmax(i0l).ge.100.0.and.
     $          r1rivrunmin(i0l).ge.10.0)then
          i1envtyp(i0l)=2
c C3
        else if(r1rivrunmax(i0l).lt.100.0.and.
     $          r1rivrunmin(i0l).ge.1.0)then
          i1envtyp(i0l)=3
c C4
        else
          i1envtyp(i0l)=4
        end if
c
      end do
c debug
d     write(*,*) 'prog_envout: i1envtyp: ',i1envtyp(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Envout
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0mon=1,12
        do i0l=1,n0l
          if(i1envtyp(i0l).eq.1)then
            if(r2rivrun(i0l,i0mon).lt.1.0)then
              r2envout(i0l,i0mon)=0.0
            else
              r2envout(i0l,i0mon)=r2rivout(i0l,i0mon)*0.1
            end if
          else if(i1envtyp(i0l).eq.2)then
            r2envout(i0l,i0mon)=r2rivout(i0l,i0mon)*0.4
            r2envflg(i0l,i0mon)=1
          else if(i1envtyp(i0l).eq.3)then
            r2envout(i0l,i0mon)=r2rivout(i0l,i0mon)*0.1
          else
            if(r2rivrun(i0l,i0mon).lt.1.0)then
              r2envout(i0l,i0mon)=0
            else if(r2rivrun(i0l,i0mon).ge.10.0)then
              r2envout(i0l,i0mon)=r2rivout(i0l,i0mon)*0.4
              r2envflg(i0l,i0mon)=1
            else
              r2envout(i0l,i0mon)=r2rivout(i0l,i0mon)*0.1
            end if
          end if
        end do
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Write
c - envtyp
c - envout
c - envflg
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0l=1,n0l
        r1tmp(i0l)=real(i1envtyp(i0l))
      end do
      c0ofname=cgetfnt(c0envtyp,i0year,0,0,0)
      call wrte_binary(n0l,r1tmp,c0ofname)
c
      do i0mon=1,12
        do i0l=1,n0l
          r1tmp(i0l)=r2envout(i0l,i0mon)
        end do
        c0ofname=cgetfnt(c0envout,i0year,i0mon,0,0)
        call wrte_binary(n0l,r1tmp,c0ofname)
      end do
c
      do i0mon=1,12
        do i0l=1,n0l
          r1tmp(i0l)=r2envflg(i0l,i0mon)
        end do
        c0ofname=cgetfnt(c0envflg,i0year,i0mon,0,0)
        call wrte_binary(n0l,r1tmp,c0ofname)
      end do
c
      end
