C mortran 2.0 macros for .lc to FORTRAN (M.Levitt May 1986)              
      		
      		
      		
      function eqsq(a1,b1)
      implicit none
      integer NAX,NWX,NZX,NTX,NGX,NJX
      parameter (NAX=1100,NWX=3000,NZX=4,NTX=4,NGX=20000,NJX=200000)
      logical eqsq
      character *(*) a1,b1
      integer * 2 uplow(127),ia2,ib2,ieos
      integer i, lena, lenb, lenm
      logical first
      character * 26 lower
      character * 26 upper
      character * 1 eos
      data lower /'abcdefghijklmnopqrstuvwxyz'/
      data upper /'ABCDEFGHIJKLMNOPQRSTUVWXYZ'/
      data eos/'_'/
      data first/.true./
      if(.not.(first))goto 23021
      do 23031 i = 1, 127
      uplow(i) = i
23031 continue
23032 continue
      do 23041 i = 1, 26
      uplow( ichar( lower(i:i) ) ) = ichar( upper(i:i) )
23041 continue
23042 continue
      first = .false.
      ieos = ichar( eos(1:1) )
23021 continue
      lena = len ( a1 )
      lenb = len ( b1 )
      lenm = lena 
      if ( lena .gt. lenb ) lenm = lenb
      do 23051 i = 1, lenm
      ia2 = uplow( ichar( a1(i:i) ) )
      ib2 = uplow( ichar( b1(i:i) ) )
      if((ib2.ne.ieos).and.(i.ne.lenm))goto 23071
      eqsq=.true. 
      return
23071 continue
      if(ia2 .ne. ib2)goto 23052
23051 continue
23052 continue
      eqsq=.false.
      return
      end
