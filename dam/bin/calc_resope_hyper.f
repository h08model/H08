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
      subroutine calc_resope_hyper(
     $     i0secint, i0damid_,
     $     i0flgkrls,r0knorm, 
     $     c0optkrls,c0optdamrls,c0optdamwbc,
     $     r0anudis, r0damcap,r0damsrf,
     $     r0daminf, r0damdem,r0damdemfix,
     $     r0damrls,
     $     r0krls,   r0damsto,
     $     i0doy,    n0damid_,
     $     r1factor, r2rlsrls,i2rlsdoy,
     $     r2maxsto, i2maxdoy,r2minsto,i2mindoy,
     $     r0targetmax,r0targetmin)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cto   calculate reservoir operation
cby   2010/09/30, hanasaki, NIES: H08ver1.0
c
c     c0optdamrls='nokrls':constant release (=mean annual discharge)
c     c0optdamrls='nodem': no water demand
c     c0optdamrls='H06':   Hanasaki et al. 2006
c     c0optdamrls='M98':   Meigh et al. 1998, Doell et al. 2003
c     c0optdamrls='M12':   Mateo et al. 2012
c     c0optdamrls='F18':   Fujiwara 2018 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      implicit none
c parameter (physical)
      integer           n0secday
      parameter        (n0secday=86400)
c parameter (default)
      real              p0mis
      parameter        (p0mis=1.0E20)
c index(time)
      integer           i0secint
c function
      integer           igetday
c in (set)
      integer           i0damid_      !! dam id
      integer           i0flgkrls     !! flag for krls
      real              r0knorm       !! normal year coefficient [kg/s]
      character*128     c0optkrls     !! option for krls
      character*128     c0optdamrls   !! option for dam release
      character*128     c0optdamwbc   !! option for water balance calculation
c in (map)
      real              r0anudis       !! mean annual discharge [kg/s]
      real              r0damcap       !! sotrage capacity [kg]
      real              r0damsrf       !! dam surface area [m2]      
c in (flux)
      real              r0daminf       !! inflow  [kg/s]
      real              r0damdem       !! dam demand
      real              r0damdemfix    !! dam demand (annual mean)
c out
      real              r0damrls       !! release [kg/s]
c statevariables
      real              r0krls         !! release coefficient [-]
      real              r0damsto       !! storage [kg]
c local
      real              r0coverd       !! Capacity over Discharge
      real              r0actsto       !! active storage of Meigh et al. 1998
c added
      integer           i0doy
      real              r0damstomin
      real              r0target
c F18
      integer           n0damid_
      real              r0targetmax
      real              r0targetmin
      real              r1factor(n0damid_)
      real              r2rlsrls(n0damid_,4)
      integer           i2rlsdoy(n0damid_,4)
      real              r2maxsto(n0damid_,4)
      integer           i2maxdoy(n0damid_,4)
      real              r2minsto(n0damid_,4)
      integer           i2mindoy(n0damid_,4)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c initialize
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      r0coverd=0.0
      r0actsto=0.0
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c   Module 1
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(c0optkrls.eq.'yes') then
        if(i0flgkrls.eq.1)then
          r0krls=r0damsto/(r0knorm*r0damcap)
d          write(*,*) 'calc_resope: r0krls:  ',r0krls
d          write(*,*) 'calc_resope: r0damsto:',r0damsto
d          write(*,*) 'calc_resope: r0knorm: ',r0knorm
d          write(*,*) 'calc_resope: r0damcap:',r0damcap
          i0flgkrls=0
        end if
      else
        r0krls=1.0
      end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c   Module 2
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(c0optdamrls.eq.'nokrls') then
        r0damrls=max(r0anudis,0.0)
      else if(c0optdamrls.eq.'M12') then
        if(i0damid_.eq.1)then
          write(*,*) 'calc_resope i0damid_',i0damid_
          if(i0doy.ge.1.and.i0doy.le.120)then
            r0damrls=292.0*1000.0
          else if(i0doy.ge.121.and.i0doy.le.366)then
            r0damrls=133.0*1000.0            
          end if
          if(i0doy.ge.1.and.i0doy.le.120)then
            r0target=1.0+(r0damstomin-1.0)/120.0*real(i0doy)
            if(r0damsto.gt.r0target*r0damcap)then
              r0damrls=r0damrls
     $             +(r0damsto-r0target*r0damcap)/real(i0secint)
            end if
          end if
        else if(i0damid_.eq.2)then
          write(*,*) 'calc_resope i0damid_',i0damid_
          if(i0doy.ge.1.and.i0doy.le.120)then
            r0damrls=146.0*1000.0
          else if(i0doy.ge.121.and.i0doy.le.366)then
            r0damrls=84.0*1000.0
          end if
          if(i0doy.ge.1.and.i0doy.le.120)then
            r0target=1.0+(r0damstomin-1.0)/120.0*real(i0doy)
            if(r0damsto.gt.r0target*r0damcap)then
              r0damrls=r0damrls
     $             +(r0damsto-r0target*r0damcap)/real(i0secint)
            end if
          end if
        end if
