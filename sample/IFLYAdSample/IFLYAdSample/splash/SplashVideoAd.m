//
//  SplashVideoAd.m
//  IFLYAdSample
//
//  Created by JzProl.m.Qiezi on 2016/12/19.
//  Copyright © 2016年 iflytek. All rights reserved.
//

#import "SplashVideoAd.h"
#import "SkipButton.h"
#import "IFLYAd.h"

@interface SplashVideoAd ()<IFLYVideoAdDelegate>

@property (nonatomic, strong) IFLYVideoAd *videoAd; // 讯飞videoAd
@property (nonatomic, strong) IFLYAdData *videoAdData;

@property (nonatomic, strong) UIView *fatherView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) SkipButton * skipButton;
@property (nonatomic, strong) UIButton * muteButton;
@property (nonatomic, assign) NSInteger traceDuration;
@property (nonatomic, copy) dispatch_source_t skipTimer;
@property (nonatomic, assign) BOOL hasRemovedUI;
@property (nonatomic, assign) BOOL videoAdIsShowing; // 视频广告是否正在展示


@end



@implementation SplashVideoAd

#pragma mark -生命周期
-(instancetype)initWithLogo:(UIImage *)logo adUnitId:(NSString*)adUnitId{
    self = [super init];
    if (self) {
        [self initConfigWithlogo:logo adUnitId:adUnitId];
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (_videoAd) {
        [_videoAd stopPlay];
        _videoAd = nil;
    }
}

#pragma mark -私有方法
-(void)initConfigWithlogo:(UIImage *)logo adUnitId:(NSString*)adUnitId{
    
    // 1. fatherView
    UIView *fatherView = [[UIView alloc]init];
    
    CGFloat father_width = XH_ScreenW;
    CGFloat father_height = 0;
    if (XH_OverIPhoneX) {
        father_height = XH_ScreenW*16.0/9.0;
        if (father_height < XH_ScreenH *0.8) {
            father_height = XH_ScreenH*0.8;
            father_width  = father_height*9.0/16.0;
        }
    }else{
        father_height = XH_ScreenW*3.0/2.0;
        if (father_height < XH_ScreenH *0.8) {
            father_height = XH_ScreenH*0.8;
            father_width  = father_height*2.0/3.0;
        }
    }
    
    fatherView.frame = CGRectMake(-(father_width - XH_ScreenW)/2.0, 0, father_width, father_height);
    self.fatherView = fatherView;
    self.fatherView.backgroundColor = [UIColor blackColor];
    
    self.videoAd = [[IFLYVideoAd alloc]initWithAdUnitId:adUnitId];
    
    self.videoAd.delegate = self;
    self.videoAd.videoType = IFLYVideoAdTypeSplash;

    self.videoAd.mute = YES;
    self.videoAd.autoPlay = YES;
    [self.videoAd setDerectJump:YES];
    [self.videoAd setParamValue:@NO forKey:IFLYAdKeyNeedLocation];
    [self.videoAd setParamValue:@NO forKey:IFLYAdKeyNeedAudio];
    [self.videoAd setParamValue:@1 forKey:IFLYAdKeyLandingPageTransitionType]
    ;
    __weak typeof(self) weakself = self;
    
    self.videoAd.didJumpBlock = ^(BOOL success) {
        if(!success){
            NSLog(@"didJumpBlock failed");
            if (self.videoAdIsShowing == YES) {
                [weakself.videoAd resumePlay];
            }
        }
    };
    self.videoAd.didLeaveApp = ^{
        NSLog(@"didLeaveApp");
        [weakself removeUI];
    };
    
    self.videoAd.dismissBlock = ^{
        NSLog(@"dismissBlock");
        [weakself removeUI];
    };
    
    
    // 3. containerView
    self.containerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, XH_ScreenW, XH_ScreenH)];
    self.containerView.backgroundColor = [UIColor blackColor];
    self.containerView.alpha = 0.0;
    self.containerView.hidden = YES;


    if (logo) {
        // 4. logoIV
        UIImageView *logoIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.fatherView.frame), XH_ScreenW, XH_ScreenH - CGRectGetMaxY(self.fatherView.frame))];
        logoIV.contentMode = UIViewContentModeCenter;
        logoIV.image = logo;
        [self.containerView addSubview:logoIV];
    }
    
    
}

