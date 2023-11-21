PROGRAM main
  !INTEGER::zy,zm,zd,DOY
  REAL::N,mN,md,k3,esa,ea,Tdew,log10W,log10Wtop,LdfT4,j,i,F1,CC,SdfSdo,Sdf,B,C,Ld
  character*4 :: c_zy
  character*2 :: c_zm, c_zd
  character*128 :: file1
  character*8 :: zstation
  
  call getarg(1, c_zy)
  call getarg(2, c_zm)
  call getarg(3, c_zd)
  
  read(c_zy, *) zy
  read(c_zm, *) zm
  read(c_zd, *) zd
  !         12345678901234567890   
  !   file1='LWDO_yyyy_mm_dd.dat'
  file1='AMeDAS2A4L_yyyy_mm_dd.txt'  
  file1(12:15)=c_zy
  file1(17:18)=c_zm
  file1(20:21)=c_zd 
  
  open(10, file=file1, status='OLD')
  write(6, *) file1 
  
  do while (.true.)
     
     read(10,*,end=999)zstation,xlon,ylat,tair,RH,psur,RN
     rad=ylat*3.14/180
     !if (zm==01) then
     if (zm==06) then
        !  DOY=zd 
        DOY=zd+151 
        d=1+0.01676*cos((0.01721*(DOY-186)))
        delta=23.5*cos((0.01689*(DOY-173)))*(3.14/180)
        w=acos(-tan(rad)*tan(delta))
        N=w*24/3.14 !sishagunyu siteiru
        !  N=NINT(w*24/3.14) !sishagunyu siteiru
        Sdo=1367/d**2*(w*sin(rad)*sin(delta)+sin(w)*cos(rad)*cos(delta))/3.14
        
        if (RN > 0) then
           Sd=Sdo*(0.244+0.511*(RN/N)) 
        else
           Sd=Sdo*0.118
        end if
        
        esa=6.1078*exp(17.2694*tair/(tair+237.3))
        ea=RH*esa/100
        Tdew=(237.3*log10(ea/6.108))/(7.5-log10(ea/6.108))
        log10W=0.0312*Tdew-0.0963
        log10Wtop=0.0315*log10W-0.1836
        LdfT4=0.74+0.19*log10Wtop+0.07*log10Wtop**2
        mN=1/COS(rad-delta)
        Bd=0.1
        A=0.2
        k3=1.402-0.06*log10(Bd+0.02)-0.1*SQRT(mN-0.91)
        md=(psur/1013)*k3*mN 
        j=(0.066+0.34+SQRT(Bd))*(A-0.15)
        i=0.014*(md+7+2*log10W)*log10W
        F1=0.056+0.16*SQRT(Bd)
        CC=0.21-0.2*Bd
        SdfSdo=(CC+0.7/10**(md*F1))*(1-i)*(j+1)
        Sdf=SdfSdo*Sdo
        B=Sd/Sdf
        C=0.03*B**3-0.3*B**2+1.25*B-0.04
        Ld=5.67/10**8*(tair+273.15)**4*(1-(1-LdfT4)*C)
        
        PRINT *,zstation,xlon,ylat,Ld,Sd
        
     else if (zm==02) then
        DOY=zd+31
        d=1+0.01676*cos((0.01721*(DOY-186)))
        delta=23.5*cos((0.01689*(DOY-173)))*(3.14/180)
        h=(3.14/2-rad+delta)
        w=acos(-tan(rad)*tan(delta))
        N=w*24/3.14 !sishagunyu siteiru
