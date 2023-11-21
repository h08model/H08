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
      subroutine read_binary(n0l,c0ifname,r1out)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cto   read binary array
cby   2010/03/31, hanasaki, NIES: H08 ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      implicit none
c parameter (array)
      integer           n0l
c parameter (file)
      integer           n0if
      parameter        (n0if=15) 
c index (array)
      integer           i0l
c in
      character*128     c0ifname
c out
      real              r1out(n0l)
c local
      integer           i0in
      character*128     c0idx
      character*128     c0ifname_dummy
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Basic info
c - get total number of charcter of c0ifname
c - get Index (final two character) of c0ifname
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      i0in=len_trim(c0ifname)
c
      c0idx=c0ifname(i0in-1:i0in)
      if(c0idx.eq.'FX')then
        c0ifname_dummy=c0ifname(1:i0in-2)
      else
        c0ifname_dummy=c0ifname
      end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      open(n0if,file=c0ifname_dummy,access='DIRECT',
     $     status='old',recl=4*n0l)
      read(n0if,rec=1)(r1out(i0l),i0l=1,n0l)
      close(n0if)
c
      end
