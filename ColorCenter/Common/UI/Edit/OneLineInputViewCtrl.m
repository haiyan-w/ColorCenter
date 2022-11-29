//
//  OneLineInputViewCtrl.m
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/21.
//

#import "OneLineInputViewCtrl.h"
#import "CommonTool.h"
#import "UIFont+CustomFont.h"
#import "UIColor+CustomColor.h"
#import "UIView+Frame.h"

@interface OneLineInputViewCtrl () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UILabel * titleLab;
@property (nonatomic, strong) UIView * inputView;
@property (nonatomic, strong) UITextField * textField;
@property (nonatomic, strong) UIButton  * cancelBtn;
@property (nonatomic, strong) UIButton * sureBtn;

@property (nonatomic, copy) NSString * titleStr;
@property (nonatomic, copy) NSString * placeHolder;
@end

@implementation OneLineInputViewCtrl

- (instancetype)initWithTitle:(NSString *)title placeHolder:(NSString *)placeHolder
{
    self = [super init];
    if (self) {
        self.titleStr = title;
        self.placeHolder = placeHolder;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor bgBlackColor];
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(28, (self.view.height - 216)/2.0, self.view.width - 2*28, 216)];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 12.0;
    [self.view addSubview:self.contentView];
    
    self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(24, 32, self.contentView.width - 2*24, 24)];
    self.titleLab.textColor = [UIColor darkTextColor];
    self.titleLab.font = [UIFont boldTextFont];
    self.titleLab.text = self.titleStr;
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.titleLab];
    
    self.inputView = [[UIView alloc] initWithFrame:CGRectMake(24, 80, self.contentView.width - 2*24, 48)];
    self.inputView.backgroundColor = [UIColor bgWhiteColor];
    self.inputView.layer.cornerRadius = 8.0;
    [self.contentView addSubview:self.inputView];
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(16, 12, self.inputView.width - 2*16, 24)];
    self.textField.backgroundColor = [UIColor clearColor];
    self.textField.placeholder = self.placeHolder;
    self.textField.font = [UIFont textFont];
    self.textField.textColor = [UIColor textColor];
    [self.inputView addSubview:self.textField];
    
    float btnW = self.contentView.width/2.0;
    self.cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.contentView.height - 56, btnW, 56)];
    [self.cancelBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    self.cancelBtn.titleLabel.font = [UIFont textFont];
    [self.cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.cancelBtn];
    
    self.sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(btnW, self.contentView.height - 56, btnW, 56)];
    [self.sureBtn setTitleColor:[UIColor tintColor] forState:UIControlStateNormal];
    [self.sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    self.sureBtn.titleLabel.font = [UIFont textFont];
    [self.sureBtn addTarget:self action:@selector(sureBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.sureBtn];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnBg)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}

-(void)showOn:(UIViewController *)viewCtrl
{
    self.modalPresentationStyle =  UIModalPresentationOverCurrentContext;
    self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [viewCtrl presentViewController:self animated:NO completion:NULL];
}

- (void)cancelBtnClicked
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)sureBtnClicked
{
    __weak typeof(self) weakSelf = self;
    [self dismissViewControllerAnimated:NO completion:^{
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf.sureBlk) {
            strongSelf.sureBlk(strongSelf.textField.text);
        }
    }];
    
}

- (void)tapOnBg
{
    [self.textField resignFirstResponder];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }

    return YES;
}

#pragma mark --Notify

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    [self addNotify];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    [self removeNotify];
}

-(void)addNotify
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)removeNotify
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIKeyboardWillShowNotification
                                                      object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIKeyboardWillHideNotification
                                                      object:nil];
}

-(void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary *userInfo = [notification userInfo];
    CGRect KeyboardRect = [[userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"]CGRectValue];

    UIWindow * window = [[UIApplication sharedApplication] keyWindow];

    if ([self.textField isFirstResponder]) {
        CGRect rect = [self.textField convertRect:self.textField.frame toView:window];
        NSInteger offset = KeyboardRect.origin.y - ( self.contentView.bottom + 12);
        
        if (offset < 0) {
            
            __weak typeof(self) weakSelf = self;
            [UIView animateWithDuration:1 animations:^{
                __strong typeof(self) strongSelf = weakSelf;
                strongSelf.contentView.frame = CGRectMake(strongSelf.contentView.left, strongSelf.contentView.top + offset, strongSelf.contentView.width, strongSelf.contentView.height);
            }];
        }
    }
}

-(void)keyboardWillHide:(NSNotification*)notification
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:1 animations:^{
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.contentView.frame = CGRectMake(strongSelf.contentView.left, (strongSelf.view.height - strongSelf.contentView.height)/2, strongSelf.contentView.width, strongSelf.contentView.height);
        
    }];
}

@end