!        N=NINT(w*24/3.14) !sishagunyu siteiru                                                                                                                             
        Sdo=1367/d**2*(w*sin(rad)*sin(delta)+sin(w)*cos(rad)*cos(delta))/3.14
        
        if (RN > 0) then
           Sd=Sdo*(0.244+0.511*(RN/N))
        else
           Sd=Sdo*0.118
        end if

        esa=6.1078*exp(17.2694*tair/(tair+237.3))
        ea=RH*esa/100
        Tdew=(237.3*log10(ea/6.108))/(7.5-log10(ea/6.108))
        log10W=0.0312*Tdew-0.0963
        log10Wtop=0.0315*log10W-0.1836
        LdfT4=0.74+0.19*log10Wtop+0.07*log10Wtop**2
        mN=1/COS(rad-delta)
        Bd=0.1
        A=0.2
        k3=1.402-0.06*log10(Bd+0.02)-0.1*SQRT(mN-0.91)
        md=(psur/1013)*k3*mN 
        j=(0.066+0.34+SQRT(Bd))*(A-0.15)
        i=0.014*(md+7+2*log10W)*log10W
        F1=0.056+0.16*SQRT(Bd)
        CC=0.21-0.2*Bd
        SdfSdo=(CC+0.7/10**(md*F1))*(1-i)*(j+1)
        Sdf=SdfSdo*Sdo
        B=Sd/Sdf
        C=0.03*B**3-0.3*B**2+1.25*B-0.04
        Ld=5.67/10**8*(tair+273.15)**4*(1-(1-LdfT4)*C)

        PRINT *,zstation,xlon,ylat,Ld,Sd
        
        
     else if (zm==03) then
        DOY=zd+59
        d=1+0.01676*cos((0.01721*(DOY-186)))
        delta=23.5*cos((0.01689*(DOY-173)))*(3.14/180)
        h=(3.14/2-rad+delta)
        w=acos(-tan(rad)*tan(delta))
        N=w*24/3.14 !sishagunyu siteiru
!        N=NINT(w*24/3.14) !sishagunyu siteiru

        Sdo=1367/d**2*(w*sin(rad)*sin(delta)+sin(w)*cos(rad)*cos(delta))/3.14
        
        if (RN > 0) then
           Sd=Sdo*(0.244+0.511*(RN/N))
        else
           Sd=Sdo*0.118
        end if
        
        esa=6.1078*exp(17.2694*tair/(tair+237.3))
        ea=RH*esa/100
        Tdew=(237.3*log10(ea/6.108))/(7.5-log10(ea/6.108))
        log10W=0.0312*Tdew-0.0963
        log10Wtop=0.0315*log10W-0.1836
        LdfT4=0.74+0.19*log10Wtop+0.07*log10Wtop**2
        mN=1/COS(rad-delta)
        Bd=0.1
        A=0.2
        k3=1.402-0.06*log10(Bd+0.02)-0.1*SQRT(mN-0.91)
        md=(psur/1013)*k3*mN 
        j=(0.066+0.34+SQRT(Bd))*(A-0.15)
        i=0.014*(md+7+2*log10W)*log10W
        F1=0.056+0.16*SQRT(Bd)
        CC=0.21-0.2*Bd
        SdfSdo=(CC+0.7/10**(md*F1))*(1-i)*(j+1)
        Sdf=SdfSdo*Sdo
        B=Sd/Sdf
        C=0.03*B**3-0.3*B**2+1.25*B-0.04
        Ld=5.67/10**8*(tair+273.15)**4*(1-(1-LdfT4)*C)

        PRINT *,zstation,xlon,ylat,Ld,Sd
        
        
        
     else if (zm==04) then
        DOY=zd+90
        d=1+0.01676*cos((0.01721*(DOY-186)))
        delta=23.5*cos((0.01689*(DOY-173)))*(3.14/180)
        h=(3.14/2-rad+delta)
        w=acos(-tan(rad)*tan(delta))
        N=w*24/3.14 !sishagunyu siteiru
