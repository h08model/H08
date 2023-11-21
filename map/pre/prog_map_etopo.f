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
      program prog_map_etopo
c
      implicit none
c
      integer    i0l
      integer    n0l
      parameter (n0l=233280000)
      real       r1dat(n0l)
      character*128 c0ifname
      character*128 c0ofname
      integer i0cnt
      integer i0lmin
      integer i0lmax
      integer i0y
c
      call getarg(1,c0ifname)
      call getarg(2,c0ofname)
c     
      open(15,file=c0ifname)
      read(15,*) (r1dat(i0l),i0l=1,n0l)
      close(15)
c
      i0cnt=1
      open(16,file=c0ofname,access='DIRECT',recl=360*60*4)
      do i0y=180*60,1,-1
         i0lmin=(i0y-1)*360*60+1
         i0lmax=i0y*360*60
         write(16,rec=i0cnt) (r1dat(i0l),i0l=i0lmin,i0lmax)
         i0cnt=i0cnt+1
      end do
      close(16)
c
      end
