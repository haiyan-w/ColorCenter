//
//  AppDelegate.m
//  ColorCenter
//
//  Created by 王海燕 on 2022/10/19.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "DeviceViewController.h"
#import "UserViewController.h"
#import "LoginViewController.h"
#import "CommonDefine.h"
#import "UIColor+CustomColor.h"


@interface AppDelegate ()
@property(nonatomic,readwrite,strong) MainViewController * mainCtrl;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] init];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self showLoginView];
    [self addNotify];
    
    return YES;
}

-(void)addNotify
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSucess) name:NOTIFICATION_LOGIN_SUCCESS object:NULL];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutSucess) name:NOTIFICATION_LOGOUT_SUCCESS object:NULL];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(agreement) name:NOTIFICATION_Agreement object:NULL];
}


- (void)showLoginView
{
    LoginViewController * loginCtrl = [[LoginViewController alloc] init];
    UINavigationController * navCtrl = [[UINavigationController alloc] initWithRootViewController:loginCtrl];
    navCtrl.navigationBar.barStyle = UIBarStyleDefault;
    navCtrl.navigationBarHidden = YES;
    self.window.rootViewController = navCtrl;
    
    [self.window makeKeyAndVisible];
}

- (void)showMainView
{
    MainViewController * mainCtrl = [[MainViewController alloc] init];
    mainCtrl.tabBarItem.title = @"首页";
    mainCtrl.tabBarItem.image = [UIImage imageNamed:@"main_sel"];
    mainCtrl.tabBarItem.selectedImage = [UIImage imageNamed:@"main_sel"];
    
    DeviceViewController * deviceCtrl = [[DeviceViewController alloc] init];
    deviceCtrl.tabBarItem.title = @"设备";
    deviceCtrl.tabBarItem.image = [UIImage imageNamed:@"device"];
    deviceCtrl.tabBarItem.selectedImage = [UIImage imageNamed:@"device"];
    
    UserViewController * userCtrl = [[UserViewController alloc] init];
    userCtrl.tabBarItem.title = @"我的";
    userCtrl.tabBarItem.image = [UIImage imageNamed:@"user"];
    userCtrl.tabBarItem.selectedImage = [UIImage imageNamed:@"user"];
    
    UITabBarController * tab = [[UITabBarController alloc] init];
    [tab setViewControllers:@[mainCtrl, deviceCtrl, userCtrl]];
    tab.tabBar.tintColor = [UIColor tintColor];
    tab.tabBar.unselectedItemTintColor = [UIColor darkTextColor];
    tab.tabBar.backgroundImage = [UIImage imageNamed:@"bg_white"];
    tab.tabBar.layer.shadowColor = [UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:0.1].CGColor;
    tab.tabBar.layer.shadowOffset = CGSizeMake(0,-1);
    tab.tabBar.layer.shadowOpacity = 1;
    tab.tabBar.layer.shadowRadius = 5;
    
    UINavigationController * navCtrl = [[UINavigationController alloc] initWithRootViewController:tab];
    navCtrl.navigationBar.barStyle = UIBarStyleDefault;
    navCtrl.navigationBarHidden = YES;
    self.window.rootViewController = navCtrl;
    
    [self.window makeKeyAndVisible];
    
}


-(void)agreement
{
//    if (self.isUMengInit) {
//        return;
//    }
//    self.isUMengInit = YES;
}

-(void)loginSucess
{
    //绑定账号
//    NSString * ssoUserId = [NetWorkAPIManager defaultManager].curUser.ssoUserId;
    
//    [CloudPushSDK bindAccount:ssoUserId withCallback:^(CloudPushCallbackResult *res) {
//        if (res.success){
//
//        }else {
//            NSLog(@"bindAccount error");
//        }
//
//    }];
    [self dataInit];
    [self showMainView];

}

-(void)logoutSucess
{
//    [CloudPushSDK unbindAccount:^(CloudPushCallbackResult *res) {
//        if (res.success){
//
//        }else {
//            NSLog(@"unbindAccount error");
//        }
//    }];
    
    _mainCtrl = nil;
    [self showLoginView];
    
}

-(void)dataInit
{

    
    
}

@end
