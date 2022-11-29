//
//  SettingViewController.m
//  EnochCar
//
//  Created by 王海燕 on 2021/5/10.
//

#import "SettingViewController.h"
#import "ModifyPwdViewController.h"
#import "NetWorkAPIManager.h"
#import "SettingTableViewCell.h"
#import "UIView+Hint.h"
#import "CommonTool.h"
#import "UIColor+CustomColor.h"
#import "AgreementViewController.h"
#import "AdviceViewController.h"
#import "SettingItem.h"
#import "CommonButton.h"
#import "AgreementViewController.h"
#import "UserInfoViewCtrl.h"

@interface SettingViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic,readwrite,strong)NSMutableArray * datasource;
@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.midTitle = @"设置";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view layoutSubviews];
    
    [self initDataSource];

    NSInteger left = 20;
    NSInteger bottom = 58 + [CommonTool bottomH];
    NSInteger btnH = 48;
    
    UIButton * logoutBtn = [[CommonButton alloc] initWithFrame:CGRectMake(left, (self.view.frame.size.height - bottom - btnH), (self.view.frame.size.width - 2*left), btnH) normalTitle:@"退出登录" disabledTitle:@"退出登录"];
    [logoutBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    logoutBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightRegular];
    [self.view addSubview:logoutBtn];

    CGFloat agreementW = 112;
    CGFloat privacyW = 86;
    UIButton * agreementBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.view.frame.size.width - agreementW - privacyW - 12)/2, logoutBtn.frame.origin.y + logoutBtn.frame.size.height + 16, agreementW, 24)];
    agreementBtn.backgroundColor = [UIColor clearColor];
    [agreementBtn setTitle:@"《以诺行用户协议》" forState:UIControlStateNormal];
    [agreementBtn setTitleColor:[UIColor tintColor] forState:UIControlStateNormal];
    [agreementBtn.titleLabel setFont:[UIFont systemFontOfSize:12 weight:UIFontWeightRegular]];
    [agreementBtn addTarget:self action:@selector(showAgreement) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:agreementBtn];
 
    UIButton * privacyBtn = [[UIButton alloc] initWithFrame:CGRectMake(agreementBtn.frame.origin.x + agreementBtn.frame.size.width + 12, agreementBtn.frame.origin.y, privacyW, 24)];
    privacyBtn.backgroundColor = [UIColor whiteColor];
    [privacyBtn setTitle:@"《隐私权政策》" forState:UIControlStateNormal];
    [privacyBtn setTitleColor:[UIColor tintColor] forState:UIControlStateNormal];
    [privacyBtn.titleLabel setFont:[UIFont systemFontOfSize:12 weight:UIFontWeightRegular]];
    [privacyBtn addTarget:self action:@selector(showPrivacy) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:privacyBtn];
    
    left = 36;
    float tableY = (self.navbarView.frame.origin.y + self.navbarView.frame.size.height);
    UITableView * tableview = [[UITableView alloc] initWithFrame:CGRectMake(0,tableY, (self.view.frame.size.width), logoutBtn.frame.origin.y - tableY)];
    tableview.backgroundColor = [UIColor clearColor];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.bounces = NO;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableview registerNib:[UINib nibWithNibName:@"SettingTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SettingTableViewCell"];
    if(@available(iOS 15.0,*)){
        tableview.sectionHeaderTopPadding=0;
    }
    [self.view addSubview:tableview];

}

-(void)initDataSource
{
    __weak typeof(self) weakSelf = self;
    
    SettingItem * baseItem = [[SettingItem alloc] init];
    baseItem.titleStr = @"基础信息";
    baseItem.hasNext = YES;
    baseItem.nextBlock = ^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf showUserInfoCtrl];
    };
    
    SettingItem * item1 = [[SettingItem alloc] init];
    item1.titleStr = @"密码修改";
    item1.hasNext = YES;
    item1.nextBlock = ^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf showModifyPwdCtrl];
    };

    
    SettingItem * item2 = [[SettingItem alloc] init];
    item2.titleStr = @"帮助";
    item2.hasNext = YES;
    item2.nextBlock = ^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf showHelp];
    };
    
    SettingItem * item3 = [[SettingItem alloc] init];
    item3.titleStr = @"版本";
    item3.rightStr = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    item3.hasNext = NO;
    
    SettingItem * item4 = [[SettingItem alloc] init];
    item4.titleStr = @"建议";
    item4.hasNext = YES;
    item4.nextBlock = ^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf showAdvice];
    };
    
    SettingItem * item5 = [[SettingItem alloc] init];
    item5.titleStr = @"版权所有";
    item5.subTitleStr = @"杭州以诺行汽车科技股份有限公司";
    item5.hasNext = NO;
    
    self.datasource = [[NSMutableArray alloc] initWithObjects:@[baseItem,item1],@[item3,item5],nil];
}

- (void)showUserInfoCtrl
{
    UserInfoViewCtrl * userCtrl = [[UserInfoViewCtrl alloc] init];
    [self.navigationController pushViewController:userCtrl animated:YES];
}

-(void)showModifyPwdCtrl
{
    ModifyPwdViewController * modifyCtrl = [[ModifyPwdViewController alloc] init];
    [self.navigationController pushViewController:modifyCtrl animated:YES];
}

-(void)showAccountManagementCtrl
{

}

-(void)showSprayTenaneConvertCtrl
{

}


-(void)logout
{

    __weak SettingViewController * weakself = self;
    NetWorkAPIManager * manager = [NetWorkAPIManager defaultManager];
    [manager logoutsuccess:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERDEFAULTS_ACCOUNT];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERDEFAULTS_PASSWORD];
        
        NSNotificationCenter * notify = [NSNotificationCenter defaultCenter];
        [notify postNotificationName:NOTIFICATION_LOGOUT_SUCCESS object:NULL userInfo:NULL];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //错误提示
        [CommonTool showError:error];
    }];
}

-(void)showAgreement
{
    AgreementViewController * agreementCtrl = [[AgreementViewController alloc] initWithResource:URL_AGREEMENT];
    [self addChildViewController:agreementCtrl];
    [self.view addSubview:agreementCtrl.view];
}

-(void)showPrivacy

{
    AgreementViewController * agreementCtrl = [[AgreementViewController alloc] initWithResource:URL_PRIVACY];
    [self addChildViewController:agreementCtrl];
    [self.view addSubview:agreementCtrl.view];
}

-(void)showHelp
{
    AgreementViewController * agreementCtrl = [[AgreementViewController alloc] initWithResource:URL_HELP];
    [self addChildViewController:agreementCtrl];
    [self.view addSubview:agreementCtrl.view];
}

-(void)showAdvice
{
    AdviceViewController * modifyCtrl = [[AdviceViewController alloc] init];
    [self.navigationController pushViewController:modifyCtrl animated:YES];
}


#pragma mark Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 48;
    if ((1 == indexPath.section) && (1 == indexPath.row)) {
        height = 74;
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    float height = 12;
    if ((0 == section)) {
        height = 0;
    }
    return height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.datasource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * array = [self.datasource objectAtIndex:section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SettingTableViewCell"];
    SettingItem * item = [[self.datasource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.item = item;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingItem * item = [[self.datasource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (item.hasNext) {
        if (item.nextBlock) {
            item.nextBlock();
        }
    }
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,0)];
    headerView.backgroundColor = [UIColor bgWhiteColor];
    return headerView;
}

@end
