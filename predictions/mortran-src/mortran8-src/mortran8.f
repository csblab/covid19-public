C mortran 2.0 macros for .lc to FORTRAN (M.Levitt May 1986)              
      integer a,b,c,d,e,f,g,h,o,p,q,r,s,t,u,v,w,x,y,z
      dimension mm(500 000)
      common/mem/mm
      common/status/iq,q,ir,r,c,nc,h,mtrc,mdef,mcnt,ngen,iquo,mort,merr,
     & uptr,unit,list,indt,note
      logical cnv
      common/letter/leta,lb,lc,ld,le,lf,lg,lh,li,lj,lk,ll, lm,ln,lo,lp,l
     &q,lr,ls,lt,lu,lv,lw,lx,ly,lz,lzero,lblank,ldot, llpar,lrpar,lcomma
     &,lequal,lplus,lminus,llbrc,lrbrc,lsemi, lcolon,lsquot,ldquot,lperc
     &n,lnum,lat,lcaret,letand,lquest
      equivalence(lims,v),(limf,io),(limr,ic),(limq,ir)
      data ic/300/,ia/400/,is/401/,g/23000/,nscn/0/,limu/ 500 000/
      data nonff/1/,nonfn/0/,nonoi/1/,nonop/2/,nonom/3/,nonol/4/,nonow/5
     &/
      data nonob/6/,nonos/7/,nonoo/8/,nonou/9/,nonod/10/,nonov/11/,nonoj
     &/12/
      data nonog/13/,nonoq/14/,nonoe/15/
      open(1,name='for001',form='formatted',status='old' )
      open(2,name='for002',form='formatted',status='old' )
      open(3,name='for003',form='formatted',status='old' )
      open(7,name='for007',form='formatted',status='new' )
      read(1,1)(mm(k),k=1,152)
      write(6,3)(mm(k),k=1,72)
      write(7,2)(mm(k),k=1,72)
2     format('C',72a1)
1     format(80a1)
3     format(1x,72a1,12x,' PROCESSOR VERSION OF 17-JAN-83'/)
6     format(1x,120a1)
      lzero=mm(81)
      leta=mm(91)
      lb=mm(92)
      lc=mm(93)
      ld=mm(94)
      le=mm(95)
      lf=mm(96)
      lg=mm(97)
      lh=mm(98)
      li=mm(99)
      lj=mm(100)
      lk=mm(101)
      ll=mm(102)
      lm=mm(103)
      ln=mm(104)
      lo=mm(105)
      lp=mm(106)
      lq=mm(107)
      lr=mm(108)
      ls=mm(109)
      lt=mm(110)
      lu=mm(111)
      lv=mm(112)
      lw=mm(113)
      lx=mm(114)
      ly=mm(115)
      lz=mm(116)
      lblank=mm(117)
      ldot=mm(119)
      llpar=mm(120)
      lrpar=mm(121)
      lcomma=mm(122)
      lequal=mm(123)
      lplus=mm(124)
      lminus=mm(125)
      llbrc=mm(130)
      lrbrc=mm(131)
      lsemi=mm(132)
      lcolon=mm(133)
      lsquot=mm(134)
      ldquot=mm(135)
      lpercn=mm(140)
      lnum=mm(141)
      lat=mm(142)
      lcaret=mm(143)
      letand=mm(144)
      lquest=mm(145)
      f=limu/8
      io=f*5
      ie=f*7
      mm(ia)=ia+25
      mm(ie)=lsemi
      mm(ir)=0
      lima=f
      o=io
      u=ie
      s=ie
      v=ie
      k=f+14
      read(1,5)kq,ka,ip,(mm(j),j=f,k)
5     format(40a2)
      j=ic
      mm(j)=lpercn
      mm(j+1)=f
      mm(j+3)=0
      mm(f)=0
      mm(f+1)=f+12
      mm(f+2)=f+14
      mm(f+3)=0
      f=f+15
23010 continue
      if(c .eq. nc)go to 23020
23030 continue
      c=c+1
      if(c .gt. nc)call nxtcrd(lblank)
23041 continue
      if(mm(c).ne.ldquot)goto 23061
23071 continue
      c=c+1
      if(c .gt. nc)call nxtcrd(ldquot)
      if(c.ne.nc)goto 23091
      if(iquo .eq. 1)go to 23010
23091 continue
      if(mm(c) .eq. ldquot)go to 23010
      goto 23071
23072 continue
23061 continue
      u=u+1
      if(limu .le. u)u=u+nono(nonoi,nonob,nonoo,nonff)
      mm(u)=mm(c)
      if(mm(c).ne.lsquot)goto 23111
      mm(u)=kq
23121 continue
      c=c+1
      if(c .gt. nc)call nxtcrd(lsquot)
      u=u+1
      if(limu .le. u)u=u+nono(nonoi,nonob,nonoo,nonff)
      mm(u)=mm(c)
      if(mm(c).ne.lsquot)goto 23141
      c=c+1
      if(c .gt. nc)call nxtcrd(lsquot)
      if(mm(c).eq.lsquot)goto 23161
      mm(u)=kq
      goto 23122
