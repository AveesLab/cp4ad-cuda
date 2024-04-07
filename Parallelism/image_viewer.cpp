#include <iostream>

#include "opencv2/highgui.hpp"

using namespace std;


extern "C" void Show_GrayImage(uint8_t* Image, int width, int height) {
    cv::Mat src(width, height, CV_8UC1, Image);
    cv::imshow("Gray Image", src);
}

extern "C" void Show_ColorImage(uint8_t* Image, int width, int height) {
    cv::Mat src(width, height, CV_8UC3, Image);
    cv::imshow("Color Image", src);
}


// extern "C" void CaptureVideo() {
//     cv::VideoCapture cap("highway.mp4");

//     if (!cap.isOpened()) {
//         cerr << "Camera open failed" << endl;
//         return;
//     }

//     cout << "Frame width : " << cvRound(cap.get(CAP_PROP_FRAME_WIDTH)) << endl;
//     cout << "Frame height : " << cvRound(cap.get(CAP_PROP_FRAME_HEIGHT)) << endl;

//     double fps = cap.get(CAP_PROP_FPS);
//     cout << "FPS : " << fps << endl;
//     int delay = cvRound(1000 / fps);
//     cv::Mat frame;
//     while (true) {
//         cpa >> frame;
//         if (frame.empty()) continue;

//         cv::imshow("result", frame);

//         if (waitKey(delay) == 27) break;
//     }

//     cv::destroyAllWindows();
// }
