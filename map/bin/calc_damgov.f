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
      program calc_damgov
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cto   calculate dam governing area
cby   2010/09/30, hanasaki, NIES: H08ver1.0
c     Copyright (C) 2010,2011 Naota Hanasaki
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      implicit none
c parameter (array)
      integer           n0l
c index (array)
      integer           i0l
      integer           i0seq
c function
      integer           iargc
      character*128     cgetfnl
c temporary
      character*128     c0tmp
      real,allocatable::r1tmp(:)
      character*128     c0ifname
      character*128     c0ofname
c in (set)
      integer           i0damdbg
      integer           i0cntmax
c in
      integer,allocatable::i1rivnxl(:)    !! river downstream
      integer,allocatable::i1rivseq(:)    !! river sequence
      integer,allocatable::i1damid_(:)    !! dam ID
      real,allocatable::r1damcap(:)
      real,allocatable::r1damnum(:)
      character*128     c0rivnxl
      character*128     c0rivseq
      character*128     c0damid_
      character*128     c0damcap
      character*128     c0damnum
c out
      real,allocatable::r1damd2s(:)    !! governing area(dam to sea)
      real,allocatable::r1damd2d(:)    !! governing area(dam to dam)
      real,allocatable::r1damup_(:)
      real,allocatable::r1damupc(:)
      character*128     c0damd2s
      character*128     c0damd2d
      character*128     c0damup_
      character*128     c0damupc
c local
      integer           i0l_dummy
      integer           i0ldbg
      integer           i0rivseqmax
      integer           i0cnt
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(iargc().ne.12)then
        write(*,*) 'calc_damgov n0l      i0damdbg i0cntmax c0rivnxl '
        write(*,*) '            c0rivseq c0damid_ c0damnum c0damcap '
        write(*,*) '            c0damd2s c0damd2d c0damup_ c0damupc '
        stop
      end if
c
      call getarg(1,c0tmp)
      read(c0tmp,*) n0l
      call getarg(2,c0tmp)
      read(c0tmp,*) i0damdbg
      call getarg(3,c0tmp)
      read(c0tmp,*) i0cntmax
      call getarg(4,c0rivnxl)
      call getarg(5,c0rivseq)
      call getarg(6,c0damid_)
      call getarg(7,c0damnum)
      call getarg(8,c0damcap)
      call getarg(9,c0damd2s)
      call getarg(10,c0damd2d)
      call getarg(11,c0damup_)
      call getarg(12,c0damupc)
c
      allocate(i1rivnxl(n0l))
      allocate(i1rivseq(n0l))
      allocate(i1damid_(n0l))
      allocate(r1damnum(n0l))
      allocate(r1damcap(n0l))
      allocate(r1damd2s(n0l))
      allocate(r1damd2d(n0l))
      allocate(r1damup_(n0l))
      allocate(r1damupc(n0l))
      allocate(r1tmp(n0l))
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Initialize
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c out
      r1damd2s=0.0
      r1damd2d=0.0
      r1damup_=0.0
      r1damupc=0.0
c local
      i0l_dummy=0
      i0ldbg=0
      i0rivseqmax=0
      i0cnt=0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Read
c - Num of dams in a grid
c - Dam capacity
c - Dam ID
c - Downstream l coordinate
c - River sequence
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      call read_binary(n0l,c0damnum,r1damnum)
c 
      call read_binary(n0l,c0damcap,r1damcap)
c 
      call read_binary(n0l,c0damid_,r1tmp)
      do i0l=1,n0l
        i1damid_(i0l)=int(r1tmp(i0l))
      end do
c
      call read_binary(n0l,c0rivnxl,r1tmp)
      do i0l=1,n0l
        i1rivnxl(i0l)=int(r1tmp(i0l))
      end do      
c
      call read_binary(n0l,c0rivseq,r1tmp)
      do i0l=1,n0l
        i1rivseq(i0l)=int(r1tmp(i0l))
      end do
      i0rivseqmax=0
      do i0l=1,n0l
        i0rivseqmax=max(i1rivseq(i0l),i0rivseqmax)
      end do      
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Calc1: Dam governing area (dam to sea)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0l=1,n0l
        if(i1damid_(i0l).ne.0)then
          write(*,*) 'Detecting governing area of',i1damid_(i0l)
c refresh
          i0l_dummy=i0l
          i0cnt=0
          r1damd2s=0.0
c iteration
 30       r1damd2s(i0l_dummy)=real(i1damid_(i0l))
          i0cnt=i0cnt+1
          if(i1rivnxl(i0l_dummy).ne.i0l_dummy.and.
     $       i1rivnxl(i0l_dummy).ne.0)then
            i0l_dummy=i1rivnxl(i0l_dummy)
            goto 30
          else
            write(*,*) i1damid_(i0l),' has',i0cnt,'gov. grids'
            c0ofname=cgetfnl(c0damd2s,i1damid_(i0l))
            call wrte_binary(n0l,r1damd2s,c0ofname)
          end if
        end if
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Calc2: Dam covering area (dam to dam)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0l=1,n0l
        if(i1damid_(i0l).ne.0)then
          write(*,*) 'Detecting governing area of',i1damid_(i0l)
c refresh
          i0l_dummy=i0l
          i0cnt=0
          r1damd2d=0.0
c iteration
 40       r1damd2d(i0l_dummy)=real(i1damid_(i0l))
          i0cnt=i0cnt+1
          if(i1rivnxl(i0l_dummy).ne.i0l_dummy.and.
     $       i1rivnxl(i0l_dummy).ne.0)then
            i0l_dummy=i1rivnxl(i0l_dummy)
            if(i1damid_(i0l_dummy).eq.0.and.i0cnt.lt.i0cntmax)then
              goto 40
            else
              goto 50
            end if
          else
 50         write(*,*) i1damid_(i0l),' has',i0cnt,'cov. grids'
            c0ofname=cgetfnl(c0damd2d,i1damid_(i0l))
            call wrte_binary(n0l,r1damd2d,c0ofname)
          end if
        end if
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Calc3: how many dams in upperstreams
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0seq=1,i0rivseqmax
        do i0l=1,n0l
          if(i1rivseq(i0l).eq.i0seq)then
            r1damup_(i0l)=r1damup_(i0l)+r1damnum(i0l)
            r1damupc(i0l)=r1damupc(i0l)+r1damcap(i0l)
            if(i1rivnxl(i0l).ne.0)then
              r1damup_(i1rivnxl(i0l))
     &             =r1damup_(i1rivnxl(i0l))+r1damup_(i0l)
              r1damupc(i1rivnxl(i0l))
     $             =r1damupc(i1rivnxl(i0l))+r1damupc(i0l)
            end if
          end if
        end do
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Write
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      call wrte_binary(n0l,r1damup_,c0damup_)
      call wrte_binary(n0l,r1damupc,c0damupc)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Check
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0l=1,n0l
        if(i1damid_(i0l).eq.i0damdbg)then
          i0ldbg=i0l
        end if
      end do
c
      write(*,*) '########################################'
      write(*,*) 'Debugging point',' [',i0ldbg,']'
      write(*,*) '########################################'
      write(*,*) 
      write(*,*) 'Input'
      write(*,*) 'calc_damgov: i1rivseq(i0ldbg)',i1rivseq(i0ldbg)
      write(*,*) 'calc_damgov: i1damid_(i0ldbg)',i1damid_(i0ldbg)
      write(*,*) 'calc_damgov: r1damnum(i0ldbg)',r1damnum(i0ldbg)
      write(*,*) 
      write(*,*) 'Output'
c
      c0ifname=cgetfnl(c0damd2s,i0damdbg)
      call read_binary(n0l,c0ifname,r1damd2s)
c
      c0ifname=cgetfnl(c0damd2d,i0damdbg)
      call read_binary(n0l,c0ifname,r1damd2d)
c
      write(*,*) 'Num of res in upper stream',r1damup_(i0damdbg)
      write(*,*) 
      write(*,*) 'Notes'
c
      do i0l=1,n0l
        if(r1damd2s(i0l).ne.0)then
          write(*,*) i1damid_(i0ldbg),' governs (dam-sea)',i0l
        end if
      end do
c
      do i0l=1,n0l
        if(r1damd2d(i0l).ne.0)then
          write(*,*) i1damid_(i0ldbg),' governs (dam-dam)',i0l
        end if
      end do
c
      end
