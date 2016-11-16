//
//  RemoteController.m
//  Remocon
//
//  Created by 福島 達夫 on 2016/11/12.
//  Copyright © 2016年 FXAT. All rights reserved.
//

#import "RemoteController.h"
#import "Reachability.h"

@interface RemoteController() <NSStreamDelegate>

@property float x;
@property float y;
@property NSString* ipAddress;
@property UInt32 port;
@property NSTimeInterval timeout;
@property NSTimer* timer;

@property NSDate* lastUpdate;

@end

@implementation RemoteController
{
    NSOutputStream* outputStream;
}

- (id)initWithIpAddress:(NSString*) ipAddress
                   port:(UInt32) port
                timeout:(NSTimeInterval)timeout{
    
    self = [super init];
    if(self){
        self.ipAddress = ipAddress;
        self.port = port;
        self.timeout = timeout;
    }
    return self;
}

-(void)open{
    Reachability* reachability = [Reachability reachabilityWithHostName:self.ipAddress];
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    if(netStatus == NotReachable){
        [self.delegate remoteControllerError];
        return;
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                  target:self
                                                selector:@selector(sendState:)
                                                userInfo:nil
                                                 repeats:YES];
    
    CFWriteStreamRef writeStream = NULL;
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)self.ipAddress, self.port, NULL, &writeStream);
    outputStream = CFBridgingRelease(writeStream);
    outputStream.delegate = self;
    [outputStream open];
    
}

-(void)close{
    [self.timer invalidate];
    [outputStream close];
}

- (void)setStatusX:(float)x
                 y:(float)y{
    
    if(fabs(x)>100 || fabs(y)>100){
        @throw NSInvalidArgumentException;
    }
    
    self.x = x;
    self.y = y;
    self.lastUpdate = [NSDate date];
    
}

- (IBAction)sendState:(id)sender{
    static float lastX = 0, lastY = 0;

    if(self.timeout != 0 && fabs([self.lastUpdate timeIntervalSinceNow]) > self.timeout){
        NSLog(@"timeout.");
        [self.delegate timeout];
        self.x = 0;
        self.y = 0;
    }
    
    if(self.x==0 && self.y==0 && lastX==0 && lastY==0){
        return;
    }
    NSString* output = [NSString stringWithFormat:@"%.0f,%.0f\n", self.x, self.y];
    NSLog(@"%@", output);
    
    NSData *data = [[NSData alloc] initWithData:[output dataUsingEncoding:NSASCIIStringEncoding]];
    NSInteger written = [outputStream write:[data bytes] maxLength:[data length]];
    
    if(written != [data length]){
        NSLog(@"write error!!");
        if(self.delegate){
            [self.delegate remoteControllerError];
        }
    }
    lastX = self.x;
    lastY = self.y;
    
}

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode{
    NSLog(@"%@", @(eventCode));
}


@end
