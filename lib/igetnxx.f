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
      integer function igetnxx(n0x,i0x,i0flwdir)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cto   get next X coordinate of the down stream grid
cby   20100331, hanasaki, NIES: H08 ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      implicit none
c parameter (array)
      integer n0x
c in
      integer i0x
      integer i0flwdir
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if (i0flwdir.eq.1.or.i0flwdir.eq.5) then
        igetnxx = i0x
      else if (i0flwdir.eq.8.or.i0flwdir.eq.7.or.i0flwdir.eq.6) then
        if (i0x.eq.1) then
          igetnxx = n0x
        else
          igetnxx = i0x-1
        end if
      else if (i0flwdir.eq.2.or.i0flwdir.eq.3.or.i0flwdir.eq.4) then
        if (i0x.eq.n0x) then
          igetnxx = 1
        else
          igetnxx = i0x+1
        end if
      else
        igetnxx = 0
      end if
c
      end
