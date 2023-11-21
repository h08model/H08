PROGRAM main

  character*128 :: file1

  character*8 :: zstation

  character*4 :: zy
  character*2 :: zm, zd

  real, dimension(1000) :: xlon_mat, ylat_mat, swdo_mat

  call getarg(1, zy)
  call getarg(2, zm)
  call getarg(3, zd)
  
  file1='swdo_'//zy//'_'//zm//'_'//zd//'.dat'
!  file1=zy//'_'//zm//'_'//zd//'.dat'

  open(10, file=file1, status='OLD')

  istation=0

  do while (.true.)
     read(10, *, err=100, end=110) zstation, xlon, ylat, iswdo
     istation=istation+1

     xlon_mat(istation)=xlon     
     ylat_mat(istation)=ylat
     swdo_mat(istation)=real(iswdo)

100  continue
  end do
110 continue

  nstation=istation

  do jgrid=1,180
     ylat_grid=34.0-(jgrid-0.5)/60
     do igrid=1,180
        xlon_grid=129.0+(igrid-0.5)/60

        swdo_sum=0.0
        weight_sum=0.0
        do istation=1,nstation

!           write(6, *) xlon_mat(istation), ylat_mat(istation)

           distance=(((xlon_grid-xlon_mat(istation))*cos((ylat_grid+ylat_mat(istation))/2/180.0*3.141592))**2+(ylat_grid-ylat_mat(istation))**2)**(0.5)

!           write(6, *) istation, distance
           
           swdo_sum=swdo_sum+swdo_mat(istation)/(distance**2)
           weight_sum=weight_sum+1.0/(distance**2)

        end do

        swdo_ave=swdo_sum/weight_sum

!        write(6, *) xlon_grid, ylat_grid, rain_ave
        write(6, *) swdo_ave

     end do
  end do

END
