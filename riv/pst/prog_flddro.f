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
      program prog_flddro
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cto   calculate flood season and drought season in simulations
cby   2010/09/30, hanasaki, NIES: H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      implicit none
c parameter (array)
      integer           n0l
c parameter (physical)
      integer           n0secday
      parameter        (n0secday=86400) 
c parameter (default)
      real              p0mis            !! missing value
      parameter        (p0mis=1.0E20)
c index (array)
      integer           i0l
c index (time)
      integer           i0year           !! year (4digit)
      integer           i0mon            !! month
c temporary
      integer           i0tmp
      real,allocatable::r1tmp(:)
      character*128     c0ifname
      character*128     c0ofname
      character*128     c0tmp
c function
      integer           igetday
      integer           iargc
      character*128     cgetfnt
c input (set)
      integer           i0ldbg           !! debuging point
c input (flux)
      real,allocatable::r2rivout(:,:)    !! river discharge
      character*128     c0rivoutmon
      character*128     c0rivoutanu
c output
      integer,allocatable::i2flgfld(:,:) !! flag of fld month
      integer,allocatable::i1fld2dro(:)  !! 1st month of dro
      integer,allocatable::i1dro2fld(:)  !! 1st month of fld
      integer,allocatable::i1flddur(:)   !! duration of fld
      real,allocatable::r1fldrat(:)      !! ratio fld dis/anu dis
      character*128     c0flgfld
      character*128     c0fld2dro
      character*128     c0dro2fld
      character*128     c0flddur
      character*128     c0fldrat
c local
      real,allocatable::r1flddis(:)      !! discharge of fld season
      real,allocatable::r2monrat(:,:)    !! mon dis/ann dis
      real,allocatable::r2fldsco(:,:)    !! scoring
      real,allocatable::r1fldscomax(:)   !! scoring
      integer,allocatable::i2fldend(:,:) !! scoring
      integer           i0monadd
      integer           i0mon_dummy
c
      integer           i1monprepre(12)
      integer           i1monpre(12)
      integer           i1monnxt(12)
      integer           i1monnxtnxt(12)
      data              i1monprepre/11,12,1,2,3,4,5,6,7,8,9,10/
      data              i1monpre      /12,1,2,3,4,5,6,7,8,9,10,11/
      data              i1monnxt         /2,3,4,5,6,7,8,9,10,11,12,1/
      data              i1monnxtnxt      /3,4,5,6,7,8,9,10,11,12,1,2/
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Get argument
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(iargc().ne.10)then
       write(*,*) 'Usage: prog_flddro l year ldbg'
       write(*,*) '                   rivout  rivout'
       write(*,*) '                   flgfld fld2dro dro2fld'
       write(*,*) '                   flddur  fldrat'
       stop
      end if
c
      call getarg(1,c0tmp)
      read(c0tmp,*) n0l
      call getarg(2,c0tmp)
      read(c0tmp,*) i0year
      call getarg(3,c0tmp)
      read(c0tmp,*) i0ldbg
      call getarg(4,c0rivoutmon)
      call getarg(5,c0rivoutanu)
      call getarg(6,c0flgfld)
      call getarg(7,c0fld2dro)
      call getarg(8,c0dro2fld)
      call getarg(9,c0flddur)
      call getarg(10,c0fldrat)
c
      allocate(r2rivout(n0l,0:12))
      allocate(i2flgfld(n0l,12))
      allocate(i1fld2dro(n0l)) 
      allocate(i1dro2fld(n0l))  
      allocate(i1flddur(n0l))  
      allocate(r1fldrat(n0l))
      allocate(r1flddis(n0l))
      allocate(r2monrat(n0l,12))
      allocate(r2fldsco(n0l,12))
      allocate(r1fldscomax(n0l))
      allocate(i2fldend(n0l,12))
      allocate(r1tmp(n0l))
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Read file
c - monthly discharge
c - annual discharge
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0mon=1,12
        call read_result(
     $       n0l,
     $       c0rivoutmon,i0year,i0mon,
     $       0,      0, n0secday,
     $       r1tmp)
        do i0l=1,n0l
          r2rivout(i0l,i0mon)=r1tmp(i0l)
        end do
      end do
c
      call read_result(
     $     n0l,
     $     c0rivoutanu,i0year,0,
     $     0,      0, n0secday,
     $     r1tmp)
      do i0l=1,n0l
        r2rivout(i0l,0)=r1tmp(i0l)
      end do
