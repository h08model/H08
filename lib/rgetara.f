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
      real function rgetara(r0lon1, r0lon2, r0lat1, r0lat2)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   calculate the area ranges from r0lon1 to r0lon2, from r0lat1 to r0lat2
cby   2010/03/31, hanasaki, NIES: H08 ver1.0
c
c     r0lat1, r0lat2 : latitude -90.0 (south pole) to 90.0 (north pole)
c     returns arealat : in m^2
c     by approximated equation
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter (physical)
      real              p0pi      !! Pi
      real              p0e2      !! e2
      real              p0rad     !! radius of the earth
      parameter        (p0pi=3.141592653589793238462643383)
      parameter        (p0e2=0.00669447) 
      parameter        (p0rad=6378136.0)
c in
      real              r0lon1    !! longitude
      real              r0lon2    !! longitude
      real              r0lat1    !! latitude
      real              r0lat2    !! latitude
c local
      real              r0e       !! e
      real              r0fnc1    !! result of function for dlat1
      real              r0fnc2    !! result of function for dlat2
      real              r0sin1    !! result of sin(dlat1)
      real              r0sin2    !! result of sin(dlat2)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      r0e=sqrt(p0e2)
c
      if((r0lat1.gt.90.0).or.(r0lat1.lt.-90.0).or.
     $   (r0lat2.gt.90.0).or.(r0lat2.lt.-90.0)) then
        write(6,*) 'rgetara: latitude out of range.'
        write(*,*) 'r0lon1(east) : ',r0lon1
        write(*,*) 'r0lon2(west) : ',r0lon2
        write(*,*) 'r0lat1(north): ',r0lat1
        write(*,*) 'r0lat1(south): ',r0lat2
        rgetara=0.0
      else
        r0sin1=sin(r0lat1*p0pi/180.0)
        r0sin2=sin(r0lat2*p0pi/180.0)
c
        r0fnc1 = r0sin1*(1+(r0e*r0sin1)**2/2.0)
        r0fnc2 = r0sin2*(1+(r0e*r0sin2)**2/2.0)
c
        rgetara = real(p0pi*p0rad**2*(1-r0e**2)/180.0*(r0fnc1-r0fnc2))
     $       *(r0lon2-r0lon1)
      end if
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Sign has been changed - to +.'
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      if (rgetara.lt.0.0) then
        rgetara=-1.0*rgetara
      end if
c
      end
