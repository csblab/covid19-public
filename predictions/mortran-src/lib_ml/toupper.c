/* toupper.f -- translated by f2c (version 20031025).
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
/* Subroutine */ int toupper_(char *str, ftnlen str_len)
{
    /* System generated locals */
    integer i__1;

    /* Builtin functions */
    integer i_len(char *, ftnlen);

    /* Local variables */
    static integer k, l;

    i__1 = i_len(str, str_len);
    for (k = 1; k <= i__1; ++k) {
	l = *(unsigned char *)&str[k - 1];
	if (l >= 'a' && l <= 'z') {
	    *(unsigned char *)&str[k - 1] = (char) (l - 32);
	}
/* L23011: */
    }
/* L23012: */
    return 0;
} /* toupper_ */