23161 continue
23141 continue
      goto 23121
23122 continue
      goto 23171
23111 continue
      if(mm(c).ne.lblank)goto 23191
      if(s.eq.u)goto 23211
      if(mm(u-1) .eq. lblank)u=u-1
23211 continue
23221 continue
      if(c .eq. nc)go to 23020
      c=c+1
      if(mm(c) .ne. lblank)goto 23222
      goto 23221
23222 continue
      goto 23231
23191 continue
      if(mm(c) .eq. lsemi)go to 23020
      if(mm(c) .eq. llbrc)h=h+1
      if(mm(c) .eq. lrbrc)h=h-1
      go to 23010
23231 continue
23181 continue
23171 continue
23101 continue
      goto 23041
23042 continue
23020 continue
      if(s.le.u)goto 23251
      s=ie
      u=s-1
      go to 23030
23251 continue
      if(mm(s).ne.ldquot)goto 23271
      nscn=1
      s=s+1
      go to 23280
23271 continue
      m=ic
23291 continue
      if(mm(m) .eq. mm(s))goto 23292
      m=m+2
      if(mm(m+1) .le. 00)go to 23280
      goto 23291
23292 continue
      m=m+1
23300 continue
      m=mm(m)
      if(m .eq. 0)go to 23280
      d=m+4
      b=mm(m+1)
      z=0
      e=0
      t=ia-1
      a=mm(ia)
      v=s
23310 continue
      if(v.le.u)goto 23331
      if(s.ne.u)goto 23351
      s=ie
      mm(s)=mm(u)
      u=s
23351 continue
      if(mort .eq. 0)go to 23300
      go to 23030
23331 continue
      if(mm(d).ne.ip)goto 23371
      d=d+1
      t=t+1
      mm(t)=a
      if(mm(d).ne.ka)goto 23391
      d=d+1
      e=n1(mm(d),0,36,0)
      d=d+1
23401 continue
      if(e .le. 0)goto 23402
      if(v .gt. u)go to 23030
      mm(a)=mm(v)
      a=a+1
      if(lima .le. a)a=a+nono(nonop,nonob,nonoo,nonff)
      v=v+1
      e=e-1
      goto 23401
23402 continue
      goto 23411
23391 continue
      e=d
      w=v
      iz=z
      p=0
23411 continue
23381 continue
      if(b .le. d)go to 23420
      go to 23310
23371 continue
      if(mm(d).ne.mm(v))goto 23441
      if(mm(d) .eq. kq)z=1-z
      d=d+1
      v=v+1
      if(b.gt.d)goto 23461
23420 continue
      if(mtrc.ne.2.or..not.(.true.))goto 23481
      write(6,23490)v, b, d, z, mm(d), mm(v)
23490 format ('B: ',4i10,1x,2a1)
      write(6,23500)(mm(jj),jj=m+4,b)
23500 format ('At A:',1x,100a1)
23481 continue
      la=t
      mm(t+1)=a
      mm(t+2)=0
      e=mm(m+2)
      b=b-1
      s=o
      w=mm(m+3)
      mcnt=mcnt-1
      if(mcnt .le. 0)mtrc=3+nono(3,15,16,0)
      if(mm(m+4).ne.ichar('V').or.mm(m+5).ne.ichar('E'))goto 23521
      write(6,23530)(mm(jj),jj=m+4,b)
23530 format ('At A:',1x,100a1)
23521 continue
      if(mtrc.ne.2)goto 23551
      write(6,23560)
23560 format('At B:')
      call mactrc(1,m+4,b,ia,la)
23551 continue
      go to 23570
23461 continue
      go to 23310
23441 continue
      if(mm(v).ne.lblank.or.z.ne.0)goto 23591
      v=v+1
      go to 23310
23591 continue
      if(e .eq. 0)go to 23300
      if(mm(t).ne.a.or.mm(w).ne.lblank)goto 23611
      if(z.ne.0)goto 23631
      w=w+1
      go to 23310
23631 continue
23611 continue
23641 continue
      mm(a)=mm(w)
      a=a+1
      if(lima .le. a)a=a+nono(nonop,nonob,nonoo,nonff)
      if(mm(w).ne.kq)goto 23661
      if(z .eq. 1 .or. iz .eq. 1)go to 23300
23671 continue
      w=w+1
      mm(a)=mm(w)
      a=a+1
      if(lima .le. a)a=a+nono(nonop,nonob,nonoo,nonff)
      if(w .gt. u)go to 23300
      if(mm(w) .eq. kq)goto 23672
      goto 23671
23672 continue
      goto 23681
23661 continue
      if(z.ne.0)goto 23701
      if(mm(w) .eq. llpar)p=p+1
      if(mm(w) .eq. lrpar)p=p-1
      if(mm(w) .eq. llbrc)p=p+1
      if(mm(w) .eq. lrbrc)p=p-1
      if(0 .gt. p)go to 23300
      if(mm(w) .eq. lsemi)go to 23300
