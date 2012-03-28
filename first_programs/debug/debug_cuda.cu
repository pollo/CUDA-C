using namespace std;

#include "debug_cuda.h"
#include <iostream>
#include <cstdlib>
#include <iomanip>

void checkCUDAError(const char *msg)
{
    cudaError_t err = cudaGetLastError();
    if( cudaSuccess != err) 
    {
      cerr << "Cuda error: "<<msg<<": "<<cudaGetErrorString(err)<<".\n";
      exit(1);
    }                         
}

void print_vector(float *data, int n)
{
  float *temp;
  temp=new float [n];
  cudaMemcpy(temp,data, sizeof(float)*n, cudaMemcpyDeviceToHost);
  checkCUDAError("DEBUG Download data");
  for (int i=0; i<n; i++)
   cout << temp[i] << " ";
  cout << endl;
  delete [] temp;
}

void print_vector(int *data, int n)
{
  int *temp;
  temp=new int [n];
  cudaMemcpy(temp,data, sizeof(int)*n, cudaMemcpyDeviceToHost);
  checkCUDAError("DEBUG Download data");
  for (int i=0; i<n; i++)
    cout << temp[i] << " ";
  cout << endl;
  delete [] temp;
}

void print_matrix(float *data, int r, int c)
{
  float *temp;
  temp=new float [r*c];
  cudaMemcpy(temp,data, sizeof(float)*r*c, cudaMemcpyDeviceToHost);
  checkCUDAError("DEBUG Download data");
  for (int i=0; i<r; i++)
  {
    for (int j=0; j<c; j++)
      cout << setw(10) << temp [i*c+j];
    cout << endl;
  }
  delete [] temp;
}
 
void print_matrix(int *data, int r, int c)
{
  int *temp;
  temp=new int [r*c];
  cudaMemcpy(temp,data, sizeof(int)*r*c, cudaMemcpyDeviceToHost);
  checkCUDAError("DEBUG Download data");
  for (int i=0; i<r; i++)
  {
    for (int j=0; j<c; j++)
      cout << setw(15) << temp [i*c+j];
    cout << endl;
  }
  delete [] temp;
}
 
