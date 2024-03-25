#include "utils.c"


int matsize = 224;
int in_channel = 3;
int out_channel = 1;
int kernelsize = 3;
int padding = 0;


__global__ void kernel_gemmconv() {

}


int main(void) {
    float matA[matsize * matsize * in_channel];
    float matF[kernelsize * kernelsize * in_channel]; // Filter
    float matC[10]; // tmp
	srand( 0 );
	setNormalizedRandomData( matA, matsize * matsize * in_channel );
	setNormalizedRandomData( matF, kernelsize * kernelsize * in_channel );
    float new_matA = im2col();
    float new_matC = im2col();

    float* dev_matA = NULL;
    float* dev_matF = NULL;
    float* dev_matC = NULL;
    cudaMalloc( (void**)&dev_matA, matsize * matsize * in_channel * sizeof(float) );
    cudaMalloc( (void**)&dev_matF, kernelsize * kernelsize * in_channel * sizeof(float) );
    cudaMalloc( (void**)&dev_matA, (matsize - (kernelsize - 1) + (2 * padding)) * (matsize - (kernelsize - 1) + (2 * padding)) * out_channel * sizeof(float) );
    cudaMemcpy( dev_matA, matA, matsize * matsize * in_channel * sizeof(float), cudaMemcpyHostToDevice );
    cudaMemcpy( dev_matF, matF, kernelsize * kernelsize * in_channel * sizeof(float), cudaMemcpyHostToDevice );


    clock_t start = clock();
    
    cudaDeviceSynchronize();
    clock_t end = clock();
    cudaMemcpy( dev_matC, matC, (matsize - (kernelsize - 1) + (2 * padding)) * (matsize - (kernelsize - 1) + (2 * padding)) * out_channel * sizeof(float), cudaMemcpyDeviceToHost );
	cudaFree( dev_matA );
	cudaFree( dev_matF );
	cudaFree( dev_matC );
    double execution_time = (double)(end - start) / CLOCKS_PER_SEC;
    printf("Execution time: %d usec\n", (int) (execution_time * 1000000));
	printf("matrix size = nrow * ncol = %d * %d\n", matsize, matsize);
	printMat( "Feature Map", matC, matsize, matsize, out_channel );
	printMat( "matA", matA, matsize, matsize, in_channel );
	printMat( "matF", matF, matsize, matsize, in_channel );
	return 0;


}