//
//  BannerAdViewController.m
//  IFLYAdSample
//
//  Created by JzProl.m.Qiezi on 2016/12/19.
//  Copyright © 2016年 iflytek. All rights reserved.
//

#import "BannerAdViewController.h"

#import "IFLYAd.h"

@interface BannerAdViewController ()<IFLYBannerAdDelegate,UITextFieldDelegate>
@property(strong,nonatomic)  IFLYBannerAd * banner;
@property (weak, nonatomic) IBOutlet UITextField *tf_adUnitId;
@property (weak, nonatomic) IBOutlet UILabel *label;
@end

@implementation BannerAdViewController

- (void)dealloc
{
    if(self.banner){
        self.banner.delegate =nil;
        self.banner.currentViewController =nil;
        [[self.banner bannerAdView] removeFromSuperview];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _banner = [[IFLYBannerAd alloc]initWithOrigin:CGPointMake(0, 200)];
    _banner.delegate = self;
    _banner.currentViewController =self;
    
    _tf_adUnitId.text = @"19CDBA6E9E7131095B1C4F1B7FCB0D7C";
    _tf_adUnitId.borderStyle = UITextBorderStyleRoundedRect;
    _tf_adUnitId.delegate=self;
    [self.view addSubview:[_banner bannerAdView]];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (IBAction)buttonClick:(id)sender {
    [self.tf_adUnitId resignFirstResponder];
    _label.text = NSLocalizedString(@"requesting AD",nil);
    [_banner loadAd:_tf_adUnitId.text];
//    [_banner setParamValue:[NSNumber numberWithInt:25] forKey:IFLYAdKeyBannerInterval];
//    [_banner loadAd:_tf_adUnitId.text autoRequest:YES];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.tf_adUnitId resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}

#pragma mark IFLYBannerAdDelegate

/**
 *  请求横幅广告成功
 */
- (void) onBannerAdReceived:(IFLYBannerAd *)banner{
    [_label setText:NSLocalizedString(@"success",nil)];
}
/**
 *  请求横幅广告错误
 *
 *  @param errorCode 错误码，详见入门手册
 */
- (void) onBannerAdFailed:(IFLYAdError *)errorCode {
   [_label setText:[NSString stringWithFormat:@"error:%i",errorCode.errorCode]];
}

/**
 *  广告被点击
 */
- (void)onBannerAdClicked {
    [_label setText:NSLocalizedString(@"click",nil)];
}

/**
 *  横幅广告关闭回调
 */
- (void)onBannerAdClosed {
    [_label setText:NSLocalizedString(@"closed",nil)];
}


@end

