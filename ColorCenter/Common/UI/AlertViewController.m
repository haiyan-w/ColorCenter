//
//  AlertViewController.m
//  EnochCar
//
//  Created by 王海燕 on 2021/11/5.
//

#import "AlertViewController.h"
#import "UIColor+CustomColor.h"
#import "CommonTool.h"
#import "NSObject+SelectorBlock.h"

@implementation AlertAction
-(instancetype)initWithTitle:(NSString *)title action:(ActionBlock)action
{
    self = [super init];
    if (self) {
        self.title = title;
        self.actionBlock = action;
    }
    return self;
}

@end

@implementation AlertItem

-(instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message position:(AlertPosition)pos actions:(NSArray<AlertAction *> *)actions
{
    self = [super init];
    if (self) {
        self.title = title;
        self.message = message;
        self.pos = pos;
        self.actions = actions;
    }
    return self;
    
}

@end

@interface AlertViewController ()< UIGestureRecognizerDelegate>

@property(nonatomic,readwrite,strong)UIView * bgView;
@property(nonatomic,readwrite,strong)UIView * contentView;
@property(nonatomic,readwrite,strong)UIScrollView * textScrollView;

@property(nonatomic,readwrite,copy)NSString * titleStr;
@property(nonatomic,readwrite,copy)NSString * message;

@property (nonatomic, readwrite,copy) NSArray<AlertAction *> *actions;
@property(nonatomic,readwrite,assign)AlertPosition pos;

@end

@implementation AlertViewController

-(instancetype)initWithItem:(AlertItem *)item
{
    self = [self initWithTitle:item.title message:item.message position:item.pos actions:item.actions];
    return self;
}


-(instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message position:(AlertPosition)pos actions:(NSArray<AlertAction *> *)actions
{
    self = [super init];
    if (self) {
        self.titleStr = title;
        self.message = message;
        self.pos = pos;
        self.actions = actions;
    }
    return self;
}

-(void)loadView
{
    [super loadView];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.bgView.backgroundColor = [UIColor bgBlackColor];
    [self.view addSubview:self.bgView];
    
    CGFloat left = 24.0f;
    CGFloat top = 24.0f;
    CGFloat space = 40.0f;
    CGFloat btnH = 55.0f;
    CGFloat textHSpace = 14.0f;
    
    CGFloat contentW = self.view.bounds.size.width * 0.85; //宽度固定
    CGFloat textW = contentW - 2*left; //文本宽度固定
    CGFloat contentMinH = 160.0f; //最小高度160
    CGFloat contentMaxH = self.view.bounds.size.height -[CommonTool statusbarH] - [CommonTool bottomH] - 2* space; //最大高度距离safearea上下各40
//    CGFloat textMinH = 160.0f - btnH - 2 * top; //文字最小高度
    CGFloat textMaxH = contentMaxH - btnH - 2 * top; //文字最大高度
    
    UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textW, 0)];
    titleLab.numberOfLines = 0;
    titleLab.text = self.titleStr;
    titleLab.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    titleLab.textColor = [UIColor textColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [titleLab sizeToFit];
    titleLab.frame = CGRectMake(0, 0, textW, titleLab.frame.size.height);
    
    CGFloat msgOrgY = (titleLab.frame.size.height > 0)?(titleLab.frame.origin.y + titleLab.frame.size.height +textHSpace):(0.0);
    UILabel * msgLab = [[UILabel alloc] initWithFrame:CGRectMake(0, msgOrgY, textW, 0)];
    msgLab.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    msgLab.textColor = [UIColor textColor];
    msgLab.textAlignment = NSTextAlignmentCenter;
    msgLab.numberOfLines = 0;
    msgLab.text = self.message;
    [msgLab sizeToFit];
    msgLab.frame = CGRectMake(0, (titleLab.frame.size.height + textHSpace), textW, msgLab.frame.size.height);
    
    CGFloat textH = titleLab.frame.size.height;
    
    if (msgLab.frame.size.height > 0) {
        textH = msgLab.frame.origin.y + msgLab.frame.size.height;
    }
    CGFloat scrollContentH = textH;
    if (textH > textMaxH) {
        textH = textMaxH;
    }
    
    CGFloat contentH = textH + btnH + 2*top;
    if (contentH < contentMinH) {
        contentH = contentMinH;
    }
    if (contentH > contentMaxH) {
        contentH = contentMaxH;
    }
    
    self.textScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(left, (contentH - btnH - textH)/2.0, textW,  textH)];
    self.textScrollView.backgroundColor = [UIColor clearColor];
    self.textScrollView.layer.masksToBounds = YES;
    [self.textScrollView addSubview:titleLab];
    [self.textScrollView addSubview:msgLab];
    self.textScrollView.bounces = NO;
    self.textScrollView.showsVerticalScrollIndicator = NO;
    self.textScrollView.showsHorizontalScrollIndicator = NO;
    self.textScrollView.contentSize = CGSizeMake(self.textScrollView.frame.size.width, scrollContentH);
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake( (self.view.bounds.size.width - contentW)/2, (self.view.bounds.size.height - contentH)/2, contentW,  contentH)];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 8.0f;
    self.contentView.layer.masksToBounds = YES;

    [self.contentView addSubview:self.textScrollView];
    [self.view addSubview:self.contentView];
    
    switch (self.pos) {
        case AlertTop:
        {
            self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, [CommonTool statusbarH] + space, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
        }
            break;
        case AlertCenter:
        {
            self.contentView.center = self.view.center;
        }
            break;
        case AlertBottom:
        {
            self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, (self.view.bounds.size.height - self.contentView.bounds.size.height - [CommonTool bottomH] - space), self.contentView.bounds.size.width, self.contentView.bounds.size.height);
        }
            break;
            
        default:
            break;
    }
    
    
    
    UIView * lineH = [[UIView alloc] initWithFrame:CGRectMake(0, self.contentView.frame.size.height - btnH, self.contentView.bounds.size.width, 1.0)];
    lineH.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self.contentView addSubview:lineH];
    
    if (self.actions.count > 0) {
        CGFloat btnW = self.contentView.bounds.size.width/self.actions.count;
        
        for ( int i = 0 ; i <self.actions.count ; i++ ) {
            
            if (i != 0) {
                UIView * lineV = [[UIView alloc] initWithFrame:CGRectMake(btnW * i, lineH.frame.origin.y + 1, 1.0, btnH -1)];
                lineV.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
                [self.contentView addSubview:lineV];
            }
            
            AlertAction * action  = [self.actions objectAtIndex:i];
            UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(i*btnW, lineH.frame.origin.y, btnW, btnH)];
            btn.backgroundColor = [UIColor clearColor];
            [btn setTitle:action.title forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor textColor] forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:17 weight:UIFontWeightMedium]];
            btn.tag = i;
            [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:btn];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
}

