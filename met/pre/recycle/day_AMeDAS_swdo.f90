PROGRAM main

  character*4 :: c_zy
  character*2 :: c_zm, c_zd

   !INTEGER::zy,zm,zd,DOY
   REAL::d,delta,h,w,N,Sdo,Sd
   character*128 :: file1
   character*8 :: zstation

   call getarg(1, c_zy)
   call getarg(2, c_zm)
   call getarg(3, c_zd)

   read(c_zy, *) zy
   read(c_zm, *) zm
   read(c_zd, *) zd

!         123456789012345678901234567890   
!   file1='SWDO_yyyy_mm_dd.dat'
   file1='AMeDAS2C14_yyyy_mm_dd.txt'

   file1(12:15)=c_zy
   file1(17:18)=c_zm
   file1(20:21)=c_zd

   open(10, file=file1, status='OLD')

   write(6, *) file1

!   zy=2015
!   zm=05
!   zd=31
   
   do while (.true.)

   read(10,*,end=999)zstation,xlon,ylat,RN

   rad=ylat*3.14/180

if (zm==01) then
  DOY=zd 
  d=1+0.01676*cos((0.01721*(DOY-186)))
  delta=23.5*cos((0.01689*(DOY-173)))*(3.14/180)
  h=(3.14/2-rad+delta)
  w=acos(-tan(rad)*tan(delta))
  N=w*24/3.14 !sishagunyu siteiru
  Sdo=1367/d**2*(w*sin(rad)*sin(delta)+sin(w)*cos(rad)*cos(delta))/3.14
  
   if (RN > 0) then
   Sd=Sdo*(0.244+0.511*(RN/N)) 
   else
   Sd=Sdo*0.118
   end if

PRINT *,zstation,xlon,ylat,Sd,Sdo

else if (zm==02) then
  DOY=zd+31
  d=1+0.01676*cos((0.01721*(DOY-186)))
  delta=23.5*cos((0.01689*(DOY-173)))*(3.14/180)
  h=(3.14/2-rad+delta)
  w=acos(-tan(rad)*tan(delta))
  N=w*24/3.14 !sishagunyu siteiru                                                                                                                             
  Sdo=1367/d**2*(w*sin(rad)*sin(delta)+sin(w)*cos(rad)*cos(delta))/3.14

   if (RN > 0) then
   Sd=Sdo*(0.244+0.511*(RN/N))
   else
   Sd=Sdo*0.118
   end if

PRINT *,zstation,xlon,ylat,Sd,Sdo

else if (zm==03) then
  DOY=zd+59
  d=1+0.01676*cos((0.01721*(DOY-186)))
  delta=23.5*cos((0.01689*(DOY-173)))*(3.14/180)
  h=(3.14/2-rad+delta)
  w=acos(-tan(rad)*tan(delta))
  N=w*24/3.14 !sishagunyu siteiru                                                                                                                             
  Sdo=1367/d**2*(w*sin(rad)*sin(delta)+sin(w)*cos(rad)*cos(delta))/3.14

   if (RN > 0) then
   Sd=Sdo*(0.244+0.511*(RN/N))
   else
   Sd=Sdo*0.118
   end if

PRINT *,zstation,xlon,ylat,Sd,Sdo

else if (zm==04) then
  DOY=zd+90
  d=1+0.01676*cos((0.01721*(DOY-186)))
  delta=23.5*cos((0.01689*(DOY-173)))*(3.14/180)
  h=(3.14/2-rad+delta)
  w=acos(-tan(rad)*tan(delta))
  N=w*24/3.14 !sishagunyu siteiru                                                                                                                             
  Sdo=1367/d**2*(w*sin(rad)*sin(delta)+sin(w)*cos(rad)*cos(delta))/3.14

   if (RN > 0) then
   Sd=Sdo*(0.244+0.511*(RN/N))
   else
   Sd=Sdo*0.118
   end if

PRINT *,zstation,xlon,ylat,Sd,Sdo

else if (zm==05) then
  DOY=zd+120
  d=1+0.01676*cos((0.01721*(DOY-186)))
  delta=23.5*cos((0.01689*(DOY-173)))*(3.14/180)
  h=(3.14/2-rad+delta)
  w=acos(-tan(rad)*tan(delta))
  N=w*24/3.14 !sishagunyu siteiru                                                                                                                             
  Sdo=1367/d**2*(w*sin(rad)*sin(delta)+sin(w)*cos(rad)*cos(delta))/3.14

   if (RN > 0) then
   Sd=Sdo*(0.244+0.511*(RN/N))
   else
   Sd=Sdo*0.118
   end if

PRINT *,zstation,xlon,ylat,Sd,Sdo

else if (zm==06) then
  DOY=zd+151
  d=1+0.01676*cos((0.01721*(DOY-186)))
  delta=23.5*cos((0.01689*(DOY-173)))*(3.14/180)
  h=(3.14/2-rad+delta)
  w=acos(-tan(rad)*tan(delta))
  N=w*24/3.14 !sishagunyu siteiru                                                                                                                             
  Sdo=1367/d**2*(w*sin(rad)*sin(delta)+sin(w)*cos(rad)*cos(delta))/3.14

   if (RN > 0) then
   Sd=Sdo*(0.244+0.511*(RN/N))
   else
   Sd=Sdo*0.118
   end if

