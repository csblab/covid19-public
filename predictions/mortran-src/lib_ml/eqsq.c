/* eqsq.f -- translated by f2c (version 20031025).
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
logical eqsq_(char *a1, char *b1, ftnlen a1_len, ftnlen b1_len)
{
    /* Initialized data */

    static char lower[26] = "abcdefghijklmnopqrstuvwxyz";
    static char upper[26] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    static char eos[1] = "_";
    static logical first = TRUE_;

    /* System generated locals */
    integer i__1;
    logical ret_val;

    /* Builtin functions */
    integer i_len(char *, ftnlen);

    /* Local variables */
    static integer i__;
    static shortint ia2, ib2;
    static integer lena, lenb, lenm;
    static shortint ieos, uplow[127];

    if (! first) {
	goto L23021;
    }
    for (i__ = 1; i__ <= 127; ++i__) {
	uplow[i__ - 1] = (shortint) i__;
/* L23031: */
    }
/* L23032: */
    for (i__ = 1; i__ <= 26; ++i__) {
	uplow[*(unsigned char *)&lower[i__ - 1] - 1] = (shortint) (*(unsigned 
		char *)&upper[i__ - 1]);
/* L23041: */
    }
/* L23042: */
    first = FALSE_;
    ieos = (shortint) (*(unsigned char *)&eos[0]);
L23021:
    lena = i_len(a1, a1_len);
    lenb = i_len(b1, b1_len);
    lenm = lena;
    if (lena > lenb) {
	lenm = lenb;
    }
    i__1 = lenm;
    for (i__ = 1; i__ <= i__1; ++i__) {
	ia2 = uplow[*(unsigned char *)&a1[i__ - 1] - 1];
	ib2 = uplow[*(unsigned char *)&b1[i__ - 1] - 1];
	if (ib2 != ieos && i__ != lenm) {
	    goto L23071;
	}
	ret_val = TRUE_;
	return ret_val;
L23071:
	if (ia2 != ib2) {
	    goto L23052;
	}
/* L23051: */
    }
L23052:
    ret_val = FALSE_;
    return ret_val;
} /* eqsq_ */

