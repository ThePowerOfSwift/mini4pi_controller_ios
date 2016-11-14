//
//  RemoteController.h
//  Remocon
//
//  Created by 福島 達夫 on 2016/11/12.
//  Copyright © 2016年 FXAT. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RemoteControllerDelegate
-(void)remoteControllerError;
-(void)timeout;
@end

@interface RemoteController : NSObject

@property (weak) id<RemoteControllerDelegate> delegate;

- (id)initWithIpAddress:(NSString*) ipAddress
                   port:(UInt32) port
                timeout:(NSTimeInterval)timeout;

- (void)open;
- (void)close;

- (void)setStatusX:(float)x
                 y:(float)y;

@end
