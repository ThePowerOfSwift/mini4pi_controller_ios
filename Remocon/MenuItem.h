//
//  MenuItem.h
//  Remocon
//
//  Created by 福島 達夫 on 2016/11/11.
//  Copyright © 2016年 FXAT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface MenuItem : NSObject
@property NSString* title;
@property UIViewController* (^viewControllerFactory)(void);


- (id)initWithTitle:(NSString*)title
          vcFactory:(UIViewController* (^)(void)) viewControllerFactory;

@end
