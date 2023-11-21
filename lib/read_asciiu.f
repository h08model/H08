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
      subroutine read_asciiu(
     $     n0l,
     $     c0ifname,
     $     r1out)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cto   read unformatted ascii array
cby   2010/03/31, hanasaki, NIES: H08 ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      implicit none
c parameter (array)
      integer           n0l
c parameter (default)
      integer           n0if
      parameter        (n0if=15) 
      real              p0mis
      integer           n0mis
      parameter        (p0mis=1.0E20)
      parameter        (n0mis=-9999)
c index (array)
      integer          i0l
c in
      character*128    c0ifname
c out
      real             r1out(n0l)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Read
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      open(n0if,file=c0ifname,status='old')
      read(n0if,*)(r1out(i0l),i0l=1,n0l)
      close(n0if)
c
      do i0l=1,n0l
        if(r1out(i0l).eq.real(n0mis))then
          r1out(i0l)=p0mis
        end if
      end do
c
      end