c
d     write(*,*) 'prog_flddro: r2rivout(i0ldbg,1): ',r2rivout(i0ldbg,1)
d     write(*,*) 'prog_flddro: r2rivout(i0ldbg,2): ',r2rivout(i0ldbg,2)
d     write(*,*) 'prog_flddro: r2rivout(i0ldbg,3): ',r2rivout(i0ldbg,3)
d     write(*,*) 'prog_flddro: r2rivout(i0ldbg,4): ',r2rivout(i0ldbg,4)
d     write(*,*) 'prog_flddro: r2rivout(i0ldbg,5): ',r2rivout(i0ldbg,5)
d     write(*,*) 'prog_flddro: r2rivout(i0ldbg,6): ',r2rivout(i0ldbg,6)
d     write(*,*) 'prog_flddro: r2rivout(i0ldbg,7): ',r2rivout(i0ldbg,7)
d     write(*,*) 'prog_flddro: r2rivout(i0ldbg,8): ',r2rivout(i0ldbg,8)
d     write(*,*) 'prog_flddro: r2rivout(i0ldbg,9): ',r2rivout(i0ldbg,9)
d     write(*,*) 'prog_flddro: r2rivout(i0ldbg,10):',r2rivout(i0ldbg,10)
d     write(*,*) 'prog_flddro: r2rivout(i0ldbg,11):',r2rivout(i0ldbg,11)
d     write(*,*) 'prog_flddro: r2rivout(i0ldbg,12):',r2rivout(i0ldbg,12)
d     write(*,*) 'prog_flddro: r2rivout(i0ldbg,0): ',r2rivout(i0ldbg,0)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Monthly dis / Annual dis
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0mon=1,12
        do i0l=1,n0l
          if(r2rivout(i0l,i0mon).ne.p0mis.and.
     $       r2rivout(i0l,0).ne.p0mis.and.r2rivout(i0l,0).ne.0.0)then
            r2monrat(i0l,i0mon)=r2rivout(i0l,i0mon)/r2rivout(i0l,0)
          else
            r2monrat(i0l,i0mon)=p0mis
          end if
        end do
      end do
c debug
d     write(*,*) 'prog_flddro: r2monrat(i0ldbg,1): ',r2monrat(i0ldbg,1)
d     write(*,*) 'prog_flddro: r2monrat(i0ldbg,2): ',r2monrat(i0ldbg,2)
d     write(*,*) 'prog_flddro: r2monrat(i0ldbg,3): ',r2monrat(i0ldbg,3)
d     write(*,*) 'prog_flddro: r2monrat(i0ldbg,4): ',r2monrat(i0ldbg,4)
d     write(*,*) 'prog_flddro: r2monrat(i0ldbg,5): ',r2monrat(i0ldbg,5)
d     write(*,*) 'prog_flddro: r2monrat(i0ldbg,6): ',r2monrat(i0ldbg,6)
d     write(*,*) 'prog_flddro: r2monrat(i0ldbg,7): ',r2monrat(i0ldbg,7)
d     write(*,*) 'prog_flddro: r2monrat(i0ldbg,8): ',r2monrat(i0ldbg,8)
d     write(*,*) 'prog_flddro: r2monrat(i0ldbg,9): ',r2monrat(i0ldbg,9)
d     write(*,*) 'prog_flddro: r2monrat(i0ldbg,10):',r2monrat(i0ldbg,10)
d     write(*,*) 'prog_flddro: r2monrat(i0ldbg,11):',r2monrat(i0ldbg,11)
d     write(*,*) 'prog_flddro: r2monrat(i0ldbg,12):',r2monrat(i0ldbg,12)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Define Dro/Fld (fld:dis>ave,dro:dis<ave)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0mon=1,12
        do i0l=1,n0l
          if(r2monrat(i0l,i0mon).ne.p0mis)then
            if(r2monrat(i0l,i0mon).ge.1.0)then
              i2flgfld(i0l,i0mon)=1
            else
              i2flgfld(i0l,i0mon)=0
            end if
          end if
        end do
      end do
c debug
d     write(*,*) 'prog_flddro: i2flgfld(i0ldbg,1): ',i2flgfld(i0ldbg,1)
d     write(*,*) 'prog_flddro: i2flgfld(i0ldbg,2): ',i2flgfld(i0ldbg,2)
d     write(*,*) 'prog_flddro: i2flgfld(i0ldbg,3): ',i2flgfld(i0ldbg,3)
d     write(*,*) 'prog_flddro: i2flgfld(i0ldbg,4): ',i2flgfld(i0ldbg,4)
d     write(*,*) 'prog_flddro: i2flgfld(i0ldbg,5): ',i2flgfld(i0ldbg,5)
d     write(*,*) 'prog_flddro: i2flgfld(i0ldbg,6): ',i2flgfld(i0ldbg,6)
d     write(*,*) 'prog_flddro: i2flgfld(i0ldbg,7): ',i2flgfld(i0ldbg,7)
d     write(*,*) 'prog_flddro: i2flgfld(i0ldbg,8): ',i2flgfld(i0ldbg,8)
d     write(*,*) 'prog_flddro: i2flgfld(i0ldbg,9): ',i2flgfld(i0ldbg,9)
d     write(*,*) 'prog_flddro: i2flgfld(i0ldbg,10):',i2flgfld(i0ldbg,10)
d     write(*,*) 'prog_flddro: i2flgfld(i0ldbg,11):',i2flgfld(i0ldbg,11)
d     write(*,*) 'prog_flddro: i2flgfld(i0ldbg,12):',i2flgfld(i0ldbg,12)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Remove hollow
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0mon=1,12
        do i0l=1,n0l
