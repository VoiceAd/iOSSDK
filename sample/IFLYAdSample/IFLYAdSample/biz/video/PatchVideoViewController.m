//
//  PatchVideoViewController.m
//  IFLYAdSample
//
//  Created by JzProl.m.Qiezi on 2016/12/19.
//  Copyright © 2016年 iflytek. All rights reserved.
//

#import "PatchVideoViewController.h"
#import "IFLYVideoAd.h"
#import "IFLYAdData.h"
#import "IFLYAdError.h"

@interface PatchVideoViewController ()<IFLYVideoAdDelegate>

@end

@implementation PatchVideoViewController{
    IFLYVideoAd  *video;
    UILabel *textLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    video = [[IFLYVideoAd alloc]initWithAdUnitId:@"4FD6D66E06506E31B431209A80189614"];
    video.currentViewController = self;
    video.delegate = self;
    
    video.didLeaveApp = ^{
        NSLog(@"didLeaveApp");
    };
    
    video.dismissBlock = ^{
        NSLog(@"dismissBlock");
    };
    
    UIView *fatherView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, self.view.frame.size.width/16*9)];
    fatherView.backgroundColor  = [UIColor whiteColor];
    
    [self.view addSubview:fatherView];
    
    video.fatherView = fatherView;
    video.mute = YES;
    video.autoPlay = YES;
    video.videoType = IFLYVideoAdTypeReward;
    
    [video loadAd];
    
    textLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 330, 100, 20)];
    [self.view addSubview:textLabel];
    
    UIButton *button_add = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button_add setFrame:CGRectMake(20, 350, 90, 50)];
    [button_add setTitle:NSLocalizedString(@"请求广告",nil) forState:UIControlStateNormal];
    [button_add setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [button_add addTarget:self action:@selector(buttonAD) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button_add];
    
    
    UIButton *button_play = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button_play setFrame:CGRectMake(120, 350, 90, 50)];
    [button_play setTitle:NSLocalizedString(@"播放",nil) forState:UIControlStateNormal];
    [button_play setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [button_play addTarget:self action:@selector(button_play) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button_play];
    
    
    UIButton *button_click = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button_click setFrame:CGRectMake(220, 350, 90, 50)];
    [button_click setTitle:NSLocalizedString(@"点击",nil) forState:UIControlStateNormal];
    [button_click setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [button_click addTarget:self action:@selector(button_click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button_click];
    
    UIButton *button_mute = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button_mute setFrame:CGRectMake(20, 420, 90, 50)];
    [button_mute setTitle:NSLocalizedString(@"静音",nil) forState:UIControlStateNormal];
    [button_mute setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [button_mute addTarget:self action:@selector(button_mute) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button_mute];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if(video){
        [video stopPlay];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}



-(void)buttonAD{
    [textLabel setText:@""];
    [video loadAd];
}

-(void)button_play{
    [video attachAd];
    [video startPlay];
}

-(void)button_click{
    [video clickAd];
    [video stopPlay];
}

-(void)button_mute{
    if (video.mute) {
        video.mute = NO;
    }else{
        video.mute = YES;
    }
}

- (void) adStartPlay{
    NSLog(@"播放开始");
}
/**
 *  视频播放出错
 */
- (void) adPlayError{
     NSLog(@"播放错误");
}
/**
 *  视频播放结束
 */
- (void) adPlayCompleted{
    NSLog(@"播放完成");
}

#pragma mark - IFLYVideoAdDelegate

-(void)onVideoAdReceived:(IFLYAdData *)adData{
    NSLog(@"onVideoAdReceived");
    [video showAd];
    [video attachAd];
}

-(void)onVideoAdFailed:(IFLYAdError *)error{
    NSLog(@"errorDescription---%@",error .errorDescription);
    NSLog(@"errorCode---%i",error .errorCode);
    [textLabel setText:[NSString stringWithFormat:@"%i",error.errorCode]];
}

- (void)onVideoAdClicked{
    [video stopPlay];
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
