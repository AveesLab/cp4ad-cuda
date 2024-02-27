#include "common.c"


int alpha = 1;
int beta = 1;
int matsize = 100; 


__global__ void kernelGEMM( float* C, float* A, float* B, int matsize, int alpha, int beta ) {
	//Matrix multiply concept with Matrix add
	int col = blockIdx.x * blockDim.x + threadIdx.x;
	int row = blockIdx.y * blockDim.y + threadIdx.y;


	{








	}
}

int main(void) {
    float matA[matsize * matsize];
    float matB[matsize * matsize];
    float matC[matsize * matsize];
	printMat( "Before_matC", matC, matsize, matsize );
	srand( 0 );
	setNormalizedRandomData( matA, matsize * matsize );
	setNormalizedRandomData( matB, matsize * matsize );
	float* dev_matA = NULL;
	float* dev_matB = NULL;
	float* dev_matC = NULL;
	//Memory allocation to GPU



	//Memory Copy CPU to GPU



	dim3 dimBlock(32, 32, 1);
	dim3 dimGrid((matsize + dimBlock.x - 1) / dimBlock.x, (matsize + dimBlock.y - 1) / dimBlock.y, 1);
	clock_t start = clock();
	kernelGEMM <<< dimGrid, dimBlock>>>(dev_matC, dev_matA, dev_matB, matsize, alpha, beta );
	cudaDeviceSynchronize();
	clock_t end = clock();
	//Memory Copy GPU to CPU

	//Delete GPU's Memory



	double execution_time = (double)(end - start) / CLOCKS_PER_SEC;
    printf("Execution time: %d usec\n", (int) (execution_time * 1000000));
	printf("matrix size = matsize * matsize = %d * %d\n", matsize, matsize);
	printMat( "matA", matA, matsize, matsize );
	printMat( "matB", matB, matsize, matsize );
	printMat( "After_matC", matC, matsize, matsize );
	return 0;
}
