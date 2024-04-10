#include "utils.cuh"
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <time.h>

__global__ void GrayKernel( uint8_t* dev_Color_Img, uint8_t* dev_Gray_Img, int width, int height) {
    int gy = blockIdx.y * blockDim.y + threadIdx.y;
    int gx = blockIdx.x * blockDim.x + threadIdx.x;

    if (gx < width && gy < height) {
        uint8_t Luminance = 0;

        int B_idx = gx + gy * width;
        int G_idx = gx + gy * width + width * height;
        int R_idx = gx + gy * width + width * height * 2;
        
        Luminance = dev_Color_Img[R_idx] * 0.21 + dev_Color_Img[G_idx] * 0.72 + dev_Color_Img[B_idx] * 0.07;

        if (Luminance > 255) Luminance = 255;
        
        int Gray_idx = gx + gy * width;
        dev_Gray_Img[Gray_idx] = Luminance;
    }
}

void Color2Gray(uint8_t* Color_Img, uint8_t* Gray_Img, int width, int height) {
	
    uint8_t* dev_Color_Img = NULL;
    uint8_t* dev_Gray_Img = NULL;
  
    cudaMalloc( (void**)&dev_Color_Img, width * height * 3 * sizeof(uint8_t) );
    cudaMalloc( (void**)&dev_Gray_Img, width * height * sizeof(uint8_t) );
    
    cudaMemcpy( dev_Color_Img, Color_Img, width * height * 3 * sizeof(uint8_t), cudaMemcpyHostToDevice );

    dim3 dimBlock(32, 32, 1);
    dim3 dimGrid((width + dimBlock.x - 1)/ dimBlock.x, (height + dimBlock.y - 1) / dimBlock.y, 1);
	
	clock_t start = clock();
    GrayKernel<<<dimGrid, dimBlock>>>(dev_Color_Img, dev_Gray_Img, width, height);
	clock_t end = clock();
	cudaDeviceSynchronize();

    cudaMemcpy( Gray_Img, dev_Gray_Img, width * height * sizeof(uint8_t), cudaMemcpyDeviceToHost );
	
    cudaFree( dev_Color_Img );
	cudaFree( dev_Gray_Img );
	
	double execution_time = (double) (end - start) / CLOCKS_PER_SEC;
	printf("Execution time: %d usec\n", (int) (execution_time * 1000000));
}
