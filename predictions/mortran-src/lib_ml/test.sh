#!/bin/csh
cat > test.ref << 'EOF'
   1   .546587
   2   .900143
   3   .939879
   4   .393384
   5   .896023
   6   .019929
   7   .297464
   8   .405194
   9   .230384
  10   .196448
 *** debug a = Michael Levitt                                                                                      
itrim(a) =   14
'EOF'

test.exe > test.out
diff test.out test.ref
if ($status == 0) then
   echo test.exe checks out 
   echo Here is test.out
   cat test.out
   rm test.out test.ref
else
   echo test.exe has problems
   echo Here is test.out
   cat test.out
   echo Here is test.ref
   cat test.ref
endif

