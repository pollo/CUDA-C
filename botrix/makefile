CC=cc
NVCC=nvcc --host-compilation=C

FLAGS=
CC_FLAGS = $(FLAGS) -pipe -Wall -Werror -fPIC
NVCC_FLAGS=  $(FLAGS) -Xcompiler -fPIC

LIBS=-lm -lc
CU_LIBS=-L/usr/local/cuda/lib64 -lcublas -lcudart
PY_LIBS=-L/usr/lib/python2.6

INCLUDE=-I./
CU_INCLUDE=-I/usr/local/cuda/include/
PY_INCLUDE=-I/usr/lib64/python2.6/site-packages/numpy/core/include/ -I/usr/include/python2.6/

libpycumats: botrixindex.o pybotrixindex.o
	$(NVCC) -shared botrixindex.o pybotrixindex.o -o pybotrixindex.so $(LIBS) $(CU_LIBS) $(PY_LIBS)

botrixindex.o: botrixindex.cu
	$(NVCC) -g -c botrixindex.cu $(INCLUDE) $(CU_INCLUDE) $(NVCC_FLAGS)

pybotrixindex.o: pybotrixindex.c
	$(NVCC) -g -c pybotrixindex.c $(INCLUDE) $(PY_INCLUDE) $(NVCC_FLAGS)

clean:
	rm -f *.o
	rm -f *.so
