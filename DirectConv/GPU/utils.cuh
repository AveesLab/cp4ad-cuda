#ifndef _UTILS_CUH_
#define _UTILS_CUH_
#include <stdint.h>

void conv_gpu(uint8_t* input, uint8_t* output ,int width_in, int height_in, int width_out, int height_out, int in_channel, int out_channel, int padding, int stride, int kernel_size);

#endif