c no need            if(i1drodurmax(i0l).ne.1)then
          if(r2rivout(i0l,0).ne.0.0)then
            if(i2flgfld(i0l,i0mon).eq.0
     $    .and.i2flgfld(i0l,i1monprepre(i0mon)).eq.1
     $    .and.i2flgfld(i0l,i1monpre(i0mon)).eq.1
     $    .and.i2flgfld(i0l,i1monnxt(i0mon)).eq.1
c bug     $      .and.i2flgfld(i0l,i1monprepre(i0mon)).eq.1)then
     $    .and.i2flgfld(i0l,i1monnxtnxt(i0mon)).eq.1)then
              i2flgfld(i0l,i0mon)=1
            end if
          end if
        end do
      end do
      do i0mon=1,12
        do i0l=1,n0l
c no need            if(iflddurmax(i0l).ne.1)then
          if(r2rivout(i0l,0).ne.0.0)then
            if(i2flgfld(i0l,i0mon).eq.1
     $    .and.i2flgfld(i0l,i1monprepre(i0mon)).eq.0
     $    .and.i2flgfld(i0l,i1monpre(i0mon)).eq.0
     $    .and.i2flgfld(i0l,i1monnxt(i0mon)).eq.0
c bug     $      .and.i2flgfld(i0l,i1monprepre(i0mon)).eq.0)then
     $    .and.i2flgfld(i0l,i1monnxtnxt(i0mon)).eq.0)then
              i2flgfld(i0l,i0mon)=0
            end if
          end if
        end do
      end do
c debug
d     write(*,*) 'prog_flddro: i2flgfld(i0ldbg,1): ',i2flgfld(i0ldbg,1)
d     write(*,*) 'prog_flddro: i2flgfld(i0ldbg,2): ',i2flgfld(i0ldbg,2)
d     write(*,*) 'prog_flddro: i2flgfld(i0ldbg,3): ',i2flgfld(i0ldbg,3)
d     write(*,*) 'prog_flddro: i2flgfld(i0ldbg,4): ',i2flgfld(i0ldbg,4)
d     write(*,*) 'prog_flddro: i2flgfld(i0ldbg,5): ',i2flgfld(i0ldbg,5)
d     write(*,*) 'prog_flddro: i2flgfld(i0ldbg,6): ',i2flgfld(i0ldbg,6)
d     write(*,*) 'prog_flddro: i2flgfld(i0ldbg,7): ',i2flgfld(i0ldbg,7)
d     write(*,*) 'prog_flddro: i2flgfld(i0ldbg,8): ',i2flgfld(i0ldbg,8)
d     write(*,*) 'prog_flddro: i2flgfld(i0ldbg,9): ',i2flgfld(i0ldbg,9)
d     write(*,*) 'prog_flddro: i2flgfld(i0ldbg,10):',i2flgfld(i0ldbg,10)
d     write(*,*) 'prog_flddro: i2flgfld(i0ldbg,11):',i2flgfld(i0ldbg,11)
d     write(*,*) 'prog_flddro: i2flgfld(i0ldbg,12):',i2flgfld(i0ldbg,12)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Scoring
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0l=1,n0l
        if(r2rivout(i0l,0).gt.0.0)then
          do i0mon=1,12
            if(i2flgfld(i0l,i0mon).eq.1)then
              do i0monadd=0,11
                i0mon_dummy=i0mon+i0monadd
                if(i0mon_dummy.gt.12)then
                  i0mon_dummy=i0mon_dummy-12
                end if
                if(i2flgfld(i0l,i0mon_dummy).eq.1)then
                  r2fldsco(i0l,i0mon)=r2fldsco(i0l,i0mon)
     $                 +r2monrat(i0l,i0mon_dummy)
                  i2fldend(i0l,i0mon)=i0mon_dummy
                else
                  goto 10
                end if
              end do
 10           continue
            end if
          end do
        end if
      end do
