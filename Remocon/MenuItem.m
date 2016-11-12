//
//  MenuItem.m
//  Remocon
//
//  Created by 福島 達夫 on 2016/11/11.
//  Copyright © 2016年 FXAT. All rights reserved.
//

#import "MenuItem.h"

@implementation MenuItem
- (id)initWithTitle:(NSString*)title
          vcFactory:(UIViewController* (^)(void)) viewControllerFactory{

    self = [super init];
    if(self){
        self.title = title;
        self.viewControllerFactory = viewControllerFactory;
    }
    return self;
}

@end
