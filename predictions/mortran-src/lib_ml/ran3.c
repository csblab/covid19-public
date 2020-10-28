/* ran3.f -- translated by f2c (version 20031025).
   You must link the resulting object file with libf2c:
	on Microsoft Windows system, link with libf2c.lib;
	on Linux or Unix systems, link with .../path/to/libf2c.a -lm
	or, if you install libf2c.a in a standard place, with -lf2c -lm
	-- in that order, at the end of the command line, as in
		cc *.o -lf2c -lm
	Source for libf2c is in /netlib/f2c/libf2c.zip, e.g.,

		http://www.netlib.org/f2c/libf2c.zip
*/

#include "f2c.h"

/* mortran 2.0 macros for .lc to FORTRAN (M.Levitt May 1986) */
doublereal ran3_(integer *idum)
{
    /* Initialized data */

    static integer iff = 0;

    /* System generated locals */
    real ret_val;

    /* Local variables */
    static integer i__, k, ma[55], ii, mj, mk, inext, inextp;

    if (*idum >= 0 && iff != 0) {
	goto L23021;
    }
    iff = 1;
    mj = 161803398 - abs(*idum);
    mj %= 1000000000;
    ma[54] = mj;
    mk = 1;
    for (i__ = 1; i__ <= 54; ++i__) {
	ii = i__ * 21 % 55;
	ma[ii - 1] = mk;
	mk = mj - mk;
	if (mk < 0) {
	    mk += 1000000000;
	}
	mj = ma[ii - 1];
/* L23031: */
    }
/* L23032: */
    for (k = 1; k <= 4; ++k) {
	for (i__ = 1; i__ <= 55; ++i__) {
	    ma[i__ - 1] -= ma[(i__ + 30) % 55];
	    if (ma[i__ - 1] < 0) {
		ma[i__ - 1] += 1000000000;
	    }
/* L23051: */
	}
/* L23052: */
/* L23041: */
    }
/* L23042: */
    inext = 0;
    inextp = 31;
    *idum = 1;
L23021:
    ++inext;
    if (inext == 56) {
	inext = 1;
    }
    ++inextp;
    if (inextp == 56) {
	inextp = 1;
    }
    mj = ma[inext - 1] - ma[inextp - 1];
    if (mj < 0) {
	mj += 1000000000;
    }
    ma[inext - 1] = mj;
    ret_val = mj * 1.0000000000000001e-9f;
    return ret_val;
} /* ran3_ */

