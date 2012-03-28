using namespace std;

#include "debug_cuda.h"
#include <iostream>
#include <cstdlib>

int main()
{
  int r,c, n;
  float *vect_h, *vect_d, *matr_h, *matr_d;
  

  n=100;
  r=20;
  c=5;

  vect_h =new float [n];
  matr_h =new float [r*c];
  cudaMalloc((void**) &vect_d, n*sizeof(float));
  cudaMalloc((void**) &matr_d, r*c*sizeof(float));
  checkCUDAError("Allocazione");

  //inizializzazione
  for (int i=0; i<n; i++)
    vect_h[i]=(float) i/(i+2)*100;
  for (int i=0; i<r*c; i++)
    matr_h[i]=(float) i/(i+2)*100;
  
  //stampa
  for (int i=0; i<n; i++)
  {
    cout << vect_h[i] << " ";
  }
  cout << endl;
  
  //stampa
  for (int i=0; i<r; i++)
  {
    for (int j=0; j<c; j++)
      cout << matr_h[i*c+j] << " ";
    cout << endl;
  }

  cout<<endl;
  cout<<endl;

  //trasferimento su device
  cudaMemcpy(vect_d,vect_h, sizeof(float)*n, cudaMemcpyHostToDevice);
  checkCUDAError("Trasferimento su device");
  cudaMemcpy(matr_d,matr_h, sizeof(float)*r*c, cudaMemcpyHostToDevice);
  checkCUDAError("Trasferimento su device");
  
  //stampa
  print_vector(vect_d,n);
  print_matrix(matr_d,r,c);
  return 0;
}
