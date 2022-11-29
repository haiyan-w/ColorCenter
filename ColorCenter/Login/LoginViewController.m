//
//  LoginViewController.m
//  EnochCar
//
//  Created by HAIYAN on 2021/5/7.
//

#import "LoginViewController.h"
#import "NetWorkAPIManager.h"
#import "AgreementViewController.h"
#import "CommonTool.h"
#import "ComplexBox.h"
#import "CommonDefine.h"
#import "UIView+Hint.h"
#import "UIColor+CustomColor.h"
#import "ForgetPwdViewController.h"
#import "FirstModifyPasswordViewController.h"
#import "FirstAgreementViewController.h"
#import "CommonButton.h"
#import "NSError+tool.h"
#import "ModifyPwdViewController.h"
#import "PasswordBox.h"

@interface LoginViewController ()<UITextFieldDelegate, UITextViewDelegate>
@property(nonatomic,readwrite,strong)ComplexBox * nameText;
@property(nonatomic,readwrite,strong)PasswordBox * passwordText;
@property(nonatomic,readwrite,strong)UIButton * forgetPwdBtn;
@property(nonatomic,readwrite,strong)UIButton * loginBtn;
@property(nonatomic,readwrite,copy)NSString * name;
@property(nonatomic,readwrite,copy)NSString * password;
@property(nonatomic,readwrite,strong)UIButton * selectBtn;
@end

