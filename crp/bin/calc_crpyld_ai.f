      subroutine calc_crpyld_ai(
     $     n0l,        n0crp,
     $     i0ldbg,
     $     i0crpdaymax,r0regfmin,  r0tdorm,    r0tfrz,
     $     r0thvs,     r0hunmax,   r0ihunmat,  c0optts,
     $     c0optws,    c0optns,    c0optps,    c0optlai,
     $     c0optce,    c0optve,    c0optfrz,
     $     r1icnum,    r1ird,      r1be,       r1hvsti,
     $     r1to,       r1tb,       r1blai,     r1dlai,
     $     r1dlp1,     r1dlp2,     r1bn1,      r1bn2,
     $     r1bn3,      r1bp1,      r1bp2,      r1bp3,
     $     r1cnyld,    r1cpyld,    r1rdmx,     r1cvm,
     $     r1almn,     r1sla,      r1pt2,      r1phun,
     $     i1flgcul,   i1crptyp,   i1crpday,
     $     r1tair,     r1swdown,   r1potevap,  r1evap,
     $     r1car,      r1vpd,      r1fer,
     $     r1evapgrn,  r1evapblu,
     $     r1huna,     r1swu,      r1swp,      r1regfw,
     $     r1regfl,    r1regfh,    r1regfn,    r1regfp,
     $     r1bt,       r1rsd,      r1outb,
     $     r1cwd,      r1cws,      r1yld,      r1regfd,
     $     r1cwsgrn,   r1cwsblu,
     $     i1flgmat,   i1flgend,   i1flgocu)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cto   calculate crop yield (SWIM ver8.0)
cby   2010/09/30, hanasaki, NIES: H08ver1.0
c     2010/09/14, pokhrel, IIS: bug fixed L141,L403,L502 (added tb)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      implicit none
c parameter (array)
      integer           n0l             !! number of girds
      integer           n0crp           !! number of crop types
c parameter (physical)
      real              p0icepnt        !! freezing point [K]
      parameter        (p0icepnt=273.15)
c index (array)
      integer           i0l             !!
c temporary
      real              r1tmp(n0l)      !! temporary
c in (set)
      integer           i0ldbg          !! debugging point
c in (parameter)
      integer           i0crpdaymax     !! maximum cropping day
      real              r0regfmin       !! minimum regf to report
      real              r0tdorm         !! dormancy temperature for winter crop
      real              r0tfrz          !! freezing temperature for winter crop
      real              r0thvs          !! min temperature for harvest
      real              r0hunmax        !! maximum daily heat unit
      real              r0ihunmat       !! heat unit for maturity
      character*128     c0optts         !! option of temperature stress
      character*128     c0optws         !! option of water stress
      character*128     c0optns         !! option of nitrogen stress
      character*128     c0optps         !! option of phosphorus stress
c ai202111start
      character*128     c0optlai        !! option of LAI adjusement
      character*128     c0optce         !! option of co2 effect
      character*128     c0optve         !! option of VPD effect
c ai202111end
      character*128     c0optfrz        !! option of freeze
c in (crop parameter)
      real              r1icnum(n0crp)  !!  1 crop number
      real              r1ird(n0crp)    !!  2 land cover category
      real              r1be(n0crp)     !!  3 biomass-energy ratio
      real              r1hvsti(n0crp)  !!  4 harvest index
      real              r1to(n0crp)     !!  5 optimal temperature
      real              r1tb(n0crp)     !!  6 base temperature
      real              r1blai(n0crp)   !!  7 maximum potential LAI
      real              r1dlai(n0crp)   !!  8 fraction of growing season
      real              r1dlp1(n0crp)   !!  9 LAI curve
      real              r1dlp2(n0crp)   !! 10 LAI curve
      real              r1bn1(n0crp)    !! 11 nitrogen
      real              r1bn2(n0crp)    !! 12 nitrogen
      real              r1bn3(n0crp)    !! 13 nitrogen
      real              r1bp1(n0crp)    !! 14 phosphorus
      real              r1bp2(n0crp)    !! 15 phosphorus
      real              r1bp3(n0crp)    !! 16 phosphorus
      real              r1cnyld(n0crp)  !! 17 fraction of N in crop yield
      real              r1cpyld(n0crp)  !! 18 fraction of P in crop yield
      real              r1rdmx(n0crp)   !! 19 maximum plant rooting depth
      real              r1cvm(n0crp)    !! 20 C factor
      real              r1almn(n0crp)   !! 21 minimum LAI
      real              r1sla(n0crp)    !! 22 specific leaf area
      real              r1pt2(n0crp)    !! 23 2nd point ??
      real              r1phun(n0crp)   !! 24 Potential heat unit
