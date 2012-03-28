#ifndef DEBUG_CUDA_H
#define DEBUG_CUDA_H

#include<cuda.h>

void checkCUDAError(const char *msg);
void print_vector(float *data, int n);
void print_vector(int *data, int n);
void print_matrix(float *data, int r, int c);
void print_matrix(int *data, int r, int c);

#endif
