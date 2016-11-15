//
//  VideoProcessor.m
//  Scouter
//
//  Created by Tatsuo Fukushima on 2016/11/11.
//  Copyright © 2016年 FXAT. All rights reserved.
//

#import "VideoProcessor.h"

@implementation VideoController
@end

@implementation VideoProcessor

- (id)initWithTitle:(NSString*) title
          processor:(id<CvVideoCameraDelegate>) processor{
  self = [super init];
  if(self){
    self.title = title;
    self.processor = processor;
  }
  return self;
}

@end
