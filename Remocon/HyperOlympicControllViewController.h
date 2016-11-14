//
//  HyperOlympicControllViewController.h
//  Remocon
//
//  Created by 福島 達夫 on 2016/11/05.
//  Copyright © 2016年 FXAT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParameterizeViewController.h"

@interface HyperOlympicControllViewController : ParameterizeViewController<UIGestureRecognizerDelegate>
- (IBAction)cancel:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
- (IBAction)leftTap:(UIButton *)sender;
- (IBAction)rightTap:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;


@end
