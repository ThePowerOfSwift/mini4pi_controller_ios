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
    int width = image.cols;
    int height = image.rows;
    
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    float ratioW = screenWidth / width;
    float ratioH = screenHeight / height;
    
    float ratio = MAX(ratioW, ratioH);

    float paddingW = (ratio * width - screenWidth)/ratio;
    float paddingH = (ratio * height - screenHeight)/ratio;
    
    
    int leftBoader = ((width - paddingW) * 0.33f)+0.5 + paddingW/2;
    int rightBoader = ((width - paddingW) * 0.66f)+0.5 + paddingW/2;
    
    int topBoarder = ((height - paddingH) * 0.33f)+0.5 + paddingH/2;
    int bottomBoarder = ((height - paddingH) * 0.66)+0.5 + paddingH/2;
    
    line(image, cv::Point(leftBoader, 0), cvPoint(leftBoader, height), Scalar(255, 0, 0), 0.5f);
    line(image, cv::Point(rightBoader, 0), cvPoint(rightBoader, height), Scalar(255, 0, 0), 0.5f);

    line(image, cv::Point(0, topBoarder), cvPoint(width, topBoarder), Scalar(255, 0, 0), 0.5f);
    line(image, cv::Point(0, bottomBoarder), cvPoint(width, bottomBoarder), Scalar(255, 0, 0), 0.5f);
    
    
    std::vector<cv::Rect> faces;
    cascade.detectMultiScale(image, faces,
                             1.1, 2,
                             CV_HAAR_SCALE_IMAGE,
                             cv::Size(30, 30));
    

    cv::putText(image, "Left Forward", cv::Point(paddingW, topBoarder), CV_FONT_HERSHEY_PLAIN, 1, cv::Scalar(255, 255, 255));
    cv::putText(image, "Forward", cv::Point(leftBoader, topBoarder), CV_FONT_HERSHEY_PLAIN, 1, cv::Scalar(255, 255, 255));
    cv::putText(image, "Right Forward", cv::Point(rightBoader, topBoarder), CV_FONT_HERSHEY_PLAIN, 1, cv::Scalar(255, 255, 255));

    cv::putText(image, "Left", cv::Point(paddingW, bottomBoarder), CV_FONT_HERSHEY_PLAIN, 1, cv::Scalar(255, 255, 255));
    cv::putText(image, "Neutral", cv::Point(leftBoader, bottomBoarder), CV_FONT_HERSHEY_PLAIN, 1, cv::Scalar(255, 255, 255));
    cv::putText(image, "Right", cv::Point(rightBoader, bottomBoarder), CV_FONT_HERSHEY_PLAIN, 1, cv::Scalar(255, 255, 255));

    cv::putText(image, "Left Back", cv::Point(paddingW, height - paddingH/2), CV_FONT_HERSHEY_PLAIN, 1, cv::Scalar(255, 255, 255));
    cv::putText(image, "Back", cv::Point(leftBoader, height - paddingH/2), CV_FONT_HERSHEY_PLAIN, 1, cv::Scalar(255, 255, 255));
    cv::putText(image, "Right Back", cv::Point(rightBoader, height - paddingH/2), CV_FONT_HERSHEY_PLAIN, 1, cv::Scalar(255, 255, 255));

    
    // 顔の位置に丸を描く
    
    
    int motorX = 0, motorY = 0;

    std::vector<cv::Rect>::const_iterator r = faces.begin();
    for(; r != faces.end(); ++r) {
        cv::rectangle(image, cv::Point(r->x, r->y), cv::Point(r->x + r->width, r->y + r->height), CV_RGB(0, 255,0), 1);

        cv::Point center;
        center.x = cv::saturate_cast<int>((r->x + r->width*0.5));
        center.y = cv::saturate_cast<int>((r->y + r->height*0.5));
        
        cv::Point pt1, pt2;
        if(center.x < leftBoader){
            motorX = -80;

            // Left Forward
            if(center.y < topBoarder){
                motorY = 100;
                pt1.x = 0;
                pt1.y = 0;
                pt2.x = leftBoader;
                pt2.y = topBoarder;
            }
            // Left Back
            else if(center.y > bottomBoarder){
                motorY = -100;
                pt1.x = 0;
                pt1.y = bottomBoarder;
                pt2.x = leftBoader;
                pt2.y = height;
            }
            // Left
            else{
                pt1.x = 0;
                pt1.y = topBoarder;
                pt2.x = leftBoader;
                pt2.y = bottomBoarder;
            
            }
        }
        else if(center.x > rightBoader){
            motorX = 80;
            
            // Right Forward
            if(center.y < topBoarder){
                motorY = 100;
                pt1.x = rightBoader;
                pt1.y = 0;
                pt2.x = width;
                pt2.y = topBoarder;
                
            }
            // Right Back
            else if(center.y > bottomBoarder){
                motorY = -100;
                pt1.x = rightBoader;
                pt1.y = bottomBoarder;
                pt2.x = width;
                pt2.y = height;
                
            }
            // Right
            else{
                pt1.x = rightBoader;
                pt1.y = topBoarder;
                pt2.x = width;
                pt2.y = bottomBoarder;
                
            }
            
        }
        else{
            // Forward
            if(center.y < topBoarder){
                motorY = 100;
                pt1.x = leftBoader;
                pt1.y = 0;
                pt2.x = rightBoader;
                pt2.y = topBoarder;
                
            }
            // Back
            else if(center.y > bottomBoarder){
                motorY = -100;
                pt1.x = leftBoader;
                pt1.y = bottomBoarder;
                pt2.x = rightBoader;
                pt2.y = height;
                
            }
            // Neutral
            else{
                pt1.x = leftBoader;
                pt1.y = topBoarder;
                pt2.x = rightBoader;
                pt2.y = bottomBoarder;
                
            }
            
        }
        cv::Mat overlay;
        double alpha = 0.3;
        
        // copy the source image to an overlay
        image.copyTo(overlay);
        
        // draw a filled, yellow rectangle on the overlay copy
        cv::rectangle(overlay, cv::Rect(pt1.x, pt1.y, pt2.x - pt1.x, pt2.y - pt1.y), cv::Scalar(0, 125, 125), -1);
        
        // blend the overlay with the source image
        cv::addWeighted(overlay, alpha, image, 1 - alpha, 0, image);
        

    
    }
    [self.remoteController setStatusX:motorX y:motorY];
}

@end
