#include "utils.c"


int alpha = 1;
int beta = 1;
int matsize = 100; 


__global__ void kernelGEMM( float* C, float* A, float* B, int matsize, int alpha, int beta ) {
	int gy = blockDim.y * blockIdx.y + threadIdx.y;
	int gx = blockDim.x * blockIdx.x + threadIdx.x;
	if (gy < matsize && gx < matsize) {
		float sum = 0.0f;
		for (int k = 0; k < matsize; k++) {
			int idxA = gy * matsize + k;
			int idxB = k * matsize + gx;
			sum += A[idxA] * B[idxB];
		}
		int idxC = gy * matsize + gx;
		C[idxC] = alpha * sum + beta * C[idxC];
	}
}

int main(void) {
    float matA[matsize * matsize];
    float matB[matsize * matsize];
    float matC[matsize * matsize]; // = {0, 0, 0, 0, .....}
	// printMat( "Before_matC", matC, matsize, matsize );
	srand( 0 );
	setNormalizedRandomData( matA, matsize * matsize );
	setNormalizedRandomData( matB, matsize * matsize );
	float* dev_matA = NULL;
	float* dev_matB = NULL;
	float* dev_matC = NULL;
	// Write your code below. Hint1. Memory allocation to GPU
	cudaMalloc( (void**)&dev_matA, matsize * matsize * sizeof(float) );
	cudaMalloc( (void**)&dev_matB, matsize * matsize * sizeof(float) );
	cudaMalloc( (void**)&dev_matC, matsize * matsize * sizeof(float) );
	
	// Write your code below. Hint2 Memory Copy CPU to GPU
	cudaMemcpy( dev_matA, matA, matsize * matsize * sizeof(float), cudaMemcpyHostToDevice );
	cudaMemcpy( dev_matB, matB, matsize * matsize * sizeof(float), cudaMemcpyHostToDevice );

	dim3 dimBlock(32, 32, 1);
	dim3 dimGrid((matsize + dimBlock.x - 1) / dimBlock.x, (matsize + dimBlock.y - 1) / dimBlock.y, 1);
	clock_t start = clock();
	kernelGEMM <<< dimGrid, dimBlock>>>(dev_matC, dev_matA, dev_matB, matsize, alpha, beta );
	cudaDeviceSynchronize();
	clock_t end = clock();
	// Write your code below. Hint3. Memory Copy GPU to CPU
	cudaMemcpy( matC, dev_matC, matsize * matsize * sizeof(float), cudaMemcpyDeviceToHost );	
	// Write your code below. Hint4. Delete GPU's Memory
	cudaFree( dev_matA );
	cudaFree( dev_matB );
	cudaFree( dev_matC );
	double execution_time = (double)(end - start) / CLOCKS_PER_SEC;
    printf("Execution time: %d usec\n", (int) (execution_time * 1000000));
	printf("matrix size = matsize * matsize = %d * %d\n", matsize, matsize);
	printMat( "matA", matA, matsize, matsize );
	printMat( "matB", matB, matsize, matsize );
	printMat( "matC", matC, matsize, matsize );
	return 0;
}