23701 continue
      if(mm(w).ne.ka)goto 23721
      w=w+1
      mm(a)=mm(w)
      a=a+1
23721 continue
23681 continue
23651 continue
      w=w+1
      if(w.le.u)goto 23741
      if(mort .eq. 0)go to 23300
      go to 23030
23741 continue
      if(p.ne.0)goto 23761
      d=e
      v=w
      z=iz
      go to 23310
23761 continue
      goto 23641
23642 continue
23570 continue
      b=b+1
      if(b.le.e)goto 23781
      if(w.eq.00)goto 23801
      b=w+1
      e=mm(b)
      w=mm(w)
      go to 23570
23801 continue
      if(mtrc.eq.0)goto 23821
      if(s .ne. o)call mactrc(2,o+1,s,0,0)
23821 continue
23831 continue
      if(s.ne.o)goto 23851
      s=v
      go to 23020
23851 continue
      v=v-1
      mm(v)=mm(s)
      s=s-1
      goto 23831
23832 continue
23781 continue
      if(mm(b).ne.ip)goto 23871
      b=b+1
      n=n1(mm(b),1,la-ia+1,1)+ia
      a=mm(n-1)
      n=mm(n)
23881 continue
      if(n .le. a)go to 23570
      s=s+1
      mm(s)=mm(a)
      a=a+1
      goto 23881
23882 continue
23871 continue
      s=s+1
      if(lims .le. s)s=s+nono(nonoe,nonob,nonoo,nonff)
      mm(s)=mm(b)
      if(mm(b).ne.ka)goto 23901
      b=b+1
      if(mm(b).ne.lc)goto 23921
      b=b+1
      s=s-1
      if(mm(b).ne.ln)goto 23941
      if(ngen.ne.0)goto 23961
      kgen=1
      ngen=1
      goto 23971
23961 continue
      kgen=kgen+1
23971 continue
23951 continue
      go to 23570
23941 continue
      if(mm(b).ne.lg)goto 23991
      if(ngen .eq. 1)kgen=kgen+1
      go to 23570
23991 continue
      if(mm(b).ne.le)goto 24011
      kgen=kgen-1
      if(kgen .le. 0)ngen=0
      go to 23570
24011 continue
23921 continue
      if(ngen.ne.1)goto 24031
      s=s-1
      go to 23570
24031 continue
      if(mm(b).ne.li)goto 24051
      b=b+1
      s=s-1
      if(mm(b).ne.lplus)goto 24071
      knt=knt+1
      go to 23570
24071 continue
      if(mm(b).ne.lminus)goto 24091
      knt=knt-1
      go to 23570
24091 continue
      if(mm(b).ne.lzero)goto 24111
      knt=0
      go to 23570
24111 continue
      if(mm(b).ne.lequal)goto 24131
      knt=mm(s)
      s=s-2
      go to 23570
24131 continue
      if(mm(b).ne.lc)goto 24151
      s=s+2
      mm(s)=knt
      go to 23570
24151 continue
24051 continue
      if(mm(b).ne.lm)goto 24171
      b=b+1
      if(mm(b).ne.ls)goto 24191
      s=s-1
      b=b+1
      q=q+1
      if(limq .le. q)q=q+nono(nonom,nonos,nonoo,nonfn)
      mm(q)=mm(b)
      go to 23570
24191 continue
      if(mm(b).ne.lr)goto 24211
      s=s-1
      b=b+1
      mm(q)=mm(b)
      go to 23570
24211 continue
      if(mm(b).ne.lu)goto 24231
      mm(s)=lat
      s=s+1
      if(q .eq. iq)q=q-nono(nonom,nonos,nonou,nonfn)
      mm(s)=mm(q)
      q=q-1
      go to 23570
24231 continue
      if(mm(b).ne.lt)goto 24251
      if(mtrc .eq. 1)call mactrc(1,m+4,mm(m+1)-1,ia,la)
      s=s-1
      go to 23570
24251 continue
      if(mm(b).ne.lg)goto 24271
      icat=0
      go to 24280
24271 continue
      if(mm(b).ne.lc)goto 24301
      icat=1
      go to 24280
24301 continue
      if(mm(b).ne.lm)goto 24321
      j=mm(ia)
      k=mm(is)-1
      write(6,6)(mm(jj),jj= j,k)
      s=s-1
      go to 23570
24321 continue
24171 continue
      if(mm(b).ne.ll)goto 24341
      b=b+1
      if(mm(b).ne.lg)goto 24361
      g=g+10
      s=s+1
      mm(s)=g
      go to 23570
24361 continue
      j=n1(mm(b+1),0,9,0)
      if(mm(b).ne.lc)goto 24381
      s=s+1
      k=r-j
      mm(s)=mm(k)+n1(mm(b+2),0,9,0)
      b=b+2
      go to 23570
24381 continue
      if(mm(b).ne.ls)goto 24401
      r=r+1
      if(limr .le. r)r=r+nono(nonol,nonos,nonoo,nonfn)
      if(j.eq.0)goto 24421
      do 24431 k=1,j
      kk=r-k
      mm(kk+1)=mm(kk)
