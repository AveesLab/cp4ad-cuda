#include <stdio.h>
#include <stdint.h>
#include <time.h>



int main(void) { 
	int width = 224;
	int height = 224;
	int channel = 3;
    uint8_t Color_Img[width * height * channel];
    uint8_t Gray_Img[width * height];

    clock_t start = clock();
    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
			uint8_t Luminance = 0;

            int B_idx = x + y * width;
            int G_idx = x + y * width + width * height;
            int R_idx = x + y * width + width * height * 2;
            
            Luminance = Color_Img[R_idx] * 0.21 + Color_Img[G_idx] * 0.72 + Color_Img[B_idx] * 0.07;

            if (Luminance > 255)
				Luminance = 255;

            int Gray_idx = x + y * width;
            Gray_Img[Gray_idx] = Luminance;
        }
    }
    clock_t end = clock();

    double execution_time = (double)(end - start) / CLOCKS_PER_SEC;
    printf("Execution time: %d usec\n", (int) (execution_time * 1000000));
//    test();
	// Show_Image(Color_Img);
   // Show_Image(Gray_Img);

    return 0;
}
