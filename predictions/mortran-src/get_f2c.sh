#!/bin/bash -e

rm -rf libf2c src src.tgz

curl -sO https://www.netlib.org/f2c/libf2c.zip
curl -sO https://www.netlib.org/f2c/src.tgz

# Compile libf2c
mkdir libf2c
mv libf2c.zip libf2c
cd libf2c
unzip libf2c.zip
cp makefile.u makefile
make

[[ ! -e "libf2c.a" ]] && echo "Error compiling libf2c." && exit 1

cd ../

# Compile f2c executable
tar -xzf src.tgz
cd src
cp makefile.u makefile
make

[[ ! -e "f2c" ]] && echo "Error compiling f2c." && exit 1

cd ../

# Copy library and executable to where we need them
for dest in . mortran8-src lib_ml
do
  cp libf2c/libf2c.a $dest
  cp libf2c/f2c.h $dest
  cp src/f2c $dest
  chmod a+x ${dest}/f2c
done

echo "Success"
rm -rf libf2c src src.tgz
