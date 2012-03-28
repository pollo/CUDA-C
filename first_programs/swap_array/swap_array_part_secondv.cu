/*
  Swap the elements of a vector: the first with the last and so on...
*/

#include<cuda.h>
#include<stdlib.h>
#include<stdio.h>
#include<sys/time.h>

void checkCUDAError(const char* msg);

__global__ void rebalta (float *dati, int n)
{
  int id;
  int t;
  id=blockIdx.x*blockDim.x+threadIdx.x;
  t=dati[n-id-1];
  dati[n-id-1]=dati[id];
  dati[id]=t; 
}

__global__ void last_rebalta (float *dati, int n, int blockid, int blockdim)
{
  int id;
  int t;
  id=blockid*blockdim+threadIdx.x;
  t=dati[n-id-1];
  dati[n-id-1]=dati[id];
  dati[id]=t; 
}



int main(int argc, char **argv)
{
  int n;
  int i;
  timeval time;
  double t1, t2;
  float *dati_h;
  float *dati_d;
   int blocksize, nblocks;
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
  sscanf(argv[1],"%d",&n);
  blocksize=512;
  nblocks=(n/2)/blocksize;
  printf ("prima volta\n");
  printf ("numero blocchi %d\n", nblocks);
  printf ("numero threads %d\n", blocksize);
  printf ("seconda volta\n");
  printf ("numero blocchi %d\n", 1);
  printf ("numero threads %d\n", (n/2)%blocksize);
  

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
  if (nblocks>0 && blocksize>0)
    rebalta <<< nblocks, blocksize >>> (dati_d, n);
  checkCUDAError("Kernel");
  if ((n/2)%blocksize>0)
    last_rebalta <<< 1, (n/2)%blocksize >>> (dati_d, n, nblocks, blocksize);
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
    fprintf(stderr, "Cuda error: %s: %s.\n", msg, cudaGetErrorString( err) );
    exit(EXIT_FAILURE);
  }                         
}
