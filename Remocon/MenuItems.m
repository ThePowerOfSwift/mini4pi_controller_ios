//
//  MenuItems.m
//  Remocon
//
//  Created by 福島 達夫 on 2016/11/11.
//  Copyright © 2016年 FXAT. All rights reserved.
//

#import "MenuItem.h"
#import "MenuItems.h"

#import "VideoProcessingViewController.h"
#import "MotionDetectVideoProcessor1.h"

@implementation MenuItems

+(NSArray*) allMenu{
    NSMutableArray* menus = [NSMutableArray new];
    
    [menus addObject:[[MenuItem alloc] initWithTitle:@"Track Circle" vcFactory:^UIViewController *{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        return [storyboard instantiateViewControllerWithIdentifier:@"JogControll"];
    }]];
    [menus addObject:[[MenuItem alloc] initWithTitle:@"Hyper Olympic" vcFactory:^UIViewController *{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        return [storyboard instantiateViewControllerWithIdentifier:@"HyperOlympicControll"];
    }]];
    [menus addObject:[[MenuItem alloc] initWithTitle:@"Motion" vcFactory:^UIViewController *{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        VideoProcessingViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"VideoControll"];
        vc.videoProcessor = [[VideoProcessor alloc] initWithTitle:@"Motion"
                                                        processor:[MotionDetectVideoProcessor1 new]];
        
        return vc;
    }]];
    return menus;
}

@end
