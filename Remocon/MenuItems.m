//
//  MenuItems.m
//  Remocon
//
//  Created by 福島 達夫 on 2016/11/11.
//  Copyright © 2016年 FXAT. All rights reserved.
//

#import "MenuItem.h"
#import "MenuItems.h"

#import "JogControllViewController.h"
#import "HyperOlympicControllViewController.h"

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
    
    return menus;
}

@end
