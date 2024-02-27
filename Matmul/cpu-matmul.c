#include "common.c"

#define matsize 100

int main(void) {
    float matA[matsize * matsize];
    float matB[matsize * matsize];
    float matC[matsize * matsize];
    srand(0);
    setNormalizedRandomData(matA, matsize * matsize);
    setNormalizedRandomData(matB, matsize * matsize);
    clock_t start = clock();
    for (int y = 0; y < matsize; ++y) {
        for (int x = 0; x < matsize; ++x) {
            int indC = y * matsize + x;
            float ans = 0.0f;
            for (int k = 0; k < matsize; ++k) {
                int indA = y * matsize + k;
                int indB = k * matsize + x;
                ans += matA[indA] * matB[indB];
            }
            matC[indC] = ans;
        }
    }
    clock_t end = clock();
    double execution_time = (double)(end - start) / CLOCKS_PER_SEC;
    printf("Execution time: %d usec\n", (int) (execution_time * 1000000));
    printf("matrix size = matsize * matsize = %d * %d\n", matsize, matsize);
    printMat("matC", matC, matsize, matsize);
    printMat("matA", matA, matsize, matsize);
    printMat("matB", matB, matsize, matsize);
    return 0;
}