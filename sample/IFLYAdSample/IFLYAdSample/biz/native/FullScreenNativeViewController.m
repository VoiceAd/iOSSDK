//
//  FullScreenNativeViewController.m
//  IFLYAdSample
//
//  Created by JzProl.m.Qiezi on 2016/12/19.
//  Copyright © 2016年 iflytek. All rights reserved.
//

#import "FullScreenNativeViewController.h"
#import "SplashNativeAd.h"
#import <AVFoundation/AVFoundation.h>

@interface FullScreenNativeViewController()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *tf_adUnitId;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@property (nonatomic,strong)SplashNativeAd *nativeAd;

@end

@implementation FullScreenNativeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _tf_adUnitId.text = @"9F080A5F0B7277EF3D0EEC45C8500E10";
    
    _tf_adUnitId.borderStyle = UITextBorderStyleRoundedRect;
    _tf_adUnitId.delegate=self;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self.tf_adUnitId resignFirstResponder];
}

- (IBAction)buttonClick:(id)sender {
    [self.tf_adUnitId resignFirstResponder];
    SplashNativeAd *nativeAd = [[SplashNativeAd alloc] initWithLogo:nil adUnitId:_tf_adUnitId.text];
    self.nativeAd = nativeAd;
    [nativeAd loadNativeAd];
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

