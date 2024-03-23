#include <stdio.h>
#include <stdlib.h>
#include <time.h>


void setNormalizedRandomData(float *mat, int size) {
    for (int i = 0; i < size; ++i) {
        mat[i] = (float)rand() / (float)RAND_MAX;
    }
}

void printMat( const char* name, float* mat, int nrow, int ncol ) {
	int c = ncol;
#define M(row,col) mat[(row)*ncol+(col)]
	printf("%s=[", name);
	printf("\t%8f %8f %8f ... %8f %8f %8f\n", M(0, 0), M(0, 1), M(0, 2), M(0, c - 3), M(0, c - 2), M(0, c - 1));
	printf("\t%8f %8f %8f ... %8f %8f %8f\n", M(1, 0), M(1, 1), M(1, 2), M(1, c - 3), M(1, c - 2), M(1, c - 1));
	printf("\t%8f %8f %8f ... %8f %8f %8f\n", M(2, 0), M(2, 1), M(2, 2), M(2, c - 3), M(2, c - 2), M(2, c - 1));
	printf("\t........ ........ ........ ... ........ ........ ........\n");
	int r = nrow - 3;
	printf("\t%8f %8f %8f ... %8f %8f %8f\n", M(r, 0), M(r, 1), M(r, 2), M(r, c - 3), M(r, c - 2), M(r, c - 1));
	r = nrow - 2;
	printf("\t%8f %8f %8f ... %8f %8f %8f\n", M(r, 0), M(r, 1), M(r, 2), M(r, c - 3), M(r, c - 2), M(r, c - 1));
	r = nrow - 1;
	printf("\t%8f %8f %8f ... %8f %8f %8f ]\n", M(r, 0), M(r, 1), M(r, 2), M(r, c - 3), M(r, c - 2), M(r, c - 1));
#undef M
}


