#include <iostream>
#include <time.h>
#include <stdint.h>
#include <opencv2/core.hpp>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>

using namespace std;


int main(void) {
	int width = 224;
	int height = 224;

    cv::Mat Color_Img = cv::imread("bonggu.JPG");
	cv::Mat Resize_Img;
	cv::Mat Gray_Img(height, width, CV_8UC1);
	
	cv::resize(Color_Img, Resize_Img, cv::Size(width, height));
    clock_t start = clock();
    for (int y = 0; y < height; y++) {
		for (int x = 0; x < width; x++) {
			
			//Gray_Img.at<uchar>(y, x) =
			
		}
	}
    clock_t end = clock();

    double execution_time = (double) (end - start) / CLOCKS_PER_SEC;
    printf("Execution time: %d usec\n", (int) (execution_time * 1000000));
    cv::imshow("Color Image", Resize_Img);
    cv::imshow("Gray Image", Gray_Img);
    
    cv::waitKey(0);
    return 0;
}
