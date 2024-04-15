#include "utils.cuh"
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <time.h>


// 각 스레드들은 컨볼루션을 할 애들을 배열에 적어줌
__global__ void im2col_kernel( uint8_t* dev_input, uint8_t* dev_col, int col_size, int width_in, int height_in, int width_out, int height_out, int in_channel, int out_channel, int padding, int stride, int kernel_size ) {
    int gx = blockIdx.x * blockDim.x + threadIdx.x; // 0 ~ col_size

    if (gx < width_out * height_out * out_channel) {
        int start_idx = gx * kernel_size * kernel_size * in_channel;
        int cx = gx % width_out;
        int cy = gx / width_out;
        for (int in_c = 0; in_c < in_channel; in_c++) {
            for (int dy = 0; dy < kernel_size; dy++) {
                for (int dx = 0; dx < kernel_size; dx++) {
                    dev_col[start_idx] = dev_input[width_in * height_in * in_c + width_in * (dy + cy) + (dx + cx)];
                    //printf("%d = %u\n", start_idx, dev_col[start_idx]);
                    start_idx++;
                }
            }
        }
		//printf("%d\n", start_idx);
    }
}


__global__ void GEMM_kernel( uint8_t* C, uint8_t* A, int8_t* B, int width_in, int width_out, int height_out, int output_size, int kernel_size, int in_channel ) {
	// Write your code below.
	int gx = blockIdx.x * blockDim.x + threadIdx.x; 
	if (gx < output_size) {
		int sum = 0;
        int start_idx = gx * 9;
		for (int k = 0; k < 9; ++k) {
			sum += A[start_idx+k] * B[k];
		}
		if (sum < 0) sum = 0;
		else if (sum > 255) sum = 255;
		C[gx] = sum;
	}
}


void im2col_gpu( uint8_t* input, uint8_t* col, int width_in, int height_in, int width_out, int height_out, int in_channel, int out_channel, int padding, int stride, int kernel_size ) {
    uint8_t* dev_input = NULL;
    uint8_t* dev_col = NULL;
    int col_size = kernel_size * kernel_size * in_channel * width_out * height_out * out_channel; 

    cudaMalloc( (void**)&dev_input, width_in * height_in * in_channel * sizeof(uint8_t) );
    cudaMalloc( (void**)&dev_col, col_size * sizeof(uint8_t) );
    cudaMemcpy( dev_input, input, width_in * height_in * in_channel * sizeof(uint8_t), cudaMemcpyHostToDevice );

    dim3 dimBlock(512, 1, 1); // 하나의 열로만 표현 하기 위해서 x축으로만 Thread 할당
    dim3 dimGrid((col_size + dimBlock.x -1) / dimBlock.x, 1, 1);

    im2col_kernel<<<dimGrid, dimBlock>>>(dev_input, dev_col, col_size, width_in, height_in, width_out, height_out, in_channel, out_channel, padding, stride, kernel_size);
    
    cudaDeviceSynchronize();
    
    cudaMemcpy( col, dev_col, col_size * sizeof(uint8_t), cudaMemcpyDeviceToHost );
    cudaFree( dev_input );
    cudaFree( dev_col );
}   


void gemm_gpu( uint8_t* input, uint8_t* output, int width_in, int height_in, int width_out, int height_out, int in_channel, int out_channel, int padding, int stride, int kernel_size ) {
    int8_t Filter[9] = {-1, 0, 1, -2, 0, 2, -1, 0, 1}; // 정답 확인을 위한 필터
    int col_size = kernel_size * kernel_size * in_channel * width_out * height_out * out_channel; 
    int output_size = width_out * height_out * out_channel;
	uint8_t* dev_input = NULL;
    int8_t* dev_Filter = NULL;
    uint8_t* dev_output = NULL;

    // Device(GPU) 메모리 할당 후 호스트 메모리에 있는 값을  Device(GPU) 메모리로 복사
    cudaMalloc( (void**)&dev_input, col_size * sizeof(uint8_t) ); // im2col 변환 된 input
    cudaMalloc( (void**)&dev_Filter, 9 * sizeof(int8_t) );
    cudaMalloc( (void**)&dev_output, width_out * height_out * out_channel * sizeof(uint8_t) );

    cudaMemcpy( dev_input, input, col_size * sizeof(uint8_t), cudaMemcpyHostToDevice );
    cudaMemcpy( dev_Filter, Filter, 9 * sizeof(int8_t), cudaMemcpyHostToDevice );

    dim3 dimBlock(512, 1, 1);
    dim3 dimGrid((col_size + dimBlock.x - 1)/ dimBlock.x, 1, 1);
    

    clock_t start = clock();
    GEMM_kernel<<<dimGrid, dimBlock>>>(dev_output, dev_input, dev_Filter, width_in, width_out, height_out, output_size, kernel_size, in_channel );
    cudaDeviceSynchronize();
    clock_t end = clock();
    cudaMemcpy( output, dev_output, width_out * height_out * out_channel * sizeof(uint8_t), cudaMemcpyDeviceToHost );

	cudaFree( dev_input );
	cudaFree( dev_Filter );
	cudaFree( dev_output );
    double execution_time = (double)(end - start) / CLOCKS_PER_SEC;
    printf("Execution time: %d usec\n", (int) (execution_time * 1000000));
}