PRINT *,zstation,xlon,ylat,Sd,Sdo

!WRITE(6,900) zstation,xlon,ylat,Sd,Sdo,N,RN
!900 format(a,f8.3,1x,f8.3,1x,f8.3,1x,f8.3,1x,f8.3,1x,f8.3)



else if (zm==07) then
  DOY=zd+181
  d=1+0.01676*cos((0.01721*(DOY-186)))
  delta=23.5*cos((0.01689*(DOY-173)))*(3.14/180)
  h=(3.14/2-rad+delta)
  w=acos(-tan(rad)*tan(delta))
  N=w*24/3.14 !sishagunyu siteiru                                                                                                                             
  Sdo=1367/d**2*(w*sin(rad)*sin(delta)+sin(w)*cos(rad)*cos(delta))/3.14

   if (RN > 0) then
   Sd=Sdo*(0.244+0.511*(RN/N))
   else
   Sd=Sdo*0.118
   end if

PRINT *,zstation,xlon,ylat,Sd,Sdo

else if (zm==08) then
  DOY=zd+212
  d=1+0.01676*cos((0.01721*(DOY-186)))
  delta=23.5*cos((0.01689*(DOY-173)))*(3.14/180)
  h=(3.14/2-rad+delta)
  w=acos(-tan(rad)*tan(delta))
  N=w*24/3.14 !sishagunyu siteiru                                                                                                                             
  Sdo=1367/d**2*(w*sin(rad)*sin(delta)+sin(w)*cos(rad)*cos(delta))/3.14

   if (RN > 0) then
   Sd=Sdo*(0.244+0.511*(RN/N))
   else
   Sd=Sdo*0.118
   end if

PRINT *,zstation,xlon,ylat,Sd,Sdo

else if (zm==09) then
  DOY=zd+243
  d=1+0.01676*cos((0.01721*(DOY-186)))
  delta=23.5*cos((0.01689*(DOY-173)))*(3.14/180)
  h=(3.14/2-rad+delta)
  w=acos(-tan(rad)*tan(delta))
  N=w*24/3.14 !sishagunyu siteiru                                                                                                                             
  Sdo=1367/d**2*(w*sin(rad)*sin(delta)+sin(w)*cos(rad)*cos(delta))/3.14

   if (RN > 0) then
   Sd=Sdo*(0.244+0.511*(RN/N))
   else
   Sd=Sdo*0.118
   end if

PRINT *,zstation,xlon,ylat,Sd,Sdo

else if (zm==10) then
  DOY=zd+273
  d=1+0.01676*cos((0.01721*(DOY-186)))
  delta=23.5*cos((0.01689*(DOY-173)))*(3.14/180)
  h=(3.14/2-rad+delta)
  w=acos(-tan(rad)*tan(delta))
  N=w*24/3.14 !sishagunyu siteiru                                                                                                                             
  Sdo=1367/d**2*(w*sin(rad)*sin(delta)+sin(w)*cos(rad)*cos(delta))/3.14

   if (RN > 0) then
   Sd=Sdo*(0.244+0.511*(RN/N))
   else
   Sd=Sdo*0.118
   end if

PRINT *,zstation,xlon,ylat,Sd,Sdo

else if (zm==11) then
  DOY=zd+304
  d=1+0.01676*cos((0.01721*(DOY-186)))
  delta=23.5*cos((0.01689*(DOY-173)))*(3.14/180)
  h=(3.14/2-rad+delta)
  w=acos(-tan(rad)*tan(delta))
  N=w*24/3.14 !sishagunyu siteiru                                                                                                                            
  Sdo=1367/d**2*(w*sin(rad)*sin(delta)+sin(w)*cos(rad)*cos(delta))/3.14

   if (RN > 0) then
   Sd=Sdo*(0.244+0.511*(RN/N))
   else
   Sd=Sdo*0.118
   end if

PRINT *,zstation,xlon,ylat,Sd,Sdo

else if (zm==12) then
  DOY=zd+334
  d=1+0.01676*cos((0.01721*(DOY-186)))
  delta=23.5*cos((0.01689*(DOY-173)))*(3.14/180)
  h=(3.14/2-rad+delta)
  w=acos(-tan(rad)*tan(delta))
  N=w*24/3.14 !sishagunyu siteiru                                                                                                                             
  Sdo=1367/d**2*(w*sin(rad)*sin(delta)+sin(w)*cos(rad)*cos(delta))/3.14

   if (RN > 0) then
   Sd=Sdo*(0.244+0.511*(RN/N))
   else
   Sd=Sdo*0.118
   end if

PRINT *,zstation,xlon,ylat,Sd,Sdo

else
PRINT *,zy,zm,zd,"nothing"

end if 

end do
999 continue

END
