PROGRAM main

  character*128 :: file1

  character*8 :: zstation

  character*4 :: zy
  character*2 :: zm, zd

  real, dimension(1000) :: xlon_mat, ylat_mat, tair_mat

  call getarg(1, zy)
  call getarg(2, zm)
  call getarg(3, zd)
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!YESTERDAY DATA or AMeDAS DATA 
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!  
!  file1='tair_'//zy//'_'//zm//'_'//zd//'.dat'
   file1='AMeDAS2C06_'//zy//'_'//zm//'_'//zd//'.txt'
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  open(10, file=file1, status='OLD')

  istation=0

  do while (.true.)
     read(10, *, err=100, end=110) zstation, xlon, ylat, itair
     istation=istation+1

     xlon_mat(istation)=xlon     
     ylat_mat(istation)=ylat
     tair_mat(istation)=real(itair)+273.15
!write(6, *) xlon_mat(istation), ylat_mat(istation), tair_mat(istation)
100  continue
  end do
110 continue

  nstation=istation

  do jgrid=1,180
     ylat_grid=34.0-(jgrid-0.5)/60
     do igrid=1,180
        xlon_grid=129.0+(igrid-0.5)/60

        tair_sum=0.0
        weight_sum=0.0
        do istation=1,nstation

!           write(6, *) xlon_mat(istation), ylat_mat(istation)

           distance=(((xlon_grid-xlon_mat(istation))*cos((ylat_grid+ylat_mat(istation))/2/180.0*3.141592))**2+(ylat_grid-ylat_mat(istation))**2)**(0.5)

!           write(6, *) istation, distance
           
           tair_sum=tair_sum+tair_mat(istation)/(distance**2)
           weight_sum=weight_sum+1.0/(distance**2)

        end do

        tair_ave=tair_sum/weight_sum

!        write(6, *) xlon_grid, ylat_grid, rain_ave
        write(6, *) tair_ave

     end do
  end do

END
