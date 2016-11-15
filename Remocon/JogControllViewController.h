//
//  JogControllViewController.h
//  Remocon
//
//  Created by 福島 達夫 on 2016/11/05.
//  Copyright © 2016年 FXAT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JogControllViewController : UIViewController<UIGestureRecognizerDelegate>
- (IBAction)cancel:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *jocControl;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;


@end
