#include <stdio.h>

__global__ void SyncKernel(void) {
	printf("THREAD %d in Block (%d, %d)\n", threadIdx.x * blockDim.y + threadIdx.y, blockIdx.x, blockIdx.y);
}

int main(void)
{
	dim3 dimBlock(2, 2);
	dim3 dimGrid(2, 2);

	printf("CUDA kernel launch with (%d * %d) blocks of (%d * %d) threads\n", dimGrid.x, dimGrid.y, dimBlock.x, dimBlock.y);
	SyncKernel<<<dimGrid, dimBlock>>>();
	
	//cudaDeviceSynchronize();

	return 0;
}
