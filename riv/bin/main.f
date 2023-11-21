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
cto   simulate river discharge
cby   2010/09/30, hanasaki, NIES: H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      implicit none
c parameter (array)
      integer           n0l             !! number of grids in horizontal
      integer           n0t
      parameter        (n0l=259200)
c     parameter        (n0l=11088)
c      parameter        (n0l=32400)
      parameter        (n0t=3) 
c parameter (physical)
      integer           n0secday        !! seconds of a day
      parameter        (n0secday=86400)
c parameter (default) 
      real              p0mis
      parameter        (p0mis=1.0E20) 
c index (array)
      integer           i0l             !! land
c index (time)
      integer           i0year          !! year
      integer           i0mon           !! month
      integer           i0day           !! day 
      integer           i0sec           !! sec
c temporary
      character*128     c0opt           !! option
      real              r1tmp(n0l)
c function
      integer           iargc           !! number of argument
      integer           igetday         !! number of day in the month
c in (set)
      integer           i0yearmin       !! start year
      integer           i0yearmax       !! end year
      integer           i0secint        !! interval
      integer           i0ldbg          !! land debugging point
      integer           i0spnflg        !! spinup flag
      real              r0spnerr        !! spinup error
      real              r0spnrat        !! spinup ratio
c in (file)
      real              r1rivseq(n0l)   !! river sequence [-]
      real              r1rivnxl(n0l)   !! next grid [-]
      real              r1rivnxd(n0l)   !! distance to next grid [m]
      real              r1lndara(n0l)   !! land area [m2]
      real              r1flwvel(n0l)   !! flow velocity [m/s]
      real              r1medrat(n0l)   !! meandering ratio [-]
      real              r1qtot(n0l)     !! total runoff [kg/m2/s]
      character*128     c0rivseq        !! river sequence
      character*128     c0rivnxl        !! index of next grid
      character*128     c0rivnxd        !! distance to next grid
      character*128     c0lndara        !! land area
      character*128     c0flwvel        !! flow velocity
      character*128     c0medrat        !! meandering ratio
      character*128     c0qtot          !! total runoff      
c state variable
      real              r1rivsto(n0l)   !! river storage [kg]
      real              r2rivsto(n0l,0:n0t)   !! river storage [kg]
      real              r1rivsto_pr(n0l)!! river storage of previous ts [kg]
      character*128     c0rivsto        !! river storage
      character*128     c0rivstoini     !! initial river storage
c out
      real              r1rivout(n0l)   !! discharge [kg/s]
      real              r2rivout(n0l,0:n0t)   !! discharge [kg/s]
      character*128     c0rivout        !! river discharge
c local
      integer           i0yearmin_dummy !! dummy yearmin for spinup [-]
      integer           i0yearmax_dummy !! dummy yearmax for spinup [-]
      real              r0rivseqmax     !! river sequence maximum [-]
      real              r1paramc(n0l)   !! parameter c [1/s]
      real              r1rivinf(n0l)   !! river inflow [kg/s]
      real              r1spn(n0l)
c namelist
      character*128     c0setriv        !! setting file for river model
      namelist         /setriv/ c0qtot,   c0rivstoini,
     $                          c0rivsto, c0rivout,
     $                          c0rivseq, c0rivnxl,
     $                          c0rivnxd, c0lndara,
     $                          c0flwvel, c0medrat,
     $                          i0ldbg,   i0secint, 
     $                          i0yearmin,i0yearmax,
     $                          i0spnflg, r0spnerr,
     $                          r0spnrat
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Get arguments
c - check the number of arguments
c - get arguments
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(iargc().ne.1) then
        write(*,*) 'Usage: main c0setriv'
        stop
      end if
c
      call getarg(1, c0setriv)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Initialize
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c out
      r1rivout=0.0
      r2rivout=0.0
c local
      i0yearmin_dummy=0
      i0yearmax_dummy=0
      r0rivseqmax=0.0
      r1paramc=0.0
      r1rivinf=0.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Read namelists
