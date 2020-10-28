#!/usr/bin/env bash

aa=$( basename $1 '.lc' )
a=$( basename $aa '.o' )
echo "file name is $a"

rm -f for001 for002 for003 for007

cp mormac.lc  for001
cp nullmac.lc for002
cp $a.lc           for003
../mortran8.exe
mv for007  _.$a.f

./f2c -r8 -c -O -u -w -Ns1602 -Nn802 -g -A -P _.$a.f

cc -O -g -mcmodel=medium -c _.$a.c
mv _.$a.o $a.o

rm -f for001 for002 for003