!        N=NINT(w*24/3.14) !sishagunyu siteiru                                                                                                                             
        Sdo=1367/d**2*(w*sin(rad)*sin(delta)+sin(w)*cos(rad)*cos(delta))/3.14
        
        if (RN > 0) then
           Sd=Sdo*(0.244+0.511*(RN/N))
        else
           Sd=Sdo*0.118
        end if
        
        esa=6.1078*exp(17.2694*tair/(tair+237.3))
        ea=RH*esa/100
        Tdew=(237.3*log10(ea/6.108))/(7.5-log10(ea/6.108))
        log10W=0.0312*Tdew-0.0963
        log10Wtop=0.0315*log10W-0.1836
        LdfT4=0.74+0.19*log10Wtop+0.07*log10Wtop**2
        mN=1/COS(rad-delta)
        Bd=0.1
        A=0.2
        k3=1.402-0.06*log10(Bd+0.02)-0.1*SQRT(mN-0.91)
        md=(psur/1013)*k3*mN 
        j=(0.066+0.34+SQRT(Bd))*(A-0.15)
        i=0.014*(md+7+2*log10W)*log10W
        F1=0.056+0.16*SQRT(Bd)
        CC=0.21-0.2*Bd
        SdfSdo=(CC+0.7/10**(md*F1))*(1-i)*(j+1)
        Sdf=SdfSdo*Sdo
        B=Sd/Sdf
        C=0.03*B**3-0.3*B**2+1.25*B-0.04
        Ld=5.67/10**8*(tair+273.15)**4*(1-(1-LdfT4)*C)

        PRINT *,zstation,xlon,ylat,Ld,Sd
        
        
        
     else if (zm==05) then
        DOY=zd+120
        d=1+0.01676*cos((0.01721*(DOY-186)))
        delta=23.5*cos((0.01689*(DOY-173)))*(3.14/180)
        h=(3.14/2-rad+delta)
        w=acos(-tan(rad)*tan(delta))
        N=w*24/3.14 !sishagunyu siteiru
!        N=NINT(w*24/3.14) !sishagunyu siteiru                                                                                                                             
        Sdo=1367/d**2*(w*sin(rad)*sin(delta)+sin(w)*cos(rad)*cos(delta))/3.14
        
        if (RN > 0) then
           Sd=Sdo*(0.244+0.511*(RN/N))
        else
           Sd=Sdo*0.118
        end if
        
        esa=6.1078*exp(17.2694*tair/(tair+237.3))
        ea=RH*esa/100
        Tdew=(237.3*log10(ea/6.108))/(7.5-log10(ea/6.108))
        log10W=0.0312*Tdew-0.0963
        log10Wtop=0.0315*log10W-0.1836
        LdfT4=0.74+0.19*log10Wtop+0.07*log10Wtop**2
        mN=1/COS(rad-delta)
        Bd=0.1
        A=0.2
        k3=1.402-0.06*log10(Bd+0.02)-0.1*SQRT(mN-0.91)
        md=(psur/1013)*k3*mN 
        j=(0.066+0.34+SQRT(Bd))*(A-0.15)
        i=0.014*(md+7+2*log10W)*log10W
        F1=0.056+0.16*SQRT(Bd)
        CC=0.21-0.2*Bd
        SdfSdo=(CC+0.7/10**(md*F1))*(1-i)*(j+1)
        Sdf=SdfSdo*Sdo
        B=Sd/Sdf
        C=0.03*B**3-0.3*B**2+1.25*B-0.04
        Ld=5.67/10**8*(tair+273.15)**4*(1-(1-LdfT4)*C)

        PRINT *,zstation,xlon,ylat,Ld,Sd
        
        
        
        
        !else if (zm==06) then
     else if (zm==01) then
        DOY=zd+151
        d=1+0.01676*cos((0.01721*(DOY-186)))
        delta=23.5*cos((0.01689*(DOY-173)))*(3.14/180)
        h=(3.14/2-rad+delta)
        w=acos(-tan(rad)*tan(delta))
        N=w*24/3.14 !sishagunyu siteiru
!        N=NINT(w*24/3.14) !sishagunyu siteiru                                                                                                                             
        Sdo=1367/d**2*(w*sin(rad)*sin(delta)+sin(w)*cos(rad)*cos(delta))/3.14
        
        if (RN > 0) then
           Sd=Sdo*(0.244+0.511*(RN/N))
        else
           Sd=Sdo*0.118
        end if
        
        esa=6.1078*exp(17.2694*tair/(tair+237.3))
        ea=RH*esa/100
        Tdew=(237.3*log10(ea/6.108))/(7.5-log10(ea/6.108))
        log10W=0.0312*Tdew-0.0963
        log10Wtop=0.0315*log10W-0.1836
        LdfT4=0.74+0.19*log10Wtop+0.07*log10Wtop**2
        mN=1/COS(rad-delta)
        Bd=0.1
        A=0.2
        k3=1.402-0.06*log10(Bd+0.02)-0.1*SQRT(mN-0.91)
        md=(psur/1013)*k3*mN 
        j=(0.066+0.34+SQRT(Bd))*(A-0.15)
        i=0.014*(md+7+2*log10W)*log10W
        F1=0.056+0.16*SQRT(Bd)
        CC=0.21-0.2*Bd
        SdfSdo=(CC+0.7/10**(md*F1))*(1-i)*(j+1)
        Sdf=SdfSdo*Sdo
        B=Sd/Sdf
        C=0.03*B**3-0.3*B**2+1.25*B-0.04
        Ld=5.67/10**8*(tair+273.15)**4*(1-(1-LdfT4)*C)

        PRINT *,zstation,xlon,ylat,Ld,Sd
        
        
        
        
     else if (zm==07) then
        DOY=zd+181
        d=1+0.01676*cos((0.01721*(DOY-186)))
        delta=23.5*cos((0.01689*(DOY-173)))*(3.14/180)
        h=(3.14/2-rad+delta)
        w=acos(-tan(rad)*tan(delta))
        N=w*24/3.14 !sishagunyu siteiru
