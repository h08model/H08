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
      integer function igeti0y(n0y,p0latmin,p0latmax,r0lat)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   get y coordinate
cby   2010/03/31, hanasaki, NIES: H08ver1.0
c
c       (plonmin,platmin)
c         /
c        /________   __________
c        |      |       |       |
c        |(1, 1)|  ...  |(nx, 1)|
c        |______|__   __|_______|
c        |      |               |
c           .     .
c           .       .
c           .         .
c        |______|__   __________|
c        |      |       |       |
c        |(1,ny)|  ...  |(nx,ny)|
c        |______|__   __|_______|
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter
      integer           n0y
      real              p0latmin
      real              p0latmax
c in
      real              r0lat
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      igeti0y=nint((p0latmax-r0lat)/(p0latmax-p0latmin)*real(n0y)+0.5)
c
      end