d     write(*,*) 'prog_flddro: r2fldsco(i0ldbg,1): ',r2fldsco(i0ldbg,1)
d     write(*,*) 'prog_flddro: r2fldsco(i0ldbg,2): ',r2fldsco(i0ldbg,2)
d     write(*,*) 'prog_flddro: r2fldsco(i0ldbg,3): ',r2fldsco(i0ldbg,3)
d     write(*,*) 'prog_flddro: r2fldsco(i0ldbg,4): ',r2fldsco(i0ldbg,4)
d     write(*,*) 'prog_flddro: r2fldsco(i0ldbg,5): ',r2fldsco(i0ldbg,5)
d     write(*,*) 'prog_flddro: r2fldsco(i0ldbg,6): ',r2fldsco(i0ldbg,6)
d     write(*,*) 'prog_flddro: r2fldsco(i0ldbg,7): ',r2fldsco(i0ldbg,7)
d     write(*,*) 'prog_flddro: r2fldsco(i0ldbg,8): ',r2fldsco(i0ldbg,8)
d     write(*,*) 'prog_flddro: r2fldsco(i0ldbg,9): ',r2fldsco(i0ldbg,9)
d     write(*,*) 'prog_flddro: r2fldsco(i0ldbg,10):',r2fldsco(i0ldbg,10)
d     write(*,*) 'prog_flddro: r2fldsco(i0ldbg,11):',r2fldsco(i0ldbg,11)
d     write(*,*) 'prog_flddro: r2fldsco(i0ldbg,12):',r2fldsco(i0ldbg,12)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Dro/Fld start month (fld:dis>ave,dro:dis<ave)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0l=1,n0l
        if(r2rivout(i0l,0).gt.0.0)then
          do i0mon=1,12
            if(r2fldsco(i0l,i0mon).ge.r1fldscomax(i0l))then
              r1fldscomax(i0l)=r2fldsco(i0l,i0mon)
              i1dro2fld(i0l)=i0mon
              i1fld2dro(i0l)=i2fldend(i0l,i0mon)+1
              if(i1fld2dro(i0l).gt.12)then
                i1fld2dro(i0l)=1
              end if
            end if
          end do
        end if
      end do
c
      write(*,*) 'prog_flddro: i1dro2fld(i0ldbg):',i1dro2fld(i0ldbg)
      write(*,*) 'prog_flddro: i1fld2dro(i0ldbg):',i1fld2dro(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Fld season duration (fld:dis>ave,dro:dis<ave)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0mon=1,12
        do i0l=1,n0l
          if(i1fld2dro(i0l).lt.i1dro2fld(i0l))then
            i1flddur(i0l)=i1fld2dro(i0l)-i1dro2fld(i0l)+12
          else
            i1flddur(i0l)=i1fld2dro(i0l)-i1dro2fld(i0l)
          end if
        end do
      end do
c debug
      write(*,*) 'prog_flddro: i1flddur(i0ldbg):',i1flddur(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Fld season discharge (fld:dis>ave,dro:dis<ave)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0mon=1,12
        do i0l=1,n0l
          if(i2flgfld(i0l,i0mon).eq.1)then
            r1flddis(i0l)=r1flddis(i0l)
     $           +r2rivout(i0l,i0mon)*igetday(i0year,i0mon)*n0secday
          end if
        end do
      end do
c
      do i0l=1,n0l
        if(r2rivout(i0l,0).ne.0)then
          r1fldrat(i0l)
     $         =r1flddis(i0l)
     $         /(r2rivout(i0l,0)*igetday(i0year,0)*n0secday)
        else
          r1fldrat(i0l)=p0mis
        end if
      end do
c debug
      write(*,*) 'prog_flddro: r1rivout(i0ldbg,0): ',
     $     (r2rivout(i0ldbg,0)*igetday(i0year,0)*n0secday)
      write(*,*) 'prog_flddro: r1flddis(i0ldbg): ',r1flddis(i0ldbg)
      write(*,*) 'prog_flddro: r1fldrat(i0ldbg): ',r1fldrat(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Write file
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0mon=1,12
        do i0l=1,n0l
          r1tmp(i0l)=real(i2flgfld(i0l,i0mon))
        end do
        c0ofname=cgetfnt(c0flgfld,i0year,i0mon,0,0)
        call wrte_binary(n0l,r1tmp,c0ofname)
      end do
c
      c0ofname=cgetfnt(c0fld2dro,i0year,0,0,0)
      do i0l=1,n0l
        r1tmp(i0l)=real(i1fld2dro(i0l))
      end do
      call wrte_binary(n0l,r1tmp,c0ofname)
c
      c0ofname=cgetfnt(c0dro2fld,i0year,0,0,0)
      do i0l=1,n0l
        r1tmp(i0l)=real(i1dro2fld(i0l))
      end do
      call wrte_binary(n0l,r1tmp,c0ofname)
c
      c0ofname=cgetfnt(c0flddur,i0year,0,0,0)
      do i0l=1,n0l
        r1tmp(i0l)=real(i1flddur(i0l))
      end do
      call wrte_binary(n0l,r1tmp,c0ofname)
c
      c0ofname=cgetfnt(c0fldrat,i0year,0,0,0)
      call wrte_binary(n0l,r1fldrat,c0ofname)
c
      end