c F18 starts
      else if(c0optdamrls.eq.'F18') then
        r0damrls=0.0
        if(i0damid_.ne.0)then
        if(r2maxsto(i0damid_,1).ge.0.0)then
        if(i0doy.ge.1.and.i0doy.lt.i2maxdoy(i0damid_,1))then
          r0targetmax=r2maxsto(i0damid_,1)
        else if(i0doy.ge.i2maxdoy(i0damid_,1).and.
     &          i0doy.lt.i2maxdoy(i0damid_,2))then
          r0targetmax=r2maxsto(i0damid_,1)
     &            +(r2maxsto(i0damid_,2)-r2maxsto(i0damid_,1))
     &            *real(i0doy-i2maxdoy(i0damid_,1)+1)
     &            /real(i2maxdoy(i0damid_,2)-i2maxdoy(i0damid_,1)+1)
        else if(i0doy.ge.i2maxdoy(i0damid_,2).and.
     &          i0doy.lt.i2maxdoy(i0damid_,3))then
          r0targetmax=r2maxsto(i0damid_,2)
        else if(i0doy.ge.i2maxdoy(i0damid_,3).and.
     &          i0doy.lt.i2maxdoy(i0damid_,4))then
          r0targetmax=r2maxsto(i0damid_,3)
        else if(i0doy.ge.i2maxdoy(i0damid_,4).and.i0doy.lt.367)then
          r0targetmax=r2maxsto(i0damid_,4)
        end if
ccc
        if(i0doy.ge.1.and.i0doy.lt.i2mindoy(i0damid_,1))then
          r0targetmin=r2minsto(i0damid_,1)
        else if(i0doy.ge.i2mindoy(i0damid_,1).and.
     &          i0doy.lt.i2mindoy(i0damid_,2))then
          r0targetmin=r2minsto(i0damid_,1)
     &            +(r2minsto(i0damid_,2)-r2minsto(i0damid_,1))
     &            *real(i0doy-i2mindoy(i0damid_,1)+1)
     &            /real(i2mindoy(i0damid_,2)-i2mindoy(i0damid_,1)+1)
        else if(i0doy.ge.i2mindoy(i0damid_,2).and.
     &          i0doy.lt.i2mindoy(i0damid_,3))then
          r0targetmin=r2minsto(i0damid_,2)
        else if(i0doy.ge.i2mindoy(i0damid_,3).and.
     &          i0doy.lt.i2mindoy(i0damid_,4))then
          r0targetmin=r2minsto(i0damid_,3)
        else if(i0doy.ge.i2mindoy(i0damid_,4).and.i0doy.lt.367)then
          r0targetmin=r2minsto(i0damid_,4)
        end if
ccc
        if(i0doy.ge.1.and.i0doy.lt.i2rlsdoy(i0damid_,1))then
          r0damrls=r2rlsrls(i0damid_,1)
        else if(i0doy.ge.i2rlsdoy(i0damid_,1).and.
     &          i0doy.lt.i2rlsdoy(i0damid_,2))then
          r0damrls=r2rlsrls(i0damid_,1)
     &            +(r2rlsrls(i0damid_,2)-r2rlsrls(i0damid_,1))
     &            *real(i0doy-i2rlsdoy(i0damid_,1)+1)
     &            /real(i2rlsdoy(i0damid_,2)-i2rlsdoy(i0damid_,1)+1)
        else if(i0doy.ge.i2rlsdoy(i0damid_,2).and.
     &          i0doy.lt.i2rlsdoy(i0damid_,3))then
          r0damrls=r2rlsrls(i0damid_,2)
        else if(i0doy.ge.i2rlsdoy(i0damid_,3).and.
     &          i0doy.lt.i2rlsdoy(i0damid_,4))then
          r0damrls=r2rlsrls(i0damid_,3)
     &            +(r2rlsrls(i0damid_,3)-r2rlsrls(i0damid_,4))
     &            *real(i0doy-i2rlsdoy(i0damid_,1)+1)
     &            /real(i2rlsdoy(i0damid_,2)-i2rlsdoy(i0damid_,1)+1)
        else if(i0doy.ge.i2rlsdoy(i0damid_,4).and.i0doy.lt.367)then
          r0damrls=r2rlsrls(i0damid_,4)
        end if
