#include <iostream>
#include <time.h>

#include <opencv2/core.hpp>
#include <opencv2/imgcodecs.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/imgproc.hpp>

using namespace std;


int main(void) {

    cv::Mat Color_Img = cv::imread("bonggu.JPG");
    cv::Mat Gray_Img;

    clock_t start = clock();
    cv::cvtColor(Color_Img, Gray_Img, cv::COLOR_BGR2GRAY);
    clock_t end = clock();

    double execution_time = (double) (end - start) / CLOCKS_PER_SEC;
    printf("Execution time: %d usec\n", (int) (execution_time * 1000000));
    cv::imshow("Color Image", Color_Img);
    cv::imshow("Gray Image", Gray_Img);
    
    cv::waitKey(0);
    return 0;
}
