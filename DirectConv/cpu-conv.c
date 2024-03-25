#include "utils.c"

int matsize = 32;
int kernelsize = 3;

int padding = 0;

int in_channel = 3;
int out_channel = 1;


int main(void) {
    float matA[matsize * matsize * in_channel];
    float matF[kernelsize * kernelsize * in_channel]; // Filter
    float matC[(matsize - (kernelsize - 1) + (2 * padding)) * (matsize - (kernelsize - 1) + (2 * padding)) * out_channel]; // Result
	srand( 0 );
	setNormalizedRandomData( matA, matsize * matsize * in_channel );
	setNormalizedRandomData( matF, kernelsize * kernelsize * in_channel );
	clock_t start = clock();
	for (int out_c = 0; out_c < out_channel; ++out_c) {
		for (int y = (kernelsize/2 - padding); y < (matsize - (kernelsize/2 - padding)); ++y) {
			for (int x = (kernelsize/2 - padding); x < (matsize - (kernelsize/2 - padding)); ++x) {
				float res = 0.0f;
				int indC = out_c * matsize * matsize + (y - (kernelsize/2 - padding)) * matsize + (x - (kernelsize/2 - padding));
				for (int in_c = 0; in_c < in_channel; ++in_c) {
					for (int k_y = -kernelsize/2; k_y < kernelsize/2 + 1; ++k_y) {
						for (int k_x = -kernelsize/2; k_x < kernelsize/2 + 1; ++k_x) {
							int indA = in_c * matsize * matsize + y * matsize + x + k_x + k_y * matsize;
							res += matA[indA];
						}
					}					
            	}
				matC[indC] = res;
			}
		}

	}
	clock_t end = clock();
    double execution_time = (double)(end - start) / CLOCKS_PER_SEC;
    printf("Execution time: %d usec\n", (int) (execution_time * 1000000));
	printf("Feature Map = matsize * matsize * channel = %d * %d * %d\n", (matsize - (kernelsize - 1) + (2 * padding)), (matsize - (kernelsize - 1) + (2 * padding)), in_channel);
	printMat( "matA", matA, matsize, matsize, in_channel );
	printMat( "Filter", matF, kernelsize, kernelsize, in_channel );
	printMat( "Feature Map", matC, matsize, matsize, out_channel );
	return 0;
}