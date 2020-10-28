# Original MORTRAN source code
The code shown here is written in MORTRAN, a dialect of FORTRAN that
is no longer maintained or supported. Check the `python/` folder for
equivalent implementations in Python.

To run the original MORTRAN code, it needs to be first translated to
FORTRAN, then to C, and finally compiled and linked into an executable.
We offer these files and instructions here without any promise of support
or maintainability.

## Requirements
gcc, gfortran, lapack-devel, blas-devel

## How to compile MORTRAN
1. Run the `get_f2c.sh` script to setup `f2c`, `f2c.h`, and `libf2c.a`
2. Run the `compile_mortran8.sh` in the `mortran8-src/` folder
3. Run `make lib_ml.a` in `lib_ml/`
4. Run `./compile_mortran.sh program.lc` to compile the `program.lc` file

## How to run the MORTRAN program
`cat input-file.txt | program.exe`