24431 continue
24432 continue
24421 continue
      k=r-j
      mm(k)=mm(s-1)
      b=b+1
      s=s-3
      go to 23570
24401 continue
      if(mm(b).ne.lu)goto 24451
      k=r-ir
      if(j .gt. k)j=nono(nonol,nonos,nonou,nonfn)
      if(j.le.0)goto 24471
      do 24481 k=1,j
      kk=r-j+k
      mm(kk-1)=mm(kk)
24481 continue
24482 continue
24471 continue
      if(0 .le. j)r=r-1
      b=b+1
      s=s-1
      go to 23570
24451 continue
24341 continue
      b=b-1
23901 continue
      go to 23570
23280 continue
24491 continue
      if(mm(s).ne.lsemi)goto 24511
      if(o .ne. io)call outlin(io,o)
      goto 24521
24511 continue
      if((mm(s).ne.ka).and.(mm(s).ne.kq))goto 24541
      z=0
24551 continue
      if(mm(s).ne.ka)goto 24571
      s=s+1
      call ncv(o,mm(s))
      if(z .eq. 0)goto 24552
      goto 24581
24571 continue
      if((mm(s).ne.kq).and.(s.le.u))goto 24601
      if(z.ne.0)goto 24621
      z=o
      if(ngen.ne.0)goto 24641
      mm(o)=lsquot 
      o=o+1
24641 continue
      goto 24651
24621 continue
      if(ngen.ne.0)goto 24671
      mm(o)=lsquot 
      o=o+1
24671 continue
      goto 24552
24651 continue
24611 continue
      goto 24681
24601 continue
      if(ngen.ne.0)goto 24701
      mm(o)=mm(s)
      o=o+1
24701 continue
24681 continue
24591 continue
24581 continue
24561 continue
      s=s+1
      goto 24551
24552 continue
      goto 24711
24541 continue
      if(mm(s).ne.ldquot)goto 24731
      nscn=0
      s=s+1
      go to 23020
24731 continue
      if(ngen.ne.0)goto 24751
      if((mm(s).eq.lblank).and.(o.eq.io))goto 24771
      mm(o)=mm(s)
      o=o+1
24771 continue
24751 continue
24711 continue
24531 continue
24521 continue
24501 continue
      s=s+1
      if(nscn .eq. 0)go to 23020
      if(s .gt. u)go to 23020
      goto 24491
24492 continue
24280 continue
      t=ia
      s=s-1
      if(mm(t+1).ne.mm(t))goto 24791
      i=nono(nonoj,nonom,nonoq,nonfn)
      go to 23570
24791 continue
24801 continue
      a=mm(t)
      t=t+1
      n=a-1
      z=0
24811 continue
      if(mm(t) .le. a)goto 24812
      if(mm(a).ne.lsquot)goto 24831
      if(z.ne.0)goto 24851
      mm(a)=kq
      z=1
      goto 24861
24851 continue
      a=a+1
      if((mm(a).eq.lsquot).and.(mm(t).gt.a))goto 24881
      a=a-1
      mm(a)=kq
      z=0
24881 continue
24861 continue
24841 continue
      goto 24891
24831 continue
      if(mm(a).ne.lnum)goto 24911
      if(mm(a+1).ne.lnum)goto 24931
      a=a+1
      goto 24941
24931 continue
      mm(a)=ip
24941 continue
24921 continue
      goto 24951
24911 continue
      if(mm(a).ne.lat)goto 24971
      if(mm(a+1).ne.lat)goto 24991
      a=a+1
      goto 25001
24991 continue
      mm(a)=ka
25001 continue
24981 continue
24971 continue
24951 continue
24901 continue
24891 continue
24821 continue
      n=n+1
      mm(n)=mm(a)
      if((mm(a).eq.lblank).and.(z.ne.1))goto 25021
      a=a+1
      goto 25031
25021 continue
25041 continue
      a=a+1
      if(mm(t) .le. a .or. mm(a) .ne. lblank)goto 25042
      goto 25041
25042 continue
25031 continue
25011 continue
      goto 24811
24812 continue
      if(t.ne.is)goto 25061
      i1=n
      goto 25071
25061 continue
      i2=n
      goto 24802
25071 continue
25051 continue
      goto 24801
24802 continue
      if(icat.ne.0)goto 25091
25100 continue
      n=f
      f=f+4
      a=mm(ia)
25111 continue
      if(a .gt. i1)goto 25112
      mm(f)=mm(a)
      f=f+1
      if(limf .le. f)f=f+nono(nonom,nonob,nonoo,nonff)
      a=a+1
      goto 25111
25112 continue
      mm(n+1)=f
      a=mm(is)
25121 continue
      if(a .gt. i2)goto 25122
      mm(f)=mm(a)
      f=f+1
      if(limf .le. f)f=f+nono(nonom,nonob,nonoo,nonff)
      a=a+1
      goto 25121
25122 continue
      mm(n+2)=f-1
      mm(n+3)=0
      t=ic
      a=mm(ia)
