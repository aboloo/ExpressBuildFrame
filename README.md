   Express Build Frame v1.1
---------------------------------
by robertluojh


frame introduce
---------------------------------
execute dir: execMain execTest
library dir: alib blib
makefile dir: mak
main makefile: Makefile


user guider
---------------------------------
make all shared=on
export LD_LIBRARY_PATH=$(pwd)/build/lib/
./build/bin/execTest
or
./build/bin/execMain

** the second build way: lazy build
make lazy    #only one main() is permitted
./expressBuild 


release note
---------------------------------
v1.1
1. support lazy build: make lazy
2. support pthread. it's only used with shared library in x86_64 os, 
   because the libpthread.a of compat-glibc is NOT compiled with -fPIC.
---------------------------------
v1.0
1. lazy mode. one makefile work best, it's mak/exec.mak
2. frame mode. support library build alonely.
3. build all ok in el5
4. build dynamic library ok in el6&el7
