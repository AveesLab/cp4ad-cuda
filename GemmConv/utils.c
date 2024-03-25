#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <stdbool.h>


void im2col(float *mat, float *new_mat, int matsize, int kernelsize, int in_channel) {
	for (int x = 0; x < (matsize - kernelsize / 2) * (matsize - kernelsize / 2); ++x) {
		int nrow = x / (matsize - kernelsize / 2);
		int ncol = x % (matsize - kernelsize / 2);
		for (int k_c = 0; k_c < in_channel; ++k_c) {
			for (int k_y = 0; k_y < kernelsize; ++k_y) {
				for (int k_x = 0; k_x < kernelsize; ++k_x) {
					int idx = k_c * matsize * matsize + k_y * matsize + k_x + nrow * matsize + ncol; // mat idx
					new_mat[x * kernelsize * kernelsize * in_channel + k_c * in_channel + k_y * kernelsize + k_x * kernelsize] = mat[idx];
				}
			}
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