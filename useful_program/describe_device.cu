#include <stdio.h>
#include <cuda.h>


int main()
{
  int deviceCount;
  cudaGetDeviceCount(&deviceCount);
  printf("Numero di device disponibili   %d\n\n\n",deviceCount);
  int device;
  for (device = 0; device < deviceCount; ++device) 
  {
    cudaDeviceProp deviceProp;
    cudaGetDeviceProperties(&deviceProp, device);
    printf("Proprieta device %d:\n\n",device);
    int canMapHostMemory=deviceProp.canMapHostMemory;
    printf("Device can map host memory with cudaHostAlloc/cudaHostGetDevicePointer. %d\n", canMapHostMemory);
    int	clockRate=deviceProp.clockRate;
    printf("Clock frequency in kilohertz. %d\n", clockRate);
    int	computeMode=deviceProp.computeMode;
    printf ("Compute mode (See cudaComputeMode). %d\n",computeMode);
    int deviceOverlap=deviceProp.deviceOverlap;
    printf("Device can concurrently copy memory and execute a kernel. %d\n",deviceOverlap);
    int integrated=deviceProp.integrated;
    printf("Device is integrated as opposed to discrete. %d\n",integrated);
    int kernelExecTimeoutEnabled=deviceProp.kernelExecTimeoutEnabled;
    printf("Specified whether there is a run time limit on kernels. %d\n",kernelExecTimeoutEnabled);
    int major=deviceProp.major;
    printf("Major compute capability. %d\n",major);
    int	maxGridSize[3];
    maxGridSize[0]=deviceProp.maxGridSize[0];
    maxGridSize[1]=deviceProp.maxGridSize[1];
    maxGridSize[2]=deviceProp.maxGridSize[2];
    printf("Maximum size of each dimension of a grid. %d %d %d\n",maxGridSize[0],maxGridSize[1],maxGridSize[2]);
    int	maxThreadsDim[3];
    maxThreadsDim[0]=deviceProp.maxThreadsDim[0];
    maxThreadsDim[1]=deviceProp.maxThreadsDim[1];
    maxThreadsDim[2]=deviceProp.maxThreadsDim[2];
    printf("Maximum size of each dimension of a block. %d %d %d\n",maxThreadsDim[0],maxThreadsDim[1],maxThreadsDim[2]);
    int maxThreadsPerBlock=deviceProp.maxThreadsPerBlock;
    printf("Maximum number of threads per block. %d\n",maxThreadsPerBlock);
    size_t memPitch=deviceProp.memPitch;
    printf("Maximum pitch in bytes allowed by memory copies. %lu\n", (unsigned long) memPitch);
    int minor=deviceProp.minor;
    printf("Minor compute capability. %d\n",minor);
    int multiProcessorCount=deviceProp.multiProcessorCount;
    printf("Number of multiprocessors on device. %d\n",multiProcessorCount);
    char name[256];
    for (int i=0; i<256; i++)
      name[i]=deviceProp.name[i];
    printf ("ASCII string identifying device. %s\n",name);
    int	regsPerBlock=deviceProp.regsPerBlock;
    printf ("32-bit registers available per block %d\n",regsPerBlock);
    size_t sharedMemPerBlock=deviceProp.sharedMemPerBlock;
    printf ("Shared memory available per block in bytes. %lu\n", (unsigned long) sharedMemPerBlock);
    size_t textureAlignment=deviceProp.textureAlignment;
    printf ("Alignment requirement for textures. %lu\n", (unsigned long) textureAlignment);
    size_t totalConstMem=deviceProp.totalConstMem;
    printf ("Constant memory available on device in bytes. %lu\n", (unsigned long) totalConstMem);
    size_t totalGlobalMem=deviceProp.totalGlobalMem;
    printf ("Global memory available on device in bytes. %lu\n", (unsigned long) totalGlobalMem);
    int	warpSize=deviceProp.warpSize;
    printf ("Warp size in threads. %d\n", warpSize);
    printf("\n");
  } 
}
