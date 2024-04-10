#include <stdio.h>

#define N 256

__global__ void ReverseKernel(int *arr)
{
	__shared__ int temp[N];
	int idx = threadIdx.x;
	int idx_inv = N - idx - 1;
	temp[idx] = arr[idx];

	//__syncthreads();

	arr[idx] = temp[idx_inv];
}

int main(void)
{
	int h_arr[N], result_arr[N], comp_arr[N];

	for (int i = 0; i < N; i++)
	{
		h_arr[i] = i;
		comp_arr[i] = N - i - 1;
	}

	int *d_arr;
	cudaMalloc( (void**)&d_arr, N * sizeof(int) );

	cudaMemcpy( d_arr, h_arr, N * sizeof(int), cudaMemcpyHostToDevice );
	ReverseKernel<<<1, N>>>(d_arr);
	//cudaDeviceSynchronize();
	cudaMemcpy( result_arr, d_arr, N * sizeof(int), cudaMemcpyDeviceToHost );
	for (int i = 0; i < N; i++)
	{
		if (result_arr[i] != comp_arr[i]) 
		{
			printf("result_arr[%d] : %d\n", i, result_arr[i]);
			printf("comp_arr[%d] : %d\n", i, comp_arr[i]);
			printf("result_arr[%d] != comp_arr[%d]\n", i, i);
			printf("\n");
		}
	}
	
	cudaFree(d_arr);

	return 0;
}
