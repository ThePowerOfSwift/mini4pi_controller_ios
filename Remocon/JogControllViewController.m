//
//  JogControllViewController.m
//  Remocon
//
//  Created by 福島 達夫 on 2016/11/05.
//  Copyright © 2016年 FXAT. All rights reserved.
//

#import "JogControllViewController.h"
#import "MyDefaults.h"
#import "RemoteController.h"

@interface JogControllViewController () <RemoteControllerDelegate>
@property CGPoint buttonOrigin;

@property NSInteger maxValue;
@property RemoteController* remoteController;

@end

@implementation JogControllViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.topItem.title = [MyDefaults loadIpAddress];
    
    UIPanGestureRecognizer *panRecognizer;
    panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                            action:@selector(panJobController:)];
    // cancel touches so that touchUpInside touches are ignored
    panRecognizer.cancelsTouchesInView = YES;
    [self.jocControl addGestureRecognizer:panRecognizer];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.maxValue = MIN(screenSize.width, screenSize.height) / 4;
    

    self.remoteController = [[RemoteController alloc] initWithIpAddress:[MyDefaults loadIpAddress] port:20000 timeout:0];
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

- (void)viewDidLayoutSubviews{
    self.buttonOrigin = self.jocControl.center;
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

- (IBAction)panJobController:(UIPanGestureRecognizer *)sender {
    if(sender.state == UIGestureRecognizerStateEnded)
    {
        self.jocControl.center = self.buttonOrigin;
        
    }
    
    else{
        // ドラッグで移動した距離を取得する
        CGPoint p = [sender translationInView:self.view];
        
        CGFloat newX = self.jocControl.center.x + p.x;
        CGFloat newY = self.jocControl.center.y + p.y;
        
        
        if(newX > self.buttonOrigin.x + self.maxValue){
            newX = self.buttonOrigin.x + self.maxValue;
        }
        if(newX < self.buttonOrigin.x - self.maxValue){
            newX = self.buttonOrigin.x - self.maxValue;
        }
        if(newY > self.buttonOrigin.y + self.maxValue){
            newY = self.buttonOrigin.y + self.maxValue;
        }
        if(newY < self.buttonOrigin.y - self.maxValue){
            newY = self.buttonOrigin.y - self.maxValue;
        }
        
        // 移動した距離だけ、UIImageViewのcenterポジションを移動させる
        CGPoint movedPoint = CGPointMake(newX, newY);
        
        self.jocControl.center = movedPoint;
        
    }
    float x = (self.buttonOrigin.x - self.jocControl.center.x) / self.maxValue * 100;
    float y = (self.buttonOrigin.y - self.jocControl.center.y) / self.maxValue * 100;
    [self.remoteController setStatusX:x * 0.7f y:y];

    
    // ドラッグで移動した距離を初期化する
    // これを行わないと、[sender translationInView:]が返す距離は、ドラッグが始まってからの蓄積値となるため、
    // 今回のようなドラッグに合わせてImageを動かしたい場合には、蓄積値をゼロにする
    [sender setTranslation:CGPointZero inView:self.jocControl];
}


#pragma mark <RemotoControllerDelegate>
- (void)remoteControllerError{
    self.navigationBar.topItem.title = @"Network Error";
    self.navigationBar.barTintColor = [UIColor redColor];
}

-(void)timeout{
    
}


@end
