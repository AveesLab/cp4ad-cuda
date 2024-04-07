#include <stdio.h>
#include <stdint.h>
#include <time.h>

int width = 224;
int height = 224;
int channel = 3;



__global__ void GrayKernel( uint8_t* Gray_Img, uint8_t* Color_Img, int width, int height, int channel) {
    int gy = blockIdx.y * blockDim.y + threadIdx.y;
    int gx = blockIdx.x * blockDim.x + threadIdx.x;

    if (gx < width && gy < height) {
        uint8_t Luminance = 0;

        int B_idx = gx + gy * height;
        int G_idx = gx + gy * height + width * height;
        int R_idx = gx + gy * height + width * height * 2;
        
        Luminance = Color_Img[R_idx] * 0.21 + Color_Img[G_idx] * 0.72 + Color_Img[B_idx] * 0.07;
        if (Luminance > 255) Luminance = 255;
        
        int G_idx = gx + gy * height;
        Gray_Img[G_idx] = Luminance;
    }
}

int main(void) {
    uint8_t Color_Img[width * height];
    uint8_t Gray_Img[width * height * channel];
    
    uint8_t* dev_Color_Img = NULL;
    uint8_t* dev_Gray_Img = NULL;

    // Step 1.  
    cudaMalloc( (void**)&dev_Color_Img, width * height * channel * sizeof(uint8_t) );
    cudaMalloc( (void**)&dev_Gray_Img, width * height * sizeof(uint8_t) );
    
    cudaMemcpy( dev_Color_Img, Color_Img, width * height * channel * sizeof(uint8_t), cudaMemcpyHostToDevice );

    dim3 dimBlock(32, 32, 1);
    dim3 dimGrid((width + dimBlock.x - 1)/ dimBlock.x, (height + dimBlock.y - 1) / dimBlock.y, 1);

    clock_t start = clock();
    GrayKernel<<<>>>;
    cudaDeviceSynchronize();
    clock_t end = clock();

    cudaMemcpy( dev_Gray_Img, Gray_Img, width * height * channel * sizeof(uint8_t), cudaMemcpyDeviceToHost );
	
    cudaFree( dev_Color_Img );
	cudaFree( dev_Gray_Img );
	
    double execution_time = (double)(end - start) / CLOCKS_PER_SEC;
    
	return 0;

}
