#!/bin/bash -e

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

./f2c -c -O -u -w -Ns1602 -Nn802 -g -A -P -r8 mortran8.f
gcc -include f2c.h -O -g -c mortran8.c
gcc -o mortran8.o -O -g -c mortran8.c

if [ "$SYSTEM" == "OSX" ]
then
  gcc -O -g -o mortran8.exe mortran8.o libf2c.a
else
  gcc -O -g -static -o mortran8.exe mortran8.o libf2c.a
fi

rm -f mortran8.c mortran8.P mortran8.o
rm -f libf2c.a f2c.h f2c

[[ ! -e "mortran8.exe" ]] && echo "Failed." && exit 1

chmod a+x mortran8.exe
cp mortran8.exe ../
echo "Success"
