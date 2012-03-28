/*
Simple program that add a vector tu another
*/

#include<cuda.h>
#include<stdio.h>
#include"cuPrintf.cu"

const int VOLTE=1000;

void checkCUDAerror(const char *mex);

__global__ void somma (float* a_d, float* b_d,  long n)
{
  int id;
  id=blockIdx.x*blockDim.x+threadIdx.x;
  if (id<n)
  {
    a_d[id]=a_d[id]+b_d[id];
//    cuPrintf("%f\n",c_d[id]); // cuPrintf("%f\n",a[id]);  cuPrintf("%f\n",b[id]);
  }
}

int main(int argc, char** argv)
{
  int nblocks, nthreads;
  int n;
  float *a;
  float *b;
   float *a_d;
  float *b_d;
  sscanf(argv[1],"%d",&n);
  printf("n = %d\n",n);

  //allocation
  a=(float*) malloc(sizeof(float)*n);
  b=(float*) malloc(sizeof(float)*n);
  cudaMalloc((void**) &a_d, n*sizeof(float));
  cudaMalloc((void**) &b_d, n*sizeof(float)); 
  checkCUDAerror("Allocation");

 //initialization
  for (int i=0; i<n; i++)
  {
    a[i]=i+1;
    b[i]=n-i;
  }
 
 //copy to device
  cudaMemcpy(a_d, a, sizeof(float)*n, cudaMemcpyHostToDevice);
  cudaMemcpy(b_d, b, sizeof(float)*n, cudaMemcpyHostToDevice);
  checkCUDAerror("Copy to device");
 
  //set dimensions blocks and grid
  nthreads=512;
  nblocks=n/nthreads+(n%nthreads==0?0:1);
  printf("nblocks = %d\nnthreads = %d\n",nblocks, nthreads);
 
  //cudaPrintfInit();
  //run kernel
  for (int i=0; i<VOLTE; i++)
  {
    somma <<< nblocks, nthreads >>> (a_d, b_d, n);
    checkCUDAerror("Kernel");
  }
  //cudaPrintfDisplay(stdout, true);

  //copy from device  
  cudaMemcpy(a, a_d, sizeof(float)*n, cudaMemcpyDeviceToHost);
  checkCUDAerror("Copy from device");

  //print results
  for (int i=0; i<n; i++)
    printf("%f ",a[i]);
  printf("\n");
}

void checkCUDAerror(const char *mex)
{
  cudaError_t err = cudaGetLastError();
  if (cudaSuccess != err)
  {
    fprintf(stderr, "Cuda error: %s: %s.\n", mex, cudaGetErrorString( err ) );
    exit(EXIT_FAILURE);
  }
}
