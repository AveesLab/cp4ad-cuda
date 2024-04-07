#include <stdio.h>
#include <stdint.h>

int width = 224;
int height = 224;
int channel = 3;

int main(void) {
    uint8_t Color_Img[width * height * channel];
    uint8_t Gray_Img[width * height];
    uint8_t Luminance;

    for (int y = 0; y < height; y++) {
        for (int x = 0; x < width; x++) {
            int r_value = Color_Img[y * width + x];
            int g_value = Color_Img[y * width + x + width * height];
            int b_value = Color_Img[y * width + x + width * height * 2];
            Luminance = r_value * 0.21 + g_value * 0.72 + b_value * 0.07;

            if (Luminance > 255) Luminance = 255;

            Gray_Img[y * width + x] = Luminance;
        }
    }


    return 0;
}