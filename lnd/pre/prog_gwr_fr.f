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
      program prog_gwr_fr
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c
      integer           n0l
      real              p0mis
      parameter        (p0mis=1.0E20) 
c index
      integer           i0l
      integer           i0cls
c temporary
      real,allocatable::r1tmp(:)
      character*128     c0tmp
c in
      real,allocatable::r2cls(:,:)
      character*128     c1cls(8)
c out
      real,allocatable::r1fr(:)
      real,allocatable::r1sco(:)
      character*128     c0fr
      character*128     c0sco
c local
      real              r1lut(7)
      data              r1lut/1.00,0.95,0.90,0.75,0.60,0.30,0.15/ 
      integer           i0ldbg
c      data              i0ldbg/79112/ 
      data              i0ldbg/1/ 
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c get argument
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if (iargc().ne.11) then
        write(6,*) 'Usage: prog_gwr_fr n0l c0if1-8 c0of c0sco'
        stop
      end if
c
      call getarg(1,c0tmp)
      read(c0tmp,*) n0l
      call getarg(2,c1cls(1))
      call getarg(3,c1cls(2))
      call getarg(4,c1cls(3))
      call getarg(5,c1cls(4))
      call getarg(6,c1cls(5))
      call getarg(7,c1cls(6))
      call getarg(8,c1cls(7))
      call getarg(9,c1cls(8))
      call getarg(10,c0fr)
      call getarg(11,c0sco)
c
      allocate(r2cls(7,n0l))
      allocate(r1tmp(n0l))
      allocate(r1sco(n0l))
      allocate(r1fr(n0l))
c
      r2cls=0.0
      r1tmp=0.0
      r1sco=0.0
      r1fr=1.0
c
      write(*,*) '[prog_gwr_fr] c1cls(1)',c1cls(1)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c read
c
c caution Doll and Fiedler classified slope into 7, 
c while FAO HWSD did into 8
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call read_binary(n0l,c1cls(1),r1tmp)
      do i0l=1,n0l
c bug        if(r1tmp(i0l).ne.p0mis)then
        if(r1tmp(i0l).ne.p0mis.and.r1tmp(i0l).ge.0.0)then
          r2cls(1,i0l)=r1tmp(i0l)
        end if
      end do
c
      call read_binary(n0l,c1cls(2),r1tmp)
      do i0l=1,n0l
c bug (2020/08/05,hanasaki)        if(r1tmp(i0l).ne.p0mis)then
        if(r1tmp(i0l).ne.p0mis.and.r1tmp(i0l).ge.0.0)then
          r2cls(1,i0l)=r2cls(1,i0l)+r1tmp(i0l)
        end if
      end do
c
      call read_binary(n0l,c1cls(3),r1tmp)
      do i0l=1,n0l
c bug (2020/08/05,hanasaki)        if(r1tmp(i0l).ne.p0mis)then
        if(r1tmp(i0l).ne.p0mis.and.r1tmp(i0l).ge.0.0)then
          r2cls(2,i0l)=r1tmp(i0l)
        end if
      end do
c
      call read_binary(n0l,c1cls(4),r1tmp)
      do i0l=1,n0l
c bug (2020/08/05,hanasaki)        if(r1tmp(i0l).ne.p0mis)then
        if(r1tmp(i0l).ne.p0mis.and.r1tmp(i0l).ge.0.0)then
          r2cls(3,i0l)=r1tmp(i0l)
        end if
      end do
c
      call read_binary(n0l,c1cls(5),r1tmp)
      do i0l=1,n0l
c bug (2020/08/05,hanasaki)        if(r1tmp(i0l).ne.p0mis)then
        if(r1tmp(i0l).ne.p0mis.and.r1tmp(i0l).ge.0.0)then
          r2cls(4,i0l)=r1tmp(i0l)
        end if
      end do
c
      call read_binary(n0l,c1cls(6),r1tmp)
      do i0l=1,n0l
c bug (2020/08/05,hanasaki)        if(r1tmp(i0l).ne.p0mis)then
        if(r1tmp(i0l).ne.p0mis.and.r1tmp(i0l).ge.0.0)then
          r2cls(5,i0l)=r1tmp(i0l)
        end if
      end do
c
      call read_binary(n0l,c1cls(7),r1tmp)
      do i0l=1,n0l
c bug (2020/08/05,hanasaki)        if(r1tmp(i0l).ne.p0mis)then
        if(r1tmp(i0l).ne.p0mis.and.r1tmp(i0l).ge.0.0)then
          r2cls(6,i0l)=r1tmp(i0l)
        end if
      end do
c
      call read_binary(n0l,c1cls(8),r1tmp)
      do i0l=1,n0l
c bug (2020/08/05,hanasaki)        if(r1tmp(i0l).ne.p0mis)then
        if(r1tmp(i0l).ne.p0mis.and.r1tmp(i0l).ge.0.0)then
          r2cls(7,i0l)=r1tmp(i0l)
        end if
      end do
c
      write(*,*) '[prog_gwr_fr] r2cls(1,i0l):',r2cls(1,i0ldbg)
      write(*,*) '[prog_gwr_fr] r2cls(2,i0l):',r2cls(2,i0ldbg)
      write(*,*) '[prog_gwr_fr] r2cls(3,i0l):',r2cls(3,i0ldbg)
      write(*,*) '[prog_gwr_fr] r2cls(4,i0l):',r2cls(4,i0ldbg)
      write(*,*) '[prog_gwr_fr] r2cls(5,i0l):',r2cls(5,i0ldbg)
      write(*,*) '[prog_gwr_fr] r2cls(6,i0l):',r2cls(6,i0ldbg)
      write(*,*) '[prog_gwr_fr] r2cls(7,i0l):',r2cls(7,i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c calc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0l=1,n0l
        do i0cls=1,7
          r1sco(i0l)=r1sco(i0l)+real(i0cls)*r2cls(i0cls,i0l)/10000.0
c debug (2020/08/05, hanasaki)
          if(i0l.eq.6398)then
            write(*,*) 'debug ',r1sco(i0l),i0cls,r2cls(i0cls,i0l)
          end if
c debug end
        end do
      end do
c
      do i0l=1,n0l
        i0cls=int(r1sco(i0l))
        if(i0cls.ne.0)then
          r1fr(i0l)=(real(i0cls+1)-r1sco(i0l))*r1lut(i0cls)
     $             +(r1sco(i0l)  -real(i0cls))*r1lut(i0cls+1)
c debug (2020/08/05, hanasaki)
          if(i0l.eq.6398)then
            write(*,*) 'debug ',r1sco(i0l),i0cls,r1fr(i0l),r1lut(i0cls)
          end if
c debug end
        end if
      end do
c
      write(*,*) '[prog_gwr_fr] r1sco(i0l):',r1sco(i0ldbg)
      write(*,*) '[prog_gwr_fr] r1fr(i0l): ',r1fr(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c write
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call wrte_binary(n0l,r1fr,c0fr)
      call wrte_binary(n0l,r1sco,c0sco)
c
      end
