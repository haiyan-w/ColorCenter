//
//  BaseViewController.m
//  EnochCar
//
//  Created by 王海燕 on 2021/7/28.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
#import "CommonTool.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect bounds = [UIScreen mainScreen].bounds;
    if (bounds.size.width > bounds.size.height) {
        self.view.frame = CGRectMake(0, 0, bounds.size.height, bounds.size.width);
    }else {
        self.view.frame = CGRectMake(0, 0, bounds.size.width, bounds.size.height);
    }
    [self.view layoutSubviews];//解决界面bounds不对问题
}

//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear: animated];
//    
//    AppDelegate *appdelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
//    if ([CommonTool isIPad]) {
//        appdelegate.shouldLandscapeRight = YES;
//    }else {
//        appdelegate.shouldLandscapeRight = FALSE;
//    }
//    
//    [appdelegate application:[UIApplication sharedApplication] supportedInterfaceOrientationsForWindow:self.view.window];
//    
//    [self listenNetworkReachabilityStatus];
//}
//
//- (void)listenNetworkReachabilityStatus {
//    AFNetworkReachabilityManager * afManager = [AFNetworkReachabilityManager sharedManager];
//    __weak BaseViewController * weakself = self;
//    [afManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        weakself.netStatus = status;
//        [weakself networkStatusChanged:status];
//    }];
//    
//    // 开始监听
//    [afManager startMonitoring];
//}
//
//-(void)setNetStatus:(AFNetworkReachabilityStatus)netStatus
//{
//    if ((netStatus == AFNetworkReachabilityStatusNotReachable)||((netStatus == AFNetworkReachabilityStatusUnknown))) {
//        self.isNetworkOn = NO;
//    }else {
//        self.isNetworkOn = YES;
//    }
//}
//
//-(void)networkStatusChanged:(AFNetworkReachabilityStatus)status
//{
//    
//}

@end
