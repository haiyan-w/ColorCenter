//
//  CustomViewController.m
//  EnochCar
//
//  Created by 王海燕 on 2021/5/13.
//适用普通二级及以上页面

#import "CommonViewController.h"
#import "CommonTool.h"
#import "CommonDefine.h"
#import "UIColor+CustomColor.h"

@interface CommonViewController ()<UIGestureRecognizerDelegate>

@property(nonatomic, readwrite, strong) UIButton * leftBtn;
@property(nonatomic, readwrite, strong) UILabel * titleLabel;
@property(nonatomic, readwrite, strong) UIButton * rightBtn;

@end

@implementation CommonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor bgWhiteColor];
    
    CGFloat statusBarH = [CommonTool statusbarH];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    _navbarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 44 + statusBarH)];
    _navbarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_navbarView];
    
    _leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(4, statusBarH+2, 40, 40)];
    _leftBtn.backgroundColor = [UIColor clearColor];
    [_leftBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [_leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [_navbarView addSubview:_leftBtn];
    
    CGFloat orgX = self.leftBtn.frame.origin.x + self.leftBtn.frame.size.width +4;
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(orgX, statusBarH, width - orgX -88, 44)];
    _titleLabel.text = @"";
    _titleLabel.textAlignment = NSTextAlignmentLeft;
    _titleLabel.textColor = [UIColor darkTextColor];
    _titleLabel.font =  [UIFont systemFontOfSize:18 weight:UIFontWeightSemibold];
    _titleLabel.backgroundColor = [UIColor clearColor];
    [_navbarView addSubview:_titleLabel];
    
//    self.line = [[UIView alloc] initWithFrame:CGRectMake(0, self.navbarView.frame.size.height-0.5, self.navbarView.frame.size.width, 1)];
//    self.line.backgroundColor = [UIColor lineColor];
//    [_navbarView addSubview:self.line];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taponbg:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
    //右滑返回上级页面
    UISwipeGestureRecognizer * swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipe];

}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    //检查是否在tableview 和 button 区域，否则table选中无效
    if ([touch.view isKindOfClass:[UIButton class]]){
        return NO;
    }else if ([NSStringFromClass([touch.view class]) isEqual:@"UITableViewCellContentView"]) {
        return NO;
    }else if ([NSStringFromClass([touch.view class]) isEqual:@"TouchView"]) {
        return NO;
    }else {
        return YES;
    }
}

-(void)taponbg:(UIGestureRecognizer *)gesture
{
    [CommonTool resign];
}

-(void)swipeRight:(UIGestureRecognizer *)gesture
{
    [self back];
}

-(void)back
{
    if (self.navigationController) {
        [self.navigationController  popViewControllerAnimated:YES];
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}

-(void)setMidTitle:(NSString *)midTitle
{
    _midTitle = midTitle;
    _titleLabel.text = _midTitle;
}


-(void)setTitle:(NSString *)title
{
    _titleLabel.text = title;
}

-(void)setRightBtn:(UIButton *)rightBtn
{
    _rightBtn = rightBtn;
    CGSize size = rightBtn.frame.size;
    _rightBtn.frame = CGRectMake((_navbarView.bounds.size.width - size.width - 20), _leftBtn.frame.origin.y + (44-size.height)/2, size.width, size.height);
    [_navbarView addSubview:rightBtn];
}


//-(void)networkStatusChanged:(AFNetworkReachabilityStatus)status
//{
//    if (self.isNetworkOn) {
//        self.titleLabel.text = self.midTitle;
//    }else {
//        self.titleLabel.text = [NSString stringWithFormat:@"%@%@",self.midTitle,TEXT_NETWORKOFF];
//    }
//}



@end
