//
//  FeedVideoViewController.m
//  IFLYAdSample
//
//  Created by JzProl.m.Qiezi on 2016/12/19.
//  Copyright © 2016年 iflytek. All rights reserved.
//

#import "FeedVideoViewController.h"
#import "IFLYVideoAd.h"
#import "IFLYAdError.h"
@interface FeedVideoViewController ()<UITableViewDelegate,UITableViewDataSource,IFLYVideoAdDelegate>

@end

@implementation FeedVideoViewController{
    IFLYVideoAd  *video;
    UITableView *tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    tableView = [[UITableView  alloc]initWithFrame:self.view.frame];
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"videoexpresscell"];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"splitnativeexpresscell"];
    
    [self.view addSubview:tableView];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if(video){
        [video pausePlay];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row  == 0) {
        return self.view.frame.size.width/16*9;
    } else {
        return 44;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"videoexpresscell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentView.tag = indexPath.row+1;
        
        video = [[IFLYVideoAd alloc]initWithAdUnitId:@"3AE3AC7B093A4CC6A1E2F19CF16709FC"];
        video.currentViewController = self;
        video.delegate = self;
        
        video.didLeaveApp = ^{
            NSLog(@"didLeaveApp");
        };
        
        video.dismissBlock = ^{
            NSLog(@"dismissBlock");
        };
        
        video.scrollView = tableView;
        video.indexPath = indexPath;
    
        video.fatherView = cell.contentView;
        video.fatherViewTag = cell.contentView.tag;
        video.videoType = IFLYVideoAdTypeNative;
        [video loadAd];
    }
    else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"splitnativeexpresscell" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.text = NSLocalizedString(@"测试信息",nil);
    }
    
    return cell;
}




#pragma mark - IFLYVideoAdDelegate

-(void)onVideoAdReceived:(IFLYAdData *)adData{
    [video showAd];
    [video attachAd];
}

-(void)onVideoAdFailed:(IFLYAdError *)error{
    NSLog(@"errorDescription---%@",error.errorDescription);
    NSLog(@"errorCode---%i",error.errorCode);
}

- (void)onVideoAdClicked{
    [video stopPlay];
}

@end
