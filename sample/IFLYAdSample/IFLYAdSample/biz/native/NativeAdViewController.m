//
//  NativeAdViewController.m
//  IFLYAdSample
//
//  Created by JzProl.m.Qiezi on 2016/12/19.
//  Copyright © 2016年 iflytek. All rights reserved.
//

#import "NativeAdViewController.h"
#import "TypedNativeAdViewController.h"

@interface NativeAdViewController ()

@end

@implementation NativeAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"one"]) {
        // segue.destinationViewController：获取连线时所指的界面（VC）
        TypedNativeAdViewController *receive = segue.destinationViewController;
        receive.type = @"one";

    }else if ([segue.identifier isEqualToString:@"more"]){
        TypedNativeAdViewController *receive = segue.destinationViewController;
        receive.type = @"more";
    }
}


@end