c
        r0damrls=r0krls*r0damrls*1000.0*r1factor(i0damid_)
        if(i0damid_.eq.2)then
          write(*,*) 'calc_resope_hyper ',
     $     i0doy,r0damrls,r0targetmax,r0targetmin,
     $     r2maxsto(i0damid_,1),r2maxsto(i0damid_,2),
     $     r2maxsto(i0damid_,3),r2maxsto(i0damid_,4)
        end if
c
        end if
        end if
c F18 end
ccc
      else if(c0optdamrls.eq.'M12flat2') then
        if(i0damid_.eq.1)then
          write(*,*) 'calc_resope flat2 i0damid_',i0damid_
          if(i0doy.ge.1.and.i0doy.le.120)then
            r0damrls=292.0*1000.0
          else if(i0doy.ge.121.and.i0doy.le.366)then
            r0damrls=133.0*1000.0            
          end if
          if(i0doy.ge.1.and.i0doy.le.120)then
            r0target=1.0+(r0damstomin-1.0)/120.0*real(i0doy)
            if(r0damsto.gt.r0target*r0damcap)then
              r0damrls=r0damrls
     $             +(r0damsto-r0target*r0damcap)/real(i0secint)
            end if
          else if(i0doy.ge.121.and.i0doy.le.181)then
            r0target=1.0+(r0damstomin-1.0)
            if(r0damsto.gt.r0target*r0damcap)then
              r0damrls=r0damrls
     $             +(r0damsto-r0target*r0damcap)/real(i0secint)
            end if
          end if
        else if(i0damid_.eq.2)then
          write(*,*) 'calc_resope i0damid_',i0damid_
          if(i0doy.ge.1.and.i0doy.le.120)then
            r0damrls=146.0*1000.0
          else if(i0doy.ge.121.and.i0doy.le.366)then
            r0damrls=84.0*1000.0
          end if
          if(i0doy.ge.1.and.i0doy.le.120)then
            r0target=1.0+(r0damstomin-1.0)/120.0*real(i0doy)
            if(r0damsto.gt.r0target*r0damcap)then
              r0damrls=r0damrls
     $             +(r0damsto-r0target*r0damcap)/real(i0secint)
            end if
          else if(i0doy.ge.121.and.i0doy.le.181)then
            r0target=1.0+(r0damstomin-1.0)
            if(r0damsto.gt.r0target*r0damcap)then
              r0damrls=r0damrls
     $             +(r0damsto-r0target*r0damcap)/real(i0secint)
            end if
          end if
        end if
ccc
ccc   Low until July Simulation
ccc
      else if(c0optdamrls.eq.'M12flat3') then
        if(i0damid_.eq.1)then
          write(*,*) 'calc_resope_flat3 i0damid_',i0damid_
          if(i0doy.ge.1.and.i0doy.le.120)then
            r0damrls=292.0*1000.0
          else if(i0doy.ge.121.and.i0doy.le.366)then
            r0damrls=133.0*1000.0            
          end if
          if(i0doy.ge.1.and.i0doy.le.120)then
            r0target=1.0+(r0damstomin-1.0)/120.0*real(i0doy)
            if(r0damsto.gt.r0target*r0damcap)then
              r0damrls=r0damrls
     $             +(r0damsto-r0target*r0damcap)/real(i0secint)
            end if
          else if(i0doy.ge.121.and.i0doy.le.212)then
            r0target=1.0+(r0damstomin-1.0)
            if(r0damsto.gt.r0target*r0damcap)then
              r0damrls=r0damrls
     $             +(r0damsto-r0target*r0damcap)/real(i0secint)
            end if
          end if
        else if(i0damid_.eq.2)then
          write(*,*) 'calc_resope',i0damid_
          if(i0doy.ge.1.and.i0doy.le.120)then
            r0damrls=146.0*1000.0
          else if(i0doy.ge.121.and.i0doy.le.366)then
            r0damrls=84.0*1000.0
          end if
          if(i0doy.ge.1.and.i0doy.le.120)then
            r0target=1.0+(r0damstomin-1.0)/120.0*real(i0doy)
            if(r0damsto.gt.r0target*r0damcap)then
              r0damrls=r0damrls
     $             +(r0damsto-r0target*r0damcap)/real(i0secint)
            end if
          else if(i0doy.ge.121.and.i0doy.le.212)then
            r0target=1.0+(r0damstomin-1.0)
            if(r0damsto.gt.r0target*r0damcap)then
              r0damrls=r0damrls
     $             +(r0damsto-r0target*r0damcap)/real(i0secint)
            end if
          end if
        end if
      else if(c0optdamrls.eq.'nodem') then
        r0daminf=r0daminf
        if(r0anudis.ne.0.0)then
          r0coverd=r0damcap/(r0anudis*365*n0secday)
        else
          r0coverd=1.0
        end if
        if(r0coverd.lt.0.5)then
          r0damrls=(r0coverd/0.5)**2*r0krls*r0anudis
     $         +(1-(r0coverd/0.5)**2)*r0daminf
        else
          r0damrls=r0krls*r0anudis
        end if
      else if(c0optdamrls.eq.'H06simple') then
        r0daminf=r0daminf
        r0damdem=r0damdem
