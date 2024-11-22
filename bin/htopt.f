ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
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
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      program htopt 
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
cto fix the characters of options
cadded in 2024/03
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc      
      implicit none
c in
      character*128     c0optnnbs   !!options in cpl/bin/main
      character*128     c0optnnbg
      character*128     c0optriv
      character*128     c0optrgw
      character*128     c0optdes
      character*128     c0optrcl
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Change characters
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(c0optnnbs.eq.'Yes'.or.c0optnnbs.eq.'YES')then
         c0optnnbs='yes'
         print *,c0optnnbs
      else if(c0optnnbg.eq.'Yes'.or.c0optnnbg.eq.'YES')then
         c0optnnbg='yes'
         print *,c0optnnbg
      else if(c0optriv.eq.'Yes'.or.c0optriv.eq.'YES')then
         c0optriv='yes'
         print *,c0optriv
      else if(c0optrgw.eq.'Yes'.or.c0optrgw.eq.'YES')then
         c0optrgw='yes'
         print *,c0optrgw
      else if(c0optdes.eq.'Yes'.or.c0optdes.eq.'YES')then
         c0optdes='yes'
         print *,c0optdes
      else if(c0optrcl.eq.'Yes'.or.c0optrcl.eq.'YES')then
         c0optrcl='yes'
         print *,c0optrcl
      else if(c0optnnbs.eq.'No'.or.c0optnnbs.eq.'no')then
         c0optnnbs='NO'
         print *,c0optnnbs
      else if(c0optnnbg.eq.'No'.or.c0optnnbg.eq.'no')then
         c0optnnbg='NO'
         print *,c0optnnbg
      else if(c0optriv.eq.'No'.or.c0optriv.eq.'no')then
         c0optriv='NO'
         print *,c0optriv
      else if(c0optrgw.eq.'No'.or.c0optrgw.eq.'no')then
         c0optrgw='NO'
         print *,c0optrgw
      else if(c0optdes.eq.'No'.or.c0optdes.eq.'no')then
         c0optdes='NO'
         print *,c0optdes
      else if(c0optrcl.eq.'No'.or.c0optrcl.eq.'no')then
         c0optrcl='NO'
         print *,c0optrcl
      end if
      end 
        
