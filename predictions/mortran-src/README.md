# Original MORTRAN source code
The code shown here is written in MORTRAN, a dialect of FORTRAN that
is no longer maintained or supported. Check the `python/` folder for
equivalent implementations in Python.

To run the original MORTRAN code, it needs to be first translated to
FORTRAN, then to C, and finally compiled and linked into an executable.
We offer these files and instructions here without any promise of support
or maintainability.

## Requirements
gcc, gfortran (and on Linux, lapack-devel, blas-devel)

## How to compile MORTRAN
1. Run the `get_f2c.sh` script to setup `f2c`, `f2c.h`, and `libf2c.a`
2. Run the `compile_mortran8.sh` in the `mortran8-src/` folder
3. Run `make lib_ml.a` in `lib_ml/`
4. Run `./compile_mortran.sh program.lc` to compile the `program.lc` file

## How to run the MORTRAN program
Make a new folder and copy the executable to it. Then, copy the input data file
and the `Dates` file to that folder. Then run the program with: `cat input-file.txt | program.exe`

Example using the data files bundled with this repository:
```bash
mkdir run1

cp best_fit_line.new-v2.3.exe run1/
cp ../example_data/Dates_for_code.txt run1/  # this path is hardcoded in the MORTRAN code so do not change the name.
cp ../example_data/Select_COVID_data_PEAKS.UNSM.ALL._00.ftxt run1/

cd run1
cat Select_COVID_data_PEAKS.UNSM.ALL._00.ftxt | best_fit_line.new-v2.3.exe > predictions.out
```
