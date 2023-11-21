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
      program prep_faosta
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   preprare FAOSTAT data
cby   2010/04/13, hanasaki, NIES: H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter (array)
      integer           n0year     !! year
      integer           n0reccod   !! code
      integer           n0recdat   !! data
      integer           n0reched   !! header
      parameter        (n0year=2100)
      parameter        (n0reccod=2000)
      parameter        (n0recdat=237)
      parameter        (n0reched=6)
c parameter (default) 
      integer           n0mis
      parameter        (n0mis=-9999) 
c index (array)
      integer           i0year
      integer           i0yearmin
      integer           i0yearmax
      integer           i0reccod
      integer           i0reccodmax
      integer           i0recdat
      integer           i0recdatmax
      integer           i0reched
c in (code)
      integer           i1cod(n0reccod)
      character*128     c1cod(n0reccod)
      character*128     c0cod
c in (data)
      real              r0factor
      character*128     c1hed(n0reched)
      real              r1dat(n0year)
      real              r2dat(n0year,n0recdat)
      character*128     c0dat
c out
      character*128     c0out1
      character*128     c0out2
c temporary
      character*128     c0tmp
c function
      integer           iargc
      character*128     cgetfnt
      character*128     cgetfnl
c local
      integer           i0flg
      integer           i1recdat2iso(n0recdat)
      character*128     c1recdat2nat(n0recdat)
      character*128     c0ofname
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Arguments
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if (iargc().ne.7) then
        write(6,*) 'Usage: prog_faosta in yearmin yearmax out1 out2'
        stop
      end if
c
      call getarg(1,c0dat)
      call getarg(2,c0cod)
      call getarg(3,c0tmp)
      read(c0tmp,*) i0yearmin
      call getarg(4,c0tmp)
      read(c0tmp,*) i0yearmax
      call getarg(5,c0tmp)
      read(c0tmp,*) r0factor
      call getarg(6,c0out1)
      call getarg(7,c0out2)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Read code
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      open(15,file=c0cod)
      i0reccod=1
 10   read(15,*,end=20) c1cod(i0reccod),i1cod(i0reccod)
      i0reccod=i0reccod+1
      goto 10
 20   close(15)
      i0reccodmax=i0reccod-1
      write(*,*) 'prog_FAOSTAT: i0reccodmax',i0reccodmax
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Read data
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      open(15,file=c0dat)
      read(15,*) (c1hed(i0reched),i0reched=1,n0reched),
     $           (r1dat(i0year),  i0year=i0yearmin,i0yearmax)
      do i0year=i0yearmin,i0yearmax
        if(int(r1dat(i0year)).ne.i0year)then
          write(*,*) 'prog_FAOSTAT: header error. Stop'
          write(*,*) 'prog_FAOSTAT: I expect ',i0year
          write(*,*) 'prog_FAOSTAT: I found  ',int(r1dat(i0year))
          stop
        end if
      end do
      i0recdat=1
 11   read(15,*,end=21) (c1hed(i0reched),i0reched=1,n0reched),
     $                  (r1dat(i0year),  i0year=i0yearmin,i0yearmax)
      i0flg=0
      do i0reccod=1,i0reccodmax
        if(c1hed(1).eq.c1cod(i0reccod))then
          i0flg=1
          i1recdat2iso(i0recdat)=i1cod(i0reccod)
          c1recdat2nat(i0recdat)=c1cod(i0reccod)
        end if
      end do
      if(i0flg.ne.1)then
        write(*,*) 'prog_FAOSTAT: country not found. Stop. ',c1hed(1)
        stop
      else
        write(*,*) i0recdat,c1hed(1),i1recdat2iso(i0recdat)
      end if
      do i0year=i0yearmin,i0yearmax
        r2dat(i0year,i0recdat)=r1dat(i0year)
      end do
      i0recdat=i0recdat+1
      goto 11
 21   close(15)
      i0recdatmax=i0recdat-1
      write(*,*) 'prog_FAOSTAT: i0recdatmax',i0recdatmax
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c write
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0recdat=1,i0recdatmax
        c0ofname=cgetfnl(c0out1,i1recdat2iso(i0recdat))
        write(*,*) c0ofname
        open(16,file=c0ofname)
        do i0year=i0yearmin,i0yearmax
          if(r2dat(i0year,i0recdat).ne.real(n0mis))then
            write(16,*) i0year,0,0,r2dat(i0year,i0recdat)*r0factor
          else
            write(16,*) i0year,0,0,real(n0mis)
          end if
        end do
        close(16)
      end do
c
      do i0year=i0yearmin,i0yearmax
        c0ofname=cgetfnt(c0out2,i0year,0,0,0)
        write(*,*) c0ofname
        open(16,file=c0ofname)
        do i0recdat=1,i0recdatmax
          if(r2dat(i0year,i0recdat).ne.real(n0mis))then
          write(16,'(a64,es16.8)') c1recdat2nat(i0recdat),
     $                        r2dat(i0year,i0recdat)*r0factor
          else
            write(16,'(a64,es16.8)') c1recdat2nat(i0recdat),
     $           real(n0mis)
          end if
        end do
        close(16)
      end do
c
      end
