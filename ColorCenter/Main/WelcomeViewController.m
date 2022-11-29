//
//  WelcomeViewController.m
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/9.
//

#import "WelcomeViewController.h"
#import "UIView+Frame.h"
#import "UIColor+CustomColor.h"


@interface WelcomeViewController ()


@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor bgBlackColor];
    
    UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.right - 343)/2.0, (self.view.bottom - 234)/2.0, 343, 234)];
    imgView.image = [UIImage imageNamed:@"welcome"];
    [self.view addSubview:imgView];
    
    UIButton * closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(imgView.right - 36 - 58, imgView.top - 20 -36, 36, 36)];
    [closeBtn setImage:[UIImage imageNamed:@"X_round"] forState:UIControlStateNormal];
    [self.view addSubview:closeBtn];
    
    [closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
}

- (void)close
{
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
}



@end
