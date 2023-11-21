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
      subroutine wrte_bytswp(n0l,r1dat,c0ofname)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cto   write binary array in the opposite endian (byte swap)
cby   2010/03/31, hanasaki, NIES: H08 ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      implicit none
c parameter (array)
      integer           n0l
c parameter (default)
      integer           n0of
      parameter        (n0of=26) 
c index (array)
      integer           i0l
c in
      real              r1dat(n0l)
c out
      character*128     c0ofname
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Write binary
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      open(n0of,file=c0ofname,access='DIRECT',recl=n0l*4)
      write(n0of,rec=1)(r1dat(i0l),i0l=1,n0l)
      close(n0of)
c
      end
