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
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! caluculate Psurf,RH,Qair,LWdown
! 20210618, hayakawa
!
! marge psur_point2grid.f90, makebin_psur_daily.f90,
!       day_AMeDAS_qair.f90, qair_point2grid.f90, makebin_qair_daily.f90,
!       day_AMeDAS_lwdo.f90, lwdo_point2grid.f90, makebin_lwdo_daily.f90
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      implicit none
      character*128 :: c0inputfile   ! InputFile
      character*128 :: psurfile, RHfile, qairfile, lwdofile, outputfile  ! OutputFile
      character*128 :: c0var
      character*4 :: suf
      character*4 :: zy        ! year
      character*2 :: zm, zd    ! month, day
      character*1 :: zl        ! level
      real xlon,ylat,prcp,tair,wind,RN,psurf,RH ! InputFile's parameter
      integer zdnum             !day
      integer DOY               !day of year
      real es,es1,es2,es3,es4,qair ! qair's parameter
      real e,esat               ! qair's parameter
      real rad,d,delta,h,w,N,Sdo,Sd ! SWdown's parameter
      real esa,ea,Tdew,log10W,log10Wtop,LdfT4        ! LWdown's parameter
      real mN,Bd,A,k3,md,j,i,F1,CC,SdfSdo,Sdf,B,C,Ld ! LWdown's parameter
!
      integer istation, nstation
      integer jgrid, igrid, lgrid
      real xlon_grid, ylat_grid, sum, weight_sum, longitude, distance
      integer rec, recl
!
! Regeonal settings (Edit here) KYUSYU
      integer, parameter :: n0x=180 !
      integer, parameter :: n0y=180 !
      real, parameter :: n0lon=129.0 !
      real, parameter :: n0lat=34.0 !
      real, parameter :: n0=60.0 !
      real, dimension(117) :: xlon_mat, ylat_mat, mat !
      real, dimension(32400) :: ave !
!
! Regeonal settings (Edit here) NakaKuji
!      integer, parameter :: n0x=120    !
!      integer, parameter :: n0y=120    !
!      real, parameter :: n0lon=139.0   !
!      real, parameter :: n0lat=38.0    !
!      real, parameter :: n0=60.0       !
!      real, dimension(78) :: xlon_mat, ylat_mat, mat   !
!      real, dimension(14400) :: ave                    !
!
      call getarg(1, zy)
      call getarg(2, zm)
      call getarg(3, zd)
      call getarg(4, zl)
      call getarg(5, c0var)
      call getarg(6, suf)
      read(zd,*) zdnum
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! Input file 
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!  
      c0inputfile='../org/ptwRpR/AMeDAS'//zl//'_'//zy//'_'//zm//'_'
     $     //zd//''//suf//'.txt'
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! Output file
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      psurfile='../dat/PSurf___/AMeDAS'//zl//'_'//zy//''//zm//''
     $     //zd//''//suf//''
      RHfile='../dat/RH______/AMeDAS'//zl//'_'//zy//''//zm//''
     $     //zd//''//suf//''
      qairfile='../dat/Qair____/AMeDAS'//zl//'_'//zy//''//zm//''
     $     //zd//''//suf//''
      lwdofile='../dat/LWdown__/AMeDAS'//zl//'_'//zy//''//zm//''
     $     //zd//''//suf//''
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! ptwRpR txt data to psurf,qair,lwdown
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      open(10, file=c0inputfile, status='OLD')
      istation=0
      lgrid=0
      do while (.true.)
         read(10, *, err=100, end=110) 
     $        xlon, ylat, prcp, tair, wind, RN, psurf, RH
         istation=istation+1
         
         xlon_mat(istation)=xlon     
         ylat_mat(istation)=ylat
         
         if(c0var.eq.'PSurf___')then
            mat(istation)=real(psurf)*100.0
            outputfile=psurfile
!     write(6,*) xlon_mat(istation), ylat_mat(istation), mat(istation)
         else if(c0var.eq.'RH______')then
            mat(istation)=real(RH)*0.01
            outputfile=RHfile
!     write(6,*) xlon_mat(istation), ylat_mat(istation), mat(istation)
         else if(c0var.eq.'Qair____')then
!
! (used by Kyusyu code)---------------------------------------------------------
!
      !!
      !!Tomitaka,1998
      !!https://www.metsoc.jp/tenki/pdf/1988/1988_02_0115.pdf
      !!
      !!eq 1
      !!
            es1=10.79574*(1-273.16/(tair+273.15))
            es2=5.028*log10((tair+273.15)/273.16)
            es3=1.50475*(10**(-4.0))
     $           *(1-10**(-8.2969*((tair+273.15)/273.16-1)))
            es4=0.42873*(10**(-3.0))
     $           *(10**(4.76955*(1-273.16/(tair+273.15)))-1)
            es=10**(es1-es2+es3+es4+0.78614) ! -2021,June
!           es=10**(-es1-es2+es3+es4+0.78614)  !NEW!    ! 2021,June- (hayakawa)
      !!
      !!Kondo,2000,P4,eq 1.2
      !!
            qair=0.622*(RH*es/100)/(psurf-0.378*RH*es/100)
!
! (used by H08)------------------------------------------------------------------
!
      !!Tetens (1930)