@implementation LoginViewController

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
    
    self.view.backgroundColor = [UIColor whiteColor];

    UIImageView * headImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 218)];
    [headImg setImage:[UIImage imageNamed:@"bgImg"]];
    [self.view addSubview:headImg];
    
    UILabel * bigLab = [[UILabel alloc] initWithFrame:CGRectMake(36, 144, self.view.frame.size.width - 2*36, 44)];
    bigLab.text = @"以诺行颜色中心";
    bigLab.textColor = [UIColor darkTextColor];
    bigLab.font = [UIFont systemFontOfSize:32 weight:UIFontWeightMedium];
    bigLab.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:bigLab];
    
    UILabel * smallLab = [[UILabel alloc] initWithFrame:CGRectMake(36, (bigLab.frame.origin.y+bigLab.frame.size.height), bigLab.frame.size.width, 24)];
    smallLab.text = @"ENOCH Color Center";
    smallLab.textColor = [UIColor darkTextColor];
    smallLab.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    smallLab.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:smallLab];
    
    UIView * icon = [[UIView alloc] initWithFrame:CGRectMake(36, (smallLab.frame.origin.y+smallLab.frame.size.height+12), 24, 4)];
    icon.backgroundColor = [UIColor tintColor];
    icon.layer.cornerRadius = 2.0;
    [self.view addSubview:icon];
    
    NSInteger left = 36;
    NSInteger top = 80;
    NSInteger bottom = 24;
    NSInteger space = 12;
    
    NSInteger centerY = smallLab.frame.origin.y+smallLab.frame.size.height +top;
    UIView * centerView = [[UIView alloc] initWithFrame:CGRectMake(left, centerY, (self.view.bounds.size.width - 2*left), (self.view.bounds.size.height - centerY - bottom) )];
    [self.view addSubview:centerView];
    
    UIView * loginView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, centerView.bounds.size.width, 234)];
    [centerView addSubview:loginView];
    
    _nameText = [[ComplexBox alloc] initWithFrame:CGRectMake(0, 0, loginView.bounds.size.width, 48) mode:ComplexBoxEdit];
    [_nameText setPlaceHolder:@"手机号"];
    _nameText.keyboardType = UIKeyboardTypeDecimalPad;
    _nameText.boxBgColor = [UIColor colorWithRed:247/255.0 green:247/255.0 blue:247/255.0 alpha:1];
    _nameText.borderColor = [UIColor clearColor];
    
    _passwordText = [[PasswordBox alloc] initWithFrame:CGRectMake(_nameText.frame.origin.x, (_nameText.frame.origin.y+_nameText.frame.size.height + space), _nameText.frame.size.width, _nameText.frame.size.height)];
    [_passwordText setPlaceHolder:@"密码"];
    
    self.forgetPwdBtn = [[UIButton alloc] initWithFrame:CGRectMake((_passwordText.frame.origin.x+_passwordText.frame.size.width-60), (_passwordText.frame.origin.y+_passwordText.frame.size.height + 8), 70, 20)];
    [self.forgetPwdBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    [self.forgetPwdBtn setTitleColor:[UIColor slightTextColor] forState:UIControlStateNormal];
    self.forgetPwdBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.forgetPwdBtn addTarget:self action:@selector(forgetPwdBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    _loginBtn = [[CommonButton alloc] initWithFrame:CGRectMake(_passwordText.frame.origin.x, (_passwordText.frame.origin.y+_passwordText.frame.size.height + 64), _nameText.frame.size.width, 44) normalTitle:@"登录" disabledTitle:@"登录"];
    _loginBtn.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightRegular];
    [_loginBtn addTarget:self action:@selector(loginBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    _loginBtn.layer.cornerRadius = 22;
    
    [loginView addSubview:_nameText];
    [loginView addSubview:_passwordText];
    [loginView addSubview:self.forgetPwdBtn];
    [loginView addSubview:_loginBtn];
    
    float labW  = 290;
    UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - labW)/2, self.view.frame.size.height - 48 - 32, labW, 32)];
    bottomView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bottomView];
    
    _selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    [_selectBtn setImage:[UIImage imageNamed:@"icon_unselect"] forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageNamed:@"icon_select"] forState:UIControlStateSelected];
    [_selectBtn addTarget:self action:@selector(agree) forControlEvents:UIControlEventTouchUpInside];
    _selectBtn.selected = NO;
    
    NSNumber * UmengInit = [[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULTS_UMengInit];
    if (UmengInit && [UmengInit boolValue]) {
        //上一次同意了协议，本次自动同意
        _selectBtn.selected = YES;
    }else{
        _selectBtn.selected = NO;
    }
    [bottomView addSubview:_selectBtn];
    
    UITextView * bottomLab = [[UITextView alloc] initWithFrame:CGRectMake(_selectBtn.frame.origin.x + _selectBtn.frame.size.width, 0, bottomView.frame.size.width-(_selectBtn.frame.origin.x + _selectBtn.frame.size.width), bottomView.frame.size.height)];
    bottomLab.font = [UIFont systemFontOfSize:12.0 weight:UIFontWeightRegular];
    bottomLab.tintColor = [UIColor tintColor];
    bottomLab.editable = NO;
    bottomLab.delegate = self;
    bottomLab.textColor = [UIColor slightTextColor];
    NSString * string = [NSString stringWithFormat:@"我已阅读并同意《用户协议》和《隐私协议》"];
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange range1 = [string rangeOfString:@"《用户协议》"];
    NSRange range2 = [string rangeOfString:@"《隐私协议》"];
    NSURL * url1= [NSURL URLWithString:URL_AGREEMENT];
    NSURL * url2= [NSURL URLWithString:URL_PRIVACY];
    [attrStr addAttributes:@{NSLinkAttributeName:url1, NSForegroundColorAttributeName:[UIColor tintColor]} range:range1];
    [attrStr addAttributes:@{NSLinkAttributeName:url2, NSForegroundColorAttributeName:[UIColor tintColor]} range:range2];
    bottomLab.attributedText = attrStr;
    [bottomView addSubview:bottomLab];

    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taponbg:)];
    [self.view addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(verifiedSuccess:) name:@"verifiedSuccess" object:nil];
    
    
    BOOL firstAgree = [[[NSUserDefaults standardUserDefaults] valueForKey:USERDEFAULTS_FIRSTAGREE] boolValue];
    if (!firstAgree && !UmengInit.boolValue) {
        [self showFirstAgreement];
    }else {
        //获取上一次登录的账号密码,自动登录
        NSString * account = [[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULTS_ACCOUNT];
        NSString * password = [[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULTS_PASSWORD];
        self.selectBtn.selected = YES;
        if (account) {
            [_nameText setText:account];
            if (password) {
                [_passwordText setText:password];
                if ([self check]) {
                    [self login];
                }
            }
        }
    }
}

-(void)showFirstAgreement
{
    FirstAgreementViewController * firstAgreeCtrl = [[FirstAgreementViewController alloc] init];
    [firstAgreeCtrl showOn:self];
}

-(void)taponbg:(UIGestureRecognizer *)gesture
{
    [CommonTool resign];
}

-(void)agree
{
    _selectBtn.selected = !_selectBtn.selected;
    if (_selectBtn.selected) {
        NSNotificationCenter * notify = [NSNotificationCenter defaultCenter];
        [notify postNotificationName:NOTIFICATION_Agreement object:NULL userInfo:NULL];
    }
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];//收起键盘
    return  YES;
}

