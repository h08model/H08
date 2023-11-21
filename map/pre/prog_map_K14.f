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
      program prog_K14
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   convert canal data format
cby   2016/02/01, hanasaki
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c
      integer           n0l
      integer           n0rec         !! # of cells to deliver water
      integer           n0recout      !! to output
      real              p0mis
      parameter        (n0l=259200)
c      parameter        (n0l=32400)    !! for Kyusyu (.ks1)
      parameter        (n0rec=20) 
      parameter        (n0recout=20)  !! must be equal to n0rec
      parameter        (p0mis=1.0E20) 
c index
      integer           i0l
      integer           i0rec
c temporary
      integer           i0tmp
      real              r1tmp(n0l)
c in
      real              r1expdes(n0l)        !! id of explicit destination
      real              r1exporg(n0l)        !! id of explicit origin
      real              r1limporg(n0l)       !! l of implicit origin 
      real              r2limpdes(n0l,n0rec) !! l of implicit destin
      real              r1seq(n0l)           !! river sequence
      character*128     c0expdes
      character*128     c0exporg
      character*128     c0limporg
      character*128     c0limpdes
      character*128     c0seq
c out
      real              r1lexporg(n0l)       !! converted canal file
      real              r2lexpdes(n0l,n0rec) !! converted canal file
      real              r1lmrgorg(n0l)       !! merged origin 
      real              r2lmrgdes(n0l,n0rec) !! merged destication
      real              r1catorg(n0l)
      real              r2catdes(n0l,n0rec)
      character*128     c0lexporg
      character*128     c0lexpdes
      character*128     c0lmrgorg
      character*128     c0lmrgdes
      character*128     c0catorg
      character*128     c0catdes
c
      integer           i0id
      integer           i0lexporg
      integer           i1cnt(n0rec)
      integer           i0cntok
      integer           i0cntng
      integer           i1id2lorg(n0l)   !! converter id --> l or origin
      integer           i1id2seq(n0l) !! converter id --> sequence
      integer           i0ldbg
      data              i0ldbg/7468/ 
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c argument
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(iargc().ne.9)then
        write(*,*) 'prog_K14 c0expdes c0exporg c0limporg c0limpdes'
        write(*,*) ' c0seq   c0lexporg  c0lexpdes c0lmrgorg c0lmrgdes'
        stop
      end if
c
      call getarg(1,c0expdes)
      call getarg(2,c0exporg)
      call getarg(3,c0limporg)
      call getarg(4,c0limpdes)
      call getarg(5,c0seq)
      call getarg(6,c0lexporg)
      call getarg(7,c0lexpdes)
      call getarg(8,c0lmrgorg)
      call getarg(9,c0lmrgdes)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c read
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call read_binary(n0l,c0expdes,   r1expdes)   !! explicit des2id
      call read_binary(n0l,c0exporg,   r1exporg)  !! explicit org2id
      call read_binary(n0l,c0seq,    r1seq)
      call read_binary(n0l,c0limporg,r1limporg)
c
c      write(*,*) 'prog_map_K14 c0limpdes',c0limpdes
      open(15,file=c0limpdes,access='DIRECT',recl=n0l*4)
      do i0rec=1,n0recout
        read(15,rec=i0rec)(r1tmp(i0l),i0l=1,n0l)
        do i0l=1,n0l
          r2limpdes(i0l,i0rec)=r1tmp(i0l)
        end do
      end do
      close(15)
c
c      write(*,*) 'prog_map_K14 r1expdes ',r1expdes(i0ldbg)
c      write(*,*) 'prog_map_K14 r1exporg ',r1exporg(i0ldbg)
c      write(*,*) 'prog_map_K14 r1limporg',r1limporg(i0ldbg)
c      write(*,*) 'prog_map_K14 r2limpdes',r2limpdes(i0ldbg,1)
c      write(*,*) 'prog_map_K14 r2limpdes',r2limpdes(i0ldbg,2)
c      write(*,*) 'prog_map_K14 r2limpdes',r2limpdes(i0ldbg,3)
c      write(*,*) 'prog_map_K14 r2limpdes',r2limpdes(i0ldbg,n0rec)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c make a look up table
c id (origin of explicit) --> l
c id (origin of explicit) --> seq
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0l=1,n0l
        if(r1exporg(i0l).ne.p0mis)then
          i0id=int(r1exporg(i0l))
          if(i0id.ne.0)then
            i1id2lorg(i0id)=i0l
            i1id2seq(i0id)=int(r1seq(i0l))
          end if
        end if
      end do
