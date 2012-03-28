using namespace std;

#include <iostream>
#include <stdio.h>
#include <cuda.h>
#include <stdlib.h>
#include <sys/time.h>
#include <math.h>
#include "cuPrintf.cu"

const long MAX_THREADS = 512;
const long MAX_BLOCK= 65535;

void checkCUDAError(const char* msg);

__global__ void swap(float* dati, long n, long c)
{
  long id;
  float t;
  id=(blockIdx.y*gridDim.x+blockIdx.x)*blockDim.x+threadIdx.x;
//  cuPrintf("Id: %ld\n", id);  
  if (id<n/2)
  {
//isorgente=id/(c/2)
//jsorgente=id%(c/2)
//idsorgente=isorgente*c+jsorgente
//idsorgenteesteso=(id/(c/2))/*is*/*c+ (id%(c/2))/*js*/)
//idtarget=idsorgente+(c-(idsorgete%c)*2-1)
//idtargetesteso=((id/(c/2))/*is*/*c+ (id%(c/2))/*js*/)/*ids*/+(c-( ((id/(c/2))/*is*/*c+ (id%(c/2))/*js*/)/*ids*/%c)*2-1)
//    cuPrintf("isorgente: %ld\n",id/(c/2));
//    cuPrintf("jsorgente: %ld\n",id%(c/2));
//    cuPrintf("idsorgente: %ld\n",(id/(c/2))/*is*/*c+ (id%(c/2))/*js*/);
//    cuPrintf("idtarget: %ld\n", ((id/(c/2))/*is*/*c+ (id%(c/2))/*js*/)/*ids*/+(c-( ((id/(c/2))/*is*/*c+ (id%(c/2))/*js*/)/*ids*/%c)*2-1));
    t=dati[(id/(c/2))*c+ (id%(c/2))];
    dati[(id/(c/2))*c+ (id%(c/2))]= dati[((id/(c/2))*c+ (id%(c/2)))+(c-( ((id/(c/2))*c+ (id%(c/2)))%c)*2-1)];
    dati[((id/(c/2))*c+ (id%(c/2)))+(c-( ((id/(c/2))*c+ (id%(c/2)))%c)*2-1)]=t;
  }
}

int main(int argc, char **argv)
{
  timeval time;
  double t1, t2;
  long r,c;
  float *dati_h, *dati_d;
  long int n_threads, n_blocks;
  int dim_blocks;
  dim3 dim_grid;
 
  //settaggio parametri
  if (argc<3)
  {
    printf("./a.out r c\n");
    exit(0);
  }
  sscanf(argv[1],"%ld",&r);
  sscanf(argv[2],"%ld",&c);
//   cout << r <<endl<< c<<endl;
  n_threads=r*(c/2);
  if (n_threads>MAX_BLOCK*MAX_BLOCK*MAX_THREADS)
  {
    printf("Troppi threads!\n");
    exit(0);
  }
  dim_blocks=MAX_THREADS;
  n_blocks=n_threads/MAX_THREADS+(n_threads%MAX_THREADS==0?0:1);

//  cout << "Numero di threads " << n_threads << endl;    
//  cout << "Numero di blocchi " << n_blocks << endl;

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

  //allocazione
  dati_h = (float*) malloc (r*c*sizeof(float));
  cudaMalloc((void**) &dati_d, r*c*sizeof(float));
  checkCUDAError("Allocazione");

  //inizializzazione
  for (long i=0; i<r*c; i++)
    dati_h[i]=i;
  
  //stampa
//  for (long i=0; i<r; i++)
//  {
//    for (long j=0; j<c; j++)
//      printf("%7.2f",dati_h[i*c+j]);
//    printf("\n");
//  }

  //trasferimento su device
  cudaMemcpy(dati_d,dati_h, sizeof(float)*r*c, cudaMemcpyHostToDevice);
  checkCUDAError("Trasferimento su device");

  //inizio cronometro
  cudaThreadSynchronize();
  gettimeofday(&time, NULL);
  t1=time.tv_sec+(time.tv_usec/1000000.0);
 
  //lancio kernel
  cudaPrintfInit();
  swap <<< dim_grid, dim_blocks >>>(dati_d, (r*c), c);
  cudaPrintfDisplay(stdout, true);
  checkCUDAError("Kernel");

  //stoppa cronometro
  cudaThreadSynchronize();
  gettimeofday(&time, NULL);
  t2=time.tv_sec+(time.tv_usec/1000000.0);
  printf("Tempo impiegato: %f\n",t2-t1);

  //trasferimento da device
  cudaMemcpy(dati_h,dati_d, sizeof(float)*r*c, cudaMemcpyDeviceToHost);
  checkCUDAError("Trasferimento da device");

  //stampa    
//  printf("\n");
//  for (long i=0; i<r; i++)
//  {
//    for (long j=0; j<c; j++)
//      printf("%7.2f",dati_h[i*c+j]);
//    printf("\n");
//  }
  

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