-(void)saveAccountAndPwd
{
    NSString * userAccount = [[NSUserDefaults standardUserDefaults] valueForKey:USERDEFAULTS_ACCOUNT];
    if (userAccount.length > 0) {
        //之前登录过
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:USERDEFAULTS_FIRSTLOGIN];
    }else {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:USERDEFAULTS_FIRSTLOGIN];
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[_nameText getText] forKey:USERDEFAULTS_ACCOUNT];
    [[NSUserDefaults standardUserDefaults] setObject:[_passwordText getText] forKey:USERDEFAULTS_PASSWORD];
}

-(BOOL)check
{
    self.name = [self.nameText getText];
    self.password = [self.passwordText getText];
    if (![CommonTool isCellphoneValid:self.name])
    {
        [CommonTool showHint:@"请输入正确的手机号码"];
        return NO;
    }
    if (!self.password || self.password.length <= 0)
    {
        [CommonTool showHint:@"请输入密码"];
        return NO;
    }
    if (!_selectBtn.selected) {
        [CommonTool showHint:@"请阅读用户协议和隐私权政策"];
        return NO;
    }
    return YES;
}

-(void)forgetPwdBtnClicked
{
    [CommonTool resign];
    
    ForgetPwdViewController * forgetCtrl = [[ForgetPwdViewController alloc] init];
    forgetCtrl.verifiedSuccessBlock = ^(NSString * _Nonnull cellPhone, NSString * _Nonnull verifyCode) {
        NSNotificationCenter * notify = [NSNotificationCenter defaultCenter];
        [notify postNotificationName:@"verifiedSuccess" object:NULL userInfo:@{@"cellPhone":cellPhone,@"verifyCode":verifyCode}];
    };
    [self.navigationController pushViewController:forgetCtrl animated:YES];
}

-(void)verifiedSuccess:(NSNotification *)notify
{
    [self.navigationController popViewControllerAnimated:NO];
    NSString * cellPhone = [notify.userInfo objectForKey:@"cellPhone"];
    NSString * verifyCode = [notify.userInfo objectForKey:@"verifyCode"];
    ModifyPwdViewController * modifyCtrl = [[ModifyPwdViewController alloc] initWithForget:YES cellphone:cellPhone verifyCode:verifyCode];
    [self.navigationController pushViewController:modifyCtrl animated:NO];
}

-(void)loginBtnClicked
{
    [CommonTool resign];
    
    if ([self check]) {
        [self login];
    }
}

-(void)login
{
    __weak typeof(self) weakSelf = self;
    [[NetWorkAPIManager defaultManager] loginWithUsername:self.name Password:self.password success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf queryUserInfo];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //错误提示
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf loginFailure:[CommonTool getErrorMessage:error]];

    }] ;
}


-(void)loginFailure:(NSString * )message
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"登录失败"
                                                                       message:message
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  //响应事件
                                                              }];

        [alert addAction:defaultAction];
    
    __weak typeof (self) weakself = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakself presentViewController:alert animated:YES completion:nil];
    });
        
}



-(void)queryUserInfo
{
    __weak LoginViewController * weakself = self;
    NetWorkAPIManager * manager = [NetWorkAPIManager defaultManager];
    [manager getUserInfosuccess:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [weakself saveAccountAndPwd];
        NSNotificationCenter * notify = [NSNotificationCenter defaultCenter];
        [notify postNotificationName:NOTIFICATION_LOGIN_SUCCESS object:NULL userInfo:NULL];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
        NSDictionary * errorInfo = [CommonTool getErrorInfo:error];
        if ([[errorInfo objectForKey:@"code"] isEqualToString:@"PASSWORD_IS_EXPIRED"]) {
            [weakself showFirstModifyViewController];
        }else {
            [CommonTool showHint:@"获取用户信息失败"];
        }
    }];
}

-(void)showFirstModifyViewController
{
    FirstModifyPasswordViewController * modifyCtrl = [[FirstModifyPasswordViewController alloc] init];
    modifyCtrl.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [modifyCtrl showViewController:self];
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction
{
    if ([URL.absoluteString isEqualToString:URL_AGREEMENT]) {
        [self showAgreement];
    }else if ([URL.absoluteString isEqualToString:URL_PRIVACY]) {
        [self showPrivacy];
    }else {
        
    }
    
    return NO;
}

@end
