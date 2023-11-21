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
      program prog_vwcnew
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   calculate virtual water content
cby   2011/04/20, hanasaki, NIES: H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter (array)
      integer           n0l
      integer           n0m
      integer           n0typ           !! crop type
      integer           n0nat           !! national id
      integer           n0recdat        !! # of record in data file
      integer           n0reccod        !! # of record in code file
      parameter        (n0m=4) 
      parameter        (n0typ=20)
      parameter        (n0nat=1015)
      parameter        (n0recdat=1000)
      parameter        (n0reccod=1000)
c parameter
      integer           n0secday
      real              p0mis
      parameter        (n0secday=86400) 
      parameter        (p0mis=1.0E20) 
c index
      integer           i0l
      integer           i0m
      integer           i0typ
      integer           i0nat
c temporary
      integer           i0tmp
      real              r0tmp
      real,allocatable::r1tmp(:)
      real              r1tmpnat(n0nat)
      character*128     c0tmp
c in
      character*128     c0opt           !! option
      character*128     c1lnduse(n0m)
c in (map)
      real,allocatable::r1crptyp1st(:)
      real,allocatable::r1crptyp2nd(:)
      real,allocatable::r1irgara2nd(:)
      real,allocatable::r1nonara1st(:)
      real,allocatable::r1nonara2nd(:)
      real,allocatable::r1pasara(:)
      real,allocatable::r1nation(:)
      real,allocatable::r1lndara(:)
      real,allocatable::r2arafrc(:,:)
      character*128     c0crptyp1st     !!
      character*128     c0crptyp2nd     !!
      character*128     c0irgara2nd     !!
      character*128     c0nonara1st     !!
      character*128     c0nonara2nd     !!
      character*128     c0pasara        !! grazing area
      character*128     c0nation        !! national id
      character*128     c0lndara        !! national id
      character*128     c1arafrc(0:n0m) !! national id
c in (list)
      character*128     c0natlst        !!
c in (evaporation)
      real,allocatable::r2cwslndmos1stgrn(:,:)
      real,allocatable::r2cwslndmos1striv(:,:)
      real,allocatable::r2cwslndmos1stmsr(:,:)
      real,allocatable::r2cwslndmos1stnnb(:,:)
      real,allocatable::r2cwslndmos2ndgrn(:,:)
      real,allocatable::r2cwslndmos2ndriv(:,:)
      real,allocatable::r2cwslndmos2ndmsr(:,:)
      real,allocatable::r2cwslndmos2ndnnb(:,:)
      character*128     c1cwslndmos1stgrn(0:n0m)
      character*128     c1cwslndmos1striv(0:n0m)
      character*128     c1cwslndmos1stmsr(0:n0m)
      character*128     c1cwslndmos1stnnb(0:n0m)
      character*128     c1cwslndmos2ndgrn(0:n0m)
      character*128     c1cwslndmos2ndriv(0:n0m)
      character*128     c1cwslndmos2ndmsr(0:n0m)
      character*128     c1cwslndmos2ndnnb(0:n0m)
c in (cropping)
      real              r2yld(n0nat,n0typ)
      real              r0yld
      real              r2prd(n0nat,n0typ)
      real              r0prd
      real              r1yldpas_nat(n0nat)
      character*128     c1yld(n0typ)
      character*128     c1prd(n0typ)
      character*128     c0yldpas_nat
      character*128     c0yldfao
c in (grazing)
      real              r1stkgoa_nat(n0nat)  !! number of goats
      real              r1stkshe_nat(n0nat)  !! number of sheep
      real              r1stkcat_nat(n0nat)  !! number of cattle
      character*128     c0stkgoa_nat  !! number of goats
      character*128     c0stkshe_nat  !! number of sheep
      character*128     c0stkcat_nat  !! number of cattle
c out (evaporation)
      real              r2vwcgrn(n0nat,n0typ) !! water footprint green
      real              r2vwcriv(n0nat,n0typ) !! water footprint river
      real              r2vwcmsr(n0nat,n0typ) !! water footprint MSR
      real              r2vwcnnb(n0nat,n0typ) !! water footprint NNBW
      real              r2vwcblu(n0nat,n0typ) !! water footprint blue
      real              r2vwctot(n0nat,n0typ) !! water footprint total
      character*128     c0vwcgrn
      character*128     c0vwcriv
      character*128     c0vwcmsr
      character*128     c0vwcnnb
      character*128     c0vwcblu
      character*128     c0vwctot
c out (checker)
      real              r2vwcchk(n0nat,n0typ)
      character*128     c0vwcchk
c out (grazing)
      real              r1frcpas_nat(n0nat)   !! fraction of grazing land
      character*128     c0frcpas_nat
c out (evaporation)
      real              r2cwsnattypgrn(n0nat,0:n0typ) !! green water evap.
      real              r2cwsnattypriv(n0nat,0:n0typ) !! river water evap.
      real              r2cwsnattypmsr(n0nat,0:n0typ) !! pond  water evap.
      real              r2cwsnattypnnb(n0nat,0:n0typ) !! gw    water evap.
      real              r2cwsnattypblu(n0nat,0:n0typ) !! blue  water evap.
      real              r2cwsnattyptot(n0nat,0:n0typ) !! total water evap.
      character*128     c0cwsnattypgrn
      character*128     c0cwsnattypriv
      character*128     c0cwsnattypmsr
      character*128     c0cwsnattypnnb
      character*128     c0cwsnattypblu
      character*128     c0cwsnattyptot
c local (cropping)
      real              r1yldavg_typ(n0typ)
      real              r2aragrn(n0nat,0:n0typ) !! area green water evaporates
      real              r2arariv(n0nat,0:n0typ) !! area river water evaporates
      real              r2aramsr(n0nat,0:n0typ) !! area MSR water evaporates
      real              r2arannb(n0nat,0:n0typ) !! area NNBW evaporates
      real              r2arablu(n0nat,0:n0typ) !! area blue water evaporates
      real              r2aratot(n0nat,0:n0typ) !! area all water evaporates
      real              r2arafao(n0nat,n0typ)   !! harvested area
      real              r0arafao
      character*128     c0arafao
      character*128     c0aratot
c local (grazing)
      real              r1pasara_nat(n0nat) !! grazing area
c local
      real              r1cwsfix(n0typ)
      data              r1cwsfix/440.0,    0.0,   0.0,   0.0, 400.0,
     $                             0.0,    0.0,   0.0,   0.0,   0.0,
     $                             0.0, 1500.0,   0.0,   0.0,   0.0,
     $                             0.0,    0.0,   0.0, 540.0, 360.0/
      integer           i0natdbg
      data              i0natdbg/392/
