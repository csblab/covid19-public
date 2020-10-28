
OBJ = eqsq.o c_io.o itrim.o tolower.o toupper.o check_time.o utils.o ualert.o \
	tonumber.o ran3.o time.o ml_argv.o

.SUFFIXES:	.o .c .c~ .y .y~ .l .l~ .s .s~ .sh .sh~ .h .h~ .f .f~ .lc .lc~

.lc.o:
	./lc-to-o-linux.sh $< 

test.exe: test.o lib_ml.a
	cc -O -g -mcmodel=medium -o $@ test.o lib_ml.a libf2c.a -lm
	./test.sh

lib_ml.a : $(OBJ)
	ar ru $@ $(OBJ)

clean:
	touch junk.o ; rm -f *.o lib_ml.a test.exe _.*.* *# *~ f2c.h

tidy:
	rm -f *# *~ _.*.*