c in (map)
      integer           i1flgcul(n0l)   !! cultivation flag
      integer           i1crptyp(n0l)   !! croptype
      integer           i1crpday(n0l)   !! cropping day
c in (flux)
      real              r1tair(n0l)     !! air temperature
      real              r1swdown(n0l)   !! shortwave down radiation
      real              r1potevap(n0l)  !! potential evaporation
      real              r1evap(n0l)     !! evaporation
c ai202111start
      real              r1car(n0l)      !! co2 concentration
      real              r1vpd(n0l)      !! vapor pressure deficit
      real              r1fer(n0l)      !! total N appilication
c ai202111end
c state variable (crop)
      real              r1huna(n0l)     !! heat unit accum [K]
      real              r1swu(n0l)      !! plant transp in latter half
      real              r1swp(n0l)      !! poten transp in latter half
      real              r1regfw(n0l)    !! regulating factor is water
      real              r1regfl(n0l)    !! regulating factor is low temp
      real              r1regfh(n0l)    !! regulating factor is high temp
      real              r1regfn(n0l)    !! regulating factor is nitrogen
      real              r1regfp(n0l)    !! regulating factor is phosphorus
c state variable (C)
      real              r1bt(n0l)       !! total biomass  C [kg/ha]
      real              r1rsd(n0l)      !! Residual       C [kg/ha]
      real              r1outb(n0l)     !! Out of system  C [kg/ha]
c state variable (water)
      real              r1cwd(n0l)      !! poten transp in whole period
      real              r1cws(n0l)      !! plant transp in whole period
c out
      real              r1yld(n0l)      !! yield [kg/ha]
      real              r1regfd(n0l)    !! regulating factor dominant
      integer           i1flgmat(n0l)   !! maturity
      integer           i1flgend(n0l)   !! end of cropping
      integer           i1flgocu(n0l)   !! violating 1st crop ocupied period
c local (appeared in SWIM manual)
      real              r1bag(n0l)      !! above ground biomass
      real              r1lai(n0l)      !! LAI
      real              r1ihun(n0l)     !! heat unit normalized [-]
      real              r1par(n0l)      !! PAR [MJ/m2]
      real              r1hiad(n0l)     !! harvest index adjusted [-]
      real              r1wsf(n0l)      !! water sufficiency index
      real              r1hia(n0l)      !! harvest index accum [-]
      real              r1rwt(n0l)      !! biomass fraction: root/total
      real              r1ws(n0l)       !! water stress
      real              r1tsh(n0l)      !! temperature stress (high)
      real              r1tsl(n0l)      !! temperature stress (low)
      real              r1ns(n0l)       !! nitrogen stress
      real              r1ps(n0l)       !! phosphorus stress
      real              r1regf(n0l)     !! regulating factor
      real              r1rd(n0l)       !! root depth
      real              r1zd(n0l)       !!
      real              r1wup(n0l)      !!
      real              r1wu(n0l)       !!
      real              r1ctsl(n0l)     !!
      real              r1ctsh(n0l)     !!
c local (original)
      integer           i1flgfrz(n0l)   !! freezing day flag
      integer           i1flgexc(n0l)   !! crpday exceeds crpdaymax flag
      real              r1xlai1(n0l)    !! LAI curve x1
      real              r1xlai2(n0l)    !! LAI curve x2
      real              r1ylai1(n0l)    !! LAI curve y1
      real              r1ylai2(n0l)    !! LAI curve y2
c ai202111start
      real              r1blai_adj(n0l)
      real              r1coe1(n0l)
      real              r1coe2(n0l)
      real              r1beadj(n0l)
      real              r1beadj2(n0l)
      real              r1hvsti_adj(n0l)
c ai202111end
c local
      real              r1evapgrn(n0l)
      real              r1evapblu(n0l)
      real              r1cwsgrn(n0l)
      real              r1cwsblu(n0l)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c initialize
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      r1yld=0.0
      r1regfd=0.0
      i1flgmat=0
      i1flgend=0
c
      r1bag=0.0
      r1lai=0.0
      r1ihun=0.0
      r1par=0.0
      r1hiad=0.0
      r1wsf=0.0
      r1hia=0.0
      r1rwt=0.0
      r1ws=0.0
      r1tsh=0.0
      r1tsl=0.0
      r1ns=0.0
      r1ps=0.0
      r1regf=0.0
      r1rd=0.0
      r1zd=0.0
      r1wup=0.0
      r1wu=0.0
      r1ctsl=0.0
      r1ctsh=0.0
