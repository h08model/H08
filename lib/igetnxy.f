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
      integer function igetnxy(n0y, i0y, i0flwdir)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cto   get the next y coordinate of the downstream grid cell
cby   2010/03/31, hanasaki, NIES: H08 ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      implicit none
c parameter (array)
      integer n0y
c in
      integer i0y
      integer i0flwdir
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if (i0flwdir.eq.7.or.i0flwdir.eq.3) then
        igetnxy = i0y
      else if (i0flwdir.eq.6.or.i0flwdir.eq.5.or.i0flwdir.eq.4) then
        if (i0y.eq.n0y) then
          igetnxy = 0
        else
          igetnxy = i0y+1
        end if
      else if (i0flwdir.eq.8.or.i0flwdir.eq.1.or.i0flwdir.eq.2) then
        if (i0y.eq.1) then
          igetnxy = 0
        else
          igetnxy = i0y-1
        end if
      else
        igetnxy = 0
      end if
c
      end
