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
      PROGRAM main
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! caluculate Tair,Prcp,Wind,SWdown
! 20210618,hayakawa
!
! marge tair_point2grid.f90, makebin_tair_daily.f90,
!       wind_point2grid.f90, makebin_wind_dayly.f90,
!       rain_point2grid.f90, makebin_rain_dayly.f90,
!       swdo_point2grid.f90, makebin_swdo_dayly.f90, day_AMeDAS_swdo.f90
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      implicit none
      character*128 :: c0inputfile   ! InputFile
      character*128 :: c0tairfile    ! OutputFile
      character*128 :: c0prcpfile    ! OutputFile
      character*128 :: c0windfile    ! OutputFile
      character*128 :: c0swdofile    ! OutputFile
      character*128 :: c0outputfile  ! OutputFile
      character*128 :: c0var
      character*4 :: c0suf
      character*4 :: c0year          ! year
      character*2 :: c0mon, c0day    ! month, day
      character*1 :: c0lev           ! level
      real r0xlon, r0ylat, r0prcp, r0tair, r0wind, r0RN  ! InputFile's parameter
      integer i0day                     ! day(number)
      integer i0DOY                     ! day of year
!
! SWdown's parameter
      real r0rad     ! lat (rad)
      real r0d       ! (distance between the earth and the sun)/(their avarage distance)
      real r0delta   ! sun declination (rad)
      real r0h       ! solar zenith angle
      real r0w       ! time angle
      real r0N       ! hours of daylight available
      real r0Sdo     ! daily horizontal radiation (J/m2sec)
      real r0Sd      ! total solar radiation
!
      integer i0istation, i0nstation
      integer i0jgrid, i0igrid, i0lgrid
      real r0xlongrid, r0ylatgrid, r0sum, r0weightsum, r0lon, r0distance
      integer rec, recl
!
! Regeonal settings (Edit here) KYUSYU
      integer, parameter :: n0x=180  !
      integer, parameter :: n0y=180  !
      real, parameter :: n0lon=129.0 !
      real, parameter :: n0lat=34.0  !
      real, parameter :: n0=60.0     !
      real, dimension(117) :: r1xlonmat, r1ylatmat, r1mat !
      real, dimension(32400) :: r1ave                     !
!     
! Regeonal settings (Edit here) NakaKuji
!      integer, parameter :: n0x=120   !
!      integer, parameter :: n0y=120   !
!      real, parameter :: n0lon=139.0  !
!      real, parameter :: n0lat=38.0   !
!      real, parameter :: n0=60.0      !
!      real, dimension(78) :: r1xlonmat, r1ylatmat, r1mat   !
!      real, dimension(14400) :: r1ave                      !
!
      call getarg(1, c0year)
      call getarg(2, c0mon)
      call getarg(3, c0day)
      call getarg(4, c0lev)
      call getarg(5, c0var)
      call getarg(6, c0suf)
      read(c0day,*) i0day
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! Input file 
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!  
      c0inputfile='../org/ptwR/AMeDAS'//c0lev//'_'//c0year//'_'
     $     //c0mon//'_'//c0day//''//c0suf//'.txt'
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!Output file
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      c0tairfile='../dat/Tair____/AMeDAS'//c0lev//'_'//c0year//''
     $     //c0mon//''//c0day//''//c0suf//''
      c0prcpfile='../dat/Prcp____/AMeDAS'//c0lev//'_'//c0year//''
     $     //c0mon//''//c0day//''//c0suf//''
      c0windfile='../dat/Wind____/AMeDAS'//c0lev//'_'//c0year//''
     $     //c0mon//''//c0day//''//c0suf//''
      c0swdofile='../dat/SWdown__/AMeDAS'//c0lev//'_'//c0year//''
     $     //c0mon//''//c0day//''//c0suf//''
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! 2Cdadta to tair,prcp,wind,swdown 
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      open(10, file=c0inputfile, status='OLD')
      i0istation=0
      i0lgrid=0
      do while (.true.)
         read(10, *, err=100, end=110)
     $        r0xlon,r0ylat,r0prcp,r0tair,r0wind,r0RN
         i0istation=i0istation+1
         
         r1xlonmat(i0istation)=r0xlon     
         r1ylatmat(i0istation)=r0ylat
         
         if(c0var.eq.'Tair____')then
            r1mat(i0istation)=real(r0tair)+273.15
            c0outputfile=c0tairfile
