//
//  TypedNativeAdViewController.m
//  IFLYAdSample
//
//  Created by JzProl.m.Qiezi on 2016/12/19.
//  Copyright © 2016年 iflytek. All rights reserved.
//

#import "TypedNativeAdViewController.h"
#import "IFLYAd.h"


@interface TypedNativeAdViewController ()<IFLYNativeAdDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *tf_adUnitId;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *adView;
@property (weak, nonatomic) IBOutlet UITextView *recText;

@property (weak, nonatomic) IBOutlet UITextField *bidfloor;
@property (weak, nonatomic) IBOutlet UITextField *pmp_id;
@property (weak, nonatomic) IBOutlet UITextField *pmp_bi;
@property (weak, nonatomic) IBOutlet UITextField *auction;

@end

@implementation TypedNativeAdViewController{
    IFLYNativeAd *nativeAd;
    IFLYAdData *_currentAd;
    BOOL _attached;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _tf_adUnitId.borderStyle = UITextBorderStyleRoundedRect;
    _tf_adUnitId.delegate=self;
    _bidfloor.delegate=self;
    _pmp_id.delegate=self;
    _pmp_bi.delegate=self;
    _auction.delegate=self;
    
    
    if ([_type isEqualToString:@"one"]) {
        _tf_adUnitId.text = @"24556006C29E3C51A624F4B704BC7345";
    }
    if ([_type isEqualToString:@"more"]) {
        _tf_adUnitId.text = @"CE6F8624BCEC3F7AD0257E9EDD224CE0";
    }
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)buttonClick:(id)sender {
    [self keyboardHide:nil];
    
    _errorLabel.text =NSLocalizedString(@"requesting AD",nil);
    _recText.text = @"";
    
    nativeAd = [[IFLYNativeAd alloc] initWithAdUnitId:_tf_adUnitId.text];
    nativeAd.currentViewController =self;
    nativeAd.delegate = self;
    
    nativeAd.didLeaveApp = ^{
        NSLog(@"didLeaveApp");
    };
    
    nativeAd.dismissBlock = ^{
        NSLog(@"dismissBlock");
    };
    
    if (_bidfloor.text.length > 0) {
        [nativeAd setParamValue:_bidfloor.text forKey:IFLYAdKeyBIDFloor];
    }
    if (_pmp_id.text.length > 0 && _pmp_bi.text.length > 0) {
        NSMutableArray<IFLYAdDeal*>* deals = [NSMutableArray<IFLYAdDeal*> arrayWithCapacity:1];
        IFLYAdDeal* deal = [[IFLYAdDeal alloc] init];
        deal.id = _pmp_id.text;
        deal.bidFlool = [_pmp_bi.text doubleValue];
        [deals addObject:deal];
        [nativeAd setParamValue:deals forKey:IFLYAdKeyPMP];
    }
    if (_auction.text.length > 0) {
        [nativeAd setParamValue:_auction.text forKey:IFLYAdKeyAuctionPrice];
    }
    
    [nativeAd loadAd];
}


-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [_tf_adUnitId resignFirstResponder];
    [_bidfloor resignFirstResponder];
    [_pmp_id resignFirstResponder];
    [_pmp_bi resignFirstResponder];
    [_auction resignFirstResponder];
}

- (void)adViewTapped:(UITapGestureRecognizer *)tap {
    [nativeAd clickAd:_adView];
}


