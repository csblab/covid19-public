C mortran 2.0 macros for .lc to FORTRAN (M.Levitt May 1986)              
      real function tonumber(str)
      implicit none
      character*(*) str
      integer k, i1
      real d10, value
      logical before_point
      before_point = .true.
      value = 0.0
      do 23011 k = 1, len(str)
      if(str(k:k) .eq. ' ')goto 23011
      if(str(k:k).ne.'.')goto 23031
      before_point = .false. 
      d10 = 0.1
23031 continue
      i1 = index ( '0123456789', str(k:k) )
      if(i1 .le. 0)goto 23011
      if(.not.(before_point))goto 23051
      value = value*10 + (i1-1)
      goto 23061
23051 continue
      value = value + (i1-1)*d10 
      d10 = d10 * 0.1
23061 continue
23041 continue
23011 continue
23012 continue
      tonumber = value
      return
      end
