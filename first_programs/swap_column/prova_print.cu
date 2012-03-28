#include "cuPrintf.cu"
#include<cuda.h>

__global__ void testKernel(int val)
{
  cuPrintf("Value is: %d\n", threadIdx.x);
}

void checkCUDAError(const char *msg)
{
  cudaError_t err = cudaGetLastError();
  if( cudaSuccess != err) 
  {
    fprintf(stderr, "Cuda error: %s: %s.\n", msg, cudaGetErrorString( err) );
    exit(EXIT_FAILURE);
  }                         
}

int main()
{
  dim3 blocks;
  blocks.x=65535;
  blocks.y=65535;
  blocks.z=1;
  cudaPrintfInit();
  testKernel<<< blocks, 512 >>>(10);
  checkCUDAError("Kernel");
  cudaPrintfDisplay(stdout, true);
  cudaPrintfEnd();
  return 0;
}
