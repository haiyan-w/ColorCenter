//
//  ModifyPwdViewController.m
//  EnochCar
//
//  Created by 王海燕 on 2021/5/24.
//

#import "ModifyPwdViewController.h"
#import "NetWorkAPIManager.h"
#import "CommonTool.h"
#import "UIView+Hint.h"

@interface ModifyPwdViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIButton *commitBtn;
@property (strong, nonatomic) IBOutlet UITextField *pwdOld;
@property (strong, nonatomic) IBOutlet UITextField *pwdNew;
@property (strong, nonatomic) IBOutlet UITextField *pWdConfirm;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *oldViewHeightConstraint;
@property (assign, nonatomic) BOOL isForget;//是否忘记密码
@property (copy, nonatomic) NSString * cellphone;
@property (copy, nonatomic) NSString * verifyCode;
@end

@implementation ModifyPwdViewController

-(instancetype)initWithForget:(BOOL)isForget cellphone:(NSString *)cellphone verifyCode:(NSString *)verifyCode
{
    self = [super init];
    if (self) {
        self.isForget = isForget;
        self.cellphone = cellphone;
        self.verifyCode = verifyCode;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.midTitle = @"修改密码";
    self.view.backgroundColor = [UIColor whiteColor];

    self.commitBtn.layer.cornerRadius = 4;
    
    self.pwdOld.delegate = self;
    self.pwdNew.delegate = self;
    self.pWdConfirm.delegate = self;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taponbg:)];
    [self.view addGestureRecognizer:tap];
    
    if (self.isForget) {
        self.oldViewHeightConstraint.constant = 0;
    }
    
    [self.view layoutIfNeeded];
}

-(void)taponbg:(UIGestureRecognizer *)gesture
{
    [CommonTool resign];
}

-(void)resetData
{
    self.pwdOld.text = @"";
    self.pwdNew.text = @"";
    self.pWdConfirm.text = @"";
}

- (IBAction)modify:(id)sender {
    if ([self check]) {
        if (self.isForget) {
            [self modifyPwdByVerifyCode];
        }else {
            [self commonModifyPwd];
        }
    }
}

-(void)modifyPwdByVerifyCode
{
    __weak typeof(self) weakSelf = self;
    [[NetWorkAPIManager defaultManager] commonPOST:@"/enocolor/client/security/password/cellphone" parm:@{@"cellphone":self.cellphone, @"newPassword":self.pwdNew.text, @"verifyCode":self.verifyCode} registerClass:[NSObject class] Success:^(NSURLSessionDataTask * _Nonnull task, ResponseObject * _Nonnull responseObj) {
        __strong typeof(self) strongSelf = weakSelf;
        [CommonTool resign];
        [strongSelf resetData];
        [CommonTool showHint:@"修改密码成功"];
        [strongSelf.navigationController popViewControllerAnimated:YES];
        
    } Failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        [CommonTool showError:error];
    }];
}


-(void)commonModifyPwd
{
    __weak typeof(self) weakSelf = self;
    [[NetWorkAPIManager defaultManager] modifyPassword:[self.pwdOld.text lowercaseString] newPwd:self.pwdNew.text confirmPwd:self.pWdConfirm.text success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        __strong typeof(self) strongSelf = weakSelf;
        [CommonTool resign];
        [strongSelf resetData];
        [CommonTool showHint:@"修改密码成功"];
        
        NSNotificationCenter * notify = [NSNotificationCenter defaultCenter];
        [notify postNotificationName:NOTIFICATION_LOGOUT_SUCCESS object:NULL userInfo:NULL];
    
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        [CommonTool showError:error];
    }];
}

-(BOOL)check
{
    if ((self.pwdOld.text.length < 1)&&!self.isForget) {
        [CommonTool showHint:@"请输入旧密码"];
        return NO;
    }else if (self.pwdNew.text.length < 1){
        [CommonTool showHint:@"请输入新密码"];
        return NO;
    }else if (self.pWdConfirm.text.length < 1){
        [CommonTool showHint:@"请输入确认密码"];
        return NO;
    }else if (![self.pWdConfirm.text isEqualToString:self.pwdNew.text]){
        [CommonTool showHint:@"两次输入密码不一致"];
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [CommonTool passwordInputCheck:string];
}

@end
