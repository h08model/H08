PROGRAM main

  character*4 :: c_zy
  character*2 :: c_zm, c_zd

   INTEGER::zy,zm,zd

   character*128 :: file1
   character*8 :: zstation

   call getarg(1, c_zy)
   call getarg(2, c_zm)
   call getarg(3, c_zd)

   read(c_zy, *) zy
   read(c_zm, *) zm
   read(c_zd, *) zd

!         12345678901234567890   
   file1='QAIR_yyyy_mm_dd.dat'
   
   file1(6:9)=c_zy
   file1(11:12)=c_zm
   file1(14:15)=c_zd

   open(10, file=file1, status='OLD')

   write(6, *) file1

!   zy=2015
!   zm=05
!   zd=31
   
do while (.true.)

   read(10,*,end=999)zstation,xlon,ylat,tair,RH,psur

es=10**(10.79574*(1-273.16/(tair+273.15))-5.028*log10((tair+273.15)/273.16)+1.50475*10**(-4)*(1-10**(-8.2969*((tair+273.15)/273.16-1)))+0.42873*10**(-3)*(10**(4.76955*(1-273.16/(tair+273.15)))-1)+0.78614)

!qair=0.622*(RH/100*es)/(psur-0.378*RH/100*es)
qair=0.622*(RH/100*es)/(psur-0.378*RH/100*es)*1000

PRINT *,zstation,xlon,ylat,qair

end do 
999 continue

END
