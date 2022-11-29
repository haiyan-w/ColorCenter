//
//  BaseViewController.m
//  EnochCar
//
//  Created by 王海燕 on 2021/9/29.
//

#import "GestureViewController.h"
#import "CommonTool.h"
#import "UIView+Hint.h"

@interface GestureViewController ()<UIGestureRecognizerDelegate>
@property(strong, nonatomic) UIPanGestureRecognizer * panRecognizer;


@end

@implementation GestureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGRect bounds = [UIScreen mainScreen].bounds;
    self.view.frame = CGRectMake(0, 0, bounds.size.width, bounds.size.height);
    [self.view layoutSubviews];//解决界面bounds不对问题
    
    self.view.backgroundColor = [UIColor clearColor];
    self.needPanGesture = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    [self addNotify];
    
    if (self.needPanGesture) {
        [self addGesture];
    }
    
    __weak GestureViewController * weakself = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakself.backgroundView.alpha = 1.0;
        weakself.moveView.frame = self.moveViewOrgFrame;
        [weakself.view layoutIfNeeded];
   
    }];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    [self removeGesture];
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

-(void)setBackgroundView:(UIView *)backgroundView
{
    _backgroundView = backgroundView;
    
    _backgroundView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.2];
}

-(void)setMoveView:(UIView *)moveView
{
    _moveView = moveView;
    if (moveView) {
        self.moveViewOrgFrame = moveView.frame;
        [_moveView setLRCornor];
    }
}

-(void)addGesture
{
    //拖动手势不能直接加在self.view上，会透过addchildviewcontroller添加的view拖动底层view
    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandle:)];
    self.panRecognizer.delegate = self;
    [self.gestureView addGestureRecognizer:self.panRecognizer ];
    
    UIPanGestureRecognizer * panRecognizer2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandle:)];
    panRecognizer2.delegate = self;
    [self.moveView addGestureRecognizer:panRecognizer2];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandle:)];
    tapGesture.delegate = self;
    [self.moveView addGestureRecognizer:tapGesture];
    
    if (self.backgroundView) {
        UITapGestureRecognizer * tapOnBgGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnBgGestureHandle:)];
        tapOnBgGesture.delegate = self;
        [self.backgroundView addGestureRecognizer:tapOnBgGesture];
    }
}

-(void)removeGesture
{
    for (UIGestureRecognizer * gesture in self.gestureView.gestureRecognizers) {
        [self.gestureView removeGestureRecognizer:gesture];
    }
    
    for (UIGestureRecognizer * gesture in self.moveView.gestureRecognizers) {
        [self.moveView removeGestureRecognizer:gesture];
    }
    
    for (UIGestureRecognizer * gesture in self.backgroundView.gestureRecognizers) {
        [self.backgroundView removeGestureRecognizer:gesture];
    }
    
    for (UIGestureRecognizer * gesture in self.view.gestureRecognizers) {
        [self.view removeGestureRecognizer:gesture];
    }
}

- (void)tapGestureHandle:(UITapGestureRecognizer *)tapGesture
{
    [CommonTool resign];
}

- (void)tapOnBgGestureHandle:(UITapGestureRecognizer *)tapGesture
{
    [CommonTool resign];
    [self dismiss];
}

- (void)panGestureHandle:(UIPanGestureRecognizer *)panGestureRecognizer{
    [CommonTool resign];
    //获取拖拽手势在self.view 的拖拽姿态
    CGPoint translation = [panGestureRecognizer translationInView:self.view];

    if (translation.y <= 0){
        self.moveView.frame = self.moveViewOrgFrame;
    }else if (translation.y >= self.moveViewOrgFrame.size.height) {

    }else {
        self.moveView.frame = CGRectMake(self.moveViewOrgFrame.origin.x, self.moveViewOrgFrame.origin.y +translation.y , self.moveViewOrgFrame.size.width, self.moveViewOrgFrame.size.height);
    }
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (translation.y >= self.moveViewOrgFrame.size.height/2) {
            [self dismiss];
        }else {
            self.moveView.frame = self.moveViewOrgFrame;
        }
    }
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }

    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"])
    {
        return NO;
    }
    
    if([NSStringFromClass([touch.view class]) isEqualToString:@"TouchView"])
    {
        return NO;
    }
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if([NSStringFromClass([touch.view class]) isEqualToString:@"BorderView"])
    {
        return NO;
    }

    return YES;
}

