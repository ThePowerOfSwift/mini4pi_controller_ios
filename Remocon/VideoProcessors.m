//
//  VideoProcessors.m
//  Scouter
//
//  Created by Tatsuo Fukushima on 2016/11/11.
//  Copyright © 2016年 FXAT. All rights reserved.
//

#import "VideoProcessors.h"
#import "VideoProcessor.h"

#import "MotionDetectVideoProcessor1.h"
#import "EdgeDetectVideoProcessor1.h"


@implementation VideoProcessors
+ (NSArray*) allProcessor{
  NSMutableArray* videoProcessors = [NSMutableArray new];
  
  [videoProcessors addObject:[[VideoProcessor alloc] initWithTitle:@"Motion Detect 1"
                                                         processor:[MotionDetectVideoProcessor1 new]]
   ];
  [videoProcessors addObject:[[VideoProcessor alloc] initWithTitle:@"Edge Detect 1"
                                                         processor:[EdgeDetectVideoProcessor1 new]]
   ];

  return videoProcessors;
}
@end
