/* itrim.f -- translated by f2c (version 20031025).
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

integer itrim_(char *line, ftnlen line_len)
{
    /* System generated locals */
    integer ret_val;

    /* Builtin functions */
    integer i_len(char *, ftnlen);

    /* Local variables */
    static integer i__, ln;

    ln = i_len(line, line_len);
    i__ = ln;
L26731:
    if (i__ < 1 || *(unsigned char *)&line[i__ - 1] != ' ') {
	goto L26732;
    }
    --i__;
    goto L26731;
L26732:
    ret_val = 1;
    if (i__ >= 1) {
	ret_val = i__;
    }
    return ret_val;
} /* itrim_ */

