#include <stdio.h>
#include <stdlib.h>
#include <time.h>


void im2col(float *mat, float *new_mat, int matsize, int kernelsize, int in_channel) {
	for (int x = 0; x < (matsize - kernelsize / 2) * (matsize - kernelsize / 2); ++x) {
		int nrow = x / (matsize - kernelsize / 2);
		int ncol = x % (matsize - kernelsize / 2);
		int start_idx = nrow * matsize + ncol;
		for (int y = 0; y < kernelsize * kernelsize * in_channel; ++y) {
			int u = y % kernelsize;
			int v = y / kernelsize;
			int w = (y / kernelsize) % kernelsize;
			new_mat[x * (matsize - kernelsize / 2) * (matsize - kernelsize / 2) + y] = mat[start_idx + w * matsize * matsize + v * matsize + u];
		}
	}
}



void setNormalizedRandomData(float *mat, int size) {
    for (int i = 0; i < size; ++i) {
        mat[i] = (float)rand() / (float)RAND_MAX;
    }
}

void printMat( const char* name, float* mat, int nrow, int ncol, int nchannel) {
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