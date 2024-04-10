#include <iostream>

#include <opencv2/core.hpp>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>
#include "utils.cuh"

using namespace std;


int main(void) {
	int width = 224;
	int height = 224;

    cv::Mat Img = cv::imread("bonggu.JPG");
	cv::Mat Resize_Img;
	cv::resize(Img, Resize_Img, cv::Size(width, height));
	
	uint8_t Gray_Img[width * height];
	uint8_t Color_Img[width * height * 3] = {0};

	for (int y = 0; y < height; y++) {
		for (int x = 0; x < width; x++) {
			int B_idx = x + width * y;
			int G_idx = x + width * y + width * height;
			int R_idx = x + width * y + width * height * 2;
			
			uint8_t B_value = Resize_Img.at<cv::Vec3b>(y, x)[0];
			uint8_t G_value = Resize_Img.at<cv::Vec3b>(y, x)[1];
			uint8_t R_value = Resize_Img.at<cv::Vec3b>(y, x)[2];

			Color_Img[B_idx] = B_value;
			Color_Img[G_idx] = G_value;
			Color_Img[R_idx] = R_value;
		}
	}

    Color2Gray(Color_Img, Gray_Img, width, height);
	cv::Mat res(cv::Size(height, width), CV_8UC1, Gray_Img);
	cv::imshow("Color Image", Resize_Img);
    cv::imshow("Gray Image", res);
    
    cv::waitKey(0);
    return 0;
}