25131 continue
      if(mm(a).ne.mm(t))goto 25151
      mm(n)=mm(t+1)
      goto 25132
25151 continue
      t=t+2
      if(mm(t+1).gt.00)goto 25171
      mm(t)=mm(a)
      mm(t+3)=0
      mm(n)=0
      goto 25132
25171 continue
      goto 25131
25132 continue
      mm(t+1)=n
      t=3
      goto 25181
25091 continue
      t=ic
      a=mm(ia)
25191 continue
      if(mm(t) .eq. mm(a))goto 25192
      t=t+2
      if(mm(t+1) .eq. 00)go to 25100
      goto 25191
25192 continue
      t=mm(t+1)
      n=t
25201 continue
      t=n+4
      a=mm(ia)
25211 continue
      if(mm(t) .ne. mm(a))goto 25212
      t=t+1
      a=a+1
      if(a .gt. i1)go to 25220
      goto 25211
25212 continue
      n=mm(n)
      if(n .eq. 0)go to 25100
      goto 25201
25202 continue
25220 continue
      t=n+3
25231 continue
      if(mm(t).eq.00)goto 25251
      t=mm(t)
      goto 25261
25251 continue
      mm(t)=f
      goto 25232
25261 continue
25241 continue
      goto 25231
25232 continue
      a=mm(is)
      mm(f)=0
      n=f+1
      f=f+2
25271 continue
      if(a .gt. i2)goto 25272
      mm(f)=mm(a)
      f=f+1
      if(limf .le. f)f=f+nono(nonom,nonob,nonoo,nonff)
      a=a+1
      goto 25271
25272 continue
      mm(n)=f-1
      t=4
25181 continue
25081 continue
      if(mdef .gt. 0)call mactrc(t,mm(ia),i1,mm(is),i2)
      go to 23570
      end
      blockdata
      integer a,b,c,d,e,f,g,h,o,p,q,r,s,t,u,v,w,x,y,z
      common/status/iq,q,ir,r,c,nc,h,mtrc,mdef,mcnt,ngen,iquo,mort,merr,
     & uptr,unit,list,indt,note
      integer unit,uptr
      data iq/200/,q/200/,ir/250/,r/250/,c/80/,nc/72/,h/0/,mtrc/0/, mdef
     &/0/,mcnt/5 000/,ngen/0/,iquo/0/,mort/1/,merr/0/,uptr/1/,unit/1/, l
     &ist/0/,indt/0/,note/0/
      end
      subroutine mactrc(w,i,j,k,l)
      integer a,b,c,d,e,f,g,h,o,p,q,r,s,t,u,v,w,x,y,z
      dimension mm(500 000)
      common/mem/mm
      goto(23030, 23010, 23310, 25280),w
23030 continue
      write(6,1)(mm(jj),jj= i,j)
      if(k.gt.l)goto 25301
      do 25311 t=k,l
      m=mm(t)
      n=mm(t+1)-1
      a=t-k+1
      if(m .le. n)write(6,2)a,(mm(jj),jj=m,n)
25311 continue
25312 continue
25301 continue
      go to 25320
23010 continue
      write(6,3)(mm(jj),jj= i,j)
      go to 25320
23310 continue
      write(6,4)(mm(jj),jj= i,j)
      write(6,5)(mm(jj),jj= k,l)
      go to 25320
25280 continue
      write(6,4)(mm(jj),jj= i,j)
      write(6,6)(mm(jj),jj= k,l)
25320 continue
      return
1     format(11x,'PATTERN MATCHED IS ',80a1/(30x,80a1))
2     format(15x,'ARGUMENT',i3,' IS ',80a1/(30x,80a1))
3     format(17x,'EXPANSION IS ',80a1/(30x,80a1))
4     format(' MACRO DEFINITION, PATTERN IS ',80a1/(30x,80a1))
5     format(15x,'REPLACEMENT IS ',80a1/(30x,80a1))
6     format(9x,'CATENATION STRING IS ',80a1/(30x,80a1))
      end
      subroutine nxtcrd(m)
      integer a,b,c,d,e,f,g,h,o,p,q,r,s,t,u,v,w,x,y,z
      dimension mm(500 000)
      common/mem/mm
      common/status/iq,q,ir,r,c,nc,h,mtrc,mdef,mcnt,ngen,iquo,mort,merr,
     & uptr,unit,list,indt,note
      logical cnv
      integer ustk,uptr,unit
      dimension ustk(20),i80(80),i79(79)
      equivalence(mm(1),i79(1),i80(1)),(mm(180),ustk(1))
      common/letter/leta,lb,lc,ld,le,lf,lg,lh,li,lj,lk,ll, lm,ln,lo,lp,l
     &q,lr,ls,lt,lu,lv,lw,lx,ly,lz,lzero,lblank,ldot, llpar,lrpar,lcomma
     &,lequal,lplus,lminus,llbrc,lrbrc,lsemi, lcolon,lsquot,ldquot,lperc
     &n,lnum,lat,lcaret,letand,lquest
      if(uptr.ne.0)goto 25341
      if(q.eq.iq)goto 25361
      merr = merr + 1
      write(6,25370)
