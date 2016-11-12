//
//  MyDefaults.h
//  Remocon
//
//  Created by 福島 達夫 on 2016/11/07.
//  Copyright © 2016年 FXAT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyDefaults : NSObject
+ (void) saveIpAddress:(NSString*)ipaddress;
+ (NSString*) loadIpAddress;


@end
