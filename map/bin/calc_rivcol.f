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
      program rivcol
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cto   four colors suffice!
cby   2011/09/17, hanasaki
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter (array)
      integer           n0l
      integer           n0x
      integer           n0y
c parameter (default)
      real              p0mis
      parameter        (p0mis=1.0E20) 
c index
      integer           i0l
      integer           i0x
      integer           i0y
      integer,allocatable::i1l2x(:)
      integer,allocatable::i1l2y(:)
      character*128     c0l2x
      character*128     c0l2y
c temporary
      integer           i0tmp
      real,allocatable::r1tmp(:)
      character*128     c0tmp
c function
      integer           igeti0l
c in
      real,allocatable::r2rivnum(:,:)
      character*128     c0rivnum
c out
      real,allocatable::r1rivcol(:)
      character*128     c0rivcol
c local
      integer           i0xn
      integer           i0xe
      integer           i0xs
      integer           i0xw
      integer           i0yn
      integer           i0ye
      integer           i0ys
      integer           i0yw
      real              r0rivnum
      real              r0rivnumn
      real              r0rivnume
      real              r0rivnums
      real              r0rivnumw
      real              r0rivcoln
      real              r0rivcole
      real              r0rivcols
      real              r0rivcolw
      real              r1num2col(0:10000)
      real              r0rplc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(iargc().ne.7)then
        write(*,*) 'calc_rivcol n0l n0x n0y c0l2x c0l2y'
        write(*,*) '            c0rivnum c0rivcol'
        stop
      end if
c
      call getarg(1,c0tmp)
      read(c0tmp,*) n0l
      call getarg(2,c0tmp)
      read(c0tmp,*) n0x
      call getarg(3,c0tmp)
      read(c0tmp,*) n0y
      call getarg(4,c0l2x)
      call getarg(5,c0l2y)
      call getarg(6,c0rivnum)
      call getarg(7,c0rivcol)
c
      allocate(r1tmp(n0l))
      allocate(i1l2x(n0l))
      allocate(i1l2y(n0l))
      allocate(r2rivnum(n0x,n0y))
      allocate(r1rivcol(n0l))
c
      call read_i1l2xy(n0l,c0l2x,c0l2y,i1l2x,i1l2y)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call read_binary(n0l,c0rivnum,r1tmp)
      call conv_r1tor2(n0l,n0x,n0y,i1l2x,i1l2y,r1tmp,r2rivnum)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c initialize
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      r1rivcol=p0mis
      r1num2col=p0mis
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c job
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0l=1,n0l
        i0x=i1l2x(i0l)
        i0y=i1l2y(i0l)
        r0rivnum=r2rivnum(i0x,i0y)
c
        i0xn=i0x
        i0yn=i0y-1
        if(i0yn.eq.0)then
          r0rivnumn=p0mis
          r0rivcoln=p0mis
        else
          r0rivnumn=r2rivnum(i0xn,i0yn)  
          r0rivcoln=r1num2col(r0rivnumn)
        end if
c
        i0xe=i0x+1
        i0ye=i0y
        if(i0xe.gt.n0x)then
          i0xe=1
        end if
        r0rivnume=r2rivnum(i0xe,i0ye)
        r0rivcole=r1num2col(r0rivnume)
c
        i0xs=i0x
        i0ys=i0y+1
        if(i0ys.gt.n0y)then
          r0rivnums=p0mis
          r0rivcols=p0mis
        else
          r0rivnums=r2rivnum(i0xs,i0ys)          
          r0rivcols=r1num2col(r0rivnums)
        end if
c
        i0xw=i0x-1
        i0yw=i0y
        if(i0xw.eq.0)then
          i0xw=n0x
        end if
        r0rivnumw=r2rivnum(i0xw,i0yw)
        r0rivcolw=r1num2col(r0rivnumw)
c
c        
        if(r0rivnum.ne.p0mis.and.r0rivnum.ne.0.0)then
          if(r0rivnum.eq.3)then
            write(*,*) i0x, i0y, r0rivnum, r1rivcol(i0l)
            write(*,*) i0xn,i0yn,r0rivnumn,        r0rivcoln
            write(*,*) i0xe,i0ye,r0rivnume,        r0rivcole
            write(*,*) i0xs,i0ys,r0rivnums,        r0rivcols
            write(*,*) i0xw,i0yw,r0rivnumw,        r0rivcolw
            write(*,*) '---------------------------'
          end if
c
          if(r1num2col(r0rivnum).ne.p0mis)then
            r1rivcol(i0l)=r1num2col(r0rivnum)
          else
            r1rivcol(i0l)=1
            if(r0rivcoln.eq.1.or.
     $         r0rivcole.eq.1.or.
     $         r0rivcols.eq.1.or.
     $         r0rivcolw.eq.1)then
              r1rivcol(i0l)=2
              if(r0rivcoln.eq.2.or.
     $           r0rivcole.eq.2.or.
     $           r0rivcols.eq.2.or.
     $           r0rivcolw.eq.2)then          
                r1rivcol(i0l)=3
                if(r0rivcoln.eq.3.or.
     $             r0rivcole.eq.3.or.
     $             r0rivcols.eq.3.or.
     $             r0rivcolw.eq.3)then          
                  r1rivcol(i0l)=4
                  if(r0rivcoln.eq.4.or.
     $               r0rivcole.eq.4.or.
     $               r0rivcols.eq.4.or.
     $               r0rivcolw.eq.4)then          
                    write(*,*) 'four colors not suffice!!!!!'
                    stop
                  end if
                end if
              end if
            end if
          end if
c
          if(r0rivnumn.ne.r0rivnum.and.
     $       r0rivcoln.eq.r1rivcol(i0l).or.
     $       r0rivnume.ne.r0rivnum.and.
     $       r0rivcole.eq.r1rivcol(i0l).or.
     $       r0rivnums.ne.r0rivnum.and.
     $       r0rivcols.eq.r1rivcol(i0l).or.
     $       r0rivnumw.ne.r0rivnum.and.
     $       r0rivcolw.eq.r1rivcol(i0l))then
            if(r1rivcol(i0l).lt.5)then
              write(*,*) 'five'
              r0rplc=5
            else if(r1rivcol(i0l).eq.5)then
              write(*,*) 'six'
              r0rplc=6
            else if(r1rivcol(i0l).eq.6)then
              write(*,*) 'seven'
              r0rplc=7
            else if(r1rivcol(i0l).eq.7)then
              write(*,*) 'eight'
              r0rplc=8
            end if
            r1num2col(int(r0rivnum))=r0rplc
            do i0tmp=1,n0l
              i0x=i1l2x(i0tmp)
              i0y=i1l2y(i0tmp)
              if(r2rivnum(i0x,i0y).eq.r0rivnum)then
                r1rivcol(i0tmp)=r0rplc
              end if
            end do
          end if
c
          r1num2col(r0rivnum)=r1rivcol(i0l)
          if(r0rivnum.eq.3)then
          write(*,*) r1num2col(3)
          write(*,*) i0x, i0y, r0rivnum, r1rivcol(i0l)
          write(*,*) '------------------------------'
          end if
        else
          r1rivcol(i0l)=p0mis
        end if
      end do
c
      call wrte_binary(n0l,r1rivcol,c0rivcol)
c
      end
