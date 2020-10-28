#!/bin/bash -e

# Call this with the file you want to compile as an argument
# e.g. compile_mortran.sh code.lc

# Get Operative System
os_type=$( echo "${OSTYPE:0:5}" | tr '[:upper:]' '[:lower:]' )
case $os_type in
    linux)
	SYSTEM="Linux"
		;;
    darwi)
	SYSTEM="OSX"
		;;
    *)
	echo "The machine OS does not seem to be supported: ${OSTYPE} .. Aborting"
	exit 1
esac



[[ "$#" -lt 1 ]] && echo "usage: $0 code.lc" && exit 1

aa=`basename $1 '.lc'`
a=`basename $aa '.o'`
echo "file name is $a"

echo "lc-to-o.sh: $a.lc -> _.$a.f -> _.$a.c -> $a.o"

rm -f for001 for002 for003 for007

cp lib_ml/mormac.lc  for001
cp lib_ml/nullmac.lc         for002
cp $a.lc           for003

./mortran8.exe
mv for007  _.$a.f

./f2c -r8 -c -O -u -w -Ns1602 -Nn802 -g -A -P _.$a.f

gcc -include f2c.h -O -g -c _.$a.c
mv _.$a.o $a.o

if [ "$SYSTEM" == "OSX" ]
then
  cc -O -g -o $a.exe $a.o lib_ml/lib_ml.a libf2c.a -lm -lc
else
  cc -O -g -static -o $a.exe $a.o lib_ml/lib_ml.a libf2c.a -lm -lc
fi

rm -f for001 for002 for003
if [ -e "$a.exe" ]
then
  rm -f _.$a.P _.$a.f _.$a.c $a.o
fi
