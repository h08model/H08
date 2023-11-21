PROGRAM main

  character*128 :: datfile1, binfile2
  
  real, dimension(32400) :: psur

  character*4 :: zy4
  character*2 :: zm,zd
  character*1 :: zl

! ==========================

  call getarg(1,zy4)
  call getarg(2,zm)
  call getarg(3,zd)
  call getarg(4,zl)

!           123456789012345678901234567890
  datfile1='KSpsur_yyyy_mm_dd.dat'
  datfile1(08:11)=zy4
  datfile1(13:14)=zm
  datfile1(16:17)=zd


  open(10, file=datfile1, status='OLD')

  lgrid=0
  do while (.true.)
     lgrid=lgrid+1
     read(10, *, err=100, end=110) psur(lgrid)

100  continue
  end do

110 continue

!           123456789012345678901234567890
!  binfile2='Psurf___/bin/KSpsur_yyyymmdd.bin'
  binfile2='../../met/dat/PSurf___/AMeDAS1_yyyymmdd.ks1'

  binfile2(30:30)=zl
  binfile2(32:35)=zy4
  binfile2(36:37)=zm
  binfile2(38:39)=zd

  open(11, file=binfile2, access='DIRECT', recl=180*4)

  do j=1,180

     write(11, rec=j) (psur(lgrid),lgrid=(j-1)*180+1,j*180)
        
  end do

  close(11)
  
END
