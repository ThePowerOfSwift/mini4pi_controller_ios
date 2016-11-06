//
//  JogControllViewController.m
//  Remocon
//
//  Created by 福島 達夫 on 2016/11/05.
//  Copyright © 2016年 FXAT. All rights reserved.
//

#import "JogControllViewController.h"

@interface JogControllViewController ()

@property CGPoint buttonOrigin;

@property NSInteger maxValue;
@property NSInteger jogX;
@property NSInteger jogY;

@end

@implementation JogControllViewController
{
    NSOutputStream* outputStream;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIPanGestureRecognizer *panRecognizer;
    panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                            action:@selector(panJobController:)];
    // cancel touches so that touchUpInside touches are ignored
    panRecognizer.cancelsTouchesInView = YES;
    [self.jocControl addGestureRecognizer:panRecognizer];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.maxValue = MIN(screenSize.width, screenSize.height) / 4;
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(sendState:) userInfo:nil repeats:YES];

     CFWriteStreamRef writeStream = NULL;
     CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)@"192.168.1.16", 20000, NULL, &writeStream);
     outputStream = CFBridgingRelease(writeStream);
     [outputStream open];

}

- (void)viewDidDisappear:(BOOL)animated{
    [outputStream close];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews{
    self.buttonOrigin = self.jocControl.center;
}

- (IBAction)sendState:(id)sender{
    static float lastX = 0, lastY = 0;
    
    
    float x = (float)self.jogX / self.maxValue * 100;
    float y = (float)self.jogY / self.maxValue * 100;

    
    if(x==0 && y==0 && lastX==0 && lastY==0){
        return;
    }
    NSString* output = [NSString stringWithFormat:@"%.0f,%.0f\n", x, y];
    NSLog(@"%@", output);
    
    NSData *data = [[NSData alloc] initWithData:[output dataUsingEncoding:NSASCIIStringEncoding]];
    NSInteger written = [outputStream write:[data bytes] maxLength:[data length]];
    
    if(written != [data length]){
        NSLog(@"write error!!");
    }
    lastX = x;
    lastY = y;
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
    self.jogX = self.buttonOrigin.x - self.jocControl.center.x;
    self.jogY = self.buttonOrigin.y - self.jocControl.center.y;

    // ドラッグで移動した距離を初期化する
    // これを行わないと、[sender translationInView:]が返す距離は、ドラッグが始まってからの蓄積値となるため、
    // 今回のようなドラッグに合わせてImageを動かしたい場合には、蓄積値をゼロにする
    [sender setTranslation:CGPointZero inView:self.jocControl];
}

@end
