#include "utils.c"

int matsize = 224;
int in_channel = 3;
int out_channel = 1;
int kernelsize = 3;
int padding = 0;



int main(void) {
    float matA[matsize * matsize * in_channel];
    float matF[kernelsize * kernelsize * in_channel]; // Filter
    float matC[(matsize - kernelsize / 2) * (matsize - kernelsize / 2)];
	srand( 0 );
	setNormalizedRandomData( matA, matsize * matsize * in_channel );
	setNormalizedRandomData( matF, kernelsize * kernelsize * in_channel );
    float new_matA[kernelsize * kernelsize * in_channel * (matsize - kernelsize / 2) * (matsize - kernelsize / 2)];
    im2col( matA, new_matA, matsize, kernelsize, in_channel );
    clock_t start = clock();
    for (int y = 0; y < (matsize - kernelsize / 2) * (matsize - kernelsize / 2); ++y) {
        float ans = 0.0f;
        for (int x = 0; x < kernelsize * kernelsize * in_channel; ++x) {
            int indNewA = y * kernelsize * kernelsize * in_channel + x;
            ans += (matF[x] * new_matA[indNewA]); 
        }
        matC[y] = ans;
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