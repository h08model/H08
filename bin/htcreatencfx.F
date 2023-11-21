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
      program htcreatenc
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cto   create an empty netcdf
cby   2010/09/30, hanasaki: H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      implicit none
      include 'netcdf.inc'
c parameter (array)
      integer           n0x
      integer           n0y
      real              p0lonmax 
      real              p0lonmin 
      real              p0latmax 
      real              p0latmin
c index (array)
      integer           i0x
      integer           i0y
c function
      integer           iargc
      integer           igeti0x 
      integer           igeti0y 
      real              rgetlat
      real              rgetlon
c temporary
      character*128     c0tmp
c out
      character*128     c0ofname
c local 
      real              p0lonmin_dummy 
      real              p0lonmax_dummy 
      real              p0latmin_dummy 
      real              p0latmax_dummy 
      character*128     s0center
      data              s0center/'center'/ 
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c NetCDF variables
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c netCDF basics
      integer           status
      integer           ncid
c dimension ID
      integer           lon_id
      integer           lat_id
c     integer           lev_id
c dimension name
      character(LEN=128)     lon_name
      character(LEN=128)     lat_name
c     character(LEN=128)     lev_name
c dimension data
      data             lon_name/'lon'/
      data             lat_name/'lat'/
c     data             lev_name/'lev'/
c var ID
      integer            varlon_id
      integer            varlat_id
c var name
      character(LEN=128)      varlon_name
      character(LEN=128)      varlat_name
c var data
      data              varlon_name/'lon'/ 
      data              varlat_name/'lat'/ 
      real,dimension(:),allocatable ::   varlon_data
      real,dimension(:),allocatable ::   varlat_data
c var dimension
      integer         varlon_dims(1)
      integer         varlat_dims(1)
      real            varlon_range(2)
      real            varlat_range(2)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Get variable
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(iargc().ne.7)then
        write(*,*) 'Usage: htcreatenc n0x n0y'
        write(*,*) '                  p0lonmin p0lonmax p0latmin '
        write(*,*) '                  p0latmax c0nc'
        stop
      end if
c
      call getarg(1,c0tmp)
      read(c0tmp,*) n0x
      call getarg(2,c0tmp)
      read(c0tmp,*) n0y
      call getarg(3,c0tmp) 
      read(c0tmp,*) p0lonmin_dummy 
      call getarg(4,c0tmp) 
      read(c0tmp,*) p0lonmax_dummy 
      call getarg(5,c0tmp) 
      read(c0tmp,*) p0latmin_dummy 
      call getarg(6,c0tmp) 
      read(c0tmp,*) p0latmax_dummy 
      call getarg(7,c0ofname)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c set longitude and latitude
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      p0lonmax=max(p0lonmin_dummy,p0lonmax_dummy) 
      p0lonmin=min(p0lonmin_dummy,p0lonmax_dummy) 
      p0latmax=max(p0latmin_dummy,p0latmax_dummy) 
      p0latmin=min(p0latmin_dummy,p0latmax_dummy) 
      varlon_range(1)=p0lonmin
      varlon_range(2)=p0lonmax
      varlat_range(1)=p0latmin
      varlat_range(2)=p0latmax
      allocate(varlon_data(n0x))
      allocate(varlat_data(n0y))
c debug
d     write(*,*) 'htcreatenc: p0lonmin: ',p0lonmin
d     write(*,*) 'htcreatenc: p0lonmax: ',p0lonmax
d     write(*,*) 'htcreatenc: p0latmin: ',p0latmin
d     write(*,*) 'htcreatenc: p0latmax: ',p0latmax
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Error checker
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(n0x.le.0)then
        write(*,*) 'htcreatenc: error: longitude no range!!'
        stop
      else if(n0y.le.0)then
        write(*,*) 'htcreatenc: error: latitude no range!!'
        stop
      end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Create netCDF file
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      status=NF_CREATE(c0ofname,NF_CLOBBER,ncid)
      if(status.ne.NF_NOERR) call sys__hdlerr(status)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c set dimension
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      status=NF_DEF_DIM(ncid,lon_name,n0x,lon_id)
      if(status.ne.NF_NOERR) call sys__hdlerr(status)
      status=NF_DEF_DIM(ncid,lat_name,n0y,lat_id)
      if(status.ne.NF_NOERR) call sys__hdlerr(status)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c put lon
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      varlon_dims(1)=lon_id
      status=NF_DEF_VAR(ncid,varlon_name,NF_FLOAT,1,
     $     varlon_dims,varlon_id)
      if(status.ne.NF_NOERR) call sys__hdlerr(status)
      do i0x=1,n0x
        varlon_data(i0x)=rgetlon(n0x,p0lonmin,p0lonmax,i0x,s0center)
      end do
      status=NF_PUT_ATT_TEXT(ncid,varlon_id,'units',
     $     12,'degrees_east')
      status=NF_PUT_ATT_TEXT(ncid,varlon_id,'long_name',
     $     9,'Longitude')
      status=NF_PUT_ATT_REAL(ncid,varlon_id,'actual_range',
     $     NF_FLOAT,2,varlon_range)
      if(status.ne.NF_NOERR) call sys__hdlerr(status)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c put lat
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      varlat_dims(1)=lat_id
      status=NF_DEF_VAR(ncid,varlat_name,NF_FLOAT,1,
     $     varlat_dims,varlat_id)
      if(status.ne.NF_NOERR) call sys__hdlerr(status)
      do i0y=1,n0y
        varlat_data(i0y)=rgetlat(n0y,p0latmin,p0latmax,i0y,s0center)
      end do
      status=NF_PUT_ATT_TEXT(ncid,varlat_id,'units',
     $     13,'degrees_north')
      status=NF_PUT_ATT_TEXT(ncid,varlat_id,'long_name',
     $     8,'Latitude')
      status=NF_PUT_ATT_REAL(ncid,varlat_id,'actual_range',
     $     NF_FLOAT,2,varlat_range)
      if(status.ne.NF_NOERR) call sys__hdlerr(status)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c put global attribution
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      status=NF_PUT_ATT_TEXT(ncid,NF_GLOBAL,'Conventions',6,'COARDS')
      if(status.ne.NF_NOERR) call sys__hdlerr(status)
      status=NF_ENDDEF(ncid)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c put lon/lat data
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if(status.ne.NF_NOERR) call sys__hdlerr(status)
      status=NF_PUT_VAR_REAL(ncid,varlon_id,varlon_data)
      if(status.ne.NF_NOERR) call sys__hdlerr(status)
      status=NF_PUT_VAR_REAL(ncid,varlat_id,varlat_data)
      if(status.ne.NF_NOERR) call sys__hdlerr(status)
      status=NF_CLOSE(ncid)
      if(status.ne.NF_NOERR) call sys__hdlerr(status)
c
      end
      subroutine sys__hdlerr(status)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cto   system handle error (netCDF)
cby   nhanasaki
con   26th Aug 2003
cat   IIS,UT
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      include 'netcdf.inc'
c
      integer          status
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(status.ne.NF_NOERR)then
        write(*,*) NF_STRERROR(status)
        stop 'stopped'
      end if
c
      end
