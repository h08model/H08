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
cto   put time series data on existing netCDF file
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
c index (time)
      integer           i0year
      integer           i0mon
      integer           i0day
      integer           i0hour
c function
      integer           iargc
      integer           igetday
      character*128     cgetfnt
c temporary
      integer           i0tmp
      character*128     c0tmp
c in (set)
      character*128     c0idx
      integer           i0yearmin
c in (flux)
      real,allocatable::r1dat(:)
      character*128     c0in
c out
      character*128     c0ofname
c local
      integer           i0t
      integer           i0daymin
      integer           i0daymax
      integer           i0hourend
      integer           i0hourmin
      integer           i0hourint
      integer           i0day2
      integer           i0mon2
      integer           i0year2
      integer           i0hour2
      character*128     c0ifname
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c netcdf 
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c netCDF basics
      integer           status
      integer           ncid
      integer           start3(3)
      integer           count3(3)
c dimension ID
      integer           lon_id
      integer           lat_id
      integer           time_id
c dimension name
      character*128     lon_name
      character*128     lat_name
      character*128     time_name
c dimension data
      data              lon_name/'lon'/
      data              lat_name/'lat'/
      data              time_name/'time'/
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
      integer           var_dims3(3)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Get variable
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(iargc().ne.13.and.iargc().ne.14)then
        write(*,*) 'Usage: htputncts n0l n0x n0y c0l2x c0l2y'
        write(*,*) '                 c0bints i0year i0mon c0nc'
        write(*,*) '                 var_name var_units var_long_name'
        write(*,*) '                 OPTION'
        write(*,*) 'OPTION:[{YR i0yearmin},'
        write(*,*) '        {MO i0yearmin},'
        write(*,*) '        {DY},'
        write(*,*) '        {6H},'
        write(*,*) '        {3H}]'
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
      call getarg(6,c0in)
      call getarg(7,c0tmp)
      read(c0tmp,*) i0year
      call getarg(8,c0tmp)
      read(c0tmp,*) i0mon
      call getarg(9,c0ofname)
      call getarg(10,var_name)
      call getarg(11,var_units)
      call getarg(12,var_long_name)
      call getarg(13,c0idx)
      if(c0idx.eq.'YR'.or.c0idx.eq.'MO')then
        if(iargc().ne.14)then
          write(*,*) 'htputncts: i0yearmin needed for YR or MO.'
          stop
        end if
        call getarg(14,c0tmp)
        read(c0tmp,*) i0yearmin
      end if
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
c get dimension id (time)
      status=NF_INQ_DIMID(ncid,time_name,time_id)
      if(status.ne.NF_NOERR) call sys__hdlerr(status)
c set dimension matrix
      var_dims3(1)=lon_id
      var_dims3(2)=lat_id
      var_dims3(3)=time_id
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c define variable
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(NF_INQ_VARID(ncid,var_name,var_id).ne.NF_NOERR)then
        status=NF_REDEF(ncid)
        status=NF_DEF_VAR(ncid,var_name,NF_FLOAT,3,var_dims3,
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
      i0t=1
      if(c0idx.eq.'MO'.or.c0idx.eq.'YR')then
        i0daymin=0
        i0daymax=0
      else
        i0daymin=1
        i0daymax=igetday(i0year,i0mon)
      end if
      do i0day=i0daymin,i0daymax
        if(c0idx.eq.'3H')then
          i0hourmin=3
          i0hourend=24
          i0hourint=3
        else if(c0idx.eq.'6H')then
          i0hourmin=6
          i0hourend=24
          i0hourint=6
        else
          i0hourmin=0
          i0hourend=0
          i0hourint=1
        end if
        do i0hour=i0hourmin,i0hourend,i0hourint
          i0year2=i0year
          i0mon2=i0mon
          i0day2=i0day
          i0hour2=i0hour
          if(i0hour2.eq.24)then
            i0hour2=0
            i0day2=i0day+1
            if(i0day2.gt.igetday(i0year,i0mon))then
              i0day2=1
              i0mon2=i0mon+1
              if(i0mon2.gt.12)then
                i0mon2=1
                i0year2=i0year+1
              end if
            end if
          end if
c set binary file name
          c0ifname=cgetfnt(c0in,i0year2,i0mon2,i0day2,i0hour2)
          write(*,*) 'htputncts: c0ifname',c0ifname
c read binary file
          call read_binary(n0l,c0ifname,r1dat)
          call conv_r1tor2(n0l,n0x,n0y,i1l2x,i1l2y,
     $         r1dat,
     $         var_data)
c set data edge
          if(c0idx.eq.'MO')then
            start3(1)=1
            start3(2)=1
            start3(3)=(i0year-i0yearmin)*12+i0mon
          else if(c0idx.eq.'YR')then
            start3(1)=1
            start3(2)=1
            start3(3)=i0year-i0yearmin+1
            if(i0year.eq.0)then
              start3(3)=1
            end if
          else
            start3(1)=1
            start3(2)=1
            start3(3)=i0t
          end if
c set data range
          count3(1)=n0x
          count3(2)=n0y
          count3(3)=1
c debug
d         write(*,*) 'htputncts: start3(1)',start3(1)
d         write(*,*) 'htputncts: start3(2)',start3(2)
d         write(*,*) 'htputncts: start3(3)',start3(3)
d         write(*,*) 'htputncts: count3(1)',count3(1)
d         write(*,*) 'htputncts: count3(2)',count3(2)
d         write(*,*) 'htputncts: count3(3)',count3(3)
          status=NF_PUT_VARA_REAL(ncid,var_id,start3,count3,var_data)
          if(status.ne.NF_NOERR) call sys__hdlerr(status)
          i0t=i0t+1
        end do
      end do
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
