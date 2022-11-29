//
//  MainViewController.m
//  ColorCenter
//
//  Created by 王海燕 on 2022/10/19.
//

#import "MainViewController.h"
#import "BlueToothManager.h"
#import "CommonSearchText.h"
#import "BlueToothViewController.h"
#import "UIColor+CustomColor.h"
#import "PopMenu.h"
#import "UIView+Frame.h"
#import "TextTabView.h"
#import "JobView.h"
#import "TextTabScrollView.h"
#import "WelcomeViewController.h"
//#import "CommonDefine.h"
#import "SearchViewController.h"
#import "CommonTool.h"

@interface MainViewController () <PopMenuDelegate, UITextFieldDelegate>
@property (strong, nonatomic) UIImageView * bgImg;
@property (nonatomic, strong) UIView * navView;
@property (nonatomic, strong) UIButton * bleConnectBtn;
@property (nonatomic, assign) BOOL bleConnected;
@property (nonatomic, strong) UIButton * moreBtn;
@property (nonatomic, strong) CommonSearchText * searchTextView;
@property (nonatomic, strong) UIView * disConnectView;

@property (nonatomic, strong) TextTabScrollView * tabScrollView;
@property (nonatomic, strong) JobView * jobView;
@property (nonatomic, strong) UIView * collectView;


@end

@implementation MainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor bgWhiteColor];
    
    self.bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 218)];
    self.bgImg.image = [UIImage imageNamed:@"bgImg"];
    [self.view addSubview:self.bgImg];
    
    self.navView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, 48)];
    [self.view addSubview:self.navView];
    
    self.bleConnectBtn = [[UIButton alloc] initWithFrame:CGRectMake(16,6, 48, 36)];
    [self.bleConnectBtn addTarget:self action:@selector(bleConnectBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.bleConnectBtn.backgroundColor = [UIColor customRedColor];
    self.bleConnectBtn.layer.cornerRadius = 18;
    [self.bleConnectBtn setImage:[UIImage imageNamed:@"unlink"] forState:UIControlStateNormal];
    [self.navView addSubview:self.bleConnectBtn];
    
    self.moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.navView.frame.size.width - 16 - 28,10, 28, 28)];
    [self.moreBtn addTarget:self action:@selector(moreBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.moreBtn setImage:[UIImage imageNamed:@"add_round"] forState:UIControlStateNormal];
    [self.navView addSubview:self.moreBtn];
    
    self.searchTextView = [[CommonSearchText alloc] initWithFrame:CGRectMake(80, 6, self.navView.frame.size.width - 80-60, 36)];
    self.searchTextView.layer.borderColor = [UIColor clearColor].CGColor;
    self.searchTextView.textField.placeholder = @"搜索";
    self.searchTextView.delegate = self;
    [self.navView addSubview:self.searchTextView];
    
    self.disConnectView = [[UIView alloc] initWithFrame:CGRectMake(16, (self.navView.frame.origin.y + self.navView.frame.size.height +12), self.view.frame.size.width-2*16, 48)];
    self.disConnectView.backgroundColor = [UIColor whiteColor];
    self.disConnectView.layer.cornerRadius = 8;
    [self.view addSubview:self.disConnectView];
    
    UIImageView * icon = [[UIImageView alloc] initWithFrame:CGRectMake(16, 12, 24, 24)];
    icon.image = [UIImage imageNamed:@"disconnect"];
    [self.disConnectView addSubview:icon];
    
    UIButton * toConnectBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.disConnectView.frame.size.width - 16 - 70, 12, 70, 24)];
    toConnectBtn.backgroundColor = [UIColor colorWithRed:227/255.0 green:77/255.0 blue:89/255.0 alpha:1];
    [toConnectBtn setTitle:@"立即连接" forState:UIControlStateNormal];
    [toConnectBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [toConnectBtn addTarget:self action:@selector(toConnectBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    toConnectBtn.layer.cornerRadius = 12;
    toConnectBtn.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    
    toConnectBtn.layer.shadowColor = [UIColor colorWithRed:227/255.0 green:77/255.0 blue:89/255.0 alpha:0.3].CGColor;
    toConnectBtn.layer.shadowOffset = CGSizeMake(0, 4);
    toConnectBtn.layer.shadowRadius = 8;
    toConnectBtn.layer.shadowOpacity = 1;
    [self.disConnectView addSubview:toConnectBtn];
    
    UILabel * disConnectLab = [[UILabel alloc] initWithFrame:CGRectMake(52, 12, toConnectBtn.frame.origin.x - 52 - 12, 24)];
    disConnectLab.text = @"未连接到设备";
    disConnectLab.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    disConnectLab.textColor = [UIColor darkTextColor];
    [self.disConnectView addSubview:disConnectLab];
    
    TextTabItem * item1 = [[TextTabItem alloc] initWithAttrTitle:[self normalTabAttrWith:@"任务"] selectAttrTitle:[self selectedTabAttrWith:@"任务"]];

    self.jobView = [[JobView alloc] init];
    self.jobView.viewCtrl = self;
    self.collectView = [[UIView alloc] init];
    
    self.tabScrollView = [[TextTabScrollView alloc] initWithFrame:CGRectMake(0, 168, self.view.width, self.view.height - 168 - [CommonTool bottomH]- 49)];
    [self.view addSubview:self.tabScrollView];
    
    self.tabScrollView.items = @[item1];
    self.tabScrollView.viewArray = @[self.jobView];
    
    [self addNotify];
}

- (void)addNotify
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bleConnect) name:NOTIFICATION_BLE_CONNECT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bleDisConnect) name:NOTIFICATION_BLE_DISCONNECT object:nil];
}