c
c      write(*,*) 'prog_map_K14 i1id2lorg(11)  ',i1id2lorg(11)
c      write(*,*) 'prog_map_K14 i1id2seq(11)',i1id2seq(11)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c convert
c canorg: map showing the l of origin 
c candes: map showing the l of destination. 
c         Excluding delivering if rivseq is greater than that of origin.
c 
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0l=1,n0l
        if(r1expdes(i0l).ne.p0mis)then
          r1lexporg(i0l)=real(i1id2lorg(int(r1expdes(i0l))))
        end if
      end do
c
c      write(*,*) 'status destination rivseq origin rivseq CanalID '
      i0cntok=0
      i0cntng=0
      do i0rec=1,n0rec
        do i0l=1,n0l
          if(r1expdes(i0l).ne.0.0.and.r1expdes(i0l).ne.p0mis)then
            i0lexporg=i1id2lorg(int(r1expdes(i0l)))
            if(r2lexpdes(i0lexporg,i0rec).eq.0.0)then
              if(i0lexporg.eq.0)then
c                write(*,*) '--'
              else
                if(int(r1seq(i0l)).lt.r1seq(i0lexporg))then
c                  write(*,*) 'ok',i0l   ,int(r1seq(i0l)),
c     $                 'from ',i0lexporg,int(r1seq(i0lexporg)),
c     $                 'CanalID ',int(r1expdes(i0l))
                  r2lexpdes(i0lexporg,i0rec)=real(i0l)
                  i0cntok=i0cntok+1
                else
c                  write(*,*) 'ng',i0l   ,int(r1seq(i0l)),
c     $                 'from ',i0lexporg,int(r1seq(i0lexporg)),
c     $                 'CanalID ',int(r1expdes(i0l))
                  r1lexporg(i0l)=0.0
                  i0cntng=i0cntng+1
                end if
                i1cnt(i0rec)=i1cnt(i0rec)+1
              end if
              r1expdes(i0l)=0.0
            end if
          end if
        end do
      end do
c
c      do i0rec=1,n0rec
c        write(*,*) 'distance: ',i0rec,'num of can: ',i1cnt(i0rec)
c      end do
c      write(*,*) 'Number of valid canals: ',i0cntok
c      write(*,*) 'Number of errorneous calans: ',i0cntng
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c merge
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c origin: explicit canal exists
      do i0l=1,n0l
        if(r1lexporg(i0l).ne.0)then
          r1lmrgorg(i0l)=r1lexporg(i0l)
          r1catorg(i0l)=1.0
        end if
      end do
c origin: implicit canal only
      do i0l=1,n0l
        if(r1lexporg(i0l).eq.0.and.r1limporg(i0l).ne.0)then
          r1lmrgorg(i0l)=r1limporg(i0l)
          r1catorg(i0l)=2.0
        end if
      end do
c destination: explicit canal only
      do i0l=1,n0l
        do i0rec=1,n0rec
          if(r2lexpdes(i0l,i0rec).ne.0)then
            r2lmrgdes(i0l,i0rec)=r2lexpdes(i0l,i0rec)
            r2catdes(i0l,i0rec)=1.0
          end if
        end do
      end do
c destination: implicit canal only
      do i0l=1,n0l
        do i0rec=1,n0rec
          if(r2lmrgdes(i0l,i0rec).eq.0)then
            do i0tmp=1,n0rec
              if(r2limpdes(i0l,i0tmp).ne.0)then
                r2lmrgdes(i0l,i0rec)=r2limpdes(i0l,i0tmp)
                r2catdes(i0l,i0rec)=2.0
                r2limpdes(i0l,i0tmp)=0.0
                if(i0l.eq.i0ldbg)then
                  write(*,*) i0l,i0rec,i0tmp,r2lmrgdes(i0l,i0rec)
                end if
                goto 100
              end if
            end do
 100        continue
          end if
        end do
      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c write
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call wrte_binary(n0l,r1lexporg,c0lexporg)
c
      open(16,file=c0lexpdes,access='DIRECT',recl=n0l*4)
      do i0rec=1,n0recout
        do i0l=1,n0l
          r1tmp(i0l)=r2lexpdes(i0l,i0rec)
        end do
        write(16,rec=i0rec)(r1tmp(i0l),i0l=1,n0l)
      end do
      close(16)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c write
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call wrte_binary(n0l,r1lmrgorg,c0lmrgorg)
c
      open(16,file=c0lmrgdes,access='DIRECT',recl=n0l*4)
      do i0rec=1,n0recout
        do i0l=1,n0l
          r1tmp(i0l)=r2lmrgdes(i0l,i0rec)
        end do
        write(16,rec=i0rec)(r1tmp(i0l),i0l=1,n0l)
      end do
      close(16)
c
      end
