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
      program list_flwdir
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(iargc().ne.2)then
        write(*,*) 'list_flwdir'
        stop
      end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      call read_binary(n0l,c0flwdir,r0tmp)
c
      do i0l=1,n0l
        i0x=i1l2x(i0l)
        i0y=i1l2y(i0l)
        i0nxx=igetnxx(n0x,i0x,i1flwdir(i0l))
        i0nxy=igetnxy(n0y,i0y,i1flwdir(i0l))
        r0lonorg=rgetlon(n0x,p0lonmin,p0lonmax,i0x,s0center)
        r0latorg=rgetlat(n0y,p0latmin,p0latmax,i0y,s0center)
        r0londes=rgetlon(n0x,p0lonmin,p0lonmax,i0nxx,s0center)
        r0latdes=rgetlat(n0y,p0latmin,p0latmax,i0nxy,s0center)
      end if
c
      write(*,*) 
c
      end
