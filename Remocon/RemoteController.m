//
//  RemoteController.m
//  Remocon
//
//  Created by 福島 達夫 on 2016/11/12.
//  Copyright © 2016年 FXAT. All rights reserved.
//

#import "RemoteController.h"

@interface RemoteController()

@property float x;
@property float y;
@property NSString* ipAddress;
@property UInt32 port;

@end

@implementation RemoteController
{
    NSOutputStream* outputStream;
}

- (id)initWithIpAddress:(NSString*) ipAddress
                   port:(UInt32) port{
    
    self = [super init];
    if(self){
        self.ipAddress = ipAddress;
        self.port = port;
    }
    return self;
}

-(void)open{
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(sendState:) userInfo:nil repeats:YES];
    
    CFWriteStreamRef writeStream = NULL;
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)self.ipAddress, self.port, NULL, &writeStream);
    outputStream = CFBridgingRelease(writeStream);
    [outputStream open];
    
}

-(void)close{
    [outputStream close];
}

- (void)setStatusX:(float)x
                 y:(float)y{
    
    if(fabs(x)>1 || fabs(y)>1){
        @throw NSInvalidArgumentException;
    }
    
    self.x = x;
    self.y = y;
    
}

- (IBAction)sendState:(id)sender{
    static float lastX = 0, lastY = 0;
    
    if(self.x==0 && self.y==0 && lastX==0 && lastY==0){
        return;
    }
    NSString* output = [NSString stringWithFormat:@"%.0f,%.0f\n", self.x, self.y];
    NSLog(@"%@", output);
    
    NSData *data = [[NSData alloc] initWithData:[output dataUsingEncoding:NSASCIIStringEncoding]];
    NSInteger written = [outputStream write:[data bytes] maxLength:[data length]];
    
    if(written != [data length]){
        NSLog(@"write error!!");
    }
    lastX = self.x;
    lastY = self.y;
}


@end