!        N=NINT(w*24/3.14) !sishagunyu siteiru                                                                                                                             
        Sdo=1367/d**2*(w*sin(rad)*sin(delta)+sin(w)*cos(rad)*cos(delta))/3.14
        
        if (RN > 0) then
           Sd=Sdo*(0.244+0.511*(RN/N))
        else
           Sd=Sdo*0.118
        end if
        
        esa=6.1078*exp(17.2694*tair/(tair+237.3))
        ea=RH*esa/100
        Tdew=(237.3*log10(ea/6.108))/(7.5-log10(ea/6.108))
        log10W=0.0312*Tdew-0.0963
        log10Wtop=0.0315*log10W-0.1836
        LdfT4=0.74+0.19*log10Wtop+0.07*log10Wtop**2
        mN=1/COS(rad-delta)
        Bd=0.1
        A=0.2
        k3=1.402-0.06*log10(Bd+0.02)-0.1*SQRT(mN-0.91)
        md=(psur/1013)*k3*mN 
        j=(0.066+0.34+SQRT(Bd))*(A-0.15)
        i=0.014*(md+7+2*log10W)*log10W
        F1=0.056+0.16*SQRT(Bd)
        CC=0.21-0.2*Bd
        SdfSdo=(CC+0.7/10**(md*F1))*(1-i)*(j+1)
        Sdf=SdfSdo*Sdo
        B=Sd/Sdf
        C=0.03*B**3-0.3*B**2+1.25*B-0.04
        Ld=5.67/10**8*(tair+273.15)**4*(1-(1-LdfT4)*C)

        PRINT *,zstation,xlon,ylat,Ld,Sd
        
        
        
        
     else if (zm==08) then
        DOY=zd+212
        d=1+0.01676*cos((0.01721*(DOY-186)))
        delta=23.5*cos((0.01689*(DOY-173)))*(3.14/180)
        h=(3.14/2-rad+delta)
        w=acos(-tan(rad)*tan(delta))
        N=w*24/3.14 !sishagunyu siteiru
!        N=NINT(w*24/3.14) !sishagunyu siteiru                                                                                                                             
        Sdo=1367/d**2*(w*sin(rad)*sin(delta)+sin(w)*cos(rad)*cos(delta))/3.14
        
        if (RN > 0) then
           Sd=Sdo*(0.244+0.511*(RN/N))
        else
           Sd=Sdo*0.118
        end if
        
        esa=6.1078*exp(17.2694*tair/(tair+237.3))
        ea=RH*esa/100
        Tdew=(237.3*log10(ea/6.108))/(7.5-log10(ea/6.108))
        log10W=0.0312*Tdew-0.0963
        log10Wtop=0.0315*log10W-0.1836
        LdfT4=0.74+0.19*log10Wtop+0.07*log10Wtop**2
        mN=1/COS(rad-delta)
        Bd=0.1
        A=0.2
        k3=1.402-0.06*log10(Bd+0.02)-0.1*SQRT(mN-0.91)
        md=(psur/1013)*k3*mN 
        j=(0.066+0.34+SQRT(Bd))*(A-0.15)
        i=0.014*(md+7+2*log10W)*log10W
        F1=0.056+0.16*SQRT(Bd)
        CC=0.21-0.2*Bd
        SdfSdo=(CC+0.7/10**(md*F1))*(1-i)*(j+1)
        Sdf=SdfSdo*Sdo
        B=Sd/Sdf
        C=0.03*B**3-0.3*B**2+1.25*B-0.04
        Ld=5.67/10**8*(tair+273.15)**4*(1-(1-LdfT4)*C)

        PRINT *,zstation,xlon,ylat,Ld,Sd
        
        
        
        
     else if (zm==09) then
        DOY=zd+243
        d=1+0.01676*cos((0.01721*(DOY-186)))
        delta=23.5*cos((0.01689*(DOY-173)))*(3.14/180)
        h=(3.14/2-rad+delta)
        w=acos(-tan(rad)*tan(delta))
        N=w*24/3.14 !sishagunyu siteiru
