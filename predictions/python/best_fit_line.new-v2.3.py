#!/usr/bin/env python

"""Line fitting Z(t).

Reimplementation of MORTRAN code best_fit_line.new-v2.3.lc for public sharing.
"""

import argparse
import decimal
import math
import pathlib
import re

EPSILON = 1e-5  # small number that will come handy


def frange(start, stop, step, include_stop=True):
    """range-like function that takes decimal step values."""
    # To avoid rounding issues
    # We cast the floats to string and then to decimals
    # see: docs on Decimal(0.1) != Decimal('0.1')
    dstep = decimal.Decimal(str(step))
    # We round the boundaries to the precision of the step
    # to avoid further issues with limits.
    precision = -1 * dstep.as_tuple().exponent

    val = decimal.Decimal(f"{start:.{precision}f}")
    end = decimal.Decimal(f"{stop:.{precision}f}")

    # Define stopping condition
    if include_stop:
        check = lambda v: v <= end
    else:
        check = lambda v: v < end

    n = 0  # number of cycles
    while check(val):
        yield start + n*step  # return the "full precision" value
        val += dstep  # to keep the boundary condition
        n += 1

# Full precision version that does not use decimal roundings.
# Matches MORTRAN in double precision: f2c -r8
def frange_fp(start, stop, step):
    """range-like function that takes decimal step values."""

    vals = []
    while start <= stop:
        vals.append(start)
        start += step
    return vals


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


def parse_datatable(filepath, fdates):
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
        nloc = 0
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


            if metadata['ctype'] == 'Confirmed':
                nloc += 1
            metadata['nloc'] = nloc  # instead of passing the variable

            # fdates have more dates than dates
            # keep this in mind.
            process_data_line(fdates, linedata, metadata)
            return


def running_average(n1, t):
    """Running average algorithm by Francesco."""

    # Defining it but we c/should change this to a more efficient function.

    # This seems to be the window, but mo? There are several defined values
    # in the MORTRAN code. This is the last one.
    # Use 10 (vs -10) to avoid abs
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


