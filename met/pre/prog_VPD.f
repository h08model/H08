      program prog_VPD
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
cto   convert RH into VPD
cby   2010/09/30, hanasaki, NIES: H08ver1.0
cby   2021/12/01, ai,       NIES: modified
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      implicit none
c parameter (array)
      integer           n0l
      integer           n0t
      parameter        (n0t=3) 
c parameter (physical)
      integer           n0secday
      real              p0icepnt
      parameter        (p0icepnt=273.15)
      parameter        (n0secday=86400)
c parameter (default)
      real              p0mis
      parameter        (p0mis=1.0E20)
c temporary
      character*128     c0tmp
      character*128     s0ave
      data              s0ave/'ave'/ 
c function
      integer           igetday
c in (set)
      integer           i0yearmin
      integer           i0yearmax
c in
      real,allocatable::r1rh(:)    !! relative humidity
      real,allocatable::r1tair(:)    !! air temperature
      character*128     c0rh
      character*128     c0tair
c out  
      real,allocatable::r1vpd(:)      !! vapor pressure deficit
      real,allocatable::r2vpd(:,:)    !! vapor pressure deficit
      character*128     c0vpd
c index (time)
      integer           i0year
      integer           i0mon
      integer           i0day
      integer           i0sec
c local
      integer           i0monmin
      integer           i0monmax
      integer           i0daymin
      integer           i0daymax
      integer           i0secint
      integer           i0lenrh
      character*128     c0idx
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c Get argument
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      if(iargc().ne.6)then
        write(*,*) 'Usage: prog_RH n0l c0rh c0tair c0vpd'
        write(*,*) '               i0yearmin i0yearmax'
        stop
      end if
c
      call getarg(1,c0tmp)
      read(c0tmp,*) n0l
      call getarg(2,c0rh)
      call getarg(3,c0tair)
      call getarg(4,c0vpd)
      call getarg(5,c0tmp)
      read(c0tmp,*) i0yearmin
      call getarg(6,c0tmp)
      read(c0tmp,*) i0yearmax
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Allocate
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
      allocate(r1rh(n0l))
      allocate(r1tair(n0l))
      allocate(r1vpd(n0l))
      allocate(r2vpd(n0l,0:n0t))
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc 
c Read/Calculate/Write
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc       
      i0lenrh=len_trim(c0vpd)
      c0idx=c0vpd(i0lenrh-1:i0lenrh)
      if(c0idx.eq.'MO'.or.c0idx.eq.'MO'.or.c0idx.eq.'DY')then
        i0secint=86400
      else if(c0idx.eq.'6H')then
        i0secint=21600
      else if(c0idx.eq.'3H')then
        i0secint=10800
      else if(c0idx.eq.'HR')then
        i0secint=3600
      else
        write(*,*) 'prog_VPD: c0idx: ',c0idx,' not supported.'
        stop
      end if
c
      do i0year=i0yearmin,i0yearmax
        i0monmin=1
        i0monmax=12
        do i0mon=i0monmin,i0monmax
          i0daymin=1
          i0daymax=igetday(i0year,i0mon)
          do i0day=i0daymin,i0daymax
            do i0sec=i0secint,n0secday,i0secint
              call read_result(
     $             n0l,
     $             c0rh       ,i0year     ,i0mon      ,
     $             i0day      ,i0sec      ,i0secint   ,
     $             r1rh    )
              call read_result(
     $             n0l,
     $             c0tair     ,i0year     ,i0mon      ,
     $             i0day      ,i0sec      ,i0secint   ,
     $             r1tair     )
              call conv_tarhtovpd(
     $             n0l,
     $             r1tair,r1rh,
     $             r1vpd) 
              call wrte_bints2(
     $             n0l,n0t,
     $             r1vpd      ,r2vpd,
     $             c0vpd      ,i0year     ,i0mon      ,
     $             i0day      ,i0sec      ,i0secint   ,
     $             s0ave      )
            end do
          end do
        end do
      end do
c
      end
