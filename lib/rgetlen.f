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
      real function rgetlen(r0lon1, r0lon2, r0lat1, r0lat2)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cto   get the length (m) between (r0lon1, r0lat1) and (r0lon2, r0lat2)
cby   20100331, hanasaki, NIES: H08ver1.0
c
c     see page 643 of Rika-Nenpyo (2000)
c     at the final calculation, earth is assumed to be a sphere
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      implicit none
c parameter physical
      real              p0pi       !! Pi
      real              p0e2       !! eccentricity powered by 2
      real              p0a        !! the radius of the earth
      parameter        (p0pi=3.141592)
      parameter        (p0e2=0.006694470)
      parameter        (p0a=6378137.0)
c in
      real              r0lon1     !! longitude of the origin
      real              r0lat1     !! latitude  of the origin
      real              r0lon2     !! longitude of the destination
      real              r0lat2     !! latitude  of the destination
c local
      real              r0sinlat1  !! sin(lat1)
      real              r0sinlon1  !! sin(lon1)
      real              r0coslat1  !! cos(lat1)
      real              r0coslon1  !! cos(lon1)
      real              r0sinlat2  !! sin(lat2) 
      real              r0sinlon2  !! sin(lon2)
      real              r0coslat2  !! cos(lat2)
      real              r0coslon2  !! cos(lon2)
      real              r0h1       !! hegiht of the origin
      real              r0n1       !! intermediate val of calculation
      real              r0x1       !! X coordinate of the origin
      real              r0y1       !! Y coordinate of the origin
      real              r0z1       !! Z coordinate of the origin
      real              r0h2       !! height of the destination
      real              r0n2       !! intermediate val of calculation
      real              r0x2       !! X coordinate of the destination
      real              r0y2       !! Y coordinate of the destination
      real              r0z2       !! Z coordinate of the destination
      real              r0len      !! length between origin and destination
      real              r0rad      !! half of the angle
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c (lon1,lat1) --> (x1,y1,z1)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      r0h1=0.0
c
      r0sinlat1 = sin(r0lat1*p0pi/180.0)
      r0sinlon1 = sin(r0lon1*p0pi/180.0)
      r0coslat1 = cos(r0lat1*p0pi/180.0)
      r0coslon1 = cos(r0lon1*p0pi/180.0)
c
      r0n1 = p0a/(sqrt(1.0-p0e2*r0sinlat1*r0sinlat1))
      r0x1 = (r0n1+r0h1)*r0coslat1*r0coslon1
      r0y1 = (r0n1+r0h1)*r0coslat1*r0sinlon1
      r0z1 = (r0n1*(1-p0e2)+r0h1)*r0sinlat1
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c (lon2,lat2) --> (x2,y2,z2)
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      r0h2=0.0
c
      r0sinlat2 = sin(r0lat2 * p0pi/180.0)
      r0sinlon2 = sin(r0lon2 * p0pi/180.0)
      r0coslat2 = cos(r0lat2 * p0pi/180.0)
      r0coslon2 = cos(r0lon2 * p0pi/180.0)
c
      r0n2 = p0a/(sqrt(1.0-p0e2*r0sinlat2*r0sinlat2))
      r0x2 = (r0n2+r0h2)*r0coslat2*r0coslon2
      r0y2 = (r0n2+r0h2)*r0coslat2*r0sinlon2
      r0z2 = (r0n2*(1-p0e2)+r0h2)*r0sinlat2      
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Calculate length
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      r0len=sqrt((r0x1-r0x2)**2+(r0y1-r0y2)**2+(r0z1-r0z2)**2)
      r0rad=asin(r0len/2.0/p0a)
      rgetlen=r0rad*2.0*p0a
c
      end
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c original
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c      dlon = abs(r0lon1 - r0lon2)
c
c      if (dlon.ge.180.0) dlon = abs(360.0 - dlon)
c
c
c      if (r0lon1.eq.r0lon2) then
c        r0lat = (r0lat1+r0lat2) / 2.0
c        rgetlen = givelat(r0lat) * abs(r0lat1-r0lat2)
c      else if (r0lat1.eq.r0lat2) then
c        r0lat = r0lat1
c        rgetlen = givelon(r0lat) * dlon
c      else
c        r0lat = (r0lat1+r0lat2) / 2.0
c        re = giverade(r0lat)
c        dx = givelon(r0lat) * dlon / re
c        dy = givelat(r0lat) * abs(r0lat1 - r0lat2) / re
c        rgetlen = acos(dble(cos(dx)*cos(dy))) * re
c      end if


