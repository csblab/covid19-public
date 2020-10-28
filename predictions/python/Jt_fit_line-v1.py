#!/usr/bin/env python

"""Line fitting J(t).

Reimplementation of MORTRAN code Jt_fit_line-v1.lc for public sharing.
"""

import argparse
import math
import pathlib
import re


EPSILON = 1e-5  # small number that will come handy


def read_args():
    """Read command-line arguments."""

    def valid_file(filepath):
        """Return Path if filepath is readable or throws error"""
        return pathlib.Path(filepath).expanduser().resolve(strict=True)

    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument(
        "datecodes",
        default="Dates_for_code.txt",
        type=valid_file,
        help="Input date codes file"
    )
    ap.add_argument(
        "datatable",
        type=valid_file,
        help="Input data tables file"
    )

    return ap.parse_args()


def parse_dates(filepath, method="last"):
    """Read date indexing file."""
    
    date2idx = {}
    with filepath.open("r") as handle:
        for line in handle:
            date, idx = line.split()
            date2idx[int(idx)] = date
    
    # print(f"TEST last_day={idx}; {date}")
    return date2idx


def parse_datatable(filepath):
    """Read JHU covid data file."""

    # RE to parse header line fields and dates
    re_header = re.compile(r"""
            \s+
            (?P<nloc>[\d]+)  # nloc
            \s+
            (?P<anto>[\d]+)  # anto (not used in mortran code)
            \s+
            (?P<fullname>[\w]+)  # Country_Region
            \s+
            (?P<ctype>[\w]+)  # Case_Type
            \s+
            (?P<totcases>[\w\.]+)  # nCases.0
            \s+
            (?P<totdeaths>[\w\.]+)  # nDeaths.0
            \s+
    """, re.VERBOSE)

    re_dates = re.compile(r"([\d/]+\.0)")  # matches 1/23/20.0

    # RE to parse data lines
    re_line = re.compile(r"""
            \s+
            (?P<nloc>[\d]+)  # nloc (number of days)
            \s+
            (?P<anto>[\d]+)  # anto (not used in mortran code)
            \s+
            (?P<fullname>[\w\.]+)  # country/region name
            \s+
            (?P<ctype>[\w]+)  # case type: confirmed/deaths
            \s+
            (?P<ntcases>[\d\.]+)  # total number of cases
            \s+
            (?P<ntdeaths>[\d\.]+)  # total number of deaths
            \s+
    """, re.VERBOSE)

    re_numdata = re.compile(r"(\d+)\.0")  # matches 12345.0 and returns 12345

    with filepath.open("r") as handle:

        # Parse header to know column names and also how many dates to expect
        try:
            header_line = next(handle)
            match = re_header.match(header_line)
            match_end = match.end()
            dates_str = header_line[match_end:].strip()
            dates = re_dates.findall(dates_str)
        except AttributeError:
            raise Exception(f"Unknown format for header line: {header_line}")

        n_dates = len(dates)
        assert n_dates - float(match.groupdict()["nloc"]) < EPSILON

        # Now parse the rest of the file
        for line in handle:
            # End of file
            if line.startswith("END"):
                break
            
            # Line with data
            # We will make use of regular expressions to parse the data
            # to make it easier to accomodate format changes.
            # First we get the 'metadata' of the line and determine where the
            # numerical data starts (match_end)
            match = re_line.match(line)
            match_end = match.end()
            # Now we take advantage of the numbers being integers in float fmt
            # to extract all at once with another regex.
            datastr = line[match_end:].strip()
            metadata = match.groupdict()
            linedata = [int(n) for n in re_numdata.findall(datastr)]
            
            # Make sure we parsed things correctly.
            # Check number of dates parsed vs header
            assert len(linedata) == n_dates

            # There is a small loop under a supposedly
            # debug comment that does affect the data.
            # do i = 3, nday { X(i-2) = tab1(i) }
            # Probably just there to avoid the two 
            # total counters.

            # Equiv to:
            # call Francesco_Predict
            process_data_line(linedata, metadata)


