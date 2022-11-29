//
//  PopViewController.m
//  EnochCar
//
//  Created by 王海燕 on 2021/5/20.
//

#import "PopViewController.h"
#import "UIColor+CustomColor.h"
#import "CommonTool.h"
#import "UIView+Hint.h"
#import "PopTableViewCell.h"

#define CELL_HEIGHT 54

@interface PopViewController ()<UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate>
@property(nonatomic,readwrite,copy)NSArray * datasource;
@property(nonatomic,readwrite,copy)NSString * poptitle;

@property(nonatomic,readwrite,strong)UIView * bgView;
@property(nonatomic,readwrite,strong)UIView * contentView;
@property(nonatomic,readwrite,strong)UILabel * titleLab;

@property(nonatomic,readwrite,assign)CGRect moveViewOrgFrame;
@end

@implementation PopViewController

-(instancetype)initWithTitle:(NSString *)title Data:(NSArray *)dataArray
{
    self = [super init];
    if (self) {
        _poptitle = title;
        _datasource = dataArray;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor clearColor];
    
    self.bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.bgView.backgroundColor = [UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:0.5];
    [self.view addSubview:self.bgView];
    
    NSInteger titleH = 52;
    NSInteger bottomH = [CommonTool bottomH];
    NSInteger maxH = [UIScreen mainScreen].bounds.size.height*2/3-titleH-bottomH;
    NSInteger cellH = CELL_HEIGHT;
    NSInteger tableH = cellH * self.datasource.count;
    if (tableH > maxH) {
        tableH = maxH;
    }
    NSInteger contentH = titleH + tableH + bottomH;
    
   _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - contentH, self.view.bounds.size.width, contentH)];
    _contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView setLRCornor];
    [self.view addSubview:_contentView];
    
    UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width, titleH)];
    titleLab.text = self.poptitle;
    titleLab.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    titleLab.textColor = [UIColor lightTextColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:titleLab];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, titleH-0.5, self.contentView.bounds.size.width, 0.5)];
    line.backgroundColor = [UIColor borderColor];
    [self.contentView addSubview:line];
    
    UITableView * tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, titleH, self.view.bounds.size.width, tableH)];
    tableview.dataSource = self;
    tableview.delegate = self;
    [tableview registerNib:[UINib nibWithNibName:@"PopTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PopTableViewCell"];
    tableview.showsVerticalScrollIndicator = NO;
    tableview.showsHorizontalScrollIndicator = NO;
    tableview.bounces = NO;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:tableview];
    
    self.backgroundView = self.bgView;
    self.moveView = self.contentView;
    self.gestureView = self.bgView;
}

-(void)addGesture
{
    //拖动手势不能直接加在self.view上，会透过addchildviewcontroller添加的view拖动底层view
    UIPanGestureRecognizer * panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandle:)];
    panRecognizer.delegate = self;
    [self.bgView addGestureRecognizer:panRecognizer];
    
    UIPanGestureRecognizer * panRecognizer2 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandle:)];
    panRecognizer2.delegate = self;
    [self.contentView addGestureRecognizer:panRecognizer2];
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taponbg)];
    tapGesture.delegate = self;
    [self.bgView addGestureRecognizer:tapGesture];
}

-(void)removeGesture
{
    for (UIGestureRecognizer * gesture in self.bgView.gestureRecognizers) {
        [self.bgView removeGestureRecognizer:gesture];
    }
    
    for (UIGestureRecognizer * gesture in self.contentView.gestureRecognizers) {
        [self.contentView removeGestureRecognizer:gesture];
    }
    
    for (UIGestureRecognizer * gesture in self.view.gestureRecognizers) {
        [self.view removeGestureRecognizer:gesture];
    }
}

-(void)taponbg
{
    [self dismiss];
}

-(void)showIn:(UIViewController *)viewCtrl
{
    self.moveView.frame = CGRectMake(self.moveViewOrgFrame.origin.x, self.view.frame.size.height, self.moveViewOrgFrame.size.width, self.moveViewOrgFrame.size.height);
    self.backgroundView.alpha = 0;

    self.modalPresentationStyle =  UIModalPresentationOverCurrentContext;
    self.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [viewCtrl presentViewController:self animated:NO completion:NULL];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PopTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"PopTableViewCell"];
    
    if (!cell) {
        cell = [[PopTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PopTableViewCell"];
    }
    cell.title = [self.datasource objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * string = [self.datasource objectAtIndex:indexPath.row];
    
    __weak typeof(self) weakSelf = self;
    [self dismissWithCompletion:^{
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(popview:disSelectRowAtIndex:)]) {
            [strongSelf.delegate popview:self disSelectRowAtIndex:indexPath.row];
        }
        
        if (self.selectBlock) {
            self.selectBlock(indexPath.row, string);
        }

    }];
}


- (void)panGestureHandle:(UIPanGestureRecognizer *)panGestureRecognizer{
    //获取拖拽手势在self.view 的拖拽姿态
    CGPoint translation = [panGestureRecognizer translationInView:self.view];

//    CGRect frame = self.contentView.frame;
    if (translation.y <= 0){
        self.contentView.frame = self.moveViewOrgFrame;
    }else if (translation.y >= self.moveViewOrgFrame.size.height) {

    }else {
        self.contentView.frame = CGRectMake(self.moveViewOrgFrame.origin.x, self.moveViewOrgFrame.origin.y +translation.y , self.moveViewOrgFrame.size.width, self.moveViewOrgFrame.size.height);
    }

    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (self.contentView.frame.origin.y >= self.view.frame.size.height/2) {
            [self dismissWithAnimated:NO];
        }else {
            self.contentView.frame = self.moveViewOrgFrame;
        }
    }
}

-(void)dismissWithAnimated:(BOOL)flag
{
    self.bgView.alpha = 0;
    [self dismiss];
//    [self dismissViewControllerAnimated:flag completion:NULL];
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
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if([NSStringFromClass([touch.view class]) isEqualToString:@"BorderView"])
    {
        return NO;
    }

    return YES;
}


@end
