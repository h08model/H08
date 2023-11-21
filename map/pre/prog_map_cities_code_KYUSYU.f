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
      program prog_map_cities_code_KYUSYU
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c to  convert mesh code into xy
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      implicit none
c     
      integer       n
      integer       in_a
      character*128 in_b
      character(8)  in_c
      integer       i
      real          lon_a,lon_b,lon_c
      real          lat_a,lat_b,lat_c
c
      real          r0lonmin,r0lonmax,r0latmin,r0latmax
      character*128 c0ifname,c0ofname
      character*128 c0temp
c
      integer       i0x,i0y
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      call getarg(1,c0temp)
      read(c0temp,*) r0lonmin
      call getarg(2,c0temp)
      read(c0temp,*) r0lonmax
      call getarg(3,c0temp)
      read(c0temp,*) r0latmin
      call getarg(4,c0temp)
      read(c0temp,*) r0latmax
      call getarg(5,c0ifname)
      call getarg(6,c0ofname)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c open/read csv file
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      open(17,file=c0ifname,status='old')
      open(18,file=c0ofname,status='replace')
      n=0
      read(17 , '()')
      do
         read (17, *, end =100) in_a, in_b, in_c
         n=n+1
      end do
 100   continue
       rewind(17)
       read(17, '()')
       do i=1,n
          read(17,*)  in_a, in_b, in_c
          read(in_c(1:2),*) lat_a
          read(in_c(3:4),*) lon_a
          read(in_c(5:5),*) lat_b
          read(in_c(6:6),*) lon_b
          read(in_c(7:7),*) lat_c
          read(in_c(8:8),*) lon_c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c conversion to latitude and logitude from "mesh code"
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
          i0y=((68-lat_a)*80+(7-lat_b)*10+(10-lat_c))-(46-r0latmax)*120
          i0x=(lon_a-22)*80+lon_b*10+(lon_c+1)-(r0lonmin-122)*80
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Output
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
          write(18,*) in_a,i0y,i0x
       end do
       close(17)
       close(18)
c
       end program prog_map_cities_code_KYUSYU
