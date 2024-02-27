#include "common.c"

#define matsize 100

int main(void) {
    float matA[matsize * matsize];
    float matB[matsize * matsize];
    float matC[matsize * matsize];
	srand( 0 );
	setNormalizedRandomData( matA, matsize * matsize );
	setNormalizedRandomData( matB, matsize * matsize );
	clock_t start = clock();
	for (int row = 0; row < matsize; ++row) {
		for (int col = 0; col < matsize; ++col) {
			int i = row * matsize + col; 
			matC[i] = matA[i] + matB[i];
		}
	}
	clock_t end = clock();
    double execution_time = (double)(end - start) / CLOCKS_PER_SEC;
    printf("Execution time: %d usec\n", (int) (execution_time * 1000000));
	printf("matrix size = matsize * matsize = %d * %d\n", matsize, matsize);
	printMat( "matC", matC, matsize, matsize );
	printMat( "matA", matA, matsize, matsize );
	printMat( "matB", matB, matsize, matsize );
	return 0;
}
