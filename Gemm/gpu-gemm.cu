#include "utils.c"


int alpha = 1;
int beta = 1;
int matsize = 100; 


__global__ void kernelGEMM( float* C, float* A, float* B, int matsize, int alpha, int beta ) {
	// Write below code. //
	int gy = blockIdx.y * blockDim.y + threadIdx.y;
	int gx = blockIdx.x * blockDim.x + threadIdx.x;
	if (gy < matsize && gx < matsize) {
		float sum = 0.0f;
		for (int k = 0; k < matsize; ++k) {
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
    float matC[matsize * matsize];
	// printMat( "Before_matC", matC, matsize, matsize );
	srand( 0 );
	setNormalizedRandomData( matA, matsize * matsize );
	setNormalizedRandomData( matB, matsize * matsize );
	float* dev_matA = NULL;
	float* dev_matB = NULL;
	float* dev_matC = NULL;
	//Memory allocation to GPU
	cudaMalloc( (void**)&dev_matA, matsize * matsize * sizeof(float) );
	cudaMalloc( (void**)&dev_matB, matsize * matsize * sizeof(float) );
	cudaMalloc( (void**)&dev_matB, matsize * matsize * sizeof(float) );
	//Memory Copy CPU to GPU
	cudaMemcpy( dev_matA, matA, matsize * matsize * sizeof(float), cudaMemcpyHostToDevice );
	cudaMemcpy( dev_matB, matB, matsize * matsize * sizeof(float), cudaMemcpyHostToDevice );
	cudaMemcpy( dev_matC, matC, matsize * matsize * sizeof(float), cudaMemcpyHostToDevice );


	dim3 dimBlock(32, 32, 1);
	dim3 dimGrid((matsize + dimBlock.x - 1) / dimBlock.x, (matsize + dimBlock.y - 1) / dimBlock.y, 1);
	clock_t start = clock();
	kernelGEMM <<< dimGrid, dimBlock>>>(dev_matC, dev_matA, dev_matB, matsize, alpha, beta );
	cudaDeviceSynchronize();
	clock_t end = clock();
	//Memory Copy GPU to CPU
	cudaMemcpy( matC, dev_matC, matsize * matsize * sizeof(float), cudaMemcpyDeviceToHost );
	//Delete GPU's Memory
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