!           write(6,*) r1xlonmat(i0istation), r1ylatmat(i0istation), r1mat(i0istation)
         else if(c0var.eq.'Prcp____')then
            r1mat(i0istation)=real(r0prcp)/86400
            c0outputfile=c0prcpfile
!           write(6,*) r1xlonmat(i0istation), r1ylatmat(i0istation), r1mat(i0istation)
         else if(c0var.eq.'Wind____')then
            r1mat(i0istation)=real(r0wind)
            c0outputfile=c0windfile
         else if(c0var.eq.'SWdown__')then
            r0rad=r0ylat*3.1415/180
            if (c0mon=='01') then
               i0DOY=i0day
            else if (c0mon=='02') then
               i0DOY=i0day+31
            else if (c0mon=='03') then
               i0DOY=i0day+59
            else if (c0mon=='04') then
               i0DOY=i0day+90
            else if (c0mon=='05') then
               i0DOY=i0day+120
            else if (c0mon=='06') then
               i0DOY=i0day+151
            else if (c0mon=='07') then
               i0DOY=i0day+181
            else if (c0mon=='08') then
               i0DOY=i0day+212
            else if (c0mon=='09') then
               i0DOY=i0day+243
            else if (c0mon=='10') then
               i0DOY=i0day+273
            else if (c0mon=='11') then
               i0DOY=i0day+304
            else if (c0mon=='12') then
               i0DOY=i0day+334
            end if
!
!Kondo,1994,P57,eq(4.3)???
!Otsuki, http://www.forest.kyushu-u.ac.jp/~otsuki/FHW_Text(Rad).pdf
!
            r0d=1+0.01676*cos((0.01721*(i0DOY-186)))
            r0delta=23.5*cos((0.01689*(i0DOY-173)))*(3.14/180)
!           r0h=(3.14/2-r0rad+r0delta)
            r0w=acos(-tan(r0rad)*tan(r0delta))
            r0N=r0w*24/3.14     !sishagunyu
            r0Sdo=1367/r0d**2*(r0w*sin(r0rad)*sin(r0delta)
     $           +sin(r0w)*cos(r0rad)*cos(r0delta))/3.14
            if (r0RN > 0) then
               r0Sd=r0Sdo*(0.244+0.511*(r0RN/r0N)) 
            else
               r0Sd=r0Sdo*0.118
            end if
            r1mat(i0istation)=real(r0Sd)
            c0outputfile=c0swdofile
         end if
   
!        write(6, *) r1xlonmat(i0istation), r1ylatmat(i0istation), r1mat(i0istation)
 100     continue
      end do
 110  continue
      close(10)
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! point-data to grid-data
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      i0nstation=i0istation
      
      do i0jgrid=1,n0y
         r0ylatgrid=n0lat-(i0jgrid-0.5)/n0
         do i0igrid=1,n0x
            r0xlongrid=n0lon+(i0igrid-0.5)/n0
            
            r0sum=0.0
            r0weightsum=0.0
            do i0istation=1,i0nstation
!              write(6, *) r1xlonmat(i0istation), r1ylatmat(i0istation)
               r0lon=(r0xlongrid-r1xlonmat(i0istation))
     $              *cos((r0ylatgrid+r1ylatmat(i0istation))
     $              /2/180.0*3.141592)
               r0distance=(r0lon**2+(r0ylatgrid
     $              -r1ylatmat(i0istation))**2)**(0.5)       
!              write(6, *) i0istation, r0distance           
               r0sum=r0sum+r1mat(i0istation)/(r0distance**2)
               r0weightsum=r0weightsum+1.0/(r0distance**2)         
            end do
            i0lgrid=(i0jgrid-1)*n0x+i0igrid
            r1ave(i0lgrid)=r0sum/r0weightsum      
!           write(6, *) r0xlongrid, r0ylatgrid, r1ave
!           write(6, *) r1ave
         end do
      end do
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! output(binary)
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      open(11, file=c0outputfile, access='DIRECT', recl=n0x*4)
       do i0jgrid=1,n0y
          write(11, rec=i0jgrid)
     $         (r1ave(i0lgrid),i0lgrid=(i0jgrid-1)*n0x+1,i0jgrid*n0x)
       end do
      close(11)
      END
