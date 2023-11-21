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
      subroutine read_ascii2(
     $     n0recdat,n0reccod,n0recout,
     $     c0dat,   c0cod,
     $     r1out)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   read ascii list
cby   2011/04/21, hanasaki, NIES: H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter (array)
      integer           n0recdat
      integer           n0reccod
      integer           n0recout
c parameter (default)
      integer           n0if
      integer           n0mis
      real              p0mis
      parameter        (n0if=15) 
      parameter        (n0mis=-9999) 
      parameter        (p0mis=1.0E20) 
c index
      integer           i0recdat
      integer           i0recdatmax
      integer           i0reccod
      integer           i0reccodmax
c in
      character*128     c0cod
      character*128     c0dat
c out
      real              r1out(n0recout)
c local
      integer           i0flg
      integer           i1recdat2cod(n0recdat)
      integer           i1cod(n0reccod)
      real              r1dat(n0recdat)
      character*128     c1cod(n0reccod)
      character*128     c1dat(n0recdat)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Initialize
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      i1recdat2cod=0
      i1cod=0
      r1dat=0.0
      c1cod=''
      c1dat=''
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Read code
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      open(n0if,file=c0cod,status='old')
      i0reccod=1
 10   read(n0if,*,end=20) c1cod(i0reccod),i1cod(i0reccod)
      i0reccod=i0reccod+1
      goto 10
 20   close(n0if)
      i0reccodmax=i0reccod-1
c     write(*,*) 'read_ascii2: i0reccodmax: ',i0reccodmax
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Read data
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(c0dat.ne.'NO')then
        open(n0if,file=c0dat,status='old')
        i0recdat=1
 11     read(n0if,*,end=21) c1dat(i0recdat),r1dat(i0recdat)
        i0flg=0
        do i0reccod=1,i0reccodmax
          if(c1cod(i0reccod).eq.c1dat(i0recdat))then
            i1recdat2cod(i0recdat)=i1cod(i0reccod)
            i0flg=1
          end if
        end do
        if(i0flg.eq.0)then
          write(*,*) 'read_ascii2: label not found: ',c1dat(i0recdat)
          stop
        end if
        i0recdat=i0recdat+1
        goto 11
 21     close(n0if)
        i0recdatmax=i0recdat-1
c       write(*,*) 'read_ascii2: i0recdatmax: ',i0recdatmax
      end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Job
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(c0dat.ne.'NO')then
        r1out=p0mis
        do i0recdat=1,i0recdatmax
          if(r1dat(i0recdat).ne.real(n0mis))then
            r1out(i1recdat2cod(i0recdat))=r1dat(i0recdat)
          else
            r1out(i1recdat2cod(i0recdat))=p0mis
          end if
        end do
      else
        r1out=p0mis
      end if
c
      end
      