c
      i1flgfrz=0
      i1flgexc=0
      r1xlai1=0.0
      r1xlai2=0.0
      r1ylai1=0.0
      r1ylai2=0.0
c ai202111start
      r1blai_adj=0.0
      r1coe1=0.0
      r1coe2=0.0
      r1beadj=0.0
      r1beadj2=0.0
      r1hvsti_adj=0.0
c ai202111end
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Heat units or Growing stage
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0l=1,n0l
        if(i1flgcul(i0l).eq.1)then
          if(i1crptyp(i0l).eq.1.or.
     $       i1crptyp(i0l).eq.13.or.
     $       i1crptyp(i0l).eq.19)then
            if(r1tair(i0l)-p0icepnt-r1tb(i1crptyp(i0l)).gt.r0tdorm)then
              r1huna(i0l)
     $             =r1huna(i0l)
     $             +min(r1tair(i0l)-p0icepnt-r1tb(i1crptyp(i0l)),
     $                  r0hunmax)
              r1ihun(i0l)=r1huna(i0l)/r1phun(i1crptyp(i0l))
            end if
          else
            if(r1tair(i0l)-p0icepnt.gt.r1tb(i1crptyp(i0l)))then
              r1huna(i0l)
     $             =r1huna(i0l)
     $             +min(r1tair(i0l)-p0icepnt-r1tb(i1crptyp(i0l)),
     $                  r0hunmax)
              r1ihun(i0l)=r1huna(i0l)/r1phun(i1crptyp(i0l))
            end if
          end if
        end if
      end do
