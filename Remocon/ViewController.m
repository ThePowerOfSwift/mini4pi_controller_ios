//
//  ViewController.m
//  Remocon
//
//  Created by Tatsuo Fukushima on 2016/11/04.
//  Copyright © 2016年 FXAT. All rights reserved.
//

#import "ViewController.h"
#import <Foundation/Foundation.h>

@interface ViewController ()
{
  NSInputStream* inputStream;
  NSOutputStream* outputStream;
}
@end

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
  CFReadStreamRef readStream = NULL;
  CFWriteStreamRef writeStream = NULL;
  CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)@"localhost", 20000, &readStream, &writeStream);
  inputStream  = CFBridgingRelease(readStream);
  outputStream = CFBridgingRelease(writeStream);
  [inputStream open];
  [outputStream open];
}

- (IBAction)action:(id)sender {
  [self writeUTF:@"1\n"];
}

- (void)writeShort:(signed short)v {
  if ([outputStream write:(uint8_t*)&v maxLength:2] != 2) {
    @throw NSInvalidArgumentException;
  }
}
- (void)writeUTF:(NSString*)v {
  //  文字がない時
  if (v.length == 0) {
    [self writeShort:0];
    return;
  }
  
  //  文字コードをUFTに変換する
  NSData* strData = [v dataUsingEncoding:NSUTF8StringEncoding];
  
  //  データサイズオーバー（signed shortで表現できるバイトサイズである必要がある）
  if (strData.length > SHRT_MAX) {
    @throw NSInvalidArgumentException;
  }
  
  //  サイズ書き出し
  signed short length = (signed short)strData.length;
  [self writeShort:length];
  
  //  文字データ書き出し
  if ([outputStream write:strData.bytes maxLength:length] != length) {
    @throw NSInvalidArgumentException;
  }
}
@end
