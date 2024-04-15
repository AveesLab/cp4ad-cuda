#include "utils.cuh"
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <time.h>


__global__ void conv_kernel( uint8_t* dev_input, uint8_t* dev_output, int8_t* FILTER, int width_in, int height_in, int width_out, int height_out, int in_channel, int out_channel, int padding, int stride, int kernel_size ) {
    int gy = blockIdx.y * blockDim.y + threadIdx.y; 
    int gx = blockIdx.x * blockDim.x + threadIdx.x;

    if (gx < width_out && gy < height_out) {
        int sum = 0;
        int cx = stride * gx + (kernel_size / 2);
        int cy = stride * gy + (kernel_size / 2);
        for (int dy = -(kernel_size / 2); dy <= (kernel_size / 2); dy++) {
            for (int dx = -(kernel_size / 2); dx <= (kernel_size / 2); dx++) {
                sum += (dev_input[width_in * (cy + dy) + (cx + dx)] * FILTER[kernel_size * ((kernel_size / 2) + dy) + (kernel_size / 2) + dx]);
            }
        }
        if (sum < 0) sum = 0;
        else if (sum > 255) sum = 255;
        int out_idx = gx + gy * width_out;
        dev_output[out_idx] = sum;
    }
}

void conv_gpu(uint8_t* input, uint8_t* output, int width_in, int height_in, int width_out, int height_out, int in_channel, int out_channel, int padding, int stride, int kernel_size) {
	int8_t Filter[9] = {-1, 0, 1, -2, 0, 2, -1, 0, 1};

    uint8_t* dev_input = NULL;
    uint8_t* dev_output = NULL;
	int8_t* dev_Filter = NULL;
  
    cudaMalloc( (void**)&dev_input, width_in * height_in * in_channel * sizeof(uint8_t) );
    cudaMalloc( (void**)&dev_output, width_out * height_out * out_channel * sizeof(uint8_t) );
    
	cudaMalloc( (void**)&dev_Filter, 9 * sizeof(int8_t) );
    cudaMemcpy( dev_input, input, width_in * height_in * in_channel * sizeof(uint8_t), cudaMemcpyHostToDevice );
	
	cudaMemcpy( dev_Filter, Filter, 9 * sizeof(int8_t), cudaMemcpyHostToDevice );

    dim3 dimBlock(32, 32, 1);
    dim3 dimGrid((width_out + dimBlock.x - 1)/ dimBlock.x, (height_out + dimBlock.y - 1) / dimBlock.y, 1);
	
	clock_t start = clock();
    conv_kernel<<<dimGrid, dimBlock>>>(dev_input, dev_output, dev_Filter, width_in, height_in, width_out, height_out, in_channel, out_channel, padding, stride, kernel_size);
	cudaDeviceSynchronize();
	clock_t end = clock();

    cudaMemcpy( output, dev_output, width_out * height_out * out_channel * sizeof(uint8_t), cudaMemcpyDeviceToHost );
	
    cudaFree( dev_input );
	cudaFree( dev_Filter );
	cudaFree( dev_output );
	
	double execution_time = (double) (end - start) / CLOCKS_PER_SEC;
	printf("Execution time: %d usec\n", (int) (execution_time * 1000000));
}