c namelist
      character*128     c0set
      namelist         /set/
     $     n0l,           c0opt,         c1lnduse,
     $     c0crptyp1st,   c0crptyp2nd,   c0pasara,      c0nation,
     $     c0lndara,      c1arafrc,
     $     c0natlst,      
     $     c1cwslndmos1stgrn,            c1cwslndmos1striv,
     $     c1cwslndmos1stmsr,            c1cwslndmos1stnnb,
     $     c1cwslndmos2ndgrn,            c1cwslndmos2ndriv,
     $     c1cwslndmos2ndmsr,            c1cwslndmos2ndnnb,
     $     c0cwsnattypgrn,               c0cwsnattypriv,
     $     c0cwsnattypmsr,               c0cwsnattypnnb,
     $     c0cwsnattypblu,               c0cwsnattyptot,
     $     c1yld,        c1prd,          c0yldpas_nat,
     $     c0stkgoa_nat, c0stkshe_nat,   c0stkcat_nat,
     $     c0vwcgrn,     c0vwcriv,       c0vwcmsr,
     $     c0vwcnnb,     c0vwcblu,       c0vwctot,
     $     c0frcpas_nat, c0vwcchk,       c0arafao,      c0aratot,
     $     c0yldfao
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c initialize (before namelist)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      c1yld='NO'
      c1prd='NO'
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c get arguments
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(iargc().ne.1)then
        write(*,*) 'prog_vwcnew set'
        stop
      end if
c
      call getarg(1,c0set)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c read namelist
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      open(15,file=c0set)
      read(15,nml=set)
      close(15)
      write(*,*) 'prog_vwcnew: --- Read namelist --------------------'
      write(*,nml=set)
c
      allocate(r1tmp(n0l))
      allocate(r1crptyp1st(n0l))
      allocate(r1crptyp2nd(n0l))
      allocate(r1pasara(n0l))
      allocate(r1nation(n0l))
      allocate(r1lndara(n0l))
      allocate(r2arafrc(n0l,0:n0m))
      allocate(r2cwslndmos1stgrn(n0l,0:n0m))
      allocate(r2cwslndmos1striv(n0l,0:n0m))
      allocate(r2cwslndmos1stmsr(n0l,0:n0m))
      allocate(r2cwslndmos1stnnb(n0l,0:n0m))
      allocate(r2cwslndmos2ndgrn(n0l,0:n0m))
      allocate(r2cwslndmos2ndriv(n0l,0:n0m))
      allocate(r2cwslndmos2ndmsr(n0l,0:n0m))
      allocate(r2cwslndmos2ndnnb(n0l,0:n0m))
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c initialize
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      r1frcpas_nat=0.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c read yield(kg/ha), production(kg) and estimate area
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0typ=1,n0typ
        call read_ascii2(
     $       n0recdat,n0reccod,n0nat,
     $       c1yld(i0typ),c0natlst,
     $       r1tmpnat)
        do i0nat=1,n0nat
          r2yld(i0nat,i0typ)=r1tmpnat(i0nat)
        end do
      end do
c
      do i0typ=1,n0typ
        call read_ascii2(
     $       n0recdat,n0reccod,n0nat,
     $       c1prd(i0typ),c0natlst,
     $       r1tmpnat)
        do i0nat=1,n0nat
          r2prd(i0nat,i0typ)=r1tmpnat(i0nat)
        end do
      end do
c
      do i0typ=1,n0typ
        do i0nat=1,n0nat
          if(r2yld(i0nat,i0typ).ne.p0mis.and.
     $       r2yld(i0nat,i0typ).ne.0.0)then
            r2arafao(i0nat,i0typ)
     $           =r2prd(i0nat,i0typ)
     $           /r2yld(i0nat,i0typ)*1.0E4
          end if
        end do
      end do
c
      write(*,*) '----------'
      write(*,*) 'Rice yield in ',i0natdbg,r2yld(i0natdbg,12),'kg/ha'
      write(*,*) 'Rice prod. in ',i0natdbg,r2prd(i0natdbg,12),'kg'
      write(*,*) 'Rice area  in ',i0natdbg,r2arafao(i0natdbg,12),'m2'
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c read yield(kg/ha) of grazing land 
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
        call read_ascii2(
     $       n0recdat,n0reccod,n0nat,
     $       c0yldpas_nat,c0natlst,
     $       r1yldpas_nat)
c
      write(*,*) '----------'
      write(*,*) 'Pas. yld in ',i0natdbg,r1yldpas_nat(i0natdbg),'kg/ha'
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c calculate crop yield(kg/ha) of world average
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0typ=1,n0typ
        r0prd=0.0
        do i0nat=1,n0nat
          if(r2prd(i0nat,i0typ).ne.p0mis)then
            r0prd=r0prd+r2prd(i0nat,i0typ)
          end if
        end do
        r0arafao=0.0
        do i0nat=1,n0nat
          if(r2prd(i0nat,i0typ).ne.p0mis)then
            r0arafao=r0arafao+r2arafao(i0nat,i0typ)
          end if
        end do
        if(r0arafao.ne.0.0)then
          r1yldavg_typ(i0typ)=r0prd/r0arafao*1.0E4
        else
          r1yldavg_typ(i0typ)=0.0
        end if
        write(*,*) '----------',i0typ
        write(*,*) 'World total production ',r0prd,'kg' 
        write(*,*) 'World total area       ',r0arafao,'m2'
        write(*,*) 'World averaged yield   ',r1yldavg_typ(i0typ),'kg/ha'
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c read head of goat/sheep/cattle
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      call read_ascii2(
     $     n0recdat,n0reccod,n0nat,
     $     c0stkgoa_nat,c0natlst,
     $     r1stkgoa_nat)
c
      call read_ascii2(
     $     n0recdat,n0reccod,n0nat,
     $     c0stkshe_nat,c0natlst,
     $     r1stkshe_nat)
c
      call read_ascii2(
     $     n0recdat,n0reccod,n0nat,
     $     c0stkcat_nat,c0natlst,
     $     r1stkcat_nat)