!        N=NINT(w*24/3.14) !sishagunyu siteiru                                                                                                                             
        Sdo=1367/d**2*(w*sin(rad)*sin(delta)+sin(w)*cos(rad)*cos(delta))/3.14
        
        if (RN > 0) then
           Sd=Sdo*(0.244+0.511*(RN/N))
        else
           Sd=Sdo*0.118
        end if
        
        esa=6.1078*exp(17.2694*tair/(tair+237.3))
        ea=RH*esa/100
        Tdew=(237.3*log10(ea/6.108))/(7.5-log10(ea/6.108))
        log10W=0.0312*Tdew-0.0963
        log10Wtop=0.0315*log10W-0.1836
        LdfT4=0.74+0.19*log10Wtop+0.07*log10Wtop**2
        mN=1/COS(rad-delta)
        Bd=0.1
        A=0.2
        k3=1.402-0.06*log10(Bd+0.02)-0.1*SQRT(mN-0.91)
        md=(psur/1013)*k3*mN 
        j=(0.066+0.34+SQRT(Bd))*(A-0.15)
        i=0.014*(md+7+2*log10W)*log10W
        F1=0.056+0.16*SQRT(Bd)
        CC=0.21-0.2*Bd
        SdfSdo=(CC+0.7/10**(md*F1))*(1-i)*(j+1)
        Sdf=SdfSdo*Sdo
        B=Sd/Sdf
        C=0.03*B**3-0.3*B**2+1.25*B-0.04
        Ld=5.67/10**8*(tair+273.15)**4*(1-(1-LdfT4)*C)

        PRINT *,zstation,xlon,ylat,Ld,Sd
        
        
        
        
     else if (zm==10) then
        DOY=zd+273
        d=1+0.01676*cos((0.01721*(DOY-186)))
        delta=23.5*cos((0.01689*(DOY-173)))*(3.14/180)
        h=(3.14/2-rad+delta)
        w=acos(-tan(rad)*tan(delta))
        N=w*24/3.14 !sishagunyu siteiru
!        N=NINT(w*24/3.14) !sishagunyu siteiru                                                                                                                             
        Sdo=1367/d**2*(w*sin(rad)*sin(delta)+sin(w)*cos(rad)*cos(delta))/3.14
        
        if (RN > 0) then
           Sd=Sdo*(0.244+0.511*(RN/N))
        else
           Sd=Sdo*0.118
        end if
        
        esa=6.1078*exp(17.2694*tair/(tair+237.3))
        ea=RH*esa/100
        Tdew=(237.3*log10(ea/6.108))/(7.5-log10(ea/6.108))
        log10W=0.0312*Tdew-0.0963
        log10Wtop=0.0315*log10W-0.1836
        LdfT4=0.74+0.19*log10Wtop+0.07*log10Wtop**2
        mN=1/COS(rad-delta)
        Bd=0.1
        A=0.2
        k3=1.402-0.06*log10(Bd+0.02)-0.1*SQRT(mN-0.91)
        md=(psur/1013)*k3*mN 
        j=(0.066+0.34+SQRT(Bd))*(A-0.15)
        i=0.014*(md+7+2*log10W)*log10W
        F1=0.056+0.16*SQRT(Bd)
        CC=0.21-0.2*Bd
        SdfSdo=(CC+0.7/10**(md*F1))*(1-i)*(j+1)
        Sdf=SdfSdo*Sdo
        B=Sd/Sdf
        C=0.03*B**3-0.3*B**2+1.25*B-0.04
        Ld=5.67/10**8*(tair+273.15)**4*(1-(1-LdfT4)*C)

        PRINT *,zstation,xlon,ylat,Ld,Sd
        
        
        
        
     else if (zm==11) then
        DOY=zd+304
        d=1+0.01676*cos((0.01721*(DOY-186)))
        delta=23.5*cos((0.01689*(DOY-173)))*(3.14/180)
        h=(3.14/2-rad+delta)
        w=acos(-tan(rad)*tan(delta))
        N=w*24/3.14 !sishagunyu siteiru
