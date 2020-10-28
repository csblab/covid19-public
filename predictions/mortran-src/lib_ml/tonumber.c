/* tonumber.f -- translated by f2c (version 20031025).
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
doublereal tonumber_(char *str, ftnlen str_len)
{
    /* System generated locals */
    integer i__1;
    real ret_val;

    /* Builtin functions */
    integer i_len(char *, ftnlen), i_indx(char *, char *, ftnlen, ftnlen);

    /* Local variables */
    static integer k, i1;
    static real d10;
    static logical before_point__;
    static real value;

    before_point__ = TRUE_;
    value = 0.f;
    i__1 = i_len(str, str_len);
    for (k = 1; k <= i__1; ++k) {
	if (*(unsigned char *)&str[k - 1] == ' ') {
	    goto L23011;
	}
	if (*(unsigned char *)&str[k - 1] != '.') {
	    goto L23031;
	}
	before_point__ = FALSE_;
	d10 = .1f;
L23031:
	i1 = i_indx("0123456789", str + (k - 1), (ftnlen)10, (ftnlen)1);
	if (i1 <= 0) {
	    goto L23011;
	}
	if (! before_point__) {
	    goto L23051;
	}
	value = value * 10 + (i1 - 1);
	goto L23061;
L23051:
	value += (i1 - 1) * d10;
	d10 *= .1f;
L23061:
/* L23041: */
L23011:
	;
    }
/* L23012: */
    ret_val = value;
    return ret_val;
} /* tonumber_ */

