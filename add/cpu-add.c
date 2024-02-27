#include "common.c"

#define Size 5

int main(void) {
	int a[Size] = { 1, 2, 3, 4, 5 };
	int b[Size] = { 10, 20, 30, 40, 50 };
	int c[Size] = { 0 };
	clock_t start = clock();
	for (int i = 0; i < Size; ++i) {
		c[i] = a[i] + b[i];
	}
	clock_t end = clock();
    double execution_time = (double)(end - start) / CLOCKS_PER_SEC;
    printf("Execution time: %d usec\n", (int) (execution_time * 1000000));
	printf("{%d,%d,%d,%d,%d} + {%d,%d,%d,%d,%d} = {%d,%d,%d,%d,%d}\n",
	       a[0], a[1], a[2], a[3], a[4],
	       b[0], b[1], b[2], b[3], b[4],
	       c[0], c[1], c[2], c[3], c[4]);
	return 0;
}