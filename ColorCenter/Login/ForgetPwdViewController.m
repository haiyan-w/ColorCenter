//
//  ForgetPwdViewController.m
//  EnochCar
//
//  Created by 王海燕 on 2022/8/1.
//

#import "ForgetPwdViewController.h"
#import "NetWorkAPIManager.h"
#import "CommonTool.h"
#import "UIColor+CustomColor.h"
#import "UIView+Hint.h"
#import "SingleInputTextField.h"
#import "CommonButton.h"

#define TAG_TF_PHONE 190
#define TAG_TF_Code 191

@interface ForgetPwdViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIView *phoneView;
@property (strong, nonatomic) IBOutlet UITextField *phoneTF;

@property (strong, nonatomic) IBOutlet UIView *codeView;
@property (strong, nonatomic) IBOutlet UIButton *getVerifyCodeBtn;
@property (strong, nonatomic) IBOutlet UITextField *verifyCodeTf;

@property (strong, nonatomic) IBOutlet CommonButton *sureBtn;

@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) int count;
@end

@implementation ForgetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view layoutIfNeeded];
    
    self.phoneView.layer.cornerRadius = 4;
    self.phoneTF.tag = TAG_TF_PHONE;
    self.phoneTF.delegate = self;
    [self.phoneTF addTarget:self action:@selector(editTF:) forControlEvents:UIControlEventEditingChanged];
    self.phoneTF.tintColor = [UIColor tintColor];
    self.phoneTF.textColor = [UIColor textColor];
    
    self.verifyCodeTf.tag = TAG_TF_Code;
    self.verifyCodeTf.delegate = self;
    self.verifyCodeTf.tintColor = [UIColor tintColor];
    self.verifyCodeTf.textColor = [UIColor textColor];
    self.codeView.layer.cornerRadius = 4;
    
    [self.getVerifyCodeBtn setTitleColor:[UIColor tintColor] forState:UIControlStateNormal];
    [self.getVerifyCodeBtn setTitleColor:[UIColor lightTintColor] forState:UIControlStateDisabled];
    self.getVerifyCodeBtn.enabled = NO;
    self.getVerifyCodeBtn.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    
    self.sureBtn.layer.cornerRadius = 22;
    [self.sureBtn setNormalTitle:@"确定" disabledTitle:@"确定"];
    self.sureBtn.enabled = NO;
    
    self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(beginCountDown) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer setFireDate:[NSDate distantFuture]];
    
    [self.phoneTF becomeFirstResponder];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taponbg:)];
    [self.view addGestureRecognizer:tap];

}

-(void)taponbg:(UIGestureRecognizer *)gesture
{
    [CommonTool resign];
}

-(void)stratCount
{
    self.count = 60;
    [self.timer setFireDate:[NSDate date]];
    [self refreshSendBtn];
}

-(void)endCount
{
    [self.timer setFireDate:[NSDate distantFuture]];
    self.count = 0;
    [self.getVerifyCodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
    [self.getVerifyCodeBtn setTitle:@"重新发送" forState:UIControlStateDisabled];
    [self refreshSendBtn];
}

-(void)refreshSendBtn
{
    if ((self.count>0) || (self.phoneTF.text.length != 11)) {
        self.getVerifyCodeBtn.enabled = NO;
    }else {
        self.getVerifyCodeBtn.enabled = YES;
    }
}

-(void)beginCountDown
{
    self.count -= 1;
    if (self.count > 0) {
        [self.getVerifyCodeBtn setTitle:[NSString stringWithFormat:@"%d%@",self.count,@"s"] forState:UIControlStateDisabled];
        [self.getVerifyCodeBtn setTitle:[NSString stringWithFormat:@"%d%@",self.count,@"s"] forState:UIControlStateNormal];
    }else {
        [self endCount];
    }
    
}


- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)getCodeBtnClicked:(id)sender {
    
    if (![CommonTool validateCellPhoneToSend:self.phoneTF.text]) {
        [CommonTool showHint:@"请输入正确的手机号码"];
    }else {
        self.getVerifyCodeBtn.enabled = NO;
        [self getVerifyCode];
    }
}


-(void)getVerifyCode
{
    __weak typeof(self) weakSelf = self;
    [[NetWorkAPIManager defaultManager] commonGET:@"/enocolor/client/security/password/cellphone/verify/code" parm:@{@"cellphone":self.phoneTF.text} registerClass:[NSObject class] Success:^(NSURLSessionDataTask * _Nonnull task, ResponseObject * _Nonnull responseObj) {
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.getVerifyCodeBtn.enabled = NO;
        [strongSelf stratCount];
        
    } Failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        __strong typeof(self) strongSelf = weakSelf;
        [CommonTool showError:error];
        strongSelf.getVerifyCodeBtn.enabled = YES;
    }];
}


- (IBAction)sureBtnClicked:(id)sender {
    
    if ([self check]) {
        //输入完成，发送验证码
        [self sendVerifyCode];
    }
}


-(void)sendVerifyCode
{
    __weak typeof(self) weakSelf = self;

    [[NetWorkAPIManager defaultManager] commonPOST:@"/enocolor/client/security/password/cellphone/verify/code" parm:@{@"cellphone":self.phoneTF.text, @"verifyCode":self.verifyCodeTf.text}  registerClass:[NSObject class] Success:^(NSURLSessionDataTask * _Nonnull task, ResponseObject * _Nonnull responseObj) {
        __strong typeof(self) strongSelf = weakSelf;
        
        if (strongSelf.verifiedSuccessBlock) {
            strongSelf.verifiedSuccessBlock(strongSelf.phoneTF.text,strongSelf.verifyCodeTf.text);
        }

    } Failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [CommonTool showError:error];
    }];
    
}




-(BOOL)check
{
    BOOL result = YES;
    if (self.verifyCodeTf.text.length == 0) {
        result = NO;
    }
    return result;
}

-(void)editTF:(UITextField *)tf
{
    switch (tf.tag) {
        case TAG_TF_PHONE:
        {
            [self refreshSendBtn];
        }
            break;

        default:
            break;
    }

}


#pragma mark Delegate

//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
//{
//    switch (textField.tag) {
//        case TAG_TF_PHONE:
//        {
//            self.phoneView.layer.borderColor = [UIColor tintColor].CGColor;
//            self.phoneView.backgroundColor = [UIColor lightBlueFillColor];
//        }
//            break;
//
//        default:
//        {
//            textField.layer.borderColor = [UIColor tintColor].CGColor;
//            textField.backgroundColor = [UIColor lightBlueFillColor];
//        }
//
//            break;
//    }
//
//    return YES;
//}
//
//- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
//{
//    switch (textField.tag) {
//        case TAG_TF_PHONE:
//        {
//            self.phoneView.layer.borderColor = [UIColor borderColor].CGColor;
//            self.phoneView.backgroundColor = [UIColor bgWhiteColor];
//
//        }
//            break;
//
//        default:
//        {
//            textField.layer.borderColor = [UIColor borderColor].CGColor;
//            textField.backgroundColor = [UIColor bgWhiteColor];
//        }
//
//            break;
//    }
//
//    return YES;
//}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * text = textField.text;
    text = [text stringByReplacingCharactersInRange:range withString:string];
    
    switch (textField.tag) {
        case TAG_TF_PHONE:
        {
            BOOL result = YES;
            result = [CommonTool validateCellPhoneStr:text];
            return result;
        }
            break;
        case TAG_TF_Code:
        {
            self.sureBtn.enabled = (text.length > 0)?YES:NO;
        }
            break;
            
        default:
            break;
    }
    
    return YES;
}





@end
