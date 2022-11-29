//
//  AgreementViewController.m
//  EnochCar
//
//  Created by 王海燕 on 2021/6/3.
//

#import "AgreementViewController.h"
#import <WebKit/WebKit.h>
#import "CommonTool.h"

@interface AgreementViewController ()
@property (strong, nonatomic) NSString *resource;
@end

@implementation AgreementViewController

-(instancetype)initWithResource:(NSString *)resourceStr
{
    self = [super init];
    if (self) {
        self.resource = resourceStr;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton * closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(4, [CommonTool statusbarH]+2, 40, 40)];
    [closeBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    
    CGFloat orgY = [CommonTool topbarH];
    WKWebView * agreementView = [[WKWebView alloc] initWithFrame:CGRectMake(0, orgY, self.view.bounds.size.width, self.view.bounds.size.height-orgY)];
    NSURL *url = [NSURL URLWithString:self.resource];
    [agreementView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:agreementView];
  
}

-(void)showIn:(UIViewController *)viewCtrl
{
    [viewCtrl addChildViewController:self];
    [viewCtrl.view addSubview:self.view];
}

-(void)closed
{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

@end
