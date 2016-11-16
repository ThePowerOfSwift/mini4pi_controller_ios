//
//  FaceDetectVideoProcessor1.m
//  Scouter
//
//  Created by Tatsuo Fukushima on 2016/11/10.
//  Copyright © 2016年 FXAT. All rights reserved.
//
#import <opencv2/opencv.hpp>
#import <opencv2/video/background_segm.hpp>
#import <opencv2/imgproc.hpp>
#import "FaceDetectVideoProcessor1.h"

using namespace cv;

@interface FaceDetectVideoProcessor1()
{
    cv::CascadeClassifier cascade;
}

@end

@implementation FaceDetectVideoProcessor1

- (id)init{
    self = [super init];
    if(self){
        // 分類器の読み込み
        NSBundle *bundle = [NSBundle mainBundle];
        NSString *path = [bundle pathForResource:@"haarcascade_frontalface_alt" ofType:@"xml"];
        std::string cascadeName = (char *)[path UTF8String];
        
        if(!cascade.load(cascadeName)) {
            return nil;
        }
    }
    return self;
}

// 動画の1フレームを受け取るデリゲート
- (void)processImage:(Mat&)image
{//Path to the training parameters for frontal face detector    // 顔検出
    std::vector<cv::Rect> faces;
    cascade.detectMultiScale(image, faces,
                             1.1, 2,
                             CV_HAAR_SCALE_IMAGE,
                             cv::Size(30, 30));
    
    
    // 顔の位置に丸を描く
    
    
    std::vector<cv::Rect>::const_iterator r = faces.begin();
    for(; r != faces.end(); ++r) {
        cv::rectangle(image, cv::Point(r->x, r->y), cv::Point(r->x + r->width, r->y + r->height), CV_RGB(0, 255,0), 1);
        /*
        cv::Point center;
        int radius;
        center.x = cv::saturate_cast<int>((r->x + r->width*0.5));
        center.y = cv::saturate_cast<int>((r->y + r->height*0.5));
        radius = cv::saturate_cast<int>((r->width + r->height));
        cv::circle(image, center, 20, cv::Scalar(80,80,255), 3, 8, 0 );
         */
    }
    //[self.remoteController setStatusX:motorX y:motorY];
}

@end