!      if(tair.gt.0.0)then                               !
!            esat=6.1078*10**((7.5*tair)/(237.3+tair))   !
!         else                                           !
!            esat=6.1078*10**((9.5*tair)/(265.3+tair))   !
!         end if                                         !
!         e=esat*RH/100                                  !
!!         qair=0.622*e/psurf                            !-2021,June 
!         qair=0.622*e/(psurf-0.378*e)  !NEW!            ! 2021,June- (hayakawa)
!---------------------------------------------------------------------------------
            mat(istation)=real(qair)
            outputfile=qairfile
         else if(c0var.eq.'LWdown__')then
            rad=ylat*3.1415/180
            if (zm=='01') then
               DOY=zdnum
            else if (zm=='02') then
               DOY=zdnum+31
            else if (zm=='03') then
               DOY=zdnum+59
            else if (zm=='04') then
               DOY=zdnum+90
            else if (zm=='05') then
               DOY=zdnum+120
            else if (zm=='06') then
               DOY=zdnum+151
            else if (zm=='07') then
               DOY=zdnum+181
            else if (zm=='08') then
               DOY=zdnum+212
            else if (zm=='09') then
               DOY=zdnum+243
            else if (zm=='10') then
               DOY=zdnum+273
            else if (zm=='11') then
               DOY=zdnum+304
            else if (zm=='12') then
               DOY=zdnum+334
            end if
      !
      !Kondo,1994,Pxx,eq
      !
            d=1+0.01676*cos((0.01721*(DOY-186)))           ! ??
            delta=23.5*cos((0.01689*(DOY-173)))*(3.14/180) ! ??
            w=acos(-tan(rad)*tan(delta))                   ! P57, eq 4.4
            N=w*24/3.14                                    ! ??(sisyagonyuu??)
            Sdo=1367/d**2*(w*sin(rad)*sin(delta)
     $           +sin(w)*cos(rad)*cos(delta))/3.14         ! P57, eq 4.3
            if (RN > 0) then
               Sd=Sdo*(0.244+0.511*(RN/N))                 ! ?? 
            else
               Sd=Sdo*0.118                                ! ??
            end if  
            esa=6.1078*exp(17.2694*tair/(tair+237.3))      ! ??
            ea=RH*esa/100                                  ! rh
            Tdew=(237.3*log10(ea/6.108))/(7.5-log10(ea/6.108)) ! P87, eq 4.73
            log10W=0.0312*Tdew-0.0963                          ! P86, eq 4.69
            log10Wtop=0.0315*log10W-0.1836                     ! P86, eq 4.70  ! -2021,June
!     log10Wtop=0.0315*Tdew-0.1836    !NEW!                    ! P86, eq 4.70  ! 2021,June- (hayakawa)
            LdfT4=0.74+0.19*log10Wtop+0.07*log10Wtop**2        ! P90, eq 4.83
            mN=1/COS(rad-delta) ! P88, eq 4.76
            Bd=0.1              ! P64, table 4.3 (dust) 
            A=0.2               ! (Albedo)
            k3=1.402-0.06*log10(Bd+0.02)-0.1*SQRT(mN-0.91)     ! P88, eq 4.76
            md=(psurf/1013)*k3*mN                              ! P88, eq 4.76
            j=(0.066+0.34+SQRT(Bd))*(A-0.15)                   ! P87, eq 4.74  ! -2021,June
!     j=(0.066+0.34*SQRT(Bd))*(A-0.15)  !NEW!                  ! P87, eq 4.74  ! 2021,June- (hayakawa)
            i=0.014*(md+7+2*log10W)*log10W                     ! P88, eq 4.76
            F1=0.056+0.16*SQRT(Bd)                             ! P87, eq 4.74
            CC=0.21-0.2*Bd                                     ! P87, eq 4.74
            SdfSdo=(CC+0.7/10**(md*F1))*(1-i)*(j+1)            ! P88, eq 4.76  ! -2021,June
!     SdfSdo=(CC+0.7/10**(-md*F1))*(1-i)*(j+1)  !NEW!          ! P88, eq 4.76  ! 2021,June- (hayakawa)
            Sdf=SdfSdo*Sdo
            B=Sd/Sdf                                           ! P91, eq 4.90
            C=0.03*B**3.0-0.3*B**2.0+1.25*B-0.04               ! P91, eq 4.90
            Ld=5.67/10**8*(tair+273.15)**4*(1-(1-LdfT4)*C)     ! P90, eq 4.84
            mat(istation)=real(Ld)
            outputfile=lwdofile
         end if
         
 100     continue
      end do
 110  continue
      close(10)
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! point-data to grid-data
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      nstation=istation
  
      do jgrid=1,n0y
         ylat_grid=n0lat-(jgrid-0.5)/n0
         do igrid=1,n0x
            xlon_grid=n0lon+(igrid-0.5)/n0
            
            sum=0.0
            weight_sum=0.0
            do istation=1,nstation
               longitude=(xlon_grid-xlon_mat(istation))
     $              *cos((ylat_grid+ylat_mat(istation))
     $              /2/180.0*3.141592)
               distance=(longitude**2+(ylat_grid-ylat_mat(istation))**2)
     $              **(0.5)
!     write(6, *) istation, distance           
               sum=sum+mat(istation)/(distance**2)
               weight_sum=weight_sum+1.0/(distance**2)     
            end do
            lgrid=(jgrid-1)*n0x+igrid
            ave(lgrid)=sum/weight_sum      
!      write(6, *) xlon_grid, ylat_grid, ave
!      write(6, *) ave
         end do
      end do
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! output(binary)
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      open(11, file=outputfile, access='DIRECT', recl=n0x*4)
      do jgrid=1,n0y
      write(11, rec=jgrid)(ave(lgrid),lgrid=(jgrid-1)*n0x+1,jgrid*n0x)
      end do
      close(11)
      END
