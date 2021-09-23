//
//  LogViewController.m
//  IFLYAdSample
//
//  Created by JzProl.m.Qiezi on 2016/12/19.
//  Copyright © 2016年 iflytek. All rights reserved.
//

#import "LogViewController.h"

@interface LogViewController ()

@end

@implementation LogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tv.text = @"注意：广告日志在缓存大于100条或应用进入后台时才会存储到文件。若无法看到日志，可先将应用退出到后台，再次打开。";
    [self loadLogFile];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadLogFile{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cachePath = [cachePaths objectAtIndex:0];
        NSString *filepath = [cachePath stringByAppendingPathComponent:@"IFLYAd.log"];
        
        if (![[NSFileManager defaultManager]fileExistsAtPath:filepath]){
            return;
        }
        
        NSError *error = nil;
        NSString *str = [[NSString alloc] initWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:&error];
        if(error){
            NSLog(@"load log failed with error :%@",error);
            return;
        }
        if(!str || [str length]<1){
            NSLog(@"log file nil or zero length. ");
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.tv.text = @"";
            self.tv.text = str;
            self.tv.layoutManager.allowsNonContiguousLayout = NO;
        });
    });
}

- (IBAction)clear:(id)sender {
    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [cachePaths objectAtIndex:0];
    NSString *filepath = [cachePath stringByAppendingPathComponent:@"IFLYAd.log"];
    
    if (![[NSFileManager defaultManager]fileExistsAtPath:filepath]){
        return;
    }
    NSError *error = nil;
    [@"" writeToFile:filepath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    _tv.text = nil;
 }

- (IBAction)backTop:(id)sender {
    [_tv scrollRangeToVisible:NSMakeRange(0, 1)];
}

- (IBAction)backBottom:(id)sender {
    [_tv scrollRangeToVisible:NSMakeRange(_tv.text.length, 1)];
}
@end