- (void)bleConnect
{
    self.bleConnected = YES;
}
- (void)bleDisConnect
{
    self.bleConnected = NO;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self showWelcome];
}

- (NSAttributedString *)normalTabAttrWith:(NSString *)text
{
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange range = [text rangeOfString:text];
    [attr addAttributes:@{NSForegroundColorAttributeName : [UIColor textColor], NSFontAttributeName : [UIFont systemFontOfSize:16 weight:UIFontWeightRegular]} range:range];
    return attr;
}

- (NSAttributedString *)selectedTabAttrWith:(NSString *)text
{
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange range = [text rangeOfString:text];
    [attr addAttributes:@{NSForegroundColorAttributeName : [UIColor darkTextColor], NSFontAttributeName : [UIFont systemFontOfSize:20 weight:UIFontWeightMedium]} range:range];
    
    return attr;
}

- (void)setBleConnected:(BOOL)bleConnected
{
    _bleConnected = bleConnected;
    
    self.disConnectView.hidden = bleConnected;
    if (bleConnected) {
        [self.bleConnectBtn setImage:[UIImage imageNamed:@"link"] forState:UIControlStateNormal];
        self.tabScrollView.frame = CGRectMake(0, self.navView.bottom + 16, self.view.width, self.view.height- self.navView.bottom-16);
    }else {
        [self.bleConnectBtn setImage:[UIImage imageNamed:@"unlink"] forState:UIControlStateNormal];
        self.tabScrollView.frame = CGRectMake(0, self.disConnectView.bottom + 16, self.view.width, self.view.height- self.disConnectView.bottom-16);
    }
}

- (void)bleConnectBtnClicked
{
    [self showBleConnectView];
}

- (void)toConnectBtnClicked
{
    [self showBleConnectView];
}

- (void)showBleConnectView
{
    BlueToothViewController * bleCtrl = [BlueToothViewController defaultBLEController];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:bleCtrl];
    nav.modalPresentationStyle =  UIModalPresentationOverCurrentContext;
    nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    nav.navigationBar.barStyle = UIBarStyleDefault;
    nav.navigationBarHidden = YES;
    [self presentViewController:nav animated:NO completion:nil];
}

- (void)moreBtnClicked
{
    PopMenu * menu = [[PopMenu alloc] initWithArrow:CGPointMake(self.moreBtn.centerX, 86) menuSize:CGSizeMake(120, 52) arrowStyle:CWPopMenuArrowTopfooter menuStrings:@[@"扫一扫"] icons:@[@"scan"]];
    menu.arrowWidth = 14;
    menu.arrowHeight = 4;
    menu.menuRadius = 6;
    menu.cellHeight = 48;
    menu.alpha = 0.5;
    menu.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    menu.delegate = self;
    [menu showMenu:YES];
}

-(void)popMenu:(PopMenu*)menu didSelectAtIndex:(NSInteger)index
{
    
}


- (void)showWelcome
{
//    BOOL firstLogin = [[[NSUserDefaults standardUserDefaults] valueForKey:USERDEFAULTS_FIRSTLOGIN] boolValue];
//    if (firstLogin) {
//        WelcomeViewController * welcomeCtrl = [[WelcomeViewController  alloc] init];
//        welcomeCtrl.modalPresentationStyle =  UIModalPresentationOverCurrentContext;
//        welcomeCtrl.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//         [self presentViewController:welcomeCtrl animated:NO completion:nil];
//    }
    
    
    
}


#pragma TextField

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    SearchViewController * searchCtrl = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:searchCtrl animated:YES];
    
    return NO;
}


@end

