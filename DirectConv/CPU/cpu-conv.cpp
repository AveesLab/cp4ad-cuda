#include <iostream>
#include <time.h>

#include <opencv2/core.hpp>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>

using namespace std;


int main(void) {
    int width = 480;
    int height = 480;
    int kernel_size = 3;
    int stride = 1;
    int padding = 1;
 
    cv::Mat Color_Img = cv::imread("bonggu.JPG");
	cv::Mat Resize_Img;
	cv::Mat Gray_Img;

    cv::Mat Result;

	cv::resize(Color_Img, Resize_Img, cv::Size(height, width));
    cv::cvtColor(Resize_Img, Gray_Img, cv::COLOR_BGR2GRAY);

    clock_t start = clock();
    cv::Sobel(Gray_Img, Result, CV_8UC1, 1, 0);
    clock_t end = clock();
    double execution_time = (double) (end - start) / CLOCKS_PER_SEC;
    printf("Execution time: %d usec\n", (int) (execution_time * 1000000));
    cv::imshow("Input", Gray_Img);
    cv::imshow("Output", Result);
    cv::waitKey(0);
    return 0;
}
