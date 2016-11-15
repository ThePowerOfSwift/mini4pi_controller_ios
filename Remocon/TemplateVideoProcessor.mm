//
//  TemplateVideoProcessor.m
//  Scouter
//
//  Created by Tatsuo Fukushima on 2016/11/11.
//  Copyright © 2016年 FXAT. All rights reserved.
//
#import <opencv2/opencv.hpp>

#import "TemplateVideoProcessor.h"

using namespace cv;

@implementation TemplateVideoProcessor
- (id)init{
  self = [super init];
  if(self){
    // 初期化処理
  }
  return self;
}

// 動画の1フレームを受け取るデリゲート
- (void)processImage:(Mat&)image
{
  // ビデオ処理
}

@end