//-(void)addGesture
//{
//    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandle:)];
//    tapGesture.delegate = self;
//    [self.bgView addGestureRecognizer:tapGesture];
//}
//
//-(void)removeGesture
//{
//    for (UIGestureRecognizer * gesture in self.bgView.gestureRecognizers) {
//        [self.bgView removeGestureRecognizer:gesture];
//    }
//}

-(void)tapGestureHandle:(UIGestureRecognizer*)gesture
{
//    [self dismissWithcompletion:NULL];
}


-(void)btnClicked:(UIButton*)sender
{
    AlertAction * action = [self.actions objectAtIndex:sender.tag];
    
    __weak typeof(self) weakSelf = self;
    [self dismissWithcompletion:^{
        __strong typeof(self) strongSelf = weakSelf;
        action.actionBlock(strongSelf);
    }];

}


//-(void)showOn:(UIViewController *)viewCtrl
//{
//    [viewCtrl.view addSubview:self.view];
//    [viewCtrl addChildViewController:self];
//
//    [self addGesture];
//}
//
//-(void)dismissWithcompletion: (void (^ __nullable)(void))completion
//{
//    [self removeGesture];
//
//    if (self.delegate && [self.delegate respondsToSelector:@selector(alertViewWillDismiss:)]) {
//        [self.delegate alertViewWillDismiss:self];
//    }
//
//    [self.view removeFromSuperview];
//    [self removeFromParentViewController];
//
//}
//
////外部强行退出，不做任何操作
//-(void)dismissSelf
//{
//    [self removeGesture];
//    [self.view removeFromSuperview];
//    [self removeFromParentViewController];
//}

-(void)showOn:(UIViewController *)viewCtrl
{
    self.modalPresentationStyle =  UIModalPresentationOverCurrentContext;
    self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [viewCtrl presentViewController:self animated:NO completion:nil];
}

-(void)dismissWithcompletion: (void (^ __nullable)(void))completion
{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(alertViewWillDismiss:)]) {
        [self.delegate alertViewWillDismiss:self];
    }
    
    [self dismissViewControllerAnimated:NO completion:completion];
}

-(void)dismissSelf
{
    [self dismissViewControllerAnimated:NO completion:nil];
}


@end
