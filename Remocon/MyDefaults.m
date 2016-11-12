//
//  MyDefaults.m
//  Remocon
//
//  Created by 福島 達夫 on 2016/11/07.
//  Copyright © 2016年 FXAT. All rights reserved.
//

#import "MyDefaults.h"

#define IPADDRESS @"networking.ipaddress"

@implementation MyDefaults


+ (void) saveIpAddress:(NSString*)ipaddress{
    [[NSUserDefaults standardUserDefaults] setValue:ipaddress forKey:IPADDRESS];
}

+ (NSString*) loadIpAddress{
    NSString* ip =  [[NSUserDefaults standardUserDefaults] stringForKey:IPADDRESS];
    if(!ip || [ip isEqualToString:@""]){
        return @"localhost";
    }
    return ip;
}

@end