c - read c0setriv
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      open(15,file=c0setriv)
      read(15,nml=setriv)
      close(15)
      write(*,*) 'main: --- Read namelist ---------------------------'
      write(*,nml=setriv)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Read fixed fields
c - read maps
c - set r0rivseqmax by finding the maximum value of r1rivseq
c - set r1paramc by calculation
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call read_binary(n0l,c0rivseq,r1rivseq)
      call read_binary(n0l,c0rivnxl,r1rivnxl)
      call read_binary(n0l,c0rivnxd,r1rivnxd)
      call read_binary(n0l,c0lndara,r1lndara)
      call read_binary(n0l,c0flwvel,r1flwvel)
      call read_binary(n0l,c0medrat,r1medrat)
c
      r0rivseqmax=0.0
      do i0l=1,n0l
        r0rivseqmax=max(r1rivseq(i0l),r0rivseqmax)
      end do
d     write(*,*) r0rivseqmax
c
      do i0l=1,n0l
        if (r1rivnxd(i0l).gt.0.0) then
          r1paramc(i0l)=r1flwvel(i0l)/(r1rivnxd(i0l)*r1medrat(i0l))
        else
          r1paramc(i0l)=p0mis
        end if
      end do
d     write(*,*) 'fixed fields fin'
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Initialize state variables
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      call read_binary(n0l,c0rivstoini,r1rivsto)
      call read_binary(n0l,c0rivstoini,r1rivsto_pr)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Calculate
c - set the start and end year of the loop
c - save the storage at the begining of the loop (for spinup)
c - the loop starts
c - read input (runoff)
c - calculate
c - write output (discharge and storage)
c - the loop ends
c - Judge spinup
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
 10   do i0l=1,n0l
        r1spn(i0l)=r1rivsto(i0l)
      end do
c
      if(i0spnflg.eq.0)then
        i0yearmin_dummy=i0yearmin
        i0yearmax_dummy=i0yearmin
      else
        i0yearmin_dummy=i0yearmin
        i0yearmax_dummy=i0yearmax
      end if
c     
      do i0year=i0yearmin_dummy,i0yearmax_dummy
        do i0mon=1,12
          do i0day=1,igetday(i0year,i0mon)
            do i0sec=i0secint,n0secday,i0secint
              write(*,*) i0year,i0mon,i0day,i0sec
c 
              call read_result(
     $             n0l,
     $             c0qtot,      i0year,     i0mon,
     $             i0day,       i0sec,      i0secint,
     $             r1qtot)
c 
              call calc_outflw(
     $             n0l,
     $             i0secint,    r1rivseq,    r0rivseqmax, 
     $             r1rivnxl,    r1lndara,    r1paramc,
     $             r1rivsto_pr, r1qtot,
     $             r1rivsto,    r1rivinf,    r1rivout)
c 
              c0opt='ave'
              call wrte_bints2(
     $             n0l,n0t,
     $             r1rivout,    r2rivout,
     $             c0rivout,    i0year,      i0mon,
     $             i0day,       i0sec,       i0secint,
     $             c0opt)
              c0opt='sta'
              call wrte_bints2(
     $             n0l,n0t,
     $             r1rivsto,    r2rivsto,
     $             c0rivsto,    i0year,      i0mon,
     $             i0day,       i0sec,       i0secint,
     $             c0opt)
c
              do i0l=1,n0l
                r1rivsto_pr(i0l)=r1rivsto(i0l)
              end do
c
            end do
          end do
        end do
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Spinup
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(i0spnflg.eq.0)then
        call calc_spinup(
     $       n0l,         i0ldbg,
     $       r0spnerr,    r0spnrat,
     $       r1rivsto,    r1spn,
     $       i0spnflg)
        if (i0spnflg.eq.0) then
          write(*,*) 'main: Again spin up'
        else
          write(*,*) 'main: End spin up.'
          c0opt='spn'
          call wrte_bints2(n0l,n0t,
     $         r1tmp,       r2rivsto,  c0rivsto,
     $         i0yearmin-1,12,31,n0secday,i0secint,
     $         c0opt)
        end if
        go to 10
      end if
c
      end


