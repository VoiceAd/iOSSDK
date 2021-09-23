//
//  FullScreenVideoViewController.m
//  IFLYAdSample
//
//  Created by JzProl.m.Qiezi on 2016/12/19.
//  Copyright © 2016年 iflytek. All rights reserved.
//

#import "FullScreenVideoViewController.h"
#import "SplashVideoAd.h"

@interface FullScreenVideoViewController ()<UITextFieldDelegate>

@property (nonatomic,strong)UITextField *tf_adUnitId;

@property (nonatomic,strong)SplashVideoAd *videoAd;

@end

@implementation FullScreenVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor whiteColor];
    
    _tf_adUnitId = [[UITextField alloc] initWithFrame:CGRectMake(20, 94, XH_ScreenW-150, 30)];
    _tf_adUnitId.borderStyle = UITextBorderStyleRoundedRect;
    _tf_adUnitId.delegate = self;
    self.tf_adUnitId.text = @"4FD6D66E06506E31B431209A80189614";
    [self.view addSubview:_tf_adUnitId];
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(XH_ScreenW-110, 84, 90, 50)];
    [button setTitle:NSLocalizedString(@"请求广告",nil) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (IBAction)buttonClick:(id)sender {
    [self.tf_adUnitId resignFirstResponder];
    SplashVideoAd *videoAd = [[SplashVideoAd alloc] initWithLogo:nil adUnitId:_tf_adUnitId.text];
    self.videoAd = videoAd;
    [videoAd loadVideoAd];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.tf_adUnitId resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}


@end