def process_data_line(x, metadata):  # X as named in the MORTRAN code
    """Process data."""
    
    # Big difference to MORTRAN code: indices in Python start at 0
    # unlike MORTRAN, where they start at 1. So Python H(1) is equal to 
    # MORTRAN H(2), ...

    def running_average(n1, t):
        """Running average algorithm by Francesco."""

        # Defining it but we c/should change this to a more efficient function.

        # This seems to be the window, but mo? There are several defined values
        # in the MORTRAN code. This is the last one.
        # Only used here too, so no need to have a negative value
        # and then abs(x).
        mo = 10

        # Will translate only the case for mo < 0
        f = 1.10
        sn, sw, na = 0, 0, 0

        for i in range(t, t - mo - 1, -1):
            if i < 0:
                break
            n1i = n1[i]
            if na > 0 and n1i > na*f:
                n1i = na * f
            sn += n1i
            sw += 1
            na = sn / sw
            # print(f"ML TEST i={i}; ni1={n1i:12.1f}; na={na:12.1f}")

        return sn / sw

    # Find first day with cases
    start = None
    for idx, d in enumerate(x):
        if d > 0:
            start = idx
            break
    else:  # if we never break
        return None  # No data

    stopt = len(x)
    # print(f"start={start}, stopt={stopt}")

    # Generate H(t) and J(t)
    # keep in mind that X(0)=0 and H(0),H(1),J(0),J(1) are not defined
    xtlim = 1
    if metadata["ctype"] == "Confirmed":
        xtlim *= 10

    h = [0.0 for _ in x]
    j = [0.0 for _ in x]
    for t in range(start + 1, stopt):
        h_now = math.log(x[t] / (x[t-1] + EPSILON) + EPSILON)
        j_now = math.log(h_now) if h_now > 0 else -99.999

        h[t] = h_now
        j[t] = j_now

        # print(f"t={t}, X(t-1)={x[t-1]}, X(t)={x[t]}, H(t)={h_now}, J(t)={j_now}")

    # Fit data up to day t* (at least 10 non-zero points to start the fit)
    u = [0.0 for _ in x]  # U(t)
    tm = [0.0 for _ in x]  # TM(t)
    alpha = [0.0 for _ in x]
    n1 = [0.0 for _ in x]
    n = [0.0 for _ in x]  # running average of n1
    for t in range(stopt):

        n_data = 0.0
        sum_x, sum_y = 0.0, 0.0
        sum_x2, sum_xy = 0.0, 0.0

        for i in range(start, t + 1):
            if h[i] > 1e-7:
                # In MORTRAN, wgt is sqrt(x[i])**2, which I assume is to avoid
                # integer truncation in these operations. Avoidable in Python.
                n_data += x[i]
                sum_y += j[i]*x[i]
                # I am not really sure of this, can't understand the original
                # code completely. Because indexing differs in Python and MORTRAN
                # the value of i will be different and as such, so will sum_x2, ...
                # We can revisit this later to fix the algorithm but for now,
                # for numerical comparisons, this works.
                sum_x2 += (i+1)*(i+1)*x[i]
                sum_x += (i+1)*x[i]
                sum_xy += (i+1)*j[i]*x[i]

        try:
            log_alpha = (sum_y * sum_x2 - sum_x * sum_xy) / (n_data * sum_x2 - sum_x**2)
            V = (n_data * sum_xy - sum_x * sum_y) / (n_data * sum_x2 - sum_x**2)
            u_now = -1 / V
        except ZeroDivisionError:
            n_data = 0.0
            alpha_now = u_now = tm_now = float('nan')
        else:
            log_alpha = j[t] + (t+1) / u_now  # same as above with i/i+1
            try:
                alpha_now = math.exp(log_alpha)
            except OverflowError:
                alpha_now = float('inf')
            try:
                tm_now = u_now * math.log(alpha_now * u_now)
            except ValueError:  # domain error
                tm_now = float('nan')

        # print(f"t={t}, alpha(t)={alpha_now:10.3f}, U(t)={u_now:10.3f}, TM(t)={tm_now:10.3f}")

        u[t] = u_now
        tm[t] = tm_now
        alpha[t] = alpha_now
        try:
            n1[t] = x[t] * math.exp(alpha_now*u_now*math.exp(-(t+1)/u_now))
        except OverflowError:
            n1[t] = float('inf')

        # Perform running average of N1
        n[t] = running_average(n1, t)
        # print(f"t={t}, N1(t)={n1[t]}, N(t)={n[t]}")
        if n[t] < x[t]:
            n[t] = x[t]  # limit N(t) to be >= X(t)

        print(f"A Jt: {t+1:>3d} {x[t]:>10d} {n[t]:>12.0f} {u[t]:>8.2f} {tm[t]:>6.1f}, {metadata['fullname']} {metadata['ctype']}")  # This is just debugging
    # Output Fits
    # example:  Jt:t,X(t),N(t),U(t),T(t),US,Confirmed
    cname = metadata['fullname']
    ctype = metadata['ctype']
    print(f"B Jt:t,X(t),N(t),U(t),T(t),{cname},{ctype}")

    nx = x[stopt - 1]  # nx = x[nday1] in mortran
    for t in range(stopt):
        if n[t] < 1:
            n[t] = 1
        # In MORTRAN there are several if statements that write to sN/sH/sJ vars
        # but these are never written? Confirm.
        # Same for frac/err

        # added by JR to truncate large integers.  This is wrong as n[t] is not an integer variable
# ML    if len(str(n[t])) > 10:
# ML        n[t] = "nan"
        if n[t] > 9999999999:
            n[t] = "nan"

        else:
            n[t] = f"{n[t]:>10.0f}"

        # Use t+1 to match MORTRAN output
        print(f"C Jt: {t+1:>3d} {x[t]:>10d} {n[t]:>10s} {u[t]:>10.2f} {tm[t]:>8.1f}, {cname} {ctype}")  # This is key output


if __name__ == "__main__":
    args = read_args()

    date2idx = parse_dates(args.datecodes)
    parse_datatable(args.datatable)