- (IBAction)receiveData:(id)sender {
    if ([_type isEqualToString:@"more"]) {
        _recText.text = [NSString stringWithFormat:@"mark: %@  \niconUrl:%@  \ntitle:%@  \ndesc:%@ ",_currentAd.ad_source_mark,_currentAd.icon.url,_currentAd.title,_currentAd.desc];
    }else{
       _recText.text = [NSString stringWithFormat:@"mark: %@     \nimgUrl:%@  \niconUrl:%@  \ntitle:%@  \ndesc:%@ ",_currentAd.ad_source_mark,_currentAd.img.url,_currentAd.icon.url,_currentAd.title,_currentAd.desc];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}

#pragma mark - IFLYNativeAdDelegate

-(void)onNativeAdReceived:(IFLYAdData *)adData {
    
    _errorLabel.text = NSLocalizedString(@"success",nil);
    for(UIView *view in [_adView subviews]){
        [view removeFromSuperview];
    }
    
    _currentAd = adData;
    
    /*开始渲染广告界面*/
    _adView.layer.borderWidth = 1;
    _adView.layer.borderColor = [UIColor redColor].CGColor;
    
    if ([_type isEqualToString:@"more"]) {
        /*广告详情图*/
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 70, _adView.frame.size.width/3, 120)];
        [_adView addSubview:imgV];
//        NSURL *imageURL = [NSURL URLWithString:_currentAd.img1.url];
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                imgV.image = [UIImage imageWithData:imageData];
//            });
//        });
        
        [IFLYAdTool downloadImageFromURL:_currentAd.img1.url completed:^(UIImage * _Nonnull image, NSError * _Nonnull error, NSURL * _Nonnull imageURL) {
            if(!error){
                imgV.image = image;
            }
        }];
        
        UIImageView *imgV1 = [[UIImageView alloc] initWithFrame:CGRectMake(_adView.frame.size.width/3, 70, _adView.frame.size.width/3, 120)];
        [_adView addSubview:imgV1];
//        NSURL *imageURL1 = [NSURL URLWithString:_currentAd.img2.url];
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//            NSData *imageData1 = [NSData dataWithContentsOfURL:imageURL1];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                imgV1.image = [UIImage imageWithData:imageData1];
//            });
//        });
        
        [IFLYAdTool downloadImageFromURL:_currentAd.img2.url completed:^(UIImage * _Nonnull image, NSError * _Nonnull error, NSURL * _Nonnull imageURL) {
            if(!error){
                imgV1.image = image;
            }
        }];
        
        UIImageView *imgV2 = [[UIImageView alloc] initWithFrame:CGRectMake(_adView.frame.size.width*2/3, 70, _adView.frame.size.width/3, 120)];
        [_adView addSubview:imgV2];
//        NSURL *imageURL2 = [NSURL URLWithString:_currentAd.img3.url];
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//            NSData *imageData2 = [NSData dataWithContentsOfURL:imageURL2];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                imgV2.image = [UIImage imageWithData:imageData2];
//            });
//        });
        
        [IFLYAdTool downloadImageFromURL:_currentAd.img3.url completed:^(UIImage * _Nonnull image, NSError * _Nonnull error, NSURL * _Nonnull imageURL) {
            if(!error){
                imgV2.image = image;
            }
        }];
    }else{
        /*广告详情图*/
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 70, _adView.frame.size.width, 120)];
        [_adView addSubview:imgV];
//        NSURL *imageURL = [NSURL URLWithString:_currentAd.img.url];
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                imgV.image = [UIImage imageWithData:imageData];
//            });
//        });
        
        [IFLYAdTool downloadImageFromURL:_currentAd.img.url completed:^(UIImage * _Nonnull image, NSError * _Nonnull error, NSURL * _Nonnull imageURL) {
            if(!error){
                imgV.image = image;
            }
        }];

    }
    
    /*广告Icon*/
    UIImageView *iconV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 60, 60)];
    [_adView addSubview:iconV];
//    NSURL *iconURL = [NSURL URLWithString:_currentAd.icon.url];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//        NSData *imageData = [NSData dataWithContentsOfURL:iconURL];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            iconV.image = [UIImage imageWithData:imageData];
//        });
//    });
    
    [IFLYAdTool downloadImageFromURL:_currentAd.icon.url completed:^(UIImage * _Nonnull image, NSError * _Nonnull error, NSURL * _Nonnull imageURL) {
        if(!error){
            iconV.image = image;
        }
    }];
    
    /*广告标题*/
    UILabel *txt = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, _adView.frame.size.width-20, 35)];
    txt.text = _currentAd.title;
    [_adView addSubview:txt];
    
    /*广告描述*/
    UILabel *desc = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, _adView.frame.size.width-20, 20)];
    desc.text = _currentAd.content;
    [_adView addSubview:desc];
    
    /*注册点击事件*/
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adViewTapped:)];
    [_adView addGestureRecognizer:tap];
    
    [nativeAd attachAd:_adView];
    
}

-(void)onNativeAdFailed:(IFLYAdError *)error{
    _errorLabel.text = [NSString stringWithFormat:@"error:%i",error.errorCode];
}

@end