25370 format (' ******** ERROR - UNCLOSED LOOP OR BLOCK')
25361 continue
      if(r.eq.ir)goto 25391
      merr = merr + 1
      write(6,25400)
25400 format (' ******** ERROR - MISSING RIGHT BRACKET')
25391 continue
      if(m.ne.lsquot)goto 25421
      merr = merr + 1
      write(6,25430)
25430 format (' ******** ERROR - UNCLOSED STRING')
25421 continue
      if(m.ne.ldquot)goto 25451
      merr = merr + 1
      write(6,25460)
25460 format (' ******** ERROR - UNCLOSED COMMENT')
25451 continue
      write(6,25470)merr
25470 format (i5,' MORTRAN ERRORS ENCOUNTERED (ML 3Feb02)')
      if ( merr .eq. 0 ) stop
      write ( 7 , 25480)
25480 format(6x,'****** MORTRAN ERROR(S), CHECK LISTING'/6x,'END')
      stop 12
25341 continue
25320 continue
1034  read ( unit, 25490, end=25500) i80
25490 format(80a1)
      i = 1
25511 if(i.gt.80.or.i80(i).eq.ldquot)goto 25512
      i = i + 1
      goto 25511
25512 continue
      if(i.le.72)goto 25531
      do 25541 i = 73, 80
      if(i80(i) .eq. lblank)goto 25541
      write(6,25550)i80
25550 format ('**** Error. Line too long:',/,80a1)
      goto 25542
25541 continue
25542 continue
25531 continue
      if ( mort .eq. 0 ) go to 25560
      i = 1
25571 if(i.gt.72.or.i80(i).ne.lblank)goto 25572
      i = i + 1
      goto 25571
25572 continue
      if ( i .gt. 72 ) go to 25560
      ifirst = i80(i)
      if ( ifirst .eq. lpercn ) go to 25560
      i = 72
25581 if(i.lt.1.or.i80(i).ne.lblank)goto 25582
      i = i - 1
      goto 25581
25582 continue
      if ( i .lt. 1 ) go to 25560
      ilast = i80(i)
      i1lst = i
      i = 1
25591 if(i.gt.72.or.i80(i).eq.ldquot)goto 25592
      i = i + 1
      goto 25591
25592 continue
      if(i80(i).ne.ldquot)goto 25611
      if ( i .eq. 1 ) go to 25560
      if(i80(i-1).ne.lblank)goto 25631
      i = i - 1
25641 if(i.lt.1.or.i80(i).ne.lblank)goto 25642
      i = i - 1
      goto 25641
25642 continue
      if ( i .gt. 0 ) ilast = i80(i)
      i1lst = i
      goto 25651
25631 continue
      ilast = i80(i-1)
      i1lst0 = i1lst
      i1lst = i - 1
      i = i1lst0
      goto 25663
25661 continue
      i = i - 1
25663 if(i.le.i1lst)goto 25662
      i80(i+1) = i80(i)
      goto 25661
25662 continue
25651 continue
25621 continue
25611 continue
      if(ilast.ne.lrbrc)goto 25681
      i = i - 1
25691 if(i.lt.1.or.(i80(i).ne.lblank).and.(i80(i).ne.lrbrc))goto 25692
      i = i - 1
      goto 25691
25692 continue
      if(i.le.1)goto 25711
      ilast = i80(i)
      i1lst0 = i1lst
      i1lst = i
      i80(i1lst0+2) = lsemi
      i = i1lst0
      goto 25723
25721 continue
      i = i - 1
25723 if(i.le.i1lst)goto 25722
      i80(i+1) = i80(i)
      goto 25721
25722 continue
25711 continue
25681 continue
      if(ilast.ne.letand)goto 25741
      i80(i1lst) = lblank
      go to 25560
25741 continue
      if ( ilast .eq. lcomma ) go to 25560
      if ( ilast .eq. llbrc .or. ilast .eq. lrbrc) go to 25560
      if ( ilast .eq. lsemi .or. ilast .eq. ldquot ) go to 25560
      if ( i1lst.lt.72 ) i80(i1lst+1) = lsemi
      go to 25560
25500 continue
      i80(1) = lpercn
      i80(2) = lpercn
      do 25751 i = 3, 72
      i80(i) = lblank
25751 continue
25752 continue
25560 continue
      if(list.eq.0)goto 25771
      if((mort.ne.0).and.(mm(1).ne.lpercn))goto 25791
      write(6,25800)i80
25800 format (9x,80a1)
      goto 25811
25791 continue
      k = max0(indt*h+1,1)
      l = 1
      if(indt.eq.0)goto 25831
25841 continue
      if(mm(l) .ne. lblank)goto 25842
      l = l + 1
      if(nc.gt.l)goto 25861
      l = 1
      goto 25842
25861 continue
      goto 25841
25842 continue
25831 continue
      igen = lblank
      if ( ngen .ne. 0 )igen = lx
      write(6,3)igen,m,h,(lblank,i=1,k),(mm(i),i=l,80)
