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
      subroutine wrte_ascii2(
     $     n0recout,n0reccod,
     $     r1out,   c0cod,
     $     c0out)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   write ascii list
cby   2011/04/21, hanasaki, NIES: H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter (array)
      integer           n0recout
      integer           n0reccod
c parameter (default)
      integer           n0if
      integer           n0of
      integer           n0mis
      real              p0mis
      parameter        (n0if=15) 
      parameter        (n0of=16) 
      parameter        (n0mis=-9999) 
      parameter        (p0mis=1.0E20) 
c index
      integer           i0recout
      integer           i0reccod
      integer           i0reccodmax
c in
      real              r1out(n0recout)
      character*128     c0cod
c out
      character*128     c0out
c temporary
      integer           i0tmp
c local
      integer           i0flg
      integer           i1cod(n0reccod)
      character*128     c1cod(n0reccod)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Initialize
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      i1cod=0
      c1cod=''
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
      write(*,*) 'wrte_ascii2: i0reccodmax: ',i0reccodmax
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Write data
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(c0out.ne.'NO')then
        open(n0of,file=c0out)
        do i0recout=1,n0recout
          if(r1out(i0recout).ne.p0mis)then
            i0flg=0
            do i0reccod=1,i0reccodmax
              if(i1cod(i0reccod).eq.i0recout)then
                i0tmp=i0reccod
                i0flg=1
              end if
            end do
            if(i0flg.eq.0)then
              write(*,*) 'wrte_ascii2: label not found for:',i0recout
              write(*,*) 'wrte_ascii2: out: ',r1out(i0recout)
              stop
            end if
            write(n0of,'(a64,es16.8)') c1cod(i0tmp),r1out(i0recout)
          end if
        end do
        close(n0of)
      end if
c
      end
      
