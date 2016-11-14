//
//  HyperOlympicControllViewController.m
//  Remocon
//
//  Created by 福島 達夫 on 2016/11/05.
//  Copyright © 2016年 FXAT. All rights reserved.
//

#import "HyperOlympicControllViewController.h"
#import "MyDefaults.h"
#import "RemoteController.h"

@interface HyperOlympicControllViewController () <RemoteControllerDelegate>

@property RemoteController* remoteController;
@property BOOL isLastTapLeft;
@property NSInteger combo;

@end

@implementation HyperOlympicControllViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.topItem.title = [MyDefaults loadIpAddress];
    self.combo = 50;
    
    

    self.remoteController = [[RemoteController alloc] initWithIpAddress:[MyDefaults loadIpAddress] port:20000 timeout:0.1];
    self.remoteController.delegate = self;
    [self.remoteController open];

}

- (void)viewDidDisappear:(BOOL)animated{
    [self.remoteController close];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark <RemotoControllerDelegate>
- (void)remoteControllerError{
    self.navigationBar.topItem.title = @"Network Error";
    self.navigationBar.barTintColor = [UIColor redColor];
}

- (IBAction)leftTap:(id)sender {
    if(self.isLastTapLeft){
        self.combo = 50;
        return;
    }
    self.isLastTapLeft = YES;
    if(self.combo<100){
        self.combo ++;
    }
    [self.remoteController setStatusX:0 y:self.combo];
}

- (IBAction)rightTap:(UIButton *)sender {
    if(!self.isLastTapLeft){
        self.combo = 50;
        return;
    }
    self.isLastTapLeft = NO;
    if(self.combo<100){
        self.combo ++;
    }
    [self.remoteController setStatusX:0 y:self.combo];
}

-(void)timeout{
    self.combo = 50;
    
}

@end
