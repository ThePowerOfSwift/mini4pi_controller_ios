//
//  ViewController.h
//  Scouter2
//
//  Created by Tatsuo Fukushima on 2016/10/31.
//  Copyright (c) 2016年 FXAT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoProcessor.h"

@interface VideoProcessingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UISwitch *cameraSwitch;
@property (weak, nonatomic) IBOutlet UILabel *labelBack;
@property (weak, nonatomic) IBOutlet UILabel *labelFront;
- (IBAction)close:(id)sender;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
- (IBAction)tapScreen:(id)sender;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@property VideoProcessor* videoProcessor;

@end

