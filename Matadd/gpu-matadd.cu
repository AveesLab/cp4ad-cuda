#include "utils.c"

int matsize = 100; 
 

__global__ void kernel_matadd( float* matC, float* matA, float* matB, int matsize ) {
	int col = blockIdx.x * blockDim.x + threadIdx.x; 
	int row = blockIdx.y * blockDim.y + threadIdx.y; 
	if (row < matsize && col < matsize) {
		int i = row * matsize + col; 
		matC[i] = matA[i] + matB[i];
	}
}

int main(void) {
    float matA[matsize * matsize];
    float matB[matsize * matsize];
    float matC[matsize * matsize];
	srand( 0 );
	setNormalizedRandomData( matA, matsize * matsize );
	setNormalizedRandomData( matB, matsize * matsize );
	float* dev_matA = NULL;
	float* dev_matB = NULL;
	float* dev_matC = NULL;
	cudaMalloc( (void**)&dev_matA, matsize * matsize * sizeof(float) );
	cudaMalloc( (void**)&dev_matB, matsize * matsize * sizeof(float) );
	cudaMalloc( (void**)&dev_matC, matsize * matsize * sizeof(float) );
	cudaMemcpy( dev_matA, matA, matsize * matsize * sizeof(float), cudaMemcpyHostToDevice );
	cudaMemcpy( dev_matB, matB, matsize * matsize * sizeof(float), cudaMemcpyHostToDevice );
	dim3 dimBlock(32, 32, 1);
	dim3 dimGrid((matsize + dimBlock.x - 1) / dimBlock.x, (matsize + dimBlock.y - 1) / dimBlock.y, 1);
	clock_t start = clock();
	kernel_matadd <<< dimGrid, dimBlock>>>( dev_matC, dev_matA, dev_matB, matsize );
	cudaDeviceSynchronize();
	clock_t end = clock();
	cudaMemcpy( matC, dev_matC, matsize * matsize * sizeof(float), cudaMemcpyDeviceToHost );
	cudaFree( dev_matA );
	cudaFree( dev_matB );
	cudaFree( dev_matC );
    double execution_time = (double)(end - start) / CLOCKS_PER_SEC;
    printf("Execution time: %d usec\n", (int) (execution_time * 1000000));
	printf("matrix size = nrow * ncol = %d * %d\n", matsize, matsize);
	printMat( "matC", matC, matsize, matsize );
	printMat( "matA", matA, matsize, matsize );
	printMat( "matB", matB, matsize, matsize );
	return 0;
}