def francesco_predict(x, metadata):

    nday = len(x)

    h = [0.0] * nday  # H(t)
    j = [0.0] * nday  # J(t)
    n = [0.0] * nday  # N(t)
    n1 = [0.0] * nday  # N1(t)
    u = [0.0] * nday  # U(t)
    alpha = [0.0] * nday  # alpha(t)
    tm = [0.0] * nday  # TM(t)
    sym = [0] * nday  # sym array

    # Detect plateaus
    for t in range(4, nday):  # avoid t1 <= 0 conditional
        t1 = t - 3
        xm = x[t] - x[t1]
        xp = x[t] + x[t1]

        if xp == 0.0:
            sym[t] = 0
        elif xm < 0.01 * xp:
            sym[t] = 1
        else:
            sym[t] = int(math.log(xm / 7)) + 2
    
    # Subtract plateau working backwards
    # Commented because we force xpl to 0
    #
    # _x = 0.2 * x[-1]  # 0.2*X(nday1)
    # for t in range(nday - 1, 1, -1):  # from nday until 2
    #     if x[t] < _x and sym[t] <= 1:
    #         tpl = t - 1
    #         break
    # else:
    #     tpl = 0  # in case loop never breaks

    # xpl = x[tpl]
    xpl = 0  # force zero plateau -- Why we comment everything above and below.

    # Commented because we force xpl to 0
    # for t in range(nday):
    #     x[t] = x[t] - xpl
    #     if x[t] < 0:
    #         x[t] = 0
    
    # start is the first day where x[t] ~= 0
    # stopt is the last data point
    start = None
    stopt = nday
    for t in range(nday):
        if start is None and x[t] > 0:
            start = t
            break  # avoid looping through the entire array

    if start is None:  # x[t] is never above 0.
        start = 0

    # Crude fix. Look at CC from all starts to stop and see when OK

    # Generate H(t) and J(t) keeping in mind X(0) = 0 and J/H(0),J/H(1) are not defined
    xtlim = 1
    if metadata['ctype'] == 'Confirmed':
        xtlim *= 10
    
    eps = 0.0  # should this be zero??!
    starta = None
    for t in range(start + 1, stopt):
        h[t] = math.log(x[t] / x[t - 1] + eps) + eps
        if h[t] > 0:
            j[t] = math.log(h[t])
        else:
            j[t] = -99.999
        
        if x[t] > xtlim and starta is None:
            starta = t

        # print(f'debug: t={t} x[t]={x[t]} h[t]={h[t]} j[t]={j[t]} starta={starta}')
    
    if starta is None:  # x[t] is never > xtlim
        starta = 0
    # print(f'debug: starta={starta} stopt={stopt}')

    # fitting data up to day t* 
    # at least 10 non zero points to start the fit
    for t in range(starta, stopt):
        n_data = 0.0
        sum_y = sum_x2 = sum_x = sum_xy = 0.0

        for i in range(start + 1, t + 1):
            if h[i] > 0.00000001:  # to avoid infinite J(t)
                wgt = x[i]  # avoid sqrt(x(i)) ** 2
                n_data += wgt
                sum_y += j[i] * wgt
                sum_x2 += (i + 1) * (i + 1) * wgt
                sum_x += (i + 1) * wgt
                sum_xy += (i + 1) * j[i] * wgt

        # print(f'debug: t={t} x[t]={x[t]} n_data={n_data} alpha[t]={alpha[t]} u[t]={u[t]} tm[t]={tm[t]}', flush=True)
        try:
            log_alpha = (sum_y*sum_x2 - sum_x*sum_xy) / (n_data*sum_x2 - sum_x*sum_x)
            V = (n_data*sum_xy - sum_x*sum_y) / (n_data*sum_x2 - sum_x*sum_x)
        except ZeroDivisionError:
            log_alpha = float('inf')
            V = float('inf')

        u[t] = -1 / V

        try:
            log_alpha = j[t] + ((t + 1) / u[t])
        except ZeroDivisionError:
            log_alpha = float('inf')
        alpha[t] = math.exp(log_alpha)
        try:
            tm[t] = u[t] * math.log(alpha[t]*u[t])
        except ValueError:  # domain error (negative)
            tm[t] = float('nan')

        try:
            n1[t] = x[t] * math.exp(alpha[t] * u[t] * math.exp(-(t+1) / u[t]))
        except ZeroDivisionError:
            n1[t] = float('inf')

        # call ave_Francesco
        n[t] = running_average(n1, t)
        if n[t] < x[t]:
            n[t] = x[t]  # limit N(t) to be >= X(t)

        # print(f'debug: t={t} n_data={n_data} alpha[t]={alpha[t]} u[t]={u[t]} tm[t]={tm[t]} n1[t]={n1[t]} n[t]={n[t]}')

    # The MORTRAN code goes to stopt+1
    #
    # We cannot do that: IndexError on x/h/j access
    # All these values are 0.0 in MORTRAN
    # Reuse values from last iteration
    log_alpha = 0.0 + ((t + 2) / u[t])
    alpha_t = math.exp(log_alpha)
    try:
        tm_t = u[t] * math.log(alpha_t*u[t])
    except ValueError:  # domain error (negative)
        tm_t = float('nan')

    n1_t = 0.0

    # call ave_Francesco
    n_t = running_average(n1 + [n1_t], t + 1)
    if n_t < 0.0:
        n_t = 0.0  # limit N(t) to be >= X(t)

    # print(f'debug: t={t+1} n_data={n_data} alpha[t]={alpha_t} u[t]={u[t]} tm[t]={tm_t} n1[t]={n1_t} n[t]={n_t}')

    # Output GNU: lines
    # print(
    #     f'GNU: {"t":<3s} {"X[t]":<10s} {"H[t]":<10s} {"J[t]":<10s} {"N[t]":<10s} {"N[t]":<12s} '
    #     f'{"u[t]":<10s} {"alpha[t]":<10s} {"tm[t]":<10s} '
    #     f'Loc Confirmed {"fra":<8s} {"err":<8s}'
    # )
    nx = x[-1]  # Nx = X(nday1)
    _x = 2*nx  # 2*X(nday1)
    for t in range(stopt):
        # n[t] += xpl  # Add back first plateau
        # x[t] += xpl  # commented out because xpl is 0.0
        if n[t] < 1:
            n[t] = 1
            if n[t] < _x:
                sN = f"{n[t]:10.1f}"
            else:
                sN = '-'
        if h[t] > 0.000001:
            sH = f"{h[t]:10.4f}"
            sJ = f"{j[t]:10.4f}"
        else:
            sH = '-'
            sJ = '-'
        
        if nx > 0:
            fra = 100 * x[t] / nx
            err = 100 * abs(n[t] - nx) / nx
            if err > 100:
                err = 100.0  # correct
            err = round(err, 0)

        # Truncate very large numbers on output
        if alpha[t] > 999999:
            s_alpha_t = "**********"
        else:
            s_alpha_t = f"{alpha[t]:10.3f}"

        # print(
        #     f"GNU: {t:>3d} {x[t]:>10.1f} {sH:>10s} {sJ:>10s} {sN:>10s} {n[t]:>12.5e} "
        #     f"{u[t]:>10.3f} {s_alpha_t:>10s} {tm[t]:>10.3f} "
        #     f"{metadata['fullname']:>s} {metadata['ctype']:>s} {fra:>8.2f} {err:>8.2f}"
        # )


