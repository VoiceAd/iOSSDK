//
//  InterstitialAdViewController.m
//  IFLYAdSample
//
//  Created by JzProl.m.Qiezi on 2016/12/19.
//  Copyright © 2016年 iflytek. All rights reserved.
//

#import "InterstitialAdViewController.h"
#import "IFLYAd.h"

@interface InterstitialAdViewController ()<IFLYInterstitialAdDelegate,UITextFieldDelegate>
@property (nonatomic,strong)   IFLYInterstitialAd * interstitialAd;
@property (nonatomic,weak) IBOutlet UITextField *tf_adUnitId;
@property (nonatomic,weak) IBOutlet UILabel *label;
@end

@implementation InterstitialAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _interstitialAd = [IFLYInterstitialAd sharedInstance];
    _interstitialAd.delegate = self;
    
    _tf_adUnitId.text = @"A5384C3FD0F43DF5DA2BD6F944154F8A";
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
    _label.text = NSLocalizedString(@"requesting AD",nil);
    [_interstitialAd loadAd:_tf_adUnitId.text];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}


#pragma mark - IFLYInterstitialAd DelegateMethod
- (void)onInterstitialAdReceived{
    _label.text = NSLocalizedString(@"success",nil);
    [_interstitialAd showAd];
}

- (void)onInterstitialAdFailed:(IFLYAdError *)error{
    _label.text = [NSString stringWithFormat:@"error:%i",error.errorCode];
}

- (void) onInterstitialAdClosed{
    _label.text = NSLocalizedString(@"closed",);
}

- (void) onInterstitialAdClicked{
    _label.text = NSLocalizedString(@"click",);
}

@end

