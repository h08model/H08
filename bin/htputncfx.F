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
      program htputncts
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cto   put data on existing netCDF file
cby   2010/09/30, hanasaki: H08ver1.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      implicit none
      include 'netcdf.inc'
c parameter (array)
      integer           n0l
      integer           n0x
      integer           n0y
      integer,allocatable::i1l2x(:)
      integer,allocatable::i1l2y(:)
      character*128     c0l2x
      character*128     c0l2y
c parameter (default)
      real              p0mis
      parameter        (p0mis=1.0E20)
c function
      integer           iargc
c temporary
      integer           i0tmp
      character*128     c0tmp
c in (set)
      character*128     c0idx
c in (flux)
      real,allocatable::r1dat(:)
      character*128     c0ifname
c out
      character*128     c0ofname
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c netcdf 
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c netCDF basics
      integer           status
      integer           ncid
      integer           start2(2)
      integer           count2(2)
c dimension ID
      integer           lon_id
      integer           lat_id
c dimension name
      character*128     lon_name
      character*128     lat_name
c dimension data
      data              lon_name/'lon'/
      data              lat_name/'lat'/
c var ID
      integer           var_id
c var name
      character*128     var_name
      character*128     var_units
      character*128     var_long_name
c var data
      real,allocatable::var_data(:,:)
c      real              var_data_tmp(nlon)
c var dimension
      integer           var_dims2(2)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Get variable
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(iargc().ne.13.and.iargc().ne.10)then
        write(*,*) 'Usage: htputncts n0l n0x n0y c0l2x c0l2y'
        write(*,*) '                 c0bints c0nc'
        write(*,*) '                 var_name var_units var_long_name'
        stop
      end if
c
      call getarg(1,c0tmp)      
      read(c0tmp,*) n0l
      call getarg(2,c0tmp)      
      read(c0tmp,*) n0x
      call getarg(3,c0tmp)      
      read(c0tmp,*) n0y
      call getarg(4,c0l2x)      
      call getarg(5,c0l2y)
      call getarg(6,c0ifname)
      call getarg(7,c0ofname)
      call getarg(8,var_name)
      call getarg(9,var_units)
      call getarg(10,var_long_name)
c
      allocate(var_data(n0x,n0y))
      allocate(r1dat(n0l))
      allocate(i1l2x(n0l))
      allocate(i1l2y(n0l))
c
      call read_i1l2xy(
     $     n0l,
     $     c0l2x,c0l2y,
     $     i1l2x,i1l2y)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Alert 
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(n0x.le.0)then 
        write(*,*) 'longitude no range!!'
        stop 
      else if(n0y.le.0)then 
        write(*,*) 'longitude no range!!'
        stop 
      end if 
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Add variable
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c open netCDF file
      status=NF_OPEN(c0ofname,NF_WRITE,ncid)
      if(status.ne.NF_NOERR) call sys__hdlerr(status)
c get dimension id (lon)
      status=NF_INQ_DIMID(ncid,lon_name,lon_id)
      if(status.ne.NF_NOERR) call sys__hdlerr(status)
c get dimension id (lat)
      status=NF_INQ_DIMID(ncid,lat_name,lat_id)
      if(status.ne.NF_NOERR) call sys__hdlerr(status)
c set dimension matrix
      var_dims2(1)=lon_id
      var_dims2(2)=lat_id
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c define variable
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(NF_INQ_VARID(ncid,var_name,var_id).ne.NF_NOERR)then
        status=NF_REDEF(ncid)
        status=NF_DEF_VAR(ncid,var_name,NF_FLOAT,2,var_dims2,
     $         var_id)
        if(status.ne.NF_NOERR) call sys__hdlerr(status)
c
        i0tmp=len_trim(var_units)
        status=NF_PUT_ATT_TEXT(ncid,var_id,'units',
     $       i0tmp,var_units)
        i0tmp=len_trim(var_long_name)
        status=NF_PUT_ATT_TEXT(ncid,var_id,'long_name',
     $       i0tmp,var_long_name)
c
        status=NF_PUT_ATT_REAL(ncid,var_id,'missing_value',
     $         NF_FLOAT,1,p0mis)
        if(status.ne.NF_NOERR) call sys__hdlerr(status)
        status=NF_ENDDEF(ncid)
        if(status.ne.NF_NOERR) call sys__hdlerr(status)
      end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Write to netCDF file
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c read binary file
      call read_binary(n0l,c0ifname,r1dat)
      call conv_r1tor2(n0l,n0x,n0y,i1l2x,i1l2y,
     $         r1dat,
     $         var_data)
c set data edge
      start2(1)=1
      start2(2)=1
c set data range
      count2(1)=n0x
      count2(2)=n0y
c debug
d     write(*,*) 'htputncts: start3(1)',start2(1)
d     write(*,*) 'htputncts: start3(2)',start2(2)
d     write(*,*) 'htputncts: count2(1)',count2(1)
d     write(*,*) 'htputncts: count2(2)',count2(2)
      status=NF_PUT_VARA_REAL(ncid,var_id,start2,count2,var_data)
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
