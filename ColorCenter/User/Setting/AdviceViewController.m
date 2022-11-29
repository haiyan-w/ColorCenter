//
//  AdviceViewController.m
//  EnochCar
//
//  Created by 王海燕 on 2022/2/22.
//

#import "AdviceViewController.h"
#import "CommonTool.h"
#import "CommonButton.h"
#import "CommonTextView.h"
#import "UIView+Hint.h"
#import "NetWorkAPIManager.h"

@interface AdviceViewController ()
@property(nonatomic,strong) CommonButton * commitBtn;
@property(nonatomic,strong) CommonTextView * adviceTV;

@end

@implementation AdviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.midTitle = @"建议";
    
    self.adviceTV = [[CommonTextView alloc] initWithFrame:CGRectMake(20, (self.navbarView.frame.origin.y + self.navbarView.frame.size.height + 24), self.view.frame.size.width - 2*20 , 140)];
    self.adviceTV.placeHolder = @"说说你的建议或遇到的问题~";
    [self.view addSubview:self.adviceTV];
    
    self.commitBtn = [[CommonButton alloc] initWithFrame:CGRectMake(20, self.view.frame.size.height - 48 - [CommonTool bottomSpace] , self.view.frame.size.width - 2*20, 48) normalTitle:@"提交" disabledTitle:@"提交"];
    [self.commitBtn addTarget:self action:@selector(commitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.commitBtn];
}


-(void)commitBtnClick
{
    [CommonTool resign];
    
    if (![self.adviceTV getText] || [self.adviceTV getText].length <= 0 ) {
        [CommonTool showHint:@"内容不能为空"];
        return;
    }
    [[NetWorkAPIManager defaultManager] feedbackWithContent:[self.adviceTV getText] success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.adviceTV setText:@""];
        [CommonTool showHint:@"发送成功"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [CommonTool showError:error];
    }];
}

@end
