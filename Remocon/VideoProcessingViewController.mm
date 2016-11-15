//
//  VideoProcessingViewController.m
//  Scouter2
//
//  Created by Tatsuo Fukushima on 2016/10/31.
//  Copyright (c) 2016年 FXAT. All rights reserved.
//

#import <opencv2/opencv.hpp>
#import <opencv2/video/background_segm.hpp>
#import <opencv2/imgproc.hpp>
#import "VideoProcessingViewController.h"
#import "FixedCvVideoCamera.h"
#import "MyDefaults.h"
#import "RemoteController.h"


using namespace cv;

@interface VideoProcessingViewController ()

@property BOOL cameraSwitchOn;
@property (nonatomic, retain) CvVideoCamera* videoCamera;

@end

static NSString* const cameraSwithObserveKey = @"cameraSwitchOn";

@implementation VideoProcessingViewController

// 画面回転時、コントロールを回転するための処理
-(void)deviceRotated:(NSNotification *)note{
    /*
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    CGFloat rotationAngle = 0;
    if (orientation == UIDeviceOrientationPortraitUpsideDown) rotationAngle = M_PI;
    else if (orientation == UIDeviceOrientationLandscapeLeft) rotationAngle = M_PI_2;
    else if (orientation == UIDeviceOrientationLandscapeRight) rotationAngle = -M_PI_2;
    [UIView animateWithDuration:0.5 animations:^{
        self.labelBack.transform = CGAffineTransformMakeRotation(rotationAngle);
        self.labelFront.transform = CGAffineTransformMakeRotation(rotationAngle);
    } completion:nil];
     */
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.videoProcessor.processor.remoteController = [[RemoteController alloc] initWithIpAddress:[MyDefaults loadIpAddress]
                                                                                            port:20000
                                                                                         timeout:0.2];
    [self.videoProcessor.processor.remoteController open];

    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.cameraSwitchOn = self.cameraSwitch.on;
    
    [self.cameraSwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
    
    self.navigationBar.topItem.title = self.videoProcessor.title;
    
    [self addObserver:self
           forKeyPath:cameraSwithObserveKey
              options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld
              context:nil];
    
    // 画面回転時の通知を受け取るための準備
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceRotated:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if([object isKindOfClass:self.class] && [keyPath isEqualToString:cameraSwithObserveKey]){
        if([change valueForKey:NSKeyValueChangeOldKey] != [change valueForKey:NSKeyValueChangeNewKey]){
            [self.videoCamera switchCameras];
        }
    }
}

- (void)changeSwitch:(UISwitch*)sender{
    self.cameraSwitchOn = sender.on;
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    // 動画処理のための初期化
    self.videoCamera = [[FixedCvVideoCamera alloc] initWithParentView:self.imageView];
    self.videoCamera.delegate = self.videoProcessor.processor;
    self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
    self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationLandscapeRight;
    self.videoCamera.defaultFPS = 30;
    self.videoCamera.grayscaleMode = NO;
    self.videoCamera.rotateVideo = NO;
    
    // カメラ処理スタート
    [self.videoCamera start];
    self.indicator.hidden = YES;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.videoProcessor.processor.remoteController close];
    
    [self removeObserver:self forKeyPath:cameraSwithObserveKey];
    self.videoCamera = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (BOOL)shouldAutorotate{
    return NO;
}

- (IBAction)close:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)tapScreen:(id)sender {
    self.navigationBar.hidden = !self.navigationBar.isHidden;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscape;
}


@end