-(void)removeUI{
    
    if (self.hasRemovedUI == YES) {
        return;
    }
    
    self.hasRemovedUI = YES;
    self.videoAdIsShowing = NO;
    
    if(_skipTimer){
        dispatch_source_cancel(_skipTimer);
        _skipTimer = nil;
    }
    
    if(_skipButton){
        [_skipButton removeFromSuperview];
        _skipButton =nil;
    }
    
    if(_muteButton){
        [_muteButton removeFromSuperview];
        _muteButton=nil;
    }
    
    self.traceDuration = 0;
    
    if (_containerView) {
        [UIView animateWithDuration:0.2 animations:^{
            self.containerView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self removeOnly];
        }];
    }
}

-(void)removeOnly{
    
    if(_skipTimer){
        dispatch_source_cancel(_skipTimer);
        _skipTimer = nil;
    }
    
    if(_skipButton){
        [_skipButton removeFromSuperview];
        _skipButton =nil;
    }
    
    if(_muteButton){
        [_muteButton removeFromSuperview];
        _muteButton=nil;
    }
    
    if (_containerView) {
        [_containerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if(obj){
                [obj removeFromSuperview];
            }
        }];
        [_containerView removeFromSuperview];
        _containerView = nil;
    }
    
    if (_videoAd) {
        [_videoAd stopPlay];
    }
}

-(void)addSkipButton{
    
    SkipType skipType = SkipTypeTimeText;
    if (self.traceDuration <= 0) {
        skipType = SkipTypeText;
    }
    
    self.skipButton = [[SkipButton alloc] initWithSkipType:skipType];
    [self.skipButton addTarget:self action:@selector(skipButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.skipButton setTitleWithSkipType:skipType duration:self.traceDuration];
    [_containerView addSubview:self.skipButton];
    
    if (skipType == SkipTypeTimeText) {
        [self startSkipDispathTimerWithSkipType:skipType];
    }
    
}

-(void)addMuteButton{
    
    CGFloat y = XH_FULLSCREEN ? 44 : 20;
    self.muteButton = [[UIButton alloc] initWithFrame:CGRectMake(13,y, 70, 35)];
    self.muteButton.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.4];
    self.muteButton.titleLabel.textColor =  [UIColor whiteColor];
    self.muteButton.layer.masksToBounds = YES;
    self.muteButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.muteButton.titleLabel.font = [UIFont systemFontOfSize:13.5];
    CGFloat min = self.muteButton.frame.size.height;
    if(self.muteButton.frame.size.height > self.muteButton.frame.size.width) {
        min = self.muteButton.frame.size.width;
    }
    self.muteButton.layer.cornerRadius = min/2.0;
    self.muteButton.layer.masksToBounds = YES;
    
    [self.muteButton addTarget:self action:@selector(muteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.muteButton setTitle:NSLocalizedString(@"关闭声音",nil) forState:UIControlStateNormal];
    [self.muteButton setTitle:NSLocalizedString(@"打开声音",nil) forState:UIControlStateSelected];
    [self.muteButton setSelected:self.videoAd.mute];
    [_containerView addSubview:self.muteButton];
}

-(void)skipButtonClick:(UIButton *)sender{
    [self removeUI];
}

-(void)muteButtonClick:(UIButton *)sender{
    [_videoAd setMute:!_videoAd.mute];
    self.muteButton.selected = !self.muteButton.selected;
}

-(void)startSkipDispathTimerWithSkipType:(SkipType)skipType{
    
    __weak __typeof__(self) weakSelf = self;
    
    NSTimeInterval period = 1.0;
    _skipTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(_skipTimer, dispatch_walltime(NULL, 0), period * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_skipTimer, ^{
        
        __strong __typeof(self) strongSelf = weakSelf;
        
        if (strongSelf) {
            if(strongSelf.traceDuration<=0){
                [strongSelf removeUI];
                return;
            }
            
            [strongSelf.skipButton setTitleWithSkipType:skipType duration:self.traceDuration];
            strongSelf.traceDuration--;
        }
        
    });
    
    dispatch_resume(_skipTimer);
    
}

#pragma mark -外部方法
-(void)loadVideoAd{
    [_videoAd preloadAd];
}

-(void)showVideoAd{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.containerView addSubview:self.fatherView];
        [[[[UIApplication sharedApplication] windows] objectAtIndex:0] addSubview:self.containerView];
        self.videoAd.currentViewController = [[[UIApplication sharedApplication] windows] objectAtIndex:0].rootViewController;
        self.videoAd.fatherView = self.fatherView;
        [self.videoAd showAd];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationUnActive) name:UIApplicationWillResignActiveNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onApplicationActive) name:UIApplicationWillEnterForegroundNotification object:nil];
    });
    
}