d       write(*,*) 'calc_resope: before:   ',r0damdem
        r0damrls=max(r0damdem,0.5*r0anudis)
        r0damrls=min(r0damrls,2.0*r0anudis)
d       write(*,*) 'calc_resope: after:    ',r0damrls
        if(r0anudis.ne.0.0)then
          r0coverd=r0damcap/(r0anudis*365*n0secday)
        else
          r0coverd=1.0
        end if
d       write(*,*) 'calc_resope: r0coverd: ',r0coverd
        if(r0coverd.lt.0.5)then
          r0damrls=(r0coverd/0.5)**2*r0krls*r0damrls
     $         +(1-(r0coverd/0.5)**2)*r0daminf
        else
          r0damrls=r0krls*r0damrls
        end if
      else if(c0optdamrls.eq.'H06') then
        r0daminf=r0daminf
        r0damdem=r0damdem
d       write(*,*) 'calc_resope: before:   ',r0damdem
        if(r0anudis.ne.0.0)then
            if(r0damdemfix.lt.r0anudis*0.5)then
              r0damrls=r0anudis+r0damdem-r0damdemfix
            else
              r0damrls=r0anudis*0.5+r0anudis*0.5*r0damdem/r0damdemfix
            end if
        else
          write(*,*) 'calc_resope: error:'
          write(*,*) 'calc_resope: r0anudis: ',r0anudis
          write(*,*) 'calc_resope: i0damid_: ',i0damid_
          stop          
        end if
d       write(*,*) 'calc_resope: after:    ',r0damrls
        if(r0anudis.ne.0.0)then
          r0coverd=r0damcap/(r0anudis*365*n0secday)
        else
          r0coverd=1.0
        end if
d       write(*,*) 'calc_resope: r0coverd: ',r0coverd
        if(r0coverd.lt.0.5)then
          r0damrls=(r0coverd/0.5)**2*r0krls*r0damrls
     $         +(1-(r0coverd/0.5)**2)*r0daminf
        else
          r0damrls=r0krls*r0damrls
        end if
      else if(c0optdamrls.eq.'M98') then
        if(r0damsrf.gt.0)then
          r0actsto=r0damsto-(r0damcap-r0damsrf*5.0*1000)
          if(r0actsto.gt.0.0.and.r0damsrf.gt.0.0)then
            r0damrls=0.01
     $           *r0actsto/real(n0secday)
     $           *(r0actsto/(r0damsrf*5.0*1000))**1.5
          else
            r0damrls=0.0
          end if
          write(*,*) 'calc_resope: r0actsto:         ',r0actsto
          write(*,*) 'calc_resope: r0actcap:         ',r0damsrf*5*1000
          write(*,*) 'calc_resope: r0damrls(before): ',r0damrls
          write(*,*) 'calc_resope: r0damsto(before): ',r0damsto
        else
          r0damrls=p0mis
        end if
      else
        write(*,*) 'calc_resope: c0optdamrls',c0optdamrls,
     $       'not supported. Abort.'
        stop
      end if      
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Module 3
c - storage
c - when storage exceed reservoir capacity
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(c0optdamwbc.eq.'yes')then
        if(r0damrls.ne.p0mis)then
c
          r0damsto=r0damsto+(r0daminf-r0damrls)*i0secint
c F18 start
          if(c0optdamrls.ne.'F18')then
             r0targetmax=1.0
             r0targetmin=0.0
          end if
          if(r0damsto.gt.r0targetmax*r0damcap)then
            r0damrls=r0damrls+(r0damsto-r0targetmax*r0damcap)/i0secint
            r0damsto=r0targetmax*r0damcap
          else if(r0damsto.lt.r0targetmin*r0damcap)then
            r0damrls=r0damrls+(r0damsto-r0targetmin*r0damcap)/i0secint
            r0damsto=r0targetmin*r0damcap
          end if
          write(*,*) 'calc_resope: r0damrls(after): ',r0damrls
          write(*,*) 'calc_resope: r0damsto(after): ',r0damsto
c F18 end
        else
          r0damsto=p0mis
        end if
      end if
c
      end

