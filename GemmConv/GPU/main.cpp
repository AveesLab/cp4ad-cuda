#include <iostream>

#include <opencv2/core.hpp>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>
#include "utils.cuh"

using namespace std;


int main(void) {
    int width = 480;
    int height = 480;
	int in_channel = 1;
	int out_channel = 1;
    int kernel_size = 3;
    int stride = 1;
    int padding = 1;
	
	int width_in = width + 2 * padding;
	int height_in = height + 2 * padding;
	int width_out = (width - kernel_size + 2 * padding) / stride + 1;
	int height_out = (height - kernel_size + 2 * padding) / stride + 1;

	int col_size = kernel_size * kernel_size * in_channel * width_out * height_out * out_channel; 
	// CUDA 실습 결과 확인을 위한 사전 프로세싱 -->
    cv::Mat Color_Img = cv::imread("bonggu.JPG");
	cv::Mat Resize_Img;
	cv::Mat Gray_Img;
    cv::Mat Pad_Img;
	
	cv::resize(Color_Img, Resize_Img, cv::Size(height, width));
    cv::copyMakeBorder(Resize_Img, Pad_Img, padding, padding, padding, padding, cv::BORDER_CONSTANT, cv::Scalar(0, 0, 0));
    cv::cvtColor(Pad_Img, Gray_Img, cv::COLOR_BGR2GRAY);

	// 1차원 배열 생성 해당 부분도 수정
	uint8_t Input[width_in * height_in * in_channel]; // input_width * output_width
	uint8_t im2col_arr[col_size];
	uint8_t Output[width_out * height_out * out_channel];
	// 2차원(height, width) Gray Image의 값들을 1차원 배열에 담아주는 과정 	
	for (int y = 0; y < height_in; y++) {
		for (int x = 0; x < width_in; x++) {
			int idx = x + width_in * y;
			Input[idx] = Gray_Img.at<uchar>(y, x);
			//printf("input %d = %u", idx, Input[idx]);
		}
	}
	// <--

    im2col_gpu(Input, im2col_arr, width_in, height_in, width_out, height_out, in_channel, out_channel, padding, stride, kernel_size);
	gemm_gpu( im2col_arr, Output, width_in, height_in, width_out, height_out, in_channel, out_channel, padding, stride, kernel_size );
	cv::Mat res(cv::Size(height, width), CV_8UC1, Output);
	cv::imshow("Input", Resize_Img);
    cv::imshow("Output", res);
    
    cv::waitKey(0);
    return 0;
}