!        N=NINT(w*24/3.14) !sishagunyu siteiru                                                                                                                             
        Sdo=1367/d**2*(w*sin(rad)*sin(delta)+sin(w)*cos(rad)*cos(delta))/3.14
        
        if (RN > 0) then
           Sd=Sdo*(0.244+0.511*(RN/N))
        else
           Sd=Sdo*0.118
        end if
        
        esa=6.1078*exp(17.2694*tair/(tair+237.3))
        ea=RH*esa/100
        Tdew=(237.3*log10(ea/6.108))/(7.5-log10(ea/6.108))
        log10W=0.0312*Tdew-0.0963
        log10Wtop=0.0315*log10W-0.1836
        LdfT4=0.74+0.19*log10Wtop+0.07*log10Wtop**2
        mN=1/COS(rad-delta)
        Bd=0.1
        A=0.2
        k3=1.402-0.06*log10(Bd+0.02)-0.1*SQRT(mN-0.91)
        md=(psur/1013)*k3*mN 
        j=(0.066+0.34+SQRT(Bd))*(A-0.15)
        i=0.014*(md+7+2*log10W)*log10W
        F1=0.056+0.16*SQRT(Bd)
        CC=0.21-0.2*Bd
        SdfSdo=(CC+0.7/10**(md*F1))*(1-i)*(j+1)
        Sdf=SdfSdo*Sdo
        B=Sd/Sdf
        C=0.03*B**3-0.3*B**2+1.25*B-0.04
        Ld=5.67/10**8*(tair+273.15)**4*(1-(1-LdfT4)*C)

        PRINT *,zstation,xlon,ylat,Ld,Sd
        
        
        
        
     else if (zm==12) then
        DOY=zd+334
        d=1+0.01676*cos((0.01721*(DOY-186)))
        delta=23.5*cos((0.01689*(DOY-173)))*(3.14/180)
        h=(3.14/2-rad+delta)
        w=acos(-tan(rad)*tan(delta))
        N=w*24/3.14 !sishagunyu siteiru
!        N=NINT(w*24/3.14) !sishagunyu siteiru                                                                                                                             
        Sdo=1367/d**2*(w*sin(rad)*sin(delta)+sin(w)*cos(rad)*cos(delta))/3.14
        
        if (RN > 0) then
           Sd=Sdo*(0.244+0.511*(RN/N))
        else
           Sd=Sdo*0.118
        end if
        
        esa=6.1078*exp(17.2694*tair/(tair+237.3))
        ea=RH*esa/100
        Tdew=(237.3*log10(ea/6.108))/(7.5-log10(ea/6.108))
        log10W=0.0312*Tdew-0.0963
        log10Wtop=0.0315*log10W-0.1836
        LdfT4=0.74+0.19*log10Wtop+0.07*log10Wtop**2
        mN=1/COS(rad-delta)
        Bd=0.1
        A=0.2
        k3=1.402-0.06*log10(Bd+0.02)-0.1*SQRT(mN-0.91)
        md=(psur/1013)*k3*mN 
        j=(0.066+0.34+SQRT(Bd))*(A-0.15)
        i=0.014*(md+7+2*log10W)*log10W
        F1=0.056+0.16*SQRT(Bd)
        CC=0.21-0.2*Bd
        SdfSdo=(CC+0.7/10**(md*F1))*(1-i)*(j+1)
        Sdf=SdfSdo*Sdo
        B=Sd/Sdf
        C=0.03*B**3-0.3*B**2+1.25*B-0.04
        Ld=5.67/10**8*(tair+273.15)**4*(1-(1-LdfT4)*C)

        PRINT *,zstation,xlon,ylat,Ld,Sd
        
        
        
     else
        PRINT *,zy,zm,zd,"nothing"
        
     end if
     
  end do
999 continue

END