c
      write(*,*) '----------'
      write(*,*) 'Goat   in ',i0natdbg,r1stkgoa_nat(i0natdbg)
      write(*,*) 'Sheep  in ',i0natdbg,r1stkshe_nat(i0natdbg)
      write(*,*) 'Cattle in ',i0natdbg,r1stkcat_nat(i0natdbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c read binary
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call read_binary(n0l,c0nation,   r1nation)
      call read_binary(n0l,c0lndara,   r1lndara)
c
      do i0m=1,n0m
        call read_binary(n0l,c1arafrc(i0m),r1tmp)
        do i0l=1,n0l
          r2arafrc(i0l,i0m)=r1tmp(i0l)
        end do
      end do
c
      call read_binary(n0l,c0crptyp1st,r1crptyp1st)
      call read_binary(n0l,c0crptyp2nd,r1crptyp2nd)
c
      call read_binary(n0l,c0pasara,   r1pasara)
c
      do i0m=0,n0m
        call read_binary(n0l,c1cwslndmos1stgrn(i0m),r1tmp)
        do i0l=1,n0l
          r2cwslndmos1stgrn(i0l,i0m)=r1tmp(i0l)
        end do

        call read_binary(n0l,c1cwslndmos1striv(i0m),r1tmp)
        do i0l=1,n0l
          r2cwslndmos1striv(i0l,i0m)=r1tmp(i0l)
        end do

        call read_binary(n0l,c1cwslndmos1stmsr(i0m),r1tmp)
        do i0l=1,n0l
          r2cwslndmos1stmsr(i0l,i0m)=r1tmp(i0l)
        end do

        call read_binary(n0l,c1cwslndmos1stnnb(i0m),r1tmp)
        do i0l=1,n0l
          r2cwslndmos1stnnb(i0l,i0m)=r1tmp(i0l)
        end do

        call read_binary(n0l,c1cwslndmos2ndgrn(i0m),r1tmp)
        do i0l=1,n0l
          r2cwslndmos2ndgrn(i0l,i0m)=r1tmp(i0l)
        end do

        call read_binary(n0l,c1cwslndmos2ndriv(i0m),r1tmp)
        do i0l=1,n0l
          r2cwslndmos2ndriv(i0l,i0m)=r1tmp(i0l)
        end do

        call read_binary(n0l,c1cwslndmos2ndmsr(i0m),r1tmp)
        do i0l=1,n0l
          r2cwslndmos2ndmsr(i0l,i0m)=r1tmp(i0l)
        end do

        call read_binary(n0l,c1cwslndmos2ndnnb(i0m),r1tmp)
        do i0l=1,n0l
          r2cwslndmos2ndnnb(i0l,i0m)=r1tmp(i0l)
        end do
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c check
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0m=0,n0m
        r0tmp=0.0
        do i0l=1,n0l
          r0tmp=r0tmp+r2cwslndmos1stgrn(i0l,i0m)
     $         *r1lndara(i0l)*r2arafrc(i0l,i0m)
        end do
        write(*,*) '1stgrn',i0m,r0tmp/1.0E6/1.0E6,' km3/yr'

        r0tmp=0.0
        do i0l=1,n0l
          r0tmp=r0tmp+r2cwslndmos1striv(i0l,i0m)
     $         *r1lndara(i0l)*r2arafrc(i0l,i0m)
        end do
        write(*,*) '1striv',i0m,r0tmp/1.0E6/1.0E6,' km3/yr'

        r0tmp=0.0
        do i0l=1,n0l
          r0tmp=r0tmp+r2cwslndmos1stmsr(i0l,i0m)
     $         *r1lndara(i0l)*r2arafrc(i0l,i0m)
        end do
        write(*,*) '1stmsr',i0m,r0tmp/1.0E6/1.0E6,' km3/yr'

        r0tmp=0.0
        do i0l=1,n0l
          r0tmp=r0tmp+r2cwslndmos1stnnb(i0l,i0m)
     $         *r1lndara(i0l)*r2arafrc(i0l,i0m)
        end do
        write(*,*) '1stnnb',i0m,r0tmp/1.0E6/1.0E6,' km3/yr'

        r0tmp=0.0
        do i0l=1,n0l
          r0tmp=r0tmp+r2cwslndmos2ndgrn(i0l,i0m)
     $         *r1lndara(i0l)*r2arafrc(i0l,i0m)
        end do
        write(*,*) '2ndgrn',i0m,r0tmp/1.0E6/1.0E6,' km3/yr'

        r0tmp=0.0
        do i0l=1,n0l
          r0tmp=r0tmp+r2cwslndmos2ndriv(i0l,i0m)
     $         *r1lndara(i0l)*r2arafrc(i0l,i0m)
        end do
        write(*,*) '2ndriv',i0m,r0tmp/1.0E6/1.0E6,' km3/yr'

        r0tmp=0.0
        do i0l=1,n0l
          r0tmp=r0tmp+r2cwslndmos2ndmsr(i0l,i0m)
     $         *r1lndara(i0l)*r2arafrc(i0l,i0m)
        end do
        write(*,*) '2ndmsr',i0m,r0tmp/1.0E6/1.0E6,' km3/yr'

        r0tmp=0.0
        do i0l=1,n0l
          r0tmp=r0tmp+r2cwslndmos2ndnnb(i0l,i0m)
     $         *r1lndara(i0l)*r2arafrc(i0l,i0m)
        end do
        write(*,*) '2ndnnb',i0m,r0tmp/1.0E6/1.0E6,' km3/yr'
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c fraction of pasturing
c grazing area: m2=1.0E-4ha; yld: t/ha=1.0E3kg/ha
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0l=1,n0l
          i0nat=int(r1nation(i0l))
          if(i0nat.lt.1.or.i0nat.gt.n0nat)then
            i0nat=999
          end if
          if(r1pasara(i0l).ne.p0mis)then
            r1pasara_nat(i0nat)=r1pasara_nat(i0nat)+r1pasara(i0l)
          end if
      end do
c
      do i0nat=1,n0nat
        if(r1pasara_nat(i0nat).gt.0.0.and.
     $     r1pasara_nat(i0nat).ne.p0mis.and.
     $     r1yldpas_nat(i0nat).gt.0.0.and.
     $     r1yldpas_nat(i0nat).ne.p0mis)then
          r1frcpas_nat(i0nat)
     $         =1.0-10.9375/(r1yldpas_nat(i0nat)/365.0)
     $         *(0.2*(r1stkgoa_nat(i0nat)+r1stkshe_nat(i0nat))
     $           +r1stkcat_nat(i0nat))
     $         /(r1pasara_nat(i0nat)*1.0E-4)
        end if
      end do
c
      do i0nat=1,n0nat
        if(r1frcpas_nat(i0nat).lt.-1.0)then
          r1frcpas_nat(i0nat)=0.0
        else if(r1frcpas_nat(i0nat).gt.1.0)then
          r1frcpas_nat(i0nat)=1.0
        else
          r1frcpas_nat(i0nat)=0.5+r1frcpas_nat(i0nat)/2.0
        end if
      end do
c
      write(*,*) 'Fraction of pasturing[-]:  ',r1frcpas_nat(840)
      write(*,*) 'Yield of pasture[kg/ha]:   ',r1yldpas_nat(840)
      write(*,*) 'Num of Livestock[head]:    ',
     $     0.2*(r1stkgoa_nat(840)+r1stkshe_nat(840))+r1stkcat_nat(840)
      write(*,*) 'Grazing area[ha]:          ',r1pasara_nat(840)/1.0E4
      write(*,*) 'Required area[ha]:         ',
     $   10.9375/(r1yldpas_nat(840)/365.0)
     $   *(0.2*(r1stkgoa_nat(840)+r1stkshe_nat(840))+r1stkcat_nat(840))
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c national  
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      r2cwsnattypgrn=0.0
      r2cwsnattypriv=0.0
      r2cwsnattypmsr=0.0
      r2cwsnattypnnb=0.0
      r2cwsnattypblu=0.0
      r2cwsnattyptot=0.0
c
      do i0typ=1,n0typ
        do i0m=1,n0m
          do i0l=1,n0l
            i0nat=int(r1nation(i0l))
            if(i0nat.lt.1.or.i0nat.gt.n0nat)then
              i0nat=999
            end if
            if(i0nat.ne.999.and.r1lndara(i0l).ne.p0mis)then
              if(int(r1crptyp1st(i0l)).eq.i0typ)then

                if(c1lnduse(i0m).eq.'scr'.or.
     $             c1lnduse(i0m).eq.'dcr')then
                  r2cwsnattypgrn(i0nat,i0typ)
     $                 =r2cwsnattypgrn(i0nat,i0typ)
     $                 +r2cwslndmos1stgrn(i0l,i0m)
     $                 *r1lndara(i0l)*r2arafrc(i0l,i0m)
                  if(r2cwslndmos1stgrn(i0l,i0m).gt.0.0)then !! bugfix
                    r2aragrn(i0nat,i0typ)
     $                   =r2aragrn(i0nat,i0typ)
     $                   +r1lndara(i0l)*r2arafrc(i0l,i0m)
                  end if

                  r2cwsnattyptot(i0nat,i0typ)
     $                 =r2cwsnattyptot(i0nat,i0typ)
     $                 +r2cwslndmos1stgrn(i0l,i0m)
     $                 *r1lndara(i0l)*r2arafrc(i0l,i0m)
                  if(r2cwslndmos1stgrn(i0l,i0m).gt.0.0)then !! bugfix
                    r2aratot(i0nat,i0typ)
     $                   =r2aratot(i0nat,i0typ)
     $                   +r1lndara(i0l)*r2arafrc(i0l,i0m)
                  end if
                end if
                
                if(c1lnduse(i0m).eq.'sci'.or.
     $             c1lnduse(i0m).eq.'dci')then
                  r2cwsnattypgrn(i0nat,i0typ)
     $                 =r2cwsnattypgrn(i0nat,i0typ)
     $                 +r2cwslndmos1stgrn(i0l,i0m)
     $                 *r1lndara(i0l)*r2arafrc(i0l,i0m)
                  if(r2cwslndmos1stgrn(i0l,i0m).gt.0.0)then !! bugfix
                    r2aragrn(i0nat,i0typ)
     $                   =r2aragrn(i0nat,i0typ)
     $                   +r1lndara(i0l)*r2arafrc(i0l,i0m)
                  end if

                  r2cwsnattypriv(i0nat,i0typ)
     $                 =r2cwsnattypriv(i0nat,i0typ)
     $                 +r2cwslndmos1striv(i0l,i0m)
     $                 *r1lndara(i0l)*r2arafrc(i0l,i0m)
                  if(r2cwslndmos1stgrn(i0l,i0m).gt.0.0)then !! bugfix
                    r2arariv(i0nat,i0typ)
     $                   =r2arariv(i0nat,i0typ)
     $                   +r1lndara(i0l)*r2arafrc(i0l,i0m)
                  end if

                  r2cwsnattypmsr(i0nat,i0typ)
     $                 =r2cwsnattypmsr(i0nat,i0typ)
     $                 +r2cwslndmos1stmsr(i0l,i0m)
     $                 *r1lndara(i0l)*r2arafrc(i0l,i0m)
                  if(r2cwslndmos1stgrn(i0l,i0m).gt.0.0)then !! bugfix
                    r2aramsr(i0nat,i0typ)
     $                   =r2aramsr(i0nat,i0typ)
     $                   +r1lndara(i0l)*r2arafrc(i0l,i0m)
                  end if

                  r2cwsnattypnnb(i0nat,i0typ)
     $                 =r2cwsnattypnnb(i0nat,i0typ)
     $                 +r2cwslndmos1stnnb(i0l,i0m)
     $                 *r1lndara(i0l)*r2arafrc(i0l,i0m)
                  if(r2cwslndmos1stgrn(i0l,i0m).gt.0.0)then !! bugfix
                    r2arannb(i0nat,i0typ)
     $                   =r2arannb(i0nat,i0typ)
     $                   +r1lndara(i0l)*r2arafrc(i0l,i0m)
                  end if
                
                  r2cwsnattypblu(i0nat,i0typ)
     $                 =r2cwsnattypblu(i0nat,i0typ)
     $                 +r2cwslndmos1striv(i0l,i0m)
     $                 *r1lndara(i0l)*r2arafrc(i0l,i0m)
     $                 +r2cwslndmos1stmsr(i0l,i0m)
     $                 *r1lndara(i0l)*r2arafrc(i0l,i0m)
     $                 +r2cwslndmos1stnnb(i0l,i0m)
     $                 *r1lndara(i0l)*r2arafrc(i0l,i0m)
                  if(r2cwslndmos1stgrn(i0l,i0m).gt.0.0)then !! bugfix
                    r2arablu(i0nat,i0typ)
     $                   =r2arablu(i0nat,i0typ)
     $                   +r1lndara(i0l)*r2arafrc(i0l,i0m)
                  end if
                
                  r2cwsnattyptot(i0nat,i0typ)
     $                 =r2cwsnattyptot(i0nat,i0typ)
     $                 +r2cwslndmos1stgrn(i0l,i0m)
     $                 *r1lndara(i0l)*r2arafrc(i0l,i0m)
     $                 +r2cwslndmos1striv(i0l,i0m)
     $                 *r1lndara(i0l)*r2arafrc(i0l,i0m)
     $                 +r2cwslndmos1stmsr(i0l,i0m)
     $                 *r1lndara(i0l)*r2arafrc(i0l,i0m)
     $                 +r2cwslndmos1stnnb(i0l,i0m)
     $                 *r1lndara(i0l)*r2arafrc(i0l,i0m)
                  if(r2cwslndmos1stgrn(i0l,i0m).gt.0.0)then !! bugfix
                    r2aratot(i0nat,i0typ)
     $                   =r2aratot(i0nat,i0typ)
     $                   +r1lndara(i0l)*r2arafrc(i0l,i0m)
                  end if
                end if

              else if(int(r1crptyp2nd(i0l)).eq.i0typ)then
              
                if(c1lnduse(i0m).eq.'dcr')then
                  r2cwsnattypgrn(i0nat,i0typ)
     $                 =r2cwsnattypgrn(i0nat,i0typ)
     $                 +r2cwslndmos2ndgrn(i0l,i0m)
     $                 *r1lndara(i0l)*r2arafrc(i0l,i0m)
                  if(r2cwslndmos2ndgrn(i0l,i0m).gt.0.0)then !! bugfix
                    r2aragrn(i0nat,i0typ)
     $                   =r2aragrn(i0nat,i0typ)
     $                   +r1lndara(i0l)*r2arafrc(i0l,i0m)
                  end if
                  
                  r2cwsnattyptot(i0nat,i0typ)
     $                 =r2cwsnattyptot(i0nat,i0typ)
     $                 +r2cwslndmos2ndgrn(i0l,i0m)
     $                 *r1lndara(i0l)*r2arafrc(i0l,i0m)
                  if(r2cwslndmos2ndgrn(i0l,i0m).gt.0.0)then !! bugfix
                    r2aratot(i0nat,i0typ)
     $                   =r2aratot(i0nat,i0typ)
     $                   +r1lndara(i0l)*r2arafrc(i0l,i0m)
                  end if
                end if
                
                if(c1lnduse(i0m).eq.'dci')then
                  r2cwsnattypgrn(i0nat,i0typ)
     $                 =r2cwsnattypgrn(i0nat,i0typ)
     $                 +r2cwslndmos2ndgrn(i0l,i0m)
     $                 *r1lndara(i0l)*r2arafrc(i0l,i0m)
                  if(r2cwslndmos2ndgrn(i0l,i0m).gt.0.0)then !! bugfix
                    r2aragrn(i0nat,i0typ)
     $                   =r2aragrn(i0nat,i0typ)
     $                   +r1lndara(i0l)*r2arafrc(i0l,i0m)
                  end if
                  
                  r2cwsnattypriv(i0nat,i0typ)
     $                 =r2cwsnattypriv(i0nat,i0typ)
     $                 +r2cwslndmos2ndriv(i0l,i0m)
     $                 *r1lndara(i0l)*r2arafrc(i0l,i0m)
                  if(r2cwslndmos2ndgrn(i0l,i0m).gt.0.0)then !! bugfix
                    r2arariv(i0nat,i0typ)
     $                   =r2arariv(i0nat,i0typ)
     $                   +r1lndara(i0l)*r2arafrc(i0l,i0m)
                  end if
                
                  r2cwsnattypmsr(i0nat,i0typ)
     $                 =r2cwsnattypmsr(i0nat,i0typ)
     $                 +r2cwslndmos2ndmsr(i0l,i0m)
     $                 *r1lndara(i0l)*r2arafrc(i0l,i0m)
                  if(r2cwslndmos2ndgrn(i0l,i0m).gt.0.0)then !! bugfix
                    r2aramsr(i0nat,i0typ)
     $                   =r2aramsr(i0nat,i0typ)
     $                   +r1lndara(i0l)*r2arafrc(i0l,i0m)
                  end if
                  
                  r2cwsnattypnnb(i0nat,i0typ)
     $                 =r2cwsnattypnnb(i0nat,i0typ)
     $                 +r2cwslndmos2ndnnb(i0l,i0m)
     $                 *r1lndara(i0l)*r2arafrc(i0l,i0m)
                  if(r2cwslndmos2ndgrn(i0l,i0m).gt.0.0)then !! bugfix
                    r2arannb(i0nat,i0typ)
     $                   =r2arannb(i0nat,i0typ)
     $                   +r1lndara(i0l)*r2arafrc(i0l,i0m)
                  end if

                  r2cwsnattypblu(i0nat,i0typ)
     $                 =r2cwsnattypblu(i0nat,i0typ)
     $                 +r2cwslndmos2ndriv(i0l,i0m)
     $                 *r1lndara(i0l)*r2arafrc(i0l,i0m)
     $                 +r2cwslndmos2ndmsr(i0l,i0m)
     $                 *r1lndara(i0l)*r2arafrc(i0l,i0m)
     $                 +r2cwslndmos2ndnnb(i0l,i0m)
     $                 *r1lndara(i0l)*r2arafrc(i0l,i0m)
                  if(r2cwslndmos2ndgrn(i0l,i0m).gt.0.0)then !! bugfix
                    r2arablu(i0nat,i0typ)
     $                   =r2arablu(i0nat,i0typ)
     $                   +r1lndara(i0l)*r2arafrc(i0l,i0m)
                  end if
                  
                  r2cwsnattyptot(i0nat,i0typ)
     $                 =r2cwsnattyptot(i0nat,i0typ)
     $                 +r2cwslndmos2ndgrn(i0l,i0m)
     $                 *r1lndara(i0l)*r2arafrc(i0l,i0m)
     $                 +r2cwslndmos2ndriv(i0l,i0m)
     $                 *r1lndara(i0l)*r2arafrc(i0l,i0m)
     $                 +r2cwslndmos2ndmsr(i0l,i0m)
     $                 *r1lndara(i0l)*r2arafrc(i0l,i0m)
     $                 +r2cwslndmos2ndnnb(i0l,i0m)
     $                 *r1lndara(i0l)*r2arafrc(i0l,i0m)
                  if(r2cwslndmos2ndgrn(i0l,i0m).gt.0.0)then !! bugfix
                    r2aratot(i0nat,i0typ)
     $                   =r2aratot(i0nat,i0typ)
     $                   +r1lndara(i0l)*r2arafrc(i0l,i0m)
                  end if
                end if

              end if
            end if
          end do
        end do

        do i0nat=1,n0nat
          r2cwsnattypgrn(i0nat,0)
     $         =r2cwsnattypgrn(i0nat,0)+r2cwsnattypgrn(i0nat,i0typ)
          r2aragrn(i0nat,0)=r2aragrn(i0nat,0)+r2aragrn(i0nat,i0typ)
          r2cwsnattypriv(i0nat,0)
     $         =r2cwsnattypriv(i0nat,0)+r2cwsnattypriv(i0nat,i0typ)
          r2arariv(i0nat,0)=r2arariv(i0nat,0)+r2arariv(i0nat,i0typ)
          r2cwsnattypmsr(i0nat,0)
     $         =r2cwsnattypmsr(i0nat,0)+r2cwsnattypmsr(i0nat,i0typ)
          r2aramsr(i0nat,0)=r2aramsr(i0nat,0)+r2aramsr(i0nat,i0typ)
          r2cwsnattypnnb(i0nat,0)
     $         =r2cwsnattypnnb(i0nat,0)+r2cwsnattypnnb(i0nat,i0typ)
          r2arannb(i0nat,0)=r2arannb(i0nat,0)+r2arannb(i0nat,i0typ)
          r2cwsnattypblu(i0nat,0)
     $         =r2cwsnattypblu(i0nat,0)+r2cwsnattypblu(i0nat,i0typ)
          r2arablu(i0nat,0)=r2arablu(i0nat,0)+r2arablu(i0nat,i0typ)
          r2cwsnattyptot(i0nat,0)
     $         =r2cwsnattyptot(i0nat,0)+r2cwsnattyptot(i0nat,i0typ)
          r2aratot(i0nat,0)=r2aratot(i0nat,0)+r2aratot(i0nat,i0typ)
        end do

      end do
c
      write(*,*) '----------'
      write(*,*) 'green water for rice in ',i0natdbg,
     $     r2cwsnattypgrn(i0natdbg,12)/1.0E6/1.0E6,' km3/yr'
      write(*,*) 'river water for rice in ',i0natdbg,
     $     r2cwsnattypriv(i0natdbg,12)/1.0E6/1.0E6,' km3/yr'
      write(*,*) 'MSR   water for rice in ',i0natdbg,
     $     r2cwsnattypmsr(i0natdbg,12)/1.0E6/1.0E6,' km3/yr'
      write(*,*) 'NNBW  water for rice in ',i0natdbg,
     $     r2cwsnattypnnb(i0natdbg,12)/1.0E6/1.0E6,' km3/yr'
      write(*,*) 'blue  water for rice in ',i0natdbg,
     $     r2cwsnattypblu(i0natdbg,12)/1.0E6/1.0E6,' km3/yr'
      write(*,*) 'total water for rice in ',i0natdbg,
     $     r2cwsnattyptot(i0natdbg,12)/1.0E6/1.0E6,' km3/yr'
      write(*,*) 'total  area for rice in ',i0natdbg,
     $     r2aratot(i0natdbg,12)/1.0E3/1.0E3,' km2'
      write(*,*) 'green water for all in ',i0natdbg,
     $     r2cwsnattypgrn(i0natdbg,0)/1.0E6/1.0E6,' km3/yr'
      write(*,*) 'river water for all in ',i0natdbg,
     $     r2cwsnattypriv(i0natdbg,0)/1.0E6/1.0E6,' km3/yr'
      write(*,*) 'MSR   water for all in ',i0natdbg,
     $     r2cwsnattypmsr(i0natdbg,0)/1.0E6/1.0E6,' km3/yr'
      write(*,*) 'NNBW  water for all in ',i0natdbg,
     $     r2cwsnattypnnb(i0natdbg,0)/1.0E6/1.0E6,' km3/yr'
      write(*,*) 'blue  water for all in ',i0natdbg,
     $     r2cwsnattypblu(i0natdbg,0)/1.0E6/1.0E6,' km3/yr'
      write(*,*) 'total water for all in ',i0natdbg,
     $     r2cwsnattyptot(i0natdbg,0)/1.0E6/1.0E6,' km3/yr'
      write(*,*) 'total  area for all in ',i0natdbg,
     $     r2aratot(i0natdbg,0)/1.0E3/1.0E3,' km2'
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c check
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      r0tmp=0.0
      do i0typ=1,n0typ
        do i0nat=1,n0nat
          r0tmp=r0tmp+r2cwsnattypgrn(i0nat,i0typ)
        end do
      end do
      write(*,*)  'green water for world : ',r0tmp/1.0E6/1.0E6,' km3/yr'
c
      r0tmp=0.0
      do i0typ=1,n0typ
        do i0nat=1,n0nat
          r0tmp=r0tmp+r2cwsnattypblu(i0nat,i0typ)
        end do
      end do
      write(*,*)  'blue water for world : ',r0tmp/1.0E6/1.0E6,' km3/yr'
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c calc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      r2vwcgrn=0.0
      r2vwcriv=0.0
      r2vwcmsr=0.0
      r2vwcnnb=0.0
      r2vwcblu=0.0
      r2vwctot=0.0
c
      do i0typ=1,n0typ
        if(i0typ.eq.20)then
          do i0nat=1,n0nat
            if(r1yldpas_nat(i0nat).ne.0.0.and.
     $         r1yldpas_nat(i0nat).ne.p0mis)then
              r2vwctot(i0nat,i0typ)
     $             =r1cwsfix(20)/r1yldpas_nat(i0nat)*1.0E4
            end if
          end do
        else
          do i0nat=1,n0nat
            if(c0opt.eq.'K03')then
              if(r2yld(i0nat,i0typ).ne.0.0.and.
     $           r2yld(i0nat,i0typ).ne.p0mis)then              
                r2vwcgrn(i0nat,i0typ)=0.0
                r2vwcriv(i0nat,i0typ)=0.0
                r2vwcmsr(i0nat,i0typ)=0.0
                r2vwcnnb(i0nat,i0typ)=0.0
                r2vwcblu(i0nat,i0typ)=0.0
                r2vwctot(i0nat,i0typ)
     $               =r1cwsfix(i0typ)/r2yld(i0nat,i0typ)*1.0E4
              else
                r2vwcgrn(i0nat,i0typ)=0.0
                r2vwcriv(i0nat,i0typ)=0.0
                r2vwcmsr(i0nat,i0typ)=0.0
                r2vwcnnb(i0nat,i0typ)=0.0
                r2vwcblu(i0nat,i0typ)=0.0
                r2vwctot(i0nat,i0typ)
     $               =r1cwsfix(i0typ)/r1yldavg_typ(i0typ)*1.0E4
              end if
            else
              if(i0nat.eq.i0natdbg)then
                write(*,*) '------debug-----------'
                write(*,*) 'i0nat:    ',i0nat
                write(*,*) 'i0typ:    ',i0typ
                write(*,*) 'r2yld:    ',r2yld(i0nat,i0typ)
                write(*,*) 'r2aratot: ',r2aratot(i0nat,i0typ)
              end if
              if(r2yld(i0nat,i0typ).ne.0.0.and.
     $           r2yld(i0nat,i0typ).ne.p0mis)then
                if(r2aratot(i0nat,i0typ).ne.0.0)then
                  r2vwcgrn(i0nat,i0typ)=r2cwsnattypgrn(i0nat,i0typ)
     $                 /r2aratot(i0nat,i0typ)/r2yld(i0nat,i0typ)*1.0E4
                  if(r2vwcgrn(i0nat,i0typ).lt.0)then
                    write(*,*) i0nat,i0typ
                    write(*,*) r2vwcgrn(i0nat,i0typ)
                    write(*,*) r2cwsnattypgrn(i0nat,i0typ)
                    write(*,*) r2aratot(i0nat,i0typ)
                    write(*,*) r2yld(i0nat,i0typ)
                    stop
                  end if
                  r2vwcriv(i0nat,i0typ)=r2cwsnattypriv(i0nat,i0typ)
     $                 /r2aratot(i0nat,i0typ)/r2yld(i0nat,i0typ)*1.0E4
                  r2vwcmsr(i0nat,i0typ)=r2cwsnattypmsr(i0nat,i0typ)
     $                 /r2aratot(i0nat,i0typ)/r2yld(i0nat,i0typ)*1.0E4
                  r2vwcnnb(i0nat,i0typ)=r2cwsnattypnnb(i0nat,i0typ)
     $                 /r2aratot(i0nat,i0typ)/r2yld(i0nat,i0typ)*1.0E4
                  r2vwcblu(i0nat,i0typ)=r2cwsnattypblu(i0nat,i0typ)
     $                 /r2aratot(i0nat,i0typ)/r2yld(i0nat,i0typ)*1.0E4
                  r2vwctot(i0nat,i0typ)=r2cwsnattyptot(i0nat,i0typ)
     $                 /r2aratot(i0nat,i0typ)/r2yld(i0nat,i0typ)*1.0E4
                else if(r2aratot(i0nat,0).ne.0.0)then
                  r2vwcgrn(i0nat,i0typ)=r2cwsnattypgrn(i0nat,0)
     $                 /r2aratot(i0nat,0)/r2yld(i0nat,i0typ)*1.0E4
                  r2vwcriv(i0nat,i0typ)=r2cwsnattypriv(i0nat,0)
     $                 /r2aratot(i0nat,0)/r2yld(i0nat,i0typ)*1.0E4
                  r2vwcmsr(i0nat,i0typ)=r2cwsnattypmsr(i0nat,0)
     $                 /r2aratot(i0nat,0)/r2yld(i0nat,i0typ)*1.0E4
                  r2vwcnnb(i0nat,i0typ)=r2cwsnattypnnb(i0nat,0)
     $                 /r2aratot(i0nat,0)/r2yld(i0nat,i0typ)*1.0E4
                  r2vwcblu(i0nat,i0typ)=r2cwsnattypblu(i0nat,0)
     $                 /r2aratot(i0nat,0)/r2yld(i0nat,i0typ)*1.0E4
                  r2vwctot(i0nat,i0typ)=r2cwsnattyptot(i0nat,0)
     $                 /r2aratot(i0nat,0)/r2yld(i0nat,i0typ)*1.0E4
                end if
              else
                if(r2aratot(i0nat,0).ne.0.0.and.
     $             r1yldavg_typ(i0typ).ne.0.0)then
                  r2vwcgrn(i0nat,i0typ)=r2cwsnattypgrn(i0nat,0)
     $                 /r2aratot(i0nat,0)/r1yldavg_typ(i0typ)*1.0E4
                  r2vwcriv(i0nat,i0typ)=r2cwsnattypriv(i0nat,0)
     $                 /r2aratot(i0nat,0)/r1yldavg_typ(i0typ)*1.0E4
                  r2vwcmsr(i0nat,i0typ)=r2cwsnattypmsr(i0nat,0)
     $                 /r2aratot(i0nat,0)/r1yldavg_typ(i0typ)*1.0E4
                  r2vwcnnb(i0nat,i0typ)=r2cwsnattypnnb(i0nat,0)
     $                 /r2aratot(i0nat,0)/r1yldavg_typ(i0typ)*1.0E4
                  r2vwcblu(i0nat,i0typ)=r2cwsnattypblu(i0nat,0)
     $                 /r2aratot(i0nat,0)/r1yldavg_typ(i0typ)*1.0E4
                  r2vwctot(i0nat,i0typ)=r2cwsnattyptot(i0nat,0)
     $                 /r2aratot(i0nat,0)/r1yldavg_typ(i0typ)*1.0E4
                end if
              end if
            end if
          end do
        end if
      end do
c
      write(*,*) '----------'
      write(*,*) 'green vwc for rice in ',i0natdbg,
     $     r2vwcgrn(i0natdbg,12),' kg/kg/yr',
     $     r2aratot(i0natdbg,0),' m2'
      write(*,*) 'river vwc for rice in ',i0natdbg,
     $     r2vwcriv(i0natdbg,12),' kg/kg/yr'
      write(*,*) 'pond  vwc for rice in ',i0natdbg,
     $     r2vwcmsr(i0natdbg,12),' kg/kg/yr'
      write(*,*) 'gw    vwc for rice in ',i0natdbg,
     $     r2vwcnnb(i0natdbg,12),' kg/kg/yr'
      write(*,*) 'blue  vwc for rice in ',i0natdbg,
     $     r2vwcblu(i0natdbg,12),' kg/kg/yr'
      write(*,*) 'total vwc for rice in ',i0natdbg,
     $     r2vwctot(i0natdbg,12),' kg/kg/yr'
c
      write(*,*) '----------'
      write(*,*) ' vwc for barley in ',i0natdbg,
     $     r2vwctot(i0natdbg,1)
      write(*,*) ' cws for barley in ',i0natdbg,
     $     r2cwsnattyptot(i0natdbg,1)
      write(*,*) ' ara for barley in ',i0natdbg,
     $     r2aratot(i0natdbg,1)
      write(*,*) ' yld for barley in ',i0natdbg,
     $     r2yld(i0natdbg,1)
      write(*,*) ' vwc for maize  in ',i0natdbg,
     $     r2vwctot(i0natdbg,5)
      write(*,*) ' cws for maize  in ',i0natdbg,
     $     r2cwsnattyptot(i0natdbg,5)
      write(*,*) ' ara for maize  in ',i0natdbg,
     $     r2aratot(i0natdbg,5) 
      write(*,*) ' yld for maize  in ',i0natdbg,
     $     r2yld(i0natdbg,5)
      write(*,*) ' vwc for rice   in ',i0natdbg,
     $     r2vwctot(i0natdbg,12)
      write(*,*) ' cws for rice   in ',i0natdbg,
     $     r2cwsnattyptot(i0natdbg,12)
      write(*,*) ' ara for rice   in ',i0natdbg,
     $     r2aratot(i0natdbg,12)
      write(*,*) ' yld for rice   in ',i0natdbg,
     $     r2yld(i0natdbg,12)
      write(*,*) ' vwc for soy    in ',i0natdbg,
     $     r2vwctot(i0natdbg,15)
      write(*,*) ' cws for soy    in ',i0natdbg,
     $     r2cwsnattyptot(i0natdbg,15)
      write(*,*) ' ara for soy    in ',i0natdbg,
     $     r2aratot(i0natdbg,15)
      write(*,*) ' yld for soy    in ',i0natdbg,
     $     r2yld(i0natdbg,15)
      write(*,*) ' vwc for wheat  in ',i0natdbg,
     $     r2vwctot(i0natdbg,19)
      write(*,*) ' cws for wheat  in ',i0natdbg,
     $     r2cwsnattyptot(i0natdbg,19)
      write(*,*) ' ara for wheat  in ',i0natdbg,
     $     r2aratot(i0natdbg,19)
      write(*,*) ' yld for wheat  in ',i0natdbg,
     $     r2yld(i0natdbg,19)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c checker (2012/03/28)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0nat=1,n0nat
        do i0typ=1,n0typ
c
          if(r2yld(i0nat,i0typ).eq.0.0.or.
     $       r2yld(i0nat,i0typ).eq.p0mis)then
            r2vwcchk(i0nat,i0typ)=-2.0
          else if(r2aratot(i0nat,i0typ).eq.0.0.or.
     $            r2aratot(i0nat,i0typ).eq.p0mis)then
            r2vwcchk(i0nat,i0typ)=-1.0
          else
            r2vwcchk(i0nat,i0typ)
     $           =r2aratot(i0nat,i0typ)/r2arafao(i0nat,i0typ)
          end if
c
        end do
      end do
c
      write(*,*) 'vwcchk: ',r2vwcchk(4,1)
      open(16,file=c0vwcchk)
      do i0nat=1,n0nat
        write(16,'(i4,x,5es16.8)') i0nat,
     $       r2vwcchk(i0nat,1),
     $       r2vwcchk(i0nat,5),
     $       r2vwcchk(i0nat,12),
     $       r2vwcchk(i0nat,15),
     $       r2vwcchk(i0nat,19)
      end do
      close(16)
c
      write(*,*) 'arafao: ',r2arafao(4,1)
      open(16,file=c0arafao)
      do i0nat=1,n0nat
        write(16,'(i4,x,5es16.8)') i0nat,
     $       r2arafao(i0nat,1),
     $       r2arafao(i0nat,5),
     $       r2arafao(i0nat,12),
     $       r2arafao(i0nat,15),
     $       r2arafao(i0nat,19)
      end do
      close(16)
c
      write(*,*) 'hoge'
      write(*,*) c0yldfao
      write(*,*) c0arafao
c
      write(*,*) 'yldfao: ',r2yld(4,1)
      open(16,file=c0yldfao)
      do i0nat=1,n0nat
        write(16,'(i4,x,5es16.8)') i0nat,
     $       r2yld(i0nat,1),
     $       r2yld(i0nat,5),
     $       r2yld(i0nat,12),
     $       r2yld(i0nat,15),
     $       r2yld(i0nat,19)
      end do
      close(16)
c
      write(*,*) 'aratot: ',r2aratot(4,1)
      open(16,file=c0aratot)
      do i0nat=1,n0nat
        write(16,'(i4,x,5es16.8)') i0nat,
     $       r2aratot(i0nat,1),
     $       r2aratot(i0nat,5),
     $       r2aratot(i0nat,12),
     $       r2aratot(i0nat,15),
     $       r2aratot(i0nat,19)
      end do
      close(16)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c write
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      open(16,file=c0cwsnattypgrn)
      do i0nat=1,n0nat
        write(16,*) i0nat,
     $       r2cwsnattypgrn(i0nat,1)/1.0E6/1.0E6,
     $       r2cwsnattypgrn(i0nat,5)/1.0E6/1.0E6,
     $       r2cwsnattypgrn(i0nat,12)/1.0E6/1.0E6,
     $       r2cwsnattypgrn(i0nat,15)/1.0E6/1.0E6,
     $       r2cwsnattypgrn(i0nat,19)/1.0E6/1.0E6,
     $       r2cwsnattypgrn(i0nat,0)/1.0E6/1.0E6
      end do
      close(16)
c
      open(16,file=c0cwsnattypblu)
      do i0nat=1,n0nat
        write(16,*) i0nat,
     $       r2cwsnattypblu(i0nat,1)/1.0E6/1.0E6,
     $       r2cwsnattypblu(i0nat,5)/1.0E6/1.0E6,
     $       r2cwsnattypblu(i0nat,12)/1.0E6/1.0E6,
     $       r2cwsnattypblu(i0nat,15)/1.0E6/1.0E6,
     $       r2cwsnattypblu(i0nat,19)/1.0E6/1.0E6,
     $       r2cwsnattypblu(i0nat,0)/1.0E6/1.0E6
      end do
      close(16)
c
      open(16,file=c0cwsnattypriv)
      do i0nat=1,n0nat
        write(16,*) i0nat,
     $       r2cwsnattypriv(i0nat,1)/1.0E6/1.0E6,
     $       r2cwsnattypriv(i0nat,5)/1.0E6/1.0E6,
     $       r2cwsnattypriv(i0nat,12)/1.0E6/1.0E6,
     $       r2cwsnattypriv(i0nat,15)/1.0E6/1.0E6,
     $       r2cwsnattypriv(i0nat,19)/1.0E6/1.0E6,
     $       r2cwsnattypriv(i0nat,0)/1.0E6/1.0E6
      end do
      close(16)
c
      open(16,file=c0cwsnattypmsr)
      do i0nat=1,n0nat
        write(16,*) i0nat,
     $       r2cwsnattypmsr(i0nat,1)/1.0E6/1.0E6,
     $       r2cwsnattypmsr(i0nat,5)/1.0E6/1.0E6,
     $       r2cwsnattypmsr(i0nat,12)/1.0E6/1.0E6,
     $       r2cwsnattypmsr(i0nat,15)/1.0E6/1.0E6,
     $       r2cwsnattypmsr(i0nat,19)/1.0E6/1.0E6,
     $       r2cwsnattypmsr(i0nat,0)/1.0E6/1.0E6
      end do
      close(16)
c
      open(16,file=c0cwsnattypnnb)
      do i0nat=1,n0nat
        write(16,*) i0nat,
     $       r2cwsnattypnnb(i0nat,1)/1.0E6/1.0E6,
     $       r2cwsnattypnnb(i0nat,5)/1.0E6/1.0E6,
     $       r2cwsnattypnnb(i0nat,12)/1.0E6/1.0E6,
     $       r2cwsnattypnnb(i0nat,15)/1.0E6/1.0E6,
     $       r2cwsnattypnnb(i0nat,19)/1.0E6/1.0E6,
     $       r2cwsnattypnnb(i0nat,0)/1.0E6/1.0E6
      end do
      close(16)
c
      open(16,file=c0cwsnattyptot)
      do i0nat=1,n0nat
        write(16,*) i0nat,
     $       r2cwsnattyptot(i0nat,1)/1.0E6/1.0E6,
     $       r2cwsnattyptot(i0nat,5)/1.0E6/1.0E6,
     $       r2cwsnattyptot(i0nat,12)/1.0E6/1.0E6,
     $       r2cwsnattyptot(i0nat,15)/1.0E6/1.0E6,
     $       r2cwsnattyptot(i0nat,19)/1.0E6/1.0E6,
     $       r2cwsnattyptot(i0nat,0)/1.0E6/1.0E6
      end do
      close(16)
c
      open(16,file=c0vwcgrn)
      do i0nat=1,n0nat
        write(16,'(i4,x,6(f12.0))') i0nat,
     $       r2vwcgrn(i0nat,1), r2vwcgrn(i0nat,5),
     $       r2vwcgrn(i0nat,12),r2vwcgrn(i0nat,15),
     $       r2vwcgrn(i0nat,19),r2vwcgrn(i0nat,20)
      end do
      close(16)
c
      open(16,file=c0vwcriv)
      do i0nat=1,n0nat
        write(16,'(i4,x,6(f12.0))') i0nat,
     $       r2vwcriv(i0nat,1), r2vwcriv(i0nat,5),
     $       r2vwcriv(i0nat,12),r2vwcriv(i0nat,15),
     $       r2vwcriv(i0nat,19),r2vwcriv(i0nat,20)
      end do
      close(16)
c
      open(16,file=c0vwcmsr)
      do i0nat=1,n0nat
        write(16,'(i4,x,6(f12.0))') i0nat,
     $       r2vwcmsr(i0nat,1), r2vwcmsr(i0nat,5),
     $       r2vwcmsr(i0nat,12),r2vwcmsr(i0nat,15),
     $       r2vwcmsr(i0nat,19),r2vwcmsr(i0nat,20)
      end do
      close(16)
c
      open(16,file=c0vwcnnb)
      do i0nat=1,n0nat
        write(16,'(i4,x,6(f12.0))') i0nat,
     $       r2vwcnnb(i0nat,1), r2vwcnnb(i0nat,5),
     $       r2vwcnnb(i0nat,12),r2vwcnnb(i0nat,15),
     $       r2vwcnnb(i0nat,19),r2vwcnnb(i0nat,20)
      end do
      close(16)
c
      open(16,file=c0vwcblu)
      do i0nat=1,n0nat
        write(16,'(i4,x,6(f12.0))') i0nat,
     $       r2vwcblu(i0nat,1), r2vwcblu(i0nat,5),
     $       r2vwcblu(i0nat,12),r2vwcblu(i0nat,15),
     $       r2vwcblu(i0nat,19),r2vwcblu(i0nat,20)
      end do
      close(16)
c
      open(16,file=c0vwctot)
      do i0nat=1,n0nat
        write(16,'(i4,x,6(f12.0))') i0nat,
     $       r2vwctot(i0nat,1), r2vwctot(i0nat,5),
     $       r2vwctot(i0nat,12),r2vwctot(i0nat,15),
     $       r2vwctot(i0nat,19),r2vwctot(i0nat,20)
      end do
      close(16)
c
      open(16,file=c0frcpas_nat)
      do i0nat=1,n0nat
        write(16,'(i4,x,f8.4)') i0nat,r1frcpas_nat(i0nat)
      end do
      close(16)
c
      end