def cc_from_lnx(first, last, ltab, lnN, xvk, yvk):
    """cc_from_lnN/lnX in MORTRAN code."""

    # Indices are funky to match MORTRAN indexing.

    sumx = sumy = sum_x2 = 0
    sum_y2 = sum_xy = sumi = 0

    for i in range(first, last):
        xvk[i] = -1  # used to signal skip value
        if ltab[i][0] < 0:
            continue

        ln_dat_minus_lnx = lnN - ltab[i][0]
        # print(f"debug: first={first} last={last} i={i} lnN={lnN} ln_dat_minus_lnx={ln_dat_minus_lnx}")
        if ln_dat_minus_lnx <= 0:
            continue


        # print(f"{first} {last} {i} {lnN:<20.10f} {ltab[i][0]:<20.10f} {ln_dat_minus_lnx:<20.10f}")

        xv = i + 1
        yv = -20 * math.log(ln_dat_minus_lnx)  # still scale by 20.0
        xvk[i] = xv
        yvk[i] = yv

        sumi += 1
        sumx += xv
        sumy += yv
        sum_x2 += xv**2
        sum_y2 += yv**2
        sum_xy += xv * yv
    
    if sumi <= 0:
        # print('failed')
        return -1.0, 0.0, xvk, yvk  # signal failure

    # Get line CC
    sumx /= sumi
    sumy /= sumi
    sum_x2 /= sumi
    sum_y2 /= sumi
    sum_xy /= sumi

    sdx = math.sqrt(abs(sum_x2 - sumx**2))
    sdy = math.sqrt(abs(sum_y2 - sumy**2))

    cc = 0.0
    if (sdx * sdy) > 0:  # both same sign
        cc = abs(sum_xy - sumx * sumy) / (sdx * sdy)

    return cc, sumi, xvk, yvk