3     format(1x,2a1,i3,2x,3(124a1/7x))
25811 continue
25781 continue
25771 continue
      if(mort.ne.0)goto 25881
      if(mm(1).eq.lpercn)goto 25901
      write ( 7, 25910 ) i80
25910 format(80a1)
25901 continue
      goto 25921
25881 continue
      if(note.ne.1)goto 25941
      write ( 7, 25950 ) i79
      if ( mm(80) .ne. lblank ) write ( 7, 25950) mm(80)
25950 format('C',79a1)
25941 continue
      if(note.ne.2)goto 25971
      write ( 7, 25980 )i80
25980 format('C',39x,40a1)
25971 continue
25921 continue
25871 continue
      if(mm(1).ne.lpercn)goto 26001
      if(mm(2).ne.lq)goto 26021
      iquo = n2 ( 0, 1, 0 )
      go to 25320
26021 continue
      if(mm(2).ne.lt)goto 26041
      mtrc=n2(0,2,0)
      go to 25320
26041 continue
      if(mm(2).ne.ld)goto 26061
      mdef=n2(0,2,0)
      go to 25320
26061 continue
      if(mm(2).ne.le)goto 26081
      write(6,6)
6     format(1h1)
      go to 25320
26081 continue
      if(mm(2).ne.ll)goto 26101
      list=1
      go to 25320
26101 continue
      if(mm(2).ne.ln)goto 26121
      list=0
      go to 25320
26121 continue
      if(mm(2) .eq. lf)go to 26130
      if(mm(2).ne.lm)goto 26151
      mort=1
      c=nc
      mm(c)=lsemi
      return
26151 continue
      if(mm(2).ne.li)goto 26171
      indt=n2(0,50,2)
      go to 25320
26171 continue
      if(mm(2).ne.leta)goto 26191
      note=n2(0,2,1)
      go to 25320
26191 continue
      if(mm(2).ne.lc)goto 26211
      nc=n2(10,80,72)
      go to 25320
26211 continue
      if(mm(2).ne.lu)goto 26231
      ustk(uptr)=unit
      uptr=uptr+1
      unit=n2(1,99,unit)
      go to 25320
26231 continue
      if(mm(2).ne.lpercn)goto 26251
      uptr=uptr-1
      if(uptr.eq.0)goto 26271
      unit=ustk(uptr)
      go to 25320
26271 continue
26130 continue
      mort=0
      c=nc-1
      mm(c)=lsemi
      mm(nc)=lsemi
      return
26251 continue
26001 continue
      if(mort .eq. 0)go to 25320
      c=1
      return
      end
      subroutine outlin(a,z)
      integer a,b,c,d,e,f,g,h,o,p,q,r,s,t,u,v,w,x,y,z
      dimension mm(500 000)
      common/mem/mm
      common/status/iq,q,ir,r,c,nc,h,mtrc,mdef,mcnt,ngen,iquo,mort,merr,
     & uptr,unit,list,indt,note
      logical cnv
      dimension l(5)
      common/letter/leta,lb,lc,ld,le,lf,lg,lh,li,lj,lk,ll, lm,ln,lo,lp,l
     &q,lr,ls,lt,lu,lv,lw,lx,ly,lz,lzero,lblank,ldot, llpar,lrpar,lcomma
     &,lequal,lplus,lminus,llbrc,lrbrc,lsemi, lcolon,lsquot,ldquot,lperc
     &n,lnum,lat,lcaret,letand,lquest
      mcnt=500
      if(ngen .ne. 0)return
      i=1
      b=a
      y=z-1
      do 26281 j=1,5
      l(j)=lblank
26281 continue
26282 continue
26291 continue
      if(mm(b).eq.lblank)goto 26311
      if(cnv(mm(b),j,0,9))goto 26292
      l(i)=mm(b)
      i=i+1
26311 continue
      b=b+1
      if(i .gt. 5 .or. b .gt. y)goto 26292
      goto 26291
26292 continue
      write(7,1)l,(mm(j),j=b,y)
      z=a
      return
1     format(5a1,1x,66a1/(5x,'&',66a1))
      end
      subroutine ncv(p,n)
      integer a,b,c,d,e,f,g,h,o,p,q,r,s,t,u,v,w,x,y,z
      dimension mm(500 000)
      common/mem/mm
      common/status/iq,q,ir,r,c,nc,h,mtrc,mdef,mcnt,ngen,iquo,mort,merr,
     & uptr,unit,list,indt,note
      common/letter/leta,lb,lc,ld,le,lf,lg,lh,li,lj,lk,ll, lm,ln,lo,lp,l
     &q,lr,ls,lt,lu,lv,lw,lx,ly,lz,lzero,lblank,ldot, llpar,lrpar,lcomma
     &,lequal,lplus,lminus,llbrc,lrbrc,lsemi, lcolon,lsquot,ldquot,lperc
     &n,lnum,lat,lcaret,letand,lquest
      if(ngen .ne. 0)return
      i=n
      p=p+5
      do 26321 j=1,5
      k=p-j
      mm(k)=lblank
      t=i/10
      if((i.eq.0).and.(j.ne.1))goto 26341
      i=i-t*10+81
      mm(k)=mm(i)
