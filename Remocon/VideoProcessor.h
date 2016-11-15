//
//  VideoProcessor.h
//  Scouter
//
//  Created by Tatsuo Fukushima on 2016/11/11.
//  Copyright © 2016年 FXAT. All rights reserved.
//

#import <opencv2/highgui/cap_ios.h>
#import <Foundation/Foundation.h>
#import "RemoteController.h"

@interface VideoController :NSObject<CvVideoCameraDelegate>
@property RemoteController* remoteController;
@end

@interface VideoProcessor : NSObject

@property NSString* title;
@property VideoController* processor;

- (id)initWithTitle:(NSString*) title
          processor:(VideoController*) processor;


@end
