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
      subroutine conv_r1toi2(
     $     n0l,n0x,n0y,i1l2x,i1l2y,
     $     r1dat,
     $     i2dat)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   convert 1d array into 2d array
cby   2010/03/31, hanasaki, NIES: H08 ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter (array)
      integer           n0l
      integer           n0x
      integer           n0y
c index (array)
      integer           i0l
      integer           i0x
      integer           i0y
c in
      integer           i1l2x(n0l)
      integer           i1l2y(n0l)
      real              r1dat(n0l)
c out
      integer           i2dat(n0x,n0y)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Initialize
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      i2dat=0.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Calculation
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      do i0l=1,n0l
        i0x=i1l2x(i0l)
        i0y=i1l2y(i0l)
        i2dat(i0x,i0y)=int(r1dat(i0l))
      end do
c
      end
