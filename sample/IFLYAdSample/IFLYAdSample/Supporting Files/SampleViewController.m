//
//  SampleViewController.m
//  IFLYAdSample
//
//  Created by JzProl.m.Qiezi on 2016/12/19.
//  Copyright © 2016年 iflytek. All rights reserved.
//

#import "SampleViewController.h"
#import "IFLYAd.h"
#import <CoreLocation/CoreLocation.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>

@interface SampleViewController ()
@property (strong)  CLLocationManager* locationManager;
@end

@implementation SampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 设置调试日志
    [IFLYAdLog setEnabled:YES];
    NSLog(@"SDK version:%@",[IFLYAdTool sdkVersion])
    
    // 请求下地理位置权限
    self.locationManager=[[CLLocationManager alloc]init];
    [self.locationManager requestWhenInUseAuthorization];
    
    // 请求下广告追踪权限
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            NSLog(@"APP 追踪权限：%lu",(unsigned long)status);
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