d     write(*,*) 'calc_crpyld: r1huna:   ',r1huna(i0ldbg)
d     write(*,*) 'calc_crpyld: r1ihun:   ',r1ihun(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c LAI (SWIM original LAI code)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      do i0l=1,n0l
c        if(i1flgcul(i0l).eq.1)then
c          if(r1ihun(i0l).le.r1dlai(i1crptyp(i0l)))then
c            r1lai(i0l)
c     $           =r1blai(i1crptyp(i0l))*r1bag(i0l)
c     $           /
c     $           (r1bag(i0l)+exp(9.5-0.0006*r1bag(i0l)))
c          else
c            r1lai(i0l)
c     $           =16.0*r1blai(i1crptyp(i0l))*(1-r1ihun(i0l))**2
c          end if
c        end if
c      end do
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c LAImax adjustment
c ai202111
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(c0optlai.eq.'yes')then
       do i0l=1,n0l
         if(i1crptyp(i0l).eq.5.or.
     $      i1crptyp(i0l).eq.12.or.
     $      i1crptyp(i0l).eq.15.or.
     $      i1crptyp(i0l).eq.19)then
c           if(r1fer(i0l).ge.0.0.and.r1fer(i0l).le.0.15)then
c            r1blai_adj(i0l)=0.5
c           else if(r1fer(i0l).gt.0.15.and.r1fer(i0l).le.0.2)then
c            r1blai_adj(i0l)=1
c           else if(r1fer(i0l).gt.0.2.and.r1fer(i0l).le.0.25)then
c            r1blai_adj(i0l)=1.5
c           else if(r1fer(i0l).gt.0.25.and.r1fer(i0l).le.0.3)then
c            r1blai_adj(i0l)=2.0
c           else if(r1fer(i0l).gt.0.3.and.r1fer(i0l).le.0.35)then
c            r1blai_adj(i0l)=2.5
c           else if(r1fer(i0l).gt.0.35.and.r1fer(i0l).le.0.4)then
c            r1blai_adj(i0l)=3.0
c           else if(r1fer(i0l).gt.0.4)then
c            r1blai_adj(i0l)=4.0
c           end if
           r1blai_adj(i0l)=r1fer(i0l)
         else
           r1blai_adj(i0l)=r1blai(i1crptyp(i0l))
         end if
       end do
      else if(c0optlai.eq.'no')then
       do i0l=1,n0l
        r1blai_adj(i0l)=r1blai(i1crptyp(i0l))
       end do
      end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c LAI (Modified LAI code)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0l=1,n0l
        if(i1flgcul(i0l).eq.1)then
          if(r1ihun(i0l).le.r1dlai(i1crptyp(i0l)))then
            r1xlai1(i0l)=real(int(r1dlp1(i1crptyp(i0l))))/100.0
            r1xlai2(i0l)=real(int(r1dlp2(i1crptyp(i0l))))/100.0
            r1ylai1(i0l)=r1dlp1(i1crptyp(i0l))-r1xlai1(i0l)*100.0
            r1ylai2(i0l)=r1dlp2(i1crptyp(i0l))-r1xlai2(i0l)*100.0
            if(r1ihun(i0l).lt.r1xlai1(i0l))then
              r1lai(i0l)
     $             =(0.0
     $             +(r1ylai1(i0l)-0.0)
     $              *(r1ihun(i0l)-0.0)
     $              /(r1xlai1(i0l)-0.0)
     $              )*r1blai_adj(i0l)
            else if(r1ihun(i0l).lt.r1xlai2(i0l))then
              r1lai(i0l)
     $             =(r1ylai1(i0l)
     $              +(r1ylai2(i0l)-r1ylai1(i0l))
     $               *(r1ihun(i0l)-r1xlai1(i0l))
     $               /(r1xlai2(i0l)-r1xlai1(i0l))
     $              )*r1blai_adj(i0l)
     $
            else
              r1lai(i0l)
     $             =(r1ylai2(i0l)
     $              +(1.0-r1ylai2(i0l))
     $               *(r1ihun(i0l)-r1xlai2(i0l))
     $               /(r1dlai(i1crptyp(i0l))-r1xlai2(i0l))
     $              )*r1blai_adj(i0l)
            end if
          else
          r1lai(i0l)=16.0*r1blai_adj(i0l)*(1.0-r1ihun(i0l))**2
          end if
        end if
      end do
d     write(*,*) 'calc_crpyld: r1lai:',r1lai(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Photosynthesis active radiation
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0l=1,n0l
        if(i1flgcul(i0l).eq.1)then
          r1par(i0l)=0.02092*r1swdown(i0l)*0.00143*60*24
     $         *(1-exp(-0.65*r1lai(i0l)))
        end if
      end do
d     write(*,*) 'calc_crpyld: r1par:',r1par(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c water stress (original swim)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      if(c0optws.eq.'no')then
c        do i0l=1,n0l
c          r1ws(i0l)=1.0
c        end do
c      else
c        do i0l=1,n0l
c          r1rd(i0l)=2.5*r1ihun(i0l)*r1rdmx(i1crptyp(i0l))
c          if(r1rd(i0l).gt.rzi)then
c            r1zd(i0l)=rz
c          else
c            r1zd(i0l)=r1rd(i0l)
c          end if
c
c          if(r1rd(i0l).eq.0)then
c            r1wup(i0l)=0.0
c          else
c            r1wup(i0l)=r1potevap(i0l)
c     $           /(1.0-exp(3.065))*(1.0-exp(-3.065*r1zd(i0l)/r1rd(i0l)))
c          end if
c
c          if(r1sw(i0l).le.0.25*r1fc(i0l)*r1sd(i0l)*1000.0)then
c            r1wu(i0l)
c     $           =r1wup(i0l)*r1sw(i0l)/(0.25*r1fc(i0l)*r1sd(i0l)*1000.0)
c          else
c            r1wu(i0l)=r1wup(i0l)
c          end if
c          if(r1potevap(i0l).le.0.0)then
c            r1ws(i0l)=1.0
c          else
c            r1ws(i0l)=r1wu(i0l)/r1potevap(i0l)
c          end if
c        end do
c      end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c water stress (modified)
c - rd
c - rz
c - water use potential (wup)
c - water use (wu)
c - water stress
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(c0optws.eq.'no')then
        do i0l=1,n0l
          r1ws(i0l)=1.0
        end do
      else
        do i0l=1,n0l
          if(i1flgcul(i0l).eq.1)then
            r1rd(i0l)=0.0
c
            r1zd(i0l)=0.0
c
c
            if(r1potevap(i0l).le.0.0)then
              r1ws(i0l)=1.0
            else
              r1wup(i0l)=r1potevap(i0l)
              if(r1evap(i0l).lt.0.33*r1potevap(i0l))then
                r1wu(i0l)=r1wup(i0l)*r1evap(i0l)/r1potevap(i0l)
              else
                r1wu(i0l)=r1wup(i0l)
              end if
              r1ws(i0l)=r1wu(i0l)/r1potevap(i0l)
            end if
          end if
        end do
      end if
d     write(*,*) 'calc_crpyld: r1wup:',r1wup(i0ldbg)
d     write(*,*) 'calc_crpyld: r1wu: ',r1wu(i0ldbg)
d     write(*,*) 'calc_crpyld: r1ws: ',r1ws(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c temperature stress
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(c0optts.eq.'no')then
        do i0l=1,n0l
          r1tsl(i0l)=1.0
          r1tsh(i0l)=1.0
        end do
      else
        do i0l=1,n0l
          if(i1flgcul(i0l).eq.1)then
            if(r1tair(i0l)-p0icepnt.lt.r1tb(i1crptyp(i0l)))then
              r1tsl(i0l)=0.0
              r1tsh(i0l)=1.0
            else if(r1tair(i0l)-p0icepnt.le.r1to(i1crptyp(i0l)))then
              r1ctsl(i0l)=(r1to(i1crptyp(i0l))+r1tb(i1crptyp(i0l)))
     $                   /(r1to(i1crptyp(i0l))-r1tb(i1crptyp(i0l)))
              if((r1tair(i0l)-p0icepnt).ne.0.0)then
                r1tsl(i0l)=exp(log(0.9)
     $               *(r1ctsl(i0l)
     $                 *(r1to(i1crptyp(i0l))-(r1tair(i0l)-p0icepnt))
     $                 /(r1tair(i0l)-p0icepnt)
     $                )**2)
                r1ctsh(i0l)=-999.0
                r1tsh(i0l)=1.0
              end if
            else if(r1tair(i0l)-p0icepnt.lt.
     $             2.0*r1to(i1crptyp(i0l))-r1tb(i1crptyp(i0l)))then
              r1ctsh(i0l)=2.0*r1to(i1crptyp(i0l))
     $             -(r1tair(i0l)-p0icepnt)-r1tb(i1crptyp(i0l))
              r1tsh(i0l)=exp(log(0.9)
     $             *((r1to(i1crptyp(i0l))-(r1tair(i0l)-p0icepnt))
     $               /r1ctsh(i0l)
     $              )**2)
              r1ctsl(i0l)=-999.0
              r1tsl(i0l)=1.0
            else
              r1tsh(i0l)=0.0
              r1tsl(i0l)=1.0
            end if
          end if
        end do
      end if
d     write(*,*) 'calc_crpyld: r1tsh:',r1tsh(i0ldbg)
d     write(*,*) 'calc_crpyld: r1tsl:',r1tsl(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c nitrogen stress
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(c0optns.eq.'no')then
        do i0l=1,n0l
          r1ns(i0l)=1.0
        end do
      end if
d     write(*,*) 'calc_crpyld: r1ns:',r1ns(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c phosphorus stress
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(c0optps.eq.'no')then
        do i0l=1,n0l
          r1ps(i0l)=1.0
        end do
      end if
d     write(*,*) 'calc_crpyld: r1ps:',r1ps(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Regurating factor
c - get the primary stress
c - save the stress
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0l=1,n0l
        if(i1flgcul(i0l).eq.1)then
          r1regf(i0l)
     $         =min(r1ws(i0l),r1tsl(i0l),r1tsh(i0l),r1ns(i0l),r1ps(i0l))
        end if
      end do
c
      do i0l=1,n0l
        if(i1flgcul(i0l).eq.1)then
          if     (r1regf(i0l).eq.r1ws(i0l) .and.
     $            r1ws(i0l) .lt.r0regfmin)then
            r1regfw(i0l)=r1regfw(i0l)+1.0
          else if(r1regf(i0l).eq.r1tsl(i0l).and.
     $            r1tsl(i0l).lt.r0regfmin)then
            r1regfl(i0l)=r1regfl(i0l)+1.0
          else if(r1regf(i0l).eq.r1tsh(i0l).and.
     $            r1tsh(i0l).lt.r0regfmin)then
            r1regfh(i0l)=r1regfh(i0l)+1.0
          else if(r1regf(i0l).eq.r1ns(i0l) .and.
     $            r1ns(i0l) .lt.r0regfmin)then
            r1regfn(i0l)=r1regfn(i0l)+1.0
          else if(r1regf(i0l).eq.r1ps(i0l) .and.
     $            r1ps(i0l) .lt.r0regfmin)then
            r1regfp(i0l)=r1regfp(i0l)+1.0
          end if
        end if
      end do
d     write(*,*) 'calc_crpyld: r1regf: ',r1regf(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c CO2 effect
c ai_202111 added
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(c0optce.eq.'yes')then
        do i0l=1,n0l
         if(r1car(i0l).le.330.0)then
          r1beadj(i0l)=r1be(i1crptyp(i0l))
         else if(r1car(i0l).gt.330.0)then
          if(i1crptyp(i0l).eq.5)then
            r1coe2(i0l)=(log(int(330.0/(0.01*4))-330.0)-
     $      log(int(660.0/(0.01*4*1.15))-660.0))/330.0
           r1coe1(i0l)=log(int(330.0/(0.01*4))-330.0)+r1coe2(i0l)*330.0
           r1beadj(i0l)=100*r1car(i0l)/(r1car(i0l)
     $      +exp(r1coe1(i0l)-r1coe2(i0l)*r1car(i0l)))
           r1beadj(i0l)=r1beadj(i0l)*10
          else if(i1crptyp(i0l).eq.12)then
            r1coe2(i0l)=(log(int(330.0/(0.01*2.5))-330.0)-
     $      log(int(660.0/(0.01*2.5*1.24))-660.0))/330.0
          r1coe1(i0l)=log(int(330.0/(0.01*2.5))-330.0)+r1coe2(i0l)*330.0
           r1beadj(i0l)=100*r1car(i0l)/(r1car(i0l)
     $      +exp(r1coe1(i0l)-r1coe2(i0l)*r1car(i0l)))
           r1beadj(i0l)=r1beadj(i0l)*10
          else if(i1crptyp(i0l).eq.15)then
            r1coe2(i0l)=(log(int(330.0/(0.01*2.5))-330.0)-
     $      log(int(660.0/(0.01*2.5*1.36))-660.0))/330.0
          r1coe1(i0l)=log(int(330.0/(0.01*2.5))-330.0)+r1coe2(i0l)*330.0
           r1beadj(i0l)=100*r1car(i0l)/(r1car(i0l)
     $      +exp(r1coe1(i0l)-r1coe2(i0l)*r1car(i0l)))
           r1beadj(i0l)=r1beadj(i0l)*10
          else if(i1crptyp(i0l).eq.19)then
            r1coe2(i0l)=(log(int(330.0/(0.01*3.0))-330.0)-
     $      log(int(660.0/(0.01*3.0*1.30))-660.0))/330.0
          r1coe1(i0l)=log(int(330.0/(0.01*3.0))-330.0)+r1coe2(i0l)*330.0
           r1beadj(i0l)=100*r1car(i0l)/(r1car(i0l)
     $      +exp(r1coe1(i0l)-r1coe2(i0l)*r1car(i0l)))
           r1beadj(i0l)=r1beadj(i0l)*10
          else
           r1beadj(i0l)=r1be(i1crptyp(i0l))
          end if
         end if
        end do
      else if(c0optce.eq.'no')then
       do i0l=1,n0l
        r1beadj(i0l)=r1be(i1crptyp(i0l))
       end do
      end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c VPD effect
c ai_202111 added
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(c0optve.eq.'yes')then
       do i0l=1,n0l
        if(r1vpd(i0l).le.1.0)then
          r1beadj2(i0l)=r1beadj(i0l)
        else if(r1vpd(i0l).gt.1.0)then
          if(i1crptyp(i0l).eq.5)then
            r1beadj2(i0l)=r1beadj(i0l)
     $      -7.2*(r1vpd(i0l)-1.0)
          else if(i1crptyp(i0l).eq.12)then
            r1beadj2(i0l)=r1beadj(i0l)
     $      -5.0*(r1vpd(i0l)-1.0)
          else if(i1crptyp(i0l).eq.15)then
            r1beadj2(i0l)=r1beadj(i0l)
     $      -8.0*(r1vpd(i0l)-1.0)
          else if(i1crptyp(i0l).eq.19)then
            r1beadj2(i0l)=r1beadj(i0l)
     $      -6.0*(r1vpd(i0l)-1.0)
          else
            r1beadj2(i0l)=r1beadj(i0l)
          end if
          if(r1beadj2(i0l).lt.(0.27*r1be(i1crptyp(i0l))))then
             r1beadj2(i0l)=0.27*r1be(i1crptyp(i0l))
          end if
        end if
       end do
      else if(c0optve.eq.'no')then
       do i0l=1,n0l
        r1beadj2(i0l)=r1beadj(i0l)
       end do
      end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Total biomass
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0l=1,n0l
        if(i1flgcul(i0l).eq.1)then
          if(i1crptyp(i0l).eq.1.or.
     $       i1crptyp(i0l).eq.13.or.
     $       i1crptyp(i0l).eq.19)then
            if(r1tair(i0l)-p0icepnt-r1tb(i1crptyp(i0l)).gt.r0tdorm)then
              r1bt(i0l)
     $        =r1bt(i0l)+r1beadj2(i0l)*r1par(i0l)*r1regf(i0l)
            end if
          else
            r1bt(i0l)
     $        =r1bt(i0l)+r1beadj2(i0l)*r1par(i0l)*r1regf(i0l)
          end if
        end if
      end do
d     write(*,*) 'calc_crpyld: r1bt:     ',r1bt(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Above ground biomass
c -
c - above ground biomass
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0l=1,n0l
        if(i1flgcul(i0l).eq.1)then
          r1rwt(i0l)=0.4-0.2*r1ihun(i0l)
c
          r1bag(i0l)=(1.0-r1rwt(i0l))*r1bt(i0l)
        end if
      end do
d     write(*,*) 'calc_crpyld: r1rwt:    ',r1rwt(i0ldbg)
d     write(*,*) 'calc_crpyld: r1bag:    ',r1bag(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Harvest index adjust
c ai_202201
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(c0optlai.eq.'yes')then
       do i0l=1,n0l
         if(i1crptyp(i0l).eq.5.or.
     $      i1crptyp(i0l).eq.12.or.
     $      i1crptyp(i0l).eq.19)then
          r1hvsti_adj(i0l)=0.10+0.5/6.8*(r1blai_adj(i0l)
     $     -0.3)
         else if(i1crptyp(i0l).eq.15)then
          r1hvsti_adj(i0l)=0.10+0.3/6.8*(r1blai_adj(i0l)
     $     -0.3)
         else
          r1hvsti_adj(i0l)=r1hvsti(i1crptyp(i0l))
         end if
       end do
      else if(c0optlai.eq.'no')then
       do i0l=1,n0l
          r1hvsti_adj(i0l)=r1hvsti(i1crptyp(i0l))
       end do
      end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Harvest index / Yield
c ai_202101,r1hvsti(i1crptyp(i0l))-> r1hvsti_adj(i0l)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0l=1,n0l
        if(i1flgcul(i0l).eq.1)then
          r1hia(i0l)=r1hvsti_adj(i0l)*100.0*r1ihun(i0l)
     $         /(100.0*r1ihun(i0l)+exp(11.1-10.0*r1ihun(i0l)))
        end if
      end do
c
      do i0l=1,n0l
        if(i1flgcul(i0l).eq.1)then
          if(r1ihun(i0l).gt.0.5.and.r1evap(i0l).gt.0.0)then
            r1swu(i0l)=r1swu(i0l)+r1evap(i0l)*86400.0
            r1swp(i0l)=r1swp(i0l)+max(r1potevap(i0l),0.0)*86400.0
          end if
        end if
      end do
c
      do i0l=1,n0l
        if(i1flgcul(i0l).eq.1)then
          if(c0optws.eq.'no')then
            r1wsf(i0l)=100
          else
            if(r1swp(i0l).eq.0)then
              r1wsf(i0l)=0.0
            else
              r1wsf(i0l)=100.0*r1swu(i0l)/r1swp(i0l)
            end if
          end if
        end if
      end do
c
      do i0l=1,n0l
        if(i1flgcul(i0l).eq.1)then
          r1hiad(i0l)=r1hia(i0l)*r1wsf(i0l)
     $         /(r1wsf(i0l)+exp(6.117-0.086*r1wsf(i0l)))
        end if
      end do
d     write(*,*) 'calc_crpyld: r1hia:  ',r1hia(i0ldbg)
d     write(*,*) 'calc_crpyld: r1swu:  ',r1swu(i0ldbg)
d     write(*,*) 'calc_crpyld: r1swp:  ',r1swp(i0ldbg)
d     write(*,*) 'calc_crpyld: r1wsf:  ',r1wsf(i0ldbg)
d     write(*,*) 'calc_crpyld: r1hiad: ',r1hiad(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Virtual Water
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0l=1,n0l
        if(i1flgcul(i0l).eq.1)then
          if(c0optws.eq.'no')then
            r1cwd(i0l)=r1cwd(i0l)+max(r1potevap(i0l),0.0)*86400.0
            r1cws(i0l)=r1cws(i0l)+max(r1potevap(i0l),0.0)*86400.0
            r1cwsgrn(i0l)=0.0
            r1cwsblu(i0l)=0.0
          else
            r1cwd(i0l)=r1cwd(i0l)+max(r1potevap(i0l),0.0)*86400.0
            r1cws(i0l)=r1cws(i0l)+max(r1evap(i0l),0.0)*86400.0
            r1cwsgrn(i0l)=r1cwsgrn(i0l)+max(r1evapgrn(i0l),0.0)*86400.0
            r1cwsblu(i0l)=r1cwsblu(i0l)+max(r1evapblu(i0l),0.0)*86400.0
          end if
        end if
      end do
d     write(*,*) 'calc_crpyld: r1cwd:  ',r1cwd(i0ldbg)
d     write(*,*) 'calc_crpyld: r1cws:  ',r1cws(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Cropping end flag: due to autumn freeze
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(c0optfrz.eq.'yes')then
        do i0l=1,n0l
          if(i1flgcul(i0l).eq.1)then
            if(i1crptyp(i0l).eq.1.or.
     $         i1crptyp(i0l).eq.13.or.
     $         i1crptyp(i0l).eq.19)then
              if(r1tair(i0l)-p0icepnt-r1tb(i1crptyp(i0l)).lt.r0tfrz)then
                i1flgfrz(i0l)=1
              else
                i1flgfrz(i0l)=0
              end if
c
              if(r1ihun(i0l).gt.r0ihunmat)then
                if(r1tair(i0l)-p0icepnt.lt.r0thvs)then
                  i1flgfrz(i0l)=1
                end if
              end if
c
            else
              if(r1tair(i0l)-p0icepnt.lt.r1tb(i1crptyp(i0l)))then
                i1flgfrz(i0l)=1
              else
                i1flgfrz(i0l)=0
              end if
            end if
          end if
        end do
      end if
d     write(*,*) 'calc_crpyld: i1flgfrz:  ',i1flgfrz(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Cropping end flag: due to too long cropping days
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0l=1,n0l
        if(i1flgcul(i0l).eq.1)then
          if(i1crpday(i0l).gt.i0crpdaymax)then
            i1flgexc(i0l)=1
          else
            i1flgexc(i0l)=0
          end if
        else
          i1flgexc(i0l)=0
        end if
      end do
d     write(*,*) 'calc_crpyld: i1flgexc:  ',i1flgexc(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Cropping end flag: due to maturity
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0l=1,n0l
        if(i1flgcul(i0l).eq.1)then
          if(r1ihun(i0l).gt.r0ihunmat.and.
     $       i1flgexc(i0l).eq.0.and.
     $       i1flgfrz(i0l).eq.0)then
            i1flgmat(i0l)=1
            r1yld(i0l)=r1hiad(i0l)*r1bag(i0l)
          else
            i1flgmat(i0l)=0
          end if
        else
          i1flgmat(i0l)=0
        end if
      end do
d     write(*,*) 'calc_crpyld: i1flgmat: ',i1flgmat(i0ldbg)
d     write(*,*) 'calc_crpyld: r1yld:    ',r1yld(i0ldbg)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Cropping end / Refreshing accumulative variables
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      do i0l=1,n0l
        if(i1flgcul(i0l).eq.1)then
          if(i1flgmat(i0l).eq.1.or.
     $       i1flgfrz(i0l).eq.1.or.
     $       i1flgexc(i0l).eq.1.or.
     $       i1flgocu(i0l).eq.1)then
c
            r1tmp(i0l)=max(r1regfw(i0l),
     $           r1regfl(i0l),r1regfh(i0l),
     $           r1regfn(i0l),r1regfp(i0l),1.0)
            if     (r1regfw(i0l).eq.r1tmp(i0l))then
              r1regfd(i0l)=1
            else if(r1regfl(i0l).eq.r1tmp(i0l))then
              r1regfd(i0l)=2
            else if(r1regfh(i0l).eq.r1tmp(i0l))then
              r1regfd(i0l)=3
            else if(r1regfn(i0l).eq.r1tmp(i0l))then
              r1regfd(i0l)=4
            else if(r1regfp(i0l).eq.r1tmp(i0l))then
              r1regfd(i0l)=5
            end if
c
            i1flgend(i0l)=1
c
            r1huna(i0l)=0.0
            r1swu(i0l)=0.0
            r1swp(i0l)=0.0
            r1regfw(i0l)=0.0
            r1regfl(i0l)=0.0
            r1regfh(i0l)=0.0
            r1regfn(i0l)=0.0
            r1regfp(i0l)=0.0
c
            r1rsd(i0l)
     $           =r1rsd(i0l)+(1.0-r1rwt(i0l))*r1bt(i0l)*r1hiad(i0l)
            r1outb(i0l)
     $           =r1outb(i0l)+r1bt(i0l)
     $           -(1.0-r1rwt(i0l))*r1bt(i0l)*r1hiad(i0l)
c
          end if
        end if
      end do
d     write(*,*) 'calc_crpyld: r1regfd:  ',r1regfd(i0ldbg)
c
      end
