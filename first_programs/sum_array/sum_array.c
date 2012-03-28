#include<stdio.h>
#include<stdlib.h>

const int VOLTE=1000;

int main(int argc, char** argv)
{
  int nblocks, nthreads;
  int n;
  float *a;
  float *b;
  sscanf(argv[1],"%d",&n);
  printf("n = %d\n",n);

  //allocation
  a=(float*) malloc(sizeof(float)*n);
  b=(float*) malloc(sizeof(float)*n);
 
 //initialization
  for (int i=0; i<n; i++)
  {
    a[i]=i+1;
    b[i]=n-i;
  }
 
   //run kernel
  for (int j=0; j<VOLTE; j++)
  {
    for (int i=0; i<n; i++)
      a[i]=a[i]+b[i];
  }
  //print results
  for (int i=0; i<n; i++)
    printf("%f ",a[i]);
  printf("\n");
}