26341 continue
      i=t
26321 continue
26322 continue
      return
      end
      logical function cnv(i,o,l,m)
      integer a,b,c,d,e,f,g,h,o,p,q,r,s,t,u,v,w,x,y,z
      dimension mm(500 000)
      common/mem/mm
      cnv=.true.
      if(l .gt. m)return
      kl=l+81
      km=m+81
      do 26351 k=kl,km
      if(mm(k).ne.i)goto 26371
      o=k-81
      cnv=.false.
      go to 25320
26371 continue
26351 continue
26352 continue
25320 continue
      return
      end
      function n1(i,l,m,k)
      integer a,b,c,d,e,f,g,h,o,p,q,r,s,t,u,v,w,x,y,z
      dimension mm(500 000)
      common/mem/mm
      common/status/iq,q,ir,r,c,nc,h,mtrc,mdef,mcnt,ngen,iquo,mort,merr,
     & uptr,unit,list,indt,note
      logical cnv
      n1=k
      n=k
      if(cnv(i,n,l,m))go to 23570
      n1=n
      return
23570 continue
      merr=merr+1
      write(6,1)i
      return
1     format(' ******** ERROR - BAD PARAMETER NUMBER',1x,a2)
      end
      function n2(l,m,k)
      integer a,b,c,d,e,f,g,h,o,p,q,r,s,t,u,v,w,x,y,z
      dimension mm(500 000)
      common/mem/mm
      common/status/iq,q,ir,r,c,nc,h,mtrc,mdef,mcnt,ngen,iquo,mort,merr,
     & uptr,unit,list,indt,note
      common/letter/leta,lb,lc,ld,le,lf,lg,lh,li,lj,lk,ll, lm,ln,lo,lp,l
     &q,lr,ls,lt,lu,lv,lw,lx,ly,lz,lzero,lblank,ldot, llpar,lrpar,lcomma
     &,lequal,lplus,lminus,llbrc,lrbrc,lsemi, lcolon,lsquot,ldquot,lperc
     &n,lnum,lat,lcaret,letand,lquest
      logical cnv
      n2=-1
      if(mm(3).eq.lblank)goto 26391
      if(cnv(mm(3),n1,0,9))go to 23570
      n2=n1
26391 continue
      if(mm(4).eq.lblank)goto 26411
      if(cnv(mm(4),n1,0,9))go to 23570
      n2=10*n2+n1
26411 continue
      if(l .le. n2 .and. n2 .le. m)go to 25320
23570 continue
      n2=k
      write(6,1)k
1     format(' ******** ERROR - BAD NUMERICS ON CONTROL CARD',i3, ' ASSU
     &MED')
      merr=merr+1
25320 continue
      return
      end
      function nono(i,j,k,l)
      integer a,b,c,d,e,f,g,h,o,p,q,r,s,t,u,v,w,x,y,z
      dimension mm(500 000)
      common/mem/mm
      common/status/iq,q,ir,r,c,nc,h,mtrc,mdef,mcnt,ngen,iquo,mort,merr,
     & uptr,unit,list,indt,note
      dimension a(64)
      data a(01),a(02),a(03),a(04)/'IN','PU','T ','  '/, a(05),a(06),a(0
     &7),a(08)/'PA','RA','MT','ER'/, a(09),a(10),a(11),a(12)/'MA','CR','
     &O ','  '/, a(13),a(14),a(15),a(16)/'LA','BE','L ','  '/, a(17),a(1
     &8),a(19),a(20)/'OU','TP','UT','  '/, a(21),a(22),a(23),a(24)/'BU',
     &'FF','ER','  '/, a(25),a(26),a(27),a(28)/'ST','AC','K ','  '/, a(2
     &9),a(30),a(31),a(32)/'OV','ER','FL','OW'/, a(33),a(34),a(35),a(36)
     &/'UN','DR','FL','OW'/, a(37),a(38),a(39),a(40)/'DI','GI','T ','  '
     &/, a(41),a(42),a(43),a(44)/'UN','DE','FI','ND'/, a(45),a(46),a(47)
     &,a(48)/'IL','LE','GA','L '/, a(49),a(50),a(51),a(52)/'ST','RI','NG
     &','  '/, a(53),a(54),a(55),a(56)/'PA','TT','ER','N '/, a(57),a(58)
     &,a(59),a(60)/'EX','PN','SI','N '/, a(61),a(62),a(63),a(64)/'LO','O
     &P','  ','  '/
      write(6,1)a(4*i-3),a(4*i-2),a(4*i-1),a(4*i),a(4*j-3),a(4*j-2), a(4
     &*j-1),a(4*j),a(4*k-3),a(4*k-2),a(4*k-1),a(4*k)
      nono=-1
      if(l .ne. 0)stop16
      merr=merr+1
      write(6,2)
      return
1     format(' ******** ERROR - ',3(1x,4a2))
2     format(' MORTRAN PROCESSING CONTINUING')
      end
