C mortran 2.0 macros for .lc to FORTRAN (M.Levitt May 1986)              
      function ran3 ( idum )
      integer idum, mbig, mseed, mz, iff, mj, mk, i, ii, k, inext, inext
     &p
      real fac, ran3
      parameter ( mbig=1000 000 000, mseed=161 803 398, mz=0, fac=1./mbi
     &g)
      integer ma(55)
      data iff/0/
      if((idum.ge.0).and.(iff.ne.0))goto 23021
      iff = 1
      mj = mseed - iabs(idum)
      mj = mod(mj,mbig)
      ma(55) = mj
      mk = 1
      do 23031 i = 1, 54
      ii = mod(21*i,55)
      ma(ii)=mk
      mk = mj - mk
      if ( mk .lt. mz ) mk = mk + mbig
      mj = ma(ii)
23031 continue
23032 continue
      do 23041 k = 1, 4
      do 23051 i = 1, 55
      ma(i) = ma(i) - ma(1+mod(i+30,55))
      if ( ma(i) .lt. mz ) ma(i) = ma(i) + mbig
23051 continue
23052 continue
23041 continue
23042 continue
      inext = 0
      inextp = 31
      idum = 1
23021 continue
      inext = inext + 1
      if ( inext .eq. 56 ) inext = 1
      inextp = inextp + 1
      if ( inextp .eq. 56 ) inextp = 1
      mj = ma(inext) - ma(inextp)
      if ( mj .lt. mz ) mj = mj + mbig
      ma(inext) = mj
      ran3 = mj * fac
      return
      end
