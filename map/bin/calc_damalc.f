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
      program calc_damalc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cto   calculate alocation coefficient 
cby   2010/09/30,hanasaki,NIES: H08ver1.0
c     Copyright (C) 2010,2011 Naota Hanasaki
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      implicit none
c parameters (array)
      integer           n0l
      integer           n0rec
c parameters (default)
      real              p0maxini
      parameter        (p0maxini=-9.9E20) 
c index (array)
      integer           i0l
      integer           i0rec
c index (time)      
      integer           i0year
c temporary
      real,allocatable::r1tmp(:)
      character*128     c0tmp
      character*128     c0ifname
      character*128     c0ofname
      character*128     c0opt
c function
      integer           iargc
      character*128     cgetfnt
      character*128     cgetfnl
c in (set)
      integer           i0damdbg
c in (map)
      integer,allocatable::i1damid_(:)   !! id of dam
      integer,allocatable::i1damprp(:)   !! purpose of dam
      integer,allocatable::i2damcov(:,:) !! governing cells of dam
      real,allocatable::r1rivout(:)      !! annual river discharge
      character*128     c0damid_
      character*128     c0damprp
      character*128     c0damcov
      character*128     c0rivout
c out
      real,allocatable::r2damalc(:,:)    !! demand allocation for dam
      real,allocatable::r1damdom(:)
      character*128     c0damalc
      character*128     c0damdom
c local
      integer           i0ldbg           !! debuging point
      integer           i0recdbg         !! debuging point
      integer           i0recmax         !! maximum num of record
      integer,allocatable::i1rec2l(:)    !! 
      integer,allocatable::i1flgcal(:)   !! calculation flag
      real,allocatable::r1rivall(:)      !! discharge at reservoirs in upstream
      real,allocatable::r1damalcmax(:)   !! dam allocate max
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Get arguments
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(iargc().ne.11)then
        write(*,*) 'calc_damalc n0l n0rec i0year i0damdbg c0opt'
        write(*,*) '            c0damid_ c0damprp c0damcov c0rivout'
        write(*,*) '            c0damalc c0damdom'
        write(*,*) 'c0opt: all or irg'
        stop
      end if
c
      call getarg(1,c0tmp)
      read(c0tmp,*) n0l
      call getarg(2,c0tmp)
      read(c0tmp,*) n0rec
      call getarg(3,c0tmp)
      read(c0tmp,*) i0year
      call getarg(4,c0tmp)
      read(c0tmp,*) i0damdbg
      call getarg(5,c0opt)
      call getarg(6,c0damid_)
      call getarg(7,c0damprp)
      call getarg(8,c0damcov)
      call getarg(9,c0rivout)
      call getarg(10,c0damalc)
      call getarg(11,c0damdom)
c
      allocate(r1tmp(n0l))
      allocate(i1rec2l(n0l))
      allocate(i1damid_(n0l))
      allocate(i1damprp(n0l))
      allocate(i2damcov(n0l,n0rec))
      allocate(r1rivout(n0l))
      allocate(r2damalc(n0l,n0rec))
      allocate(i1flgcal(n0l))
      allocate(r1rivall(n0l))
      allocate(r1damalcmax(n0l))
      allocate(r1damdom(n0l))
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Initialize
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c out
      r2damalc=0.0
c local
      i0ldbg=1
      i0recdbg=1
      i0recmax=0
      i1rec2l=0
      i1flgcal=0
      r1rivall=0.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Read dam list
c - Annual discharge
c - Dam purpose
c - Select reservoirs to calculate (i1flgcal=1 means to calculate)
c - Dam ID
c - Irrigation dam coverage
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      call read_binary(n0l,c0damid_,r1tmp)
      do i0l=1,n0l
        i1damid_(i0l)=int(r1tmp(i0l))
      end do
c
      do i0l=1,n0l
        if(i1damid_(i0l).eq.i0damdbg)then
          i0ldbg=i0l
        end if
      end do
      write(*,*) 'calc_damalc: i0ldbg  :',i0ldbg
      write(*,*) 'calc_damalc: i1damid_:',i1damid_(i0ldbg)
c
      c0ifname=cgetfnt(c0rivout,i0year,0,0,0)
      call read_binary(n0l,c0ifname,r1rivout)
      write(*,*) 'calc_damalc: r1rivout:',r1rivout(i0ldbg)