#pragma mark - 前后台系统通知的监听
- (void)onApplicationUnActive {
    NSLog(@"video ad 不活跃");
}

- (void)onApplicationEnterBackground {
    NSLog(@"video ad 进入后台");
    if (self.videoAdIsShowing == YES) {
        [self removeUI];
    }
}


- (void)onApplicationActive {
    NSLog(@"video ad 回到前台");
    if (self.videoAdIsShowing == YES) {
//        [self removeUI];
        [self.videoAd resumePlay];
    }
}


#pragma mark - IFLYVideoAdDelegate
-(void)onVideoAdReceived:(IFLYAdData *)videoAdData{
    NSLog(@"video onVideoAdReceived");
}

-(void)onVideoAdFailed:(IFLYAdError *)error{
     NSLog(@"video onVideoAdFailed error:%d",error.errorCode);
}

-(void)onPreloadSuccess:(IFLYAdData *)videoAdData withSize:(CGSize)videoSize{
    
    NSLog(@"video onPreloadSuccess");

    self.videoAdData = videoAdData;

    if (isStringEmpty(videoAdData.video.url)) {
        [self removeOnly];
    }else{

        // 2.2 记录视频时长
        if (self.videoAdData.video.duration) {
            self.traceDuration = [self.videoAdData.video.duration integerValue];
        }else{
            self.traceDuration = 0;
        }
        [self showVideoAd];

    }
}

-(void)onPreloadFailed:(IFLYAdError *)error{
    NSLog(@"video onPreloadFailed error:%d",error.errorCode);
    [self removeOnly];
}

- (void)onVideoAdClicked{
    NSLog(@"video onVideoAdClicked");
    [self.videoAd pausePlay];
//    [self.containerView removeFromSuperview];
}

/**
 *  视频开始播放
 */
- (void)adStartPlay{
    
    NSLog(@"adStartPlay");
    self.videoAdIsShowing = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.videoAd.mute = YES;
        //  渲染UI
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowAnimatedContent | UIViewAnimationOptionAllowUserInteraction  animations:^{
            self.containerView.alpha = 1.0;
            self.containerView.hidden = NO;
        }completion:^(BOOL finished) {
           [self.videoAd attachWindowAd:nil];
        }];
        [self addSkipButton];
        [self addMuteButton];
        
    });
    
}
/**
 *  视频播放出错
 */
- (void)adPlayError{
    NSLog(@"adPlayError");
    [self removeOnly];
}
/**
 *  视频播放结束
 */
- (void)adPlayCompleted{
    NSLog(@"adPlayCompleted");
    [self removeUI];
}

@end
