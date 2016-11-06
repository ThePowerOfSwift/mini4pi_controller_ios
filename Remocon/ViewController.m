//
//  ViewController.m
//  Remocon
//
//  Created by Tatsuo Fukushima on 2016/11/04.
//  Copyright © 2016年 FXAT. All rights reserved.
//

#import "ViewController.h"
#import <Foundation/Foundation.h>


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
  // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


- (IBAction)connect:(id)sender {
    [self performSegueWithIdentifier:@"pushJobControllView" sender:self];
}

- (IBAction)action:(id)sender {
}
@end
