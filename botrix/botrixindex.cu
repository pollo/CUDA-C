using namespace std;

#include <iostream>
#include <stdio.h>
#include <cuda.h>
#include <stdlib.h>
#include <sys/time.h>
#include <math.h>
#include <fstream>
//#include "cuPrintf.cu"

#define B0 -2.647866f
#define B1 -0.374927f
#define B2 0.061601f
#define B3 -0.001511f

const long MAX_THREADS = 512;
const long MAX_BLOCK= 65535;

extern "C" void botrix_index (float *tempday_h, float* precday_h, int n, float* output);
extern "C" void init ();
void checkCUDAError(const char* msg);

__global__ void calculate_index(float* tempday, float* precday, int n)
{
  int id;
  float x, y;
  id=(blockIdx.y*gridDim.x+blockIdx.x)*blockDim.x+threadIdx.x;
  x=tempday[id];
  y=precday[id];
  if (id<n)
  {
    if (x!=-9999 && y!=-9999)
    {
      if (y>=4 && x<40)
      {
	if (x<12)
	  x=12;
	if (x>32)
	  x=32;
	tempday[id]=powf(M_E,(B0+(B1*y)+(B2*y*x)+(B3*y*(x*x)))) / (1+powf(M_E,(B0+(B1*y)+(B2*y*x)+(B3*y*(x*x)))));
    
      }
      else
	tempday[id]=0;
    }
    else
      tempday[id]=-9999;
  }
}

void init()
{
  cudaSetDevice(0);
}

void botrix_index(float *tempday_h, float* precday_h, int n, float* output)
{
  float *tempday_d, *precday_d;
  long n_threads;
  int n_blocks;
  int dim_blocks;
  dim3 dim_grid;

  //selezione device da utilizzare
//  cudaSetDevice(0);

  //settaggio parametri
  n_threads=n;
  if (n_threads>MAX_BLOCK*MAX_BLOCK*MAX_THREADS)
  {
    printf("Troppi threads!\n");
    exit(0);
  }
  dim_blocks=MAX_THREADS;
  n_blocks=n_threads/MAX_THREADS+(n_threads%MAX_THREADS==0?0:1);
  if (n_blocks<=MAX_BLOCK)
  {
    dim_grid.x=n_blocks;
    dim_grid.y=1;
    dim_grid.z=1;
  }
  else
  {
    dim_grid.x=(unsigned int) ceil(sqrt(n_blocks));
    dim_grid.y=(unsigned int) ceil(sqrt(n_blocks));
    dim_grid.z=1;
  }
  printf("Numero threads per blocco: %d\n",dim_blocks);
  printf("Dimensioni grid: x %d,  y %d\n",dim_grid.x,dim_grid.y);

  //stampa input
//  cout << "tempday\n";
//  for (int i=0; i<n; i++)
//  {
//    cout<<tempday_h[i]<<" ";
//  }
//  cout << endl;
//  cout << "precday\n";
//  for (int i=0; i<n; i++)
//  {
//    cout<<precday_h[i]<<" ";
//  }
//  cout << endl;

  //allocazione
  cudaMalloc((void**) &precday_d, n*sizeof(float));
  cudaMalloc((void**) &tempday_d, n*sizeof(float));
  checkCUDAError("Allocazione");

  //trasferimento su device
  cudaMemcpy(tempday_d,tempday_h, sizeof(float)*n, cudaMemcpyHostToDevice);
  cudaMemcpy(precday_d,precday_h, sizeof(float)*n, cudaMemcpyHostToDevice);
  checkCUDAError("Trasferimento su device");
 
  //lancio kernel
  //cudaPrintfInit();
  calculate_index <<< dim_grid, dim_blocks >>>(tempday_d, precday_d, n);
  //cudaPrintfDisplay(stdout, true);
  checkCUDAError("Kernel");

  //trasferimento da device
  cudaMemcpy(output,tempday_d, sizeof(float)*n, cudaMemcpyDeviceToHost);
  checkCUDAError("Trasferimento da device");

//  cout << "output\n";
//  for (int i=0; i<n; i++)
//  {
//    cout<<output[i]<<" ";
//  }
//  cout << endl;

  //deallocazione
  cudaFree(precday_d);
  cudaFree(tempday_d);
}

int main(int argc, char **argv)
{
  fstream tempday, precday;
  int n;
  float *tempday_h, *precday_h, *output;

  //lettura parametri
  if (argc<3)
  {
    printf("./a.out tempday.txt precday.txt lunghezza\n");
    exit(0);
  }
  tempday.open(argv[1],ios::in);
  precday.open(argv[2],ios::in);
  sscanf(argv[3],"%d",&n);

  //allocazione
  precday_h = (float*) malloc (n*sizeof(float));
  tempday_h = (float*) malloc (n*sizeof(float));
  output = (float*) malloc (n*sizeof(float));
  checkCUDAError("Allocazione");

  //inizializzazione
  for (int i=0; i<n; i++)
  {
    tempday >> tempday_h[i];
    precday >> precday_h[i];
  }

  botrix_index(tempday_h,precday_h,n,output);

  //stampa
  cout << "Risultato botrite:\n";
  for (int i=0; i<n; i++)
  {
    cout<<output[i]<<" ";
  }

  //deallocazione
  free(precday_h);
  free(tempday_h);
  return 0;
}


void checkCUDAError(const char *msg)
{
    cudaError_t err = cudaGetLastError();
    if( cudaSuccess != err) 
    {
        fprintf(stderr, "Cuda error: %s: %s.\n", msg, 
                                  cudaGetErrorString( err) );
        exit(EXIT_FAILURE);
    }                         
}