c
      call read_binary(n0l,c0damprp,r1tmp)
      do i0l=1,n0l
        i1damprp(i0l)=int(r1tmp(i0l))
      end do
      write(*,*) 'calc_damalc: i1damprp: ',i1damprp(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Flags for calculation
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      i1flgcal=0
      if(c0opt.eq.'all')then
        do i0l=1,n0l
          if(i1damid_(i0l).gt.0)then
            i1flgcal(i0l)=1
          end if
        end do
      else if (c0opt.eq.'irg')then
        do i0l=1,n0l
          if(i1damprp(i0l).eq.4)then
            i1flgcal(i0l)=1
          end if
        end do
      else
        write(*,*) 'calc_damalc: c0opt:',c0opt,' not supported. Abort.'
        stop
      end if
c 
      i0rec=0
      do i0l=1,n0l
        if(i1flgcal(i0l).eq.1)then
          i0rec=i0rec+1
          i1rec2l(i0rec)=i0l
          if(i0l.eq.i0ldbg)then
            i0recdbg=i0rec
          end if
        end if
      end do
      i0recmax=i0rec
      write(*,*) 'calc_damalc: i0recdbg: ', i0recdbg
c 
      do i0rec=1,i0recmax
        c0ifname=cgetfnl(c0damcov,i1damid_(i1rec2l(i0rec)))
        if(i0rec.eq.i0recdbg)then
          write(*,*) c0ifname
        end if
        call read_binary(n0l,c0ifname,r1tmp)
        do i0l=1,n0l
          i2damcov(i0l,i0rec)=int(r1tmp(i0l))
        end do
      end do
      write(*,*) 'calc_damalc: i1rec2l:  ', i1rec2l(i0recdbg)
      write(*,*) 'calc_damalc: i1damid:  ', i1damid_(i1rec2l(i0recdbg))
      write(*,*) 'calc_damalc: i2damcov: ', i2damcov(i0ldbg,i0recdbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Calculation
c - 
c - 
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      r1rivall=0.0
      do i0rec=1,i0recmax
        do i0l=1,n0l
          if(i2damcov(i0l,i0rec).ne.0)then
            r1rivall(i0l)=r1rivall(i0l)+r1rivout(i1rec2l(i0rec))
          end if
        end do
      end do
      write(*,*) 'calc_damalc: r1rivall: ', r1rivall(i0ldbg)
c
      r2damalc=0.0
      do i0rec=1,i0recmax
        do i0l=1,n0l
          if(i2damcov(i0l,i0rec).ne.0.and.r1rivall(i0l).gt.0.0)then
            r2damalc(i0l,i0rec)=r1rivout(i1rec2l(i0rec))/r1rivall(i0l)
          end if
        end do
      end do
c
      r1damalcmax=p0maxini
      r1damdom=0.0
      do i0l=1,n0l
        do i0rec=1,i0recmax
          if(r2damalc(i0l,i0rec).ne.0.0)then
            if(r2damalc(i0l,i0rec).gt.r1damalcmax(i0l))then
              r1damalcmax(i0l)=r2damalc(i0l,i0rec)
              r1damdom(i0l)=real(i1damid_(i1rec2l(i0rec)))
            end if
          end if
        end do
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Write result
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0rec=1,i0recmax
        c0ofname=cgetfnl(c0damalc,i1damid_(i1rec2l(i0rec)))
        do i0l=1,n0l
          r1tmp(i0l)=r2damalc(i0l,i0rec)
        end do
        call wrte_binary(n0l,r1tmp,c0ofname)
      end do
c
      call wrte_binary(n0l,r1damdom,c0damdom)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Check
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      write(*,*) '########################################'
      write(*,*) 'Debugging point [',i0ldbg,' ]'
      write(*,*) '########################################'
c
      write(*,*) 'calc_damalc: Input'
      write(*,*) 'calc_damalc: r1rivout: ',r1rivout(i0ldbg)
      write(*,*) 'calc_damalc: i1damprp: ',i1damprp(i0ldbg)
      write(*,*) 'calc_damalc: i1damid_: ',i1damid_(i0ldbg)
c
      write(*,*) 'calc_damalc: Output'
      write(*,*) 'calc_damalc: i0recmax: ',i0recmax
      write(*,*) 'calc_damalc: r1rivall: ',r1rivall(i0ldbg)
c
      end



