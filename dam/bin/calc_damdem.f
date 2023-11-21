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
      subroutine calc_damdem(
     $     n0l,
     $     i1damid_, r1demtot, c0damalc,
     $     r1damdem)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   allocate water demand for reservoirs
cby   2010/09/30, hanasaki, NIES: H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter (array)
      integer           n0l
c parameter
      real              p0mis
      parameter        (p0mis=1.0E20) 
c index (array)
      integer           i0l
c temporary
      real              r1tmp(n0l)
      character*128     c0ifname
c function
      character*128     cgetfnl
c in
      integer           i1damid_(n0l)
      real              r1demtot(n0l)
      character*128     c0damalc
c out
      real              r1damdem(n0l)
c local
      integer           i0l_dummy
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0l=1,n0l
        if(i1damid_(i0l).ne.0)then
          c0ifname=cgetfnl(c0damalc,i1damid_(i0l))
          call read_binary(n0l,c0ifname,r1tmp)
          r1damdem(i0l)=0.0
          do i0l_dummy=1,n0l
            if(r1demtot(i0l_dummy).ne.p0mis)then
              r1damdem(i0l)
     $             =r1damdem(i0l)
     $             +r1tmp(i0l_dummy)*r1demtot(i0l_dummy)
            end if
          end do
        end if
      end do
c
      end
