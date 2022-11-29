//
//  FirstModifyPasswordViewController.m
//  EnochCar
//
//  Created by 王海燕 on 2021/8/20.
//

#import "FirstModifyPasswordViewController.h"
#import "ComplexBox.h"
#import "NetWorkAPIManager.h"
#import "UIView+Hint.h"
#import "UIColor+CustomColor.h"
#import "CommonTool.h"
#import "CommonButton.h"

#define TAG_TEXTFIELD_NEW  91
#define TAG_TEXTFIELD_CONFIRM  92

@interface FirstModifyPasswordViewController ()<ComplexBoxDelegate>
@property (strong, nonatomic) IBOutlet UIView *bgview;
@property (strong, nonatomic) IBOutlet ComplexBox *pwdNew;
@property (strong, nonatomic) IBOutlet ComplexBox *pwdconfirm;
@property (strong, nonatomic) IBOutlet CommonButton *confirmBtn;
@property (strong, nonatomic) IBOutlet UILabel *ruleTipLab;

@property (strong, nonatomic) IBOutlet UILabel *sameTipLab;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *ruleTipHeightConst;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraints;

@property (assign, nonatomic) BOOL isPasswordValid;
@property (assign, nonatomic) BOOL isPasswordSame;
@property (assign, nonatomic) BOOL isModify;
@end

@implementation FirstModifyPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.1];
    self.bgview.layer.cornerRadius = 12;
    
    UIBlurEffect * blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView * effe = [[UIVisualEffectView alloc]initWithEffect:blur];
    effe.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view insertSubview:effe belowSubview:self.bgview];
    
    self.bgview.layer.cornerRadius = 12;
    self.bgview.backgroundColor = [UIColor whiteColor];
    self.bgview.layer.shadowColor = [UIColor blackColor].CGColor;
    self.bgview.layer.shadowOffset = CGSizeMake(0,-3);
    self.bgview.layer.shadowOpacity = 0.16;
    self.bgview.layer.shadowRadius = 24.0;
    self.bgview.clipsToBounds = NO;
    
    [self.pwdNew setMode:ComplexBoxEdit];
    self.pwdNew.boxDelegate = self;
    self.pwdconfirm.boxDelegate = self;
    [self.pwdconfirm setMode:ComplexBoxEdit];
    [self.pwdNew setTag:TAG_TEXTFIELD_NEW];
    [self.pwdconfirm setTag:TAG_TEXTFIELD_CONFIRM];
    [self.pwdNew setPlaceHolder:@"请输入新密码"];
    [self.pwdconfirm setPlaceHolder:@"请输入新密码"];
    [self.pwdNew setBorderColor:[UIColor clearColor]];
    [self.pwdconfirm setBorderColor:[UIColor clearColor]];
    
    self.sameTipLab.hidden = YES;
    CGRect frame = self.bgview.frame;
    self.bottomConstraints.constant = frame.size.height;
    
    self.isModify = NO;

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomConstraints.constant = 0;
        [self.view layoutIfNeeded];
    }];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)showViewController:(UIViewController *)vc
{
    [vc.view addSubview:self.view];
    [vc addChildViewController:self];
}



-(void)removeSelf
{
    [self removeFromParentViewController];
    [self.view removeFromSuperview];
    
}

- (IBAction)confirmBtnClicked:(id)sender {
    
    __weak typeof(self) weakself = self;
    
    if ([self.pwdNew getText].length <= 0) {
        [CommonTool showHint:@"请输入新密码"];
        return;
    }
    if ([self.pwdconfirm getText].length <= 0) {
        [CommonTool showHint:@"请输入确认密码"];
        return;
    }
    
    if (![self sameCheck]) {
        [CommonTool showHint:@"两次输入密码不一致"];
        return;
    }

    [[NetWorkAPIManager defaultManager] modifyPassword:@"123456" newPwd:[self.pwdNew getText] confirmPwd:[self.pwdconfirm getText] success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        weakself.isModify = YES;
        [weakself removeSelf];
//        NSNotificationCenter * notify = [NSNotificationCenter defaultCenter];
//        [notify postNotificationName:NOTIFICATION_LOGOUT_SUCCESS object:NULL userInfo:NULL];
        dispatch_async(dispatch_get_main_queue(), ^{
            [CommonTool showHint:@"修改密码成功，请重新登录"];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        weakself.isModify = YES;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [CommonTool showError:error];
        });

    }];
}


-(void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary *userInfo = [notification userInfo];
    CGRect KeyboardRect = [[userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"]CGRectValue];

    [UIView animateWithDuration:0.5 animations:^{
        if (self.bottomConstraints.constant == 0) {
            self.bottomConstraints.constant = self.bottomConstraints.constant - KeyboardRect.size.height;
            [self.view layoutIfNeeded];
        }
        
    }];
}

-(void)keyboardWillHide:(NSNotification*)notification
{
    [UIView animateWithDuration:0.5 animations:^{
        self.bottomConstraints.constant = 0;
        [self.view layoutIfNeeded];
    }];
}

//检查新密码与确认密码是否一致
-(BOOL)sameCheck
{
    if ([[self.pwdNew getText] isEqualToString:[self.pwdconfirm getText]]) {
        return YES;
    }
    return NO;
}


-(void)complexBoxViewEndEditing:(ComplexBox*)box
{
    if (box.tag == TAG_TEXTFIELD_NEW) {
        self.isPasswordValid = [CommonTool passwordRuleCheck:[box getText]];
    }
}


- (BOOL)complexBox:(ComplexBox*)box shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return  [CommonTool passwordInputCheck:string];
}



@end