def process_data_line(fdates, x, metadata):  # X as named in the MORTRAN code
    """Process data."""
    
    # Big difference to MORTRAN code: indices in Python start at 0
    # unlike MORTRAN, where they start at 1. So Python H(1) is equal to 
    # MORTRAN H(2), ...

    nday = len(x)

    # Last day is defined in MORTRAN as the last numerical index
    # in the Dates_for_code.txt file. So we can simply count the dates.
    last_day = len(fdates)
    # Extract dates from fdates dictionary
    dates = [fdates[d] for d in sorted(fdates)]

    # MORTRAN code defines nk as 200000 in the header.
    # We will use nk_max here to define arrays
    nk_max = 200000
    ccmax_k = [0.0] * nk_max
    ccmax1_k = [0.0] * nk_max
    lnx_max_k = [0.0] * nk_max
    first_k = [0.0] * nk_max
    last_k = [0.0] * nk_max
    maxxX_k = [0.0] * nk_max
    predX_k = [0.0] * nk_max
    currX_k = [0.0] * nk_max
    slope_k = [0.0] * nk_max
    percent_k = [0.0] * nk_max
    per_comp_k = [0.0] * nk_max
    x1_k = [0.0] * nk_max
    x2_k = [0.0] * nk_max
    y1_k = [0.0] * nk_max
    y2_k = [0.0] * nk_max
    T_value_k = [0.0] * nk_max
    end_day_k = [0.0] * nk_max
    iloop_k = [0.0] * nk_max

    first_zt = True

    #
    # call Francesco_Predict
    #
    francesco_predict(x, metadata)
    
    ltab = []  # v, log(v)
    for t in range(nday):
        v = x[t] + 0.00001  # to avoid issues with log
        log_v = math.log(v)
        ltab.append((log_v, v))

    # First non zero case (log scale)
    for t in range(nday):
        if ltab[t][0] > 0:
            first1 = t
            break
    
    # NEW JUNE 14 2020
    # Get log of log X(t)/X(t-1) for t=2 adding 0.0001 to stop log(0.0)
    lnHr8 = [0.0] * nday  # real8 == Python float
    lnH = []
    lnH.append(' - ')

    xvb = list(range(nday))  # this seems to be an array of nday
    yvb = list(range(nday))

    for t in range(1, nday):

        xt = ltab[t][1]
        xt_prev = ltab[t - 1][1]

        if xt_prev < 1 or xt_prev >= xt:
            lnH.append('-')
            xvb[t] = -1
        else:
            v0 = math.log(xt_prev + 0.00001)
            v1 = math.log(xt + 0.00001)
            lnH_t = math.log(v1 - v0 + 0.0001)
            lnH.append(f"{lnH_t:8.4f}")
            lnHr8[t] = lnH_t  # ln of change in ln
        
        if t == 1:
            lnHr8[0] = lnHr8[1]
        
        # print(f"debug: t={t} ltab[t-1][1]={ltab[t-1][1]} ltab[t][1]={ltab[t][1]} lnH[t]={lnH[t]}")

    xvb[0] = xvb[1] - 1
    lnHr8[0] = lnHr8[1]

    # BEST SLOPE is always false, so not translating that part.
    #
    slopes = [0.0] * nday
    lim = 0

    lnH[0] = lnH[1]
    # print(
    #     f"lnH: {metadata['fullname']}={metadata['ctype']} U= {float('inf'):8.2f} {lim:4d} 0 "
    #     f"{' '.join(lnH)}"
    # )

    # ==================================================
    # ==================================================

    # Clear iv1x
    iv1x = [0] * nday

    datesk = list(dates)
    for t in range(nday):
        if t % 7 != 1:
            datesk[t] = "."
    
    print(f"ML aaa nday1 {nday} {dates[-1]} {ltab[-1][1]} {ltab[-1][0]}")

    predX_max = 0
    nk = 0
    # never formally defined in MORTRAN code.
    # but passed as argument to get_cc
    # we define it here to let it accumulate
    # as the loops run.
    lnx_max = 0.0
    for last in range(nday - 1, 4, -1):  # walk backwards
        for first in range(last - 5, -1, -1):

            if ltab[first][0] < 0:
                continue

            #
            # get_cc in MORTRAN
            # no need to define a function here.
            # too many globals.
            #

            # These arrays are never initialized in MORTRAN but are defined 
            # in get_cc and passed as an argument to cc_from_lnx
            xvk = [0.0] * nday
            yvk = [0.0] * nday

            ln_max = ltab[last][0]
            lnx1 = ln_max - 1

            # In MORTRAN output with a precision of 10 digits.
            # 2.3 = 2.2999999523
            # 0.8 = .8000000119
            # These are single precision numbers.
            # We could translate them with
            # to_single = lambda x: struct.unpack('f', struct.pack('f', x))[0]
            # to_single(2.3) = 2.299999952316284
            # But we'd have to apply this to _all_ numbers and results
            # of all arithmetic operations.
            # 
            lnx2 = ln_max + 2.3
            dlnx = 0.8

            # print(f"debug: first={first}, last={last}, ln_max={ln_max} lnx1={lnx1} lnx2={lnx2}")

            ccmax = -10
            for itry in range(12):
                if itry > 0:
                    lnx1 = lnx_max - dlnx
                    lnx2 = lnx_max + dlnx
                    dlnx /= 2
                # frange: defined above
                # range-like for decimal steps
                # Best way we found to reproduce MORTRAN's for-loop
                # with decimal step and inclusive stop (<=)
                #
                # Sometimes the number of iterations inside cc_from_lnx
                # will differ from MORTRAN, again because of floating point precision
                # ln_dat_minus_lnx will be 0 in double precision but not in single
                # precision (MORTRAN).
                #
                # The frange_fp version of the function matches the MORTRAN output
                # if compiled with f2c -r8 option: forced double precision.
                for lnx in frange_fp(lnx1, lnx2, dlnx):
                    # print(f"debug: itry={itry} lnx1={lnx1:20.15f} lnx2={lnx2:20.15f} dlnx={dlnx:20.15f}")
                    cc, sumi, xvk, yvk = cc_from_lnx(first, last + 1, ltab, lnx, xvk, yvk)
                    # print(f"debug: lnx={lnx:15.12f} sumi={sumi} cc={cc:8.5f} ccmax={ccmax:8.5f} lnx_max={lnx_max:8.5f}")
                    if sumi >= 7 and ccmax < cc:
                        # print(f"debug: ccmax={ccmax:30.10f} < cc={cc:30.10f} lnx_max={lnx_max} => lnx={lnx}")
                        ccmax = cc
                        lnx_max = lnx
                        for i in range(first, last + 1):
                            xvb[i] = xvk[i]
                            yvb[i] = yvk[i]

            # print(f"debug: first={first} last={last} itry={itry} sumi={sumi} cc={cc} lnx_max={lnx_max} lnx1={lnx1} lnx2={lnx2} dlnx={dlnx}")

            # 
            # end of get_cc function in MORTRAN
            #

            # I could not find a way to regularize this between the two programs
            # without converting the entire code to use numpy float32.
            # Even then, the lnx frange for-loop will be hard to reproduce.
            # MORTRAN should be double precision but the C code translates e.g.
            # real*8 2.3 to 2.3f in C. To force conversion, use f2c -r8 flag
            # Python will always handle the floats in double precision (on 64 bit machines).
            #
            # As a result, lnx_max and yvb will differ from the MORTRAN code
            # This will be more obvious when we use exp() and log() functions
            # Here's a comparison of the yvb values in both languages:
            # e.g.
            #  MORTRAN: 14.740763669104
            #  PYTHON : 14.740763669106
            #

            if ccmax < 0:
                continue  # fail to find CC with >= 7 points
            ccmax = abs(ccmax)

            # print(f"debug: first= {first} last= {last} ccmax= {ccmax:10.4f} lnx_max= {lnx_max:10.4f}")

            M = 0
            sumx = sumy = 0
            sum_x2 = sum_y2 = sum_xy = 0

            for i in range(first, last + 1):
                x1 = xvb[i]
                if x1 < 0:
                    continue

                y1 = yvb[i] / 20.0

                M += 1

                sumx += x1
                sumy += y1
                sum_x2 += x1 * x1
                sum_y2 += y1 * y1
                sum_xy += x1 * y1
            
            # Numerically equivalent to MORTRAN if -r8
            # print(f"{first} {last} {M} {ccmax:<20.5f} {sumx:<20.5f} {sumy:<20.5f}")

            try:
                slopR = (M * sum_xy - sumx * sumy) / (M * sum_x2 - sumx**2)
            except ZeroDivisionError:
                slopR = float('inf')
            
            try:
                intcR = (sumy * sum_x2 - sumx * sum_xy) / (M * sum_x2 - sumx**2)
            except ZeroDivisionError:
                intcR = float('inf')
            
            try:
                ccR = (sum_xy - sumx*sumy/M) / math.sqrt((sum_x2 - sumx**2 / M) * (sum_y2 - sumy**2 / M))
            except (ZeroDivisionError, ValueError):
                ccR = float('inf')

            # MORTRAN without f2c -r8:
            # These values are almost always matched between the codes.
            # Benchmarks show 0.6% of values differ, due to the precision issues
            # mentioned above.
            # print(f"{first} {last} {M} {ccmax:<20.5f} {sumx:<20.5f} {sumy:<20.5f} {slopR:<20.5f} {intcR:<20.5f} {ccR:<20.5f}")
            # MORTRAN with f2c -r8:
            # Values match 100%.

            try:
                TvR = -intcR / slopR
            except ZeroDivisionError:
                TvR = float('inf')

            x1 = xvb[first]
            x2 = xvb[last]
            y1 = yvb[first] / 20.0
            y2 = yvb[last] / 20.0
            slope = 999.0
            if abs(x1 - x2) > 0:
                slope = (y2 - y1) / (x2 - x1)

            now = ltab[nday - 1][1]

            # Potential difference bc of precisions and truncation.
            # e.g.
            #  MORTRAN = 306271490
            #  PYTHON  = 306271468
            #
            predict = int(math.exp(lnx_max))

            percent = 100 * predict / (now - 1.0)
            per_comp = 100 * now / predict

            sumi = last - first + 1
            predX = predict  # now sure why repeated
            currX = int(ltab[last][1])
            maxxX = int(ltab[nday - 1][1])
            try:
                ccmax1 = ccmax - 1 / math.sqrt(sumi)  # substract one SD to be cautious
            except ZeroDivisionError:
                ccmax = float('inf')

            # must be accurate determination of slope
            try:
                sdx = math.sqrt(M * sum_x2 - sumx**2)
                sdy = math.sqrt(M * sum_y2 - sumy**2)
                sdx_sdy_ratio = sdx / sdy
                if sdx_sdy_ratio > 1000.0 or sdx_sdy_ratio < 0.001:
                    raise ZeroDivisionError  # being lazy here
            except (ZeroDivisionError, ValueError):
                # ValueError catches domain errors in sqrt
                TvR = -99.99
                slopR = 1 / 99.99

            # print(f"debug: first={first} last={last} slope={slope} ccmax1={ccmax1} TvR={TvR} predX={predX} currX={currX} maxxX={maxxX}")
            # print(f"{first:8d} {last:8d} {slope:<20.10f} {ccmax1:<20.10f} {TvR:<20.10f} {predX:20d} {currX:20d} {maxxX:20d}")

            if ccmax1 > 0.50 and predX >= currX:
                # Acceptance criterion
                del_day = 0
                date_last = ""

                if slope > 0:
                    T_value = -(y1-x1*slope) / slope
                    # Get the predicted day when N/X(t) == 0.99
                    # This means: log(log(1/0.99)) = -2.36
                    # log10(log10(1/0.95)) = -1.65 ; log(log(1/0.99)) = -2.36
                    del_day = (2.36 - y2) / slope
                
                end_day = int(last + 1 + del_day)  # compensate difference of -1 to MORTRAN
                endR = (2.36 - intcR) / slopR

                # DEBUG STATEMENT BLOCK
                #
                # print(f"debug: sdx={sdx} sdy={sdy}")
                # print(
                #     f"debug: first={first} last={last} M={M} slopR={slopR:15.5f} slope={slope:15.5f} ccR={ccR:15.5f}"
                #     f" ccmax={ccmax:15.5f} intcR={intcR:15.5f} TvR={TvR:15.5f} T_value={T_value:15.5f} endR={endR:15.5f} end_day={end_day}"
                # )
                #
                #

                # Use new values
                end_day = int(endR)  # MORTRAN cast to int
                T_value = TvR
                slope = slopR

                if end_day > 0 and end_day < last_day:
                    date_last = dates[end_day]
                    if date_last == "":
                        date_last = "future"
                else:
                    date_last = "undefine"
                
                slope = 1.0 / slope

                ccmax_k[nk] = ccmax
                ccmax1_k[nk] = ccmax1
                lnx_max_k[nk] = lnx_max
                first_k[nk] = first
                last_k[nk] = last + 1  # to match MORTRAN
                maxxX_k[nk] = maxxX
                predX_k[nk] = predX
                currX_k[nk] = currX
                slope_k[nk] = slope
                T_value_k[nk] = T_value
                percent_k[nk] = percent
                per_comp_k[nk] = per_comp
                end_day_k[nk] = end_day
                x1_k[nk] = x1
                x2_k[nk] = x2
                y1_k[nk] = y1
                y2_k[nk] = y2
                # iloop_k[nk] = iloop  # not used here in Python
                # print(f"nk={nk} predX={predX} last={last}")
                nk += 1  # nk at the end to compensate for MORTRAN 1-based indexing

    # End of double first/last for-loop
    # Now process the data

    # Sort the data by increasing predX_k(k) for a given end day
    # We use a dictionary here to sort indexes by values
    i_v_dict = {k: -1 * (predX_k[k] + last_k[k]*10000000) for k in range(nk)}
    indx = sorted(i_v_dict, key=lambda k: i_v_dict[k])
    # vals = [i_v_dict[k] for k in indx]

    # Get the histograms using the sorted data
    # Need to get the k values of the lines that are used for most probable (propabable?)
    ilp = 0
    ilpx = 0
    iv1_ihi = [0] * 1000
    i_ihi = [0] * 1000
    hist = [0] * 1001
    histx = [0] * nday
    nh_ilp = [0] * nday
    # pred_ilp = [0] * nday  # never used
    ih_ilp = [0] * nday
    iv1_mn = [0] * nday
    iv1_mx = [0] * nday
    iv1_me = [0] * nday

    ivh_k = [0] * nk

    for k in range(nk):
        k1 = indx[k]
        il = last_k[k1] - 1  # MORTRAN->Python indexing
        if il != ilp:
            if ilp > 0:
                ihi = 0

                for ih in range(200):
                    if hist[ih] > 0:
                        # correct ih + 1 for python indexing
                        iv1 = int((ih + 1 - 0.5) * predX_max / 200.0)  # two hundred bins for the full range
                        if histx[ilp] < hist[ih]:  # most common histogram value
                            histx[ilp] = hist[ih]
                            iv1x[ilp] = iv1
                            ih_ilp[ilp] = ih

                        iv1_ihi[ihi] = iv1
                        i_ihi[ihi] = ih
                        ihi += 1
                
                #
                if ilpx < ilp:
                    ilpx = ilp
                
                # set minimum, median, maximum
                if ihi > 0:
                    iv1_mn[ilp] = iv1_ihi[0]
                    iv1_mx[ilp] = iv1_ihi[ihi - 1]  # correct for Python indexing
                    iv1_me[ilp] = iv1_ihi[ihi // 2]  # correct for Python indexing
                else:
                    iv1_mn[ilp] = 0
                    iv1_mx[ilp] = 0
                    iv1_me[ilp] = 0
                
            #
            ilp = il
            hist = [0 for _ in range(1000)]  # reset?
            predX_max = predX_k[k1]
        #
        ivh = int(200.0 * predX_k[k1] / predX_max)  # adjust to Python indexing
        hist[ivh] += 1
        ivh_k[k1] = ivh  # ivh_k[k] is the histogram bin for line k
        nh_ilp[ilp] += 1
        # print(f" ivh={ivh} hist[ivh]={hist[ivh]} ivh_k[k1]={ivh_k[k1]} nh_ilp[ilp]={nh_ilp[ilp]}")
    #

    # Find the line with the highest value of ccmax1_k[nk]
    ccmax1k = 0
    for k in range(nk):
        if ccmax1k < ccmax1_k[k]:
            ccmax1k = ccmax1_k[k]
            kx1 = k
    # print(f"debug: ccmax1k={ccmax1k:20.10f} kx1={kx1:10d}")

    # Write out the TAB data table
    print(
        "TAB: Date   Day     Real      MAX  "
        "Predict    Count      Min      Max      Med      "
        " Frac      eCon       eMed"
    )
    m_limit = 10.0 * ltab[nday - 1][1]

    # Back average N1(t) as done in ave_francesco
    n = [0.0] * nday  # N(t)
    n1 = [0.0] * nday  # N1(t)

    f = 1.10
    for t in range(nday):
        n1[t] = iv1x[t]
        sn, sw, na = 0, 0, 0
        for i in range(t, t - 10 - 1, -1):
            if i < 0:
                break

            n1i = int(n1[i])
            if na > 0 and n1i > na*f:
                n1i = int(na * f)
            sn += n1i
            sw += 1
            na = int(sn / sw)

        n[t] = int(sn / sw)
        # print(f"debug: t={t} iv1x[t]={iv1x[t]} n[t]={n[t]} sn={sn} sw={sw}")

    for ilp in range(nday):
        string = " - "
        if n[ilp] < m_limit:
            string = f"{n[ilp]:9d}"  # skip if n[t] > m_limit
        if n[ilp] < ltab[ilp][1]:
            string = f"{int(ltab[ilp][1]):9d}"  # n[t] > x[t]
        
        ltab_nday = ltab[nday - 1][1]
        if ltab_nday > 0:
            frac = ltab[ilp][1] / ltab_nday
            eCon = 100 * (iv1x[ilp] - ltab_nday) / ltab_nday
            eMed = 100 * (iv1_me[ilp] - ltab_nday) / ltab_nday
        else:
            frac, eCon, eMed = float('inf')
        
        print(
            f"TAB: {metadata['fullname']} {metadata['ctype']} {datesk[ilp]:10s}"
            f" {ilp:5d} {ltab[ilp][1]:9.0f} {ltab_nday:9.0f} {string:9s} {histx[ilp]:9d}"
            f" {iv1_mn[ilp]:9d} {iv1_mx[ilp]:9d} {iv1_me[ilp]:9d}"
            f" {frac:10.4f} {eCon:10.4f} {eMed:10.4f}"
        )

    # Print the saved data
    write_il = [0] * nday
    ilp = 0

    for k1 in range(nk - 1, -1, -1):  # reverse iteration
        k = k1
        # No sorting test
        end_day = end_day_k[k] - 1
        date_last = ""

        if end_day > 0 and end_day < last_day:
            date_last = dates[end_day]
            if date_last == "":
                date_last = "future"
        else:
            end_day = 999
            date_last = "undefine"
        
        ilp = last_k[k] - 1
        lnx_max = lnx_max_k[k]

        # Mark data as best if its rounded value for histogram is matched
        # ih_ilp[ilp] is the number of the most probable histogram bin
        # ivh_k[k] is the histogram bin for line k
        mode = "xxxx"
        if ivh_k[k] == ih_ilp[ilp]:
            mode = "BEST"
        
        if mode == "BEST":
            print(
                f"AAA1 {int(metadata['nloc']):5d} {metadata['fullname']} {metadata['ctype']} cc1={ccmax_k[k]:8.6f} cc2={ccmax1_k[k]:8.6f}"
                f" lx={lnx_max_k[k]:8.5f} if={first_k[k] + 1:3d} il={last_k[k] + 1:3d} {dates[last_k[k] - 1]}"
                f" n={last_k[k] - first_k[k] + 1:3d} now={maxxX_k[k]:9d}"
                f" thsP={predX_k[k]:10d} then={currX_k[k]:10d} conP={iv1x[ilp]:10d}"
                f" U={slope_k[k]:8.2f} T={T_value_k[k]:8.1f} p1={percent_k[k]:5.1f}"
                f" p2={per_comp_k[k]:7.1f} ed={end_day + 1:5d} {date_last:10s}"
                f" x1={x1_k[k]:4.0f} x2={x2_k[k]:4.0f} y1={y1_k[k]:4.0f} y2={y2_k[k]:4.0f}"
                f" {mode}"
            )
        
        # Mark the first line of each new ilp
        if k == nk or last_k[k] > last_k[k + 1]:
            mode += "F1"

        print(
            f"AAA2 {int(metadata['nloc']):5d} {metadata['fullname']} {metadata['ctype']} cc1={ccmax_k[k]:8.6f} cc2={ccmax1_k[k]:8.6f}"
            f" lx={lnx_max_k[k]:8.5f} if={first_k[k] + 1:3d} il={last_k[k] + 1:3d} {dates[last_k[k] - 1]}"
            f" n={last_k[k] - first_k[k] + 1:3d} now={maxxX_k[k]:9d}"
            f" thsP={predX_k[k]:10d} then={currX_k[k]:10d} conP={iv1x[ilp]:10d}"
            f" U={slope_k[k]:8.2f} T={T_value_k[k]:8.1f} p1={percent_k[k]:5.1f}"
            f" p2={per_comp_k[k]:7.1f} ed={end_day + 1:5d} {date_last:10s}"
            f" x1={x1_k[k]:4.0f} x2={x2_k[k]:4.0f} y1={y1_k[k]:4.0f} y2={y2_k[k]:4.0f}"
            f" {mode}"
            f" histx={histx[ilp]:3d} {nh_ilp[ilp]:3d}"  # no iloop
        )

        # 17 June 2020.  Write out Z(t) for all BEST lnN of final day1 of data
        if k == kx1:
            # call output_cc1
            #ccmax_k[k], lnx_max[k], nday, ltab, first_k[k], last_k[k], header

            lnx = lnx_max_k[k]
            xvk = [-1] * nday
            yvk = [0] * nday
            cc, sumi, xvk, yvk = cc_from_lnx(first_k[k], last_k[k], ltab, lnx, xvk, yvk)

            yvk = [i / 20.0 for i in yvk]  # rescale to compensate for *20
            for i in range(1, nday):  # look for errors
                if yvk[i] > 0 and yvk[i - 1] > 0 and yvk[i] < yvk[i - 1]:
                    print(f"Zt_error: {i:4d} {nday:4d} {yvk[i-1]:8.3f} {yvk[i]:8.3f}")

            ytr8 = yvk[:]

            print(
                f"test_Zt: cc={cc:10.7f} n={sumi:4d}"
                # header in MORTRAN
                f"{metadata['fullname']}={metadata['ctype'][0]}_{ccmax_k[k]:8.6f}_{last_k[k] - first_k[k] + 1:6d},"
                f"lnN:{lnx_max_k[k]:7.4f},e:{last_k[k] - 1:6d},M:{maxxX_k[k]:10d},N:{predX_k[k]:10d},"
                f"U:{slope_k[k]:6.2f},T:{T_value_k[k]:5.1f}"
            )

            first_zt = False  # Just write out first line, the mosty global fit
        
        if k1 == 0:  # adjust for Python indexing
            print(
                f"GP:  Dates           Day     Max  Predict Current    Bpred  Count eDay EndDate"
            )
        
        string = "    -     "
        if iv1x[ilp] < m_limit:
            string = f"{iv1x[ilp]:9d}"
        string1 = "    -     "
        if predX_k[k] > m_limit:
            string1 = f"{predX_k[k]:9d}"
        
        print(
            "GP: "
            f"{metadata['ctype']:9s} {metadata['fullname']} {dates[ilp]:10s}"
            f" {ilp:8d} {maxxX_k[k]:8d} {string1} {currX_k[k]:8d} {string}"
            f" {histx[ilp]:6d} {end_day + 1:6d} {date_last:10s}"
        )


if __name__ == "__main__":
    args = read_args()

    date2idx = parse_dates(args.datecodes)
    parse_datatable(args.datatable, date2idx)
