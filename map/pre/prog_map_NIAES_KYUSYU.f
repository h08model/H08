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
      program prog_map_NIAES_KYUSYU
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   convert NIAES 1995.csv data into one minutes binary
cby   2020/03/ matsuda, modified by hanasaki
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c
      integer           n0rec
      parameter        (n0rec=377970)
c
      integer           i0rec                  !! record (row)
      integer           i0itm                  !! item (column)
      real              r0lon                  !! longitude
      real              r0lat                  !! latitude
      character*128     c0lonmin
      character*128     c0lonmax
      character*128     c0latmin
      character*128     c0latmax
      real              r0lonmin
      real              r0lonmax
      real              r0latmin
      real              r0latmax
c in
      character(8) ::   mesh            !! the "mesh code"
      integer           i1dat(27)       !! data (1995B.csv)
      character*128     c0ifname
c out
      character*128     c0ofname
c local
      integer           i0prfc              !! prefecture code
      character*128     c0prfcmin
      character*128     c0prfcmax
      integer           i0prfcmin
      integer           i0prfcmax
c
      real lat_a                !! fragments of the "mesh code"
      real lat_b
      real lat_c
      real lon_a
      real lon_b
      real lon_c
c
      real              r0lon01
      real              r0lon02
      real              r0lon03
      real              r0lat01
      real              r0lat02
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(iargc().ne.8)then
        write(*,*) 'prog_map_NIAES_KYUSYU c0ifname c0ofname 
     $        c0prfcmin c0prfcmax c0lonmin c0lonmax c0latmin c0latmax'
        stop
      end if
c
      call getarg(1,c0ifname)
      call getarg(2,c0ofname)
      call getarg(3,c0prfcmin)
      call getarg(4,c0prfcmax)
      call getarg(5,c0lonmin)
      call getarg(6,c0lonmax)
      call getarg(7,c0latmin)
      call getarg(8,c0latmax)
c
      read(c0prfcmin,*)i0prfcmin
      read(c0prfcmax,*)i0prfcmax
      read(c0lonmin,*)r0lonmin
      read(c0lonmax,*)r0lonmax
      read(c0latmin,*)r0latmin
      read(c0latmax,*)r0latmax
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c open/read csv file
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      open(17,file=c0ifname, status='old')
      open(18,file=c0ofname, status='replace')
c
c skip/add header
c
      read(17, '()')
c      if(c0opt.eq.'crp')then
c        write(18,*) 'LON','LAT','CODE','RICE','FIEL','WHE_','MILG','POT_',
c     $              'GRN_','SUC_','RAP_','SUN_','SOR_','OTHR','MESH'
c      else
c        write(18,*) 'LON','LAT','CODE'
c      end if
c
c read
c
      i1dat=0
      do i0rec=1,n0rec
        read (17,*) mesh,(i1dat(i0itm),i0itm=1,25)
c
c conversion of "mesh code"
c
        read(mesh(1:2),*) lat_a
        read(mesh(3:4),*) lon_a
        read(mesh(5:5),*) lat_b
        read(mesh(6:6),*) lon_b
        read(mesh(7:7),*) lat_c
        read(mesh(8:8),*) lon_c
c
        i0prfc=int(i1dat(1)/1000)
c
c conversion to latitude and logitude from "mesh code"
c        
        r0lat=(lat_a/1.5*3600+lat_b*5*60+lat_c*30+7.5)/3600
        r0lon=((lon_a+100)*3600+lon_b*7.5*60+lon_c*45+7.5)/3600
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      lon01=lon, lat01=lat
c      
c      lat03,lon01---lat03,lon02---lat03,lon03---lat03,lon04
c           |             |             |             |
c           |             |             |             |
c      lat02,lon01---lat02,lon02---lat02,lon03---lat02,lon04
c           |             |             |             |
c           |             |             |             |
c      lat01,lon01---lat01,lon02---lat01,lon03---lat01,lon04
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
        r0lat01=r0lat
        r0lat02=(r0lat*3600+15)/3600
        r0lon01=r0lon
        r0lon02=(r0lon*3600+15)/3600
        r0lon03=(r0lon*3600+30)/3600
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Output
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c write (15"), unit conversion a -->m2
c
        if(i0prfc.ge.i0prfcmin.and.i0prfc.le.i0prfcmax) then
          if(r0lon.ge.r0lonmin.and.r0lon.le.r0lonmax.and.
     $       r0lat.ge.r0latmin.and.r0lat.le.r0latmax)then
c            write(18,*) r0lon01,r0lat01,i1dat(1),i0prfc,
            write(18,*) r0lon01,r0lat01,
     $             real(i1dat(10))/6.0*100.0,
     $             real(i1dat(11))/6.0*100.0,
     $             real(i1dat(12))/6.0*100.0
c            write(18,*) r0lon01,r0lat02,i1dat(1),i0prfc,
            write(18,*) r0lon01,r0lat02,
     $             real(i1dat(10))/6.0*100.0,
     $             real(i1dat(11))/6.0*100.0,
     $             real(i1dat(12))/6.0*100.0
c            write(18,*) r0lon02,r0lat01,i1dat(1),i0prfc,
            write(18,*) r0lon02,r0lat01,
     $             real(i1dat(10))/6.0*100.0,
     $             real(i1dat(11))/6.0*100.0,
     $             real(i1dat(12))/6.0*100.0
c            write(18,*) r0lon02,r0lat02,i1dat(1),i0prfc,
            write(18,*) r0lon02,r0lat02,
     $             real(i1dat(10))/6.0*100.0,
     $             real(i1dat(11))/6.0*100.0,
     $             real(i1dat(12))/6.0*100.0
c            write(18,*) r0lon03,r0lat01,i1dat(1),i0prfc,
            write(18,*) r0lon03,r0lat01,
     $             real(i1dat(10))/6.0*100.0,
     $             real(i1dat(11))/6.0*100.0,
     $             real(i1dat(12))/6.0*100.0
c            write(18,*) r0lon03,r0lat02,i1dat(1),i0prfc,
            write(18,*) r0lon03,r0lat02,
     $             real(i1dat(10))/6.0*100.0,
     $             real(i1dat(11))/6.0*100.0,
     $             real(i1dat(12))/6.0*100.0
          end if
        end if
      end do
c
c close files
c
      close(17)
      close(18)
c
      end
