#include <iostream>
#include <time.h>

#include "opencv2/highgui.hpp"

using namespace std;


int main(void) {

    cv::Mat Color_Img = imread("");
    cv::Mat Gray_Img;

    clock_t start = clock();
    cv2::cvtColor(Color_Img, Gray_Img, COLOR_BGR2GRAY);
    clock_t end = clock();

    double excution_time = (double) (end - start) / CLOCKS_PER_SEC;
    printf("Execution time: %d usec\n", (int) (execution_time * 1000000));
    cv::imshow("Color Image", Color_Img);
    cv::imshow("Gray Image", Gray_Img);
    
    cv::waitKey(0);
    return 0;
}