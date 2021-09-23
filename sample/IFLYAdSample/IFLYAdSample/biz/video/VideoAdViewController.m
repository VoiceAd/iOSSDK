//
//  VideoAdViewController.m
//  IFLYAdSample
//
//  Created by JzProl.m.Qiezi on 2016/12/19.
//  Copyright © 2016年 iflytek. All rights reserved.
//

#import "VideoAdViewController.h"
#import "PatchVideoViewController.h"
#import "FullScreenVideoViewController.h"
#import "FeedVideoViewController.h"

@interface VideoAdViewController () 

@end

@implementation VideoAdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

- (IBAction)full:(id)sender {
    FullScreenVideoViewController *full = [[FullScreenVideoViewController alloc]init];
    [self.navigationController pushViewController:full animated:YES];
}

- (IBAction)patch:(id)sender {
    PatchVideoViewController *patch = [[PatchVideoViewController alloc]init];
    [self.navigationController pushViewController:patch animated:YES];
}
- (IBAction)feed:(id)sender {
    FeedVideoViewController *feed = [[FeedVideoViewController alloc]init];
    [self.navigationController pushViewController:feed animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
