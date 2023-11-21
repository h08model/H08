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
      subroutine read_i1l2xy(
     $     n0l,
     $     c0l2x,c0l2y,
     $     i1l2x,i1l2y)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cto   read the array i1l2x and i1l2y
cby   2010/03/31, haasaki, NIES: H08 ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      implicit none
c parameter (array)
      integer           n0l
c index (array)
      integer           i0l
c temporary
      real              r1tmp(n0l)
c in
      character*128     c0l2x
      character*128     c0l2y
c out
      integer           i1l2x(n0l)
      integer           i1l2y(n0l)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call read_asciiu(n0l,c0l2x,r1tmp)
      do i0l=1,n0l
        i1l2x(i0l)=int(r1tmp(i0l))
      end do
c
      call read_asciiu(n0l,c0l2y,r1tmp)
      do i0l=1,n0l
        i1l2y(i0l)=int(r1tmp(i0l))
      end do
c
      end
