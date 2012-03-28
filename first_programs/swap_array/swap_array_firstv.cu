/*
  Swap the elements of a vector: the first with the last and so on...
*/

#include <stdio.h>
#include <cuda.h>
#include <stdlib.h>
#include <sys/time.h>

void checkCUDAError(const char* msg);

__global__ void rebalta (float *dati,  long n)
{
  long id;
  long t;
  id=blockIdx.x*blockDim.x+threadIdx.x;
  if (id<n/2)
  {
    t=dati[n-id-1];
    dati[n-id-1]=dati[id];
    dati[id]=t; 
  }
}

int main(int argc, char **argv)
{
  long n;
  long i;
  timeval time;
  double t1, t2;
  float *dati_h;
  float *dati_d;
  long blocksize, nblocks;
  srand(1);

  //inizio cronometro
  gettimeofday(&time, NULL);
  t1=time.tv_sec+(time.tv_usec/1000000.0);
 
  //settaggio parametri
  if (argc<2)
  {
    printf("./a.out n\n");
    exit(0);
  }
  sscanf(argv[1],"%ld",&n);
  blocksize=512;
  nblocks=(n/2)/blocksize + ((n/2)%blocksize == 0?0:1);
  printf ("numero blocchi %ld\n", nblocks);
  printf ("numero threads %ld\n", blocksize);

  //allocazione
  dati_h=(float *) malloc (n*sizeof(float));
  cudaMalloc((void**) &dati_d, n*sizeof(float));
  checkCUDAError("Allocazione");

  //inizializzazione
  for (i=0; i<n; i++)
    dati_h[i]=(rand()%100000)/1000.0;

//  for (i=0; i<n; i++)
//    printf("%f ",dati_h[i]);
//  printf("\n");
  
  //trasferimento su device
  cudaMemcpy(dati_d,dati_h, sizeof(float)*n, cudaMemcpyHostToDevice);
  checkCUDAError("Trasferimento su device");
  
  //lancio kernel
  rebalta <<< nblocks, blocksize >>> (dati_d, n);
  checkCUDAError("Kernel");

  //trasferimento da device
  cudaMemcpy(dati_h,dati_d, sizeof(float)*n, cudaMemcpyDeviceToHost);
  checkCUDAError("Trasferimento da device");
  
  //stoppa cronometro
  cudaThreadSynchronize();
  gettimeofday(&time, NULL);
  t2=time.tv_sec+(time.tv_usec/1000000.0);
  printf("Tempo impiegato: %f\n",t2-t1);

//  for (i=0; i<n; i++)
//    printf("%f ",dati_h[i]);
//  printf("\n");
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
