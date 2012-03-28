

#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <math.h>

void swap(float &a, float &b)
{
  float t;
  t=a;
  a=b;
  b=t;
}

int main(int argc, char **argv)
{
  timeval time;
  double t1, t2;
  long r,c;
  float *dati;
   
  //settaggio parametri
  if (argc<3)
  {
    printf("./a.out r c\n");
    exit(0);
  }
  sscanf(argv[1],"%ld",&r);
  sscanf(argv[2],"%ld",&c);
//   cout << r <<endl<< c<<endl;

  //allocazione
  dati = (float*) malloc (r*c*sizeof(float));
  
  //inizializzazione
  for (long i=0; i<r*c; i++)
    dati[i]=i;
  
  //stampa
//  for (long i=0; i<r; i++)
//  {
//    for (long j=0; j<c; j++)
//      printf("%7.2f",dati[i*c+j]);
//    printf("\n");
//  }

  //inizio cronometro
  gettimeofday(&time, NULL);
  t1=time.tv_sec+(time.tv_usec/1000000.0);
 
  //swap
  for (long i=0; i<r; i++)
    for (long j=0; j<c/2; j++)
      swap(dati[i*c+j],dati[(i+1)*c-j-1]);

  //stoppa cronometro
 
  gettimeofday(&time, NULL);
  t2=time.tv_sec+(time.tv_usec/1000000.0);
  printf("Tempo impiegato: %f\n",t2-t1);

 
  //stampa    
//  printf("\n");
//  for (long i=0; i<r; i++)
//  {
//    for (long j=0; j<c; j++)
//      printf("%7.2f",dati[i*c+j]);
//    printf("\n");
//  }

  return 0;
}
