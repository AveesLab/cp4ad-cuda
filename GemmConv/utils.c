#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <stdbool.h>


void im2col(float *mat, int matsize, int kernelsize, int in_channel, int out_channel, bool isFeatureMap) {
	if (isFeatureMap) {
		float new_mat[(matsize-(kernelsize/2)) * (matsize-(kernelsize/2)) * kernelsize * kernelsize * in_channel];
		int i;


		
		for (int dy = 0; dy < kernelsize; ++dy)
			for (int dx = 0; dx < kernelsize; ++dx) {
				int indNew = dy * (matsize-(kernelsize/2)) * (matsize-(kernelsize/2)) + dx;
				new_mat[indNew] = mat[i];
			}

		return new_mat;
	}
	float new_filter[kernelsize * kernelsize * in_channel];
	

	return new_filter;
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