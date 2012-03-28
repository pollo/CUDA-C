#include <stdio.h>
#include <stdlib.h>

int main(void)
{
  int driverVersion, runtimeVersion;
  cudaDriverGetVersion(&driverVersion);
  cudaRuntimeGetVersion(&runtimeVersion);
  printf("driver version %d runtime version %d\n",
	 driverVersion, runtimeVersion);
  return 0;
}
