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
      integer function igeti0x(n0x,p0lonmin,p0lonmax,r0lon)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cto   get x coordinate
cby   2010/03/31, hanasaki, NIES: H08 ver1.0
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
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      implicit none
c parameter (array)
      integer           n0x
      real              p0lonmin
      real              p0lonmax
c in 
      real              r0lon
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      igeti0x=nint((r0lon-p0lonmin)/(p0lonmax-p0lonmin)*real(n0x)+0.5)
c
      end

