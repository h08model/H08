      program prog_flwdir_CAMA
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      implicit none
      integer,
      integer    i0l
c
      call read_binary(n0l,c0rivnxl,r1rivnxl)
      call read_binary(n0l,c0rivnum,r1rivnum)
c
      do i0l=1,n0l
         if(r1rivnum(i0l).gt.0.0)then
            write(*,*) i0l,r1rivnxl(i0l)
        end if    
      end do

c
      end