-(void)showAnimate
{
    self.backgroundView.alpha = 1.0;
    self.moveView.frame = self.moveViewOrgFrame;
    [self.view layoutIfNeeded];
}

-(void)dissmissAnimate
{
    self.backgroundView.alpha = 0;
   self.moveView.frame = CGRectMake(self.moveViewOrgFrame.origin.x, self.view.frame.size.height, self.moveViewOrgFrame.size.width, self.moveViewOrgFrame.size.height);
    [self.view layoutIfNeeded];
}

-(void)dismissWithAnimated:(BOOL)flag
{
    self.backgroundView.alpha = 0;
    [self dismissViewControllerAnimated:flag completion:NULL];
}

-(void)showOn:(UIViewController *)viewCtrl
{
    self.moveView.frame = CGRectMake(self.moveViewOrgFrame.origin.x, self.view.frame.size.height, self.moveViewOrgFrame.size.width, self.moveViewOrgFrame.size.height);
    self.backgroundView.alpha = 0;

    self.modalPresentationStyle =  UIModalPresentationOverCurrentContext;
    self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [viewCtrl presentViewController:self animated:NO completion:NULL];
}

-(void)dismiss
{
    [self dismissWithCompletion:NULL];
}

-(void)dismissWithCompletion:(void (^ __nullable)(void))completion
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(gestureViewController:viewWillDismiss:)]) {
        [self.delegate gestureViewController:self viewWillDismiss:YES];
    }
    
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:0.3 animations:^{
        __strong typeof(self) strongSelf = weakself;
        strongSelf.backgroundView.alpha = 0;
        strongSelf.moveView.frame = CGRectMake(strongSelf.moveViewOrgFrame.origin.x, self.view.frame.size.height, strongSelf.moveViewOrgFrame.size.width, strongSelf.moveViewOrgFrame.size.height);
        
        if (nil != strongSelf.contentViewBottomConstraint) {
            strongSelf.contentViewBottomConstraint.constant = -strongSelf.moveViewOrgFrame.size.height;
            [strongSelf.view layoutIfNeeded];
        }
        
    } completion:^(BOOL finished) {
        __strong typeof(self) strongSelf = weakself;
        [strongSelf dismissViewControllerAnimated:NO completion:completion];
    }];

}

#pragma mark --Notify

-(void)keyboardWillShow:(NSNotification*)notification
{
    NSDictionary *userInfo = [notification userInfo];
    CGRect KeyboardRect = [[userInfo objectForKey:@"UIKeyboardFrameEndUserInfoKey"]CGRectValue];

    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    UIView * firstResponder = [self.view findFirstResponder];
    if (firstResponder != nil) {
        CGRect rect = [firstResponder convertRect:firstResponder.frame toView:window];
        NSInteger offset = KeyboardRect.origin.y - ( rect.origin.y + rect.size.height + 12);
        
        if (offset < 0) {
            
            __weak typeof(self) weakSelf = self;
            [UIView animateWithDuration:1 animations:^{
                
                weakSelf.moveView.frame = CGRectMake(weakSelf.moveViewOrgFrame.origin.x, weakSelf.moveView.frame.origin.y + offset, weakSelf.moveViewOrgFrame.size.width, weakSelf.moveViewOrgFrame.size.height);
                if (nil != weakSelf.contentViewBottomConstraint) {
                    weakSelf.contentViewBottomConstraint.constant = -offset ;
                    [weakSelf.view layoutIfNeeded];
                }
            }];
        }
    }
}

-(void)keyboardWillHide:(NSNotification*)notification
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:1 animations:^{
        weakSelf.moveView.frame = weakSelf.moveViewOrgFrame;
        if (nil != weakSelf.contentViewBottomConstraint) {
            weakSelf.contentViewBottomConstraint.constant = 0;
            [weakSelf.view layoutIfNeeded];
        }
    }];
}

@end
