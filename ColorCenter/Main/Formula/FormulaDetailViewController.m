//
//  FormulaDetailViewController.m
//  ColorCenter
//
//  Created by 王海燕 on 2022/10/31.
//

#import "FormulaDetailViewController.h"
#import "UIView+Frame.h"
#import "TextTabView.h"
#import "UIColor+CustomColor.h"
#import "CommonTool.h"
#import "AFormulaView.h"
#import "NetWorkAPIManager.h"
#import "AdjustViewController.h"
#import "MeasureViewController.h"
#import "RefreshView.h"

@interface FormulaDetailViewController ()<TabViewDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) NSArray <JobFormulaQuery *> * formulas;
@property (nonatomic, assign) int index;
@property (nonatomic, strong) AFormulaView * lastFormulaView;
@property (nonatomic, strong) RefreshView * upTipView;
@property (nonatomic, strong) AFormulaView * formulaView;
@property (nonatomic, strong) RefreshView * downTipView;
@property (nonatomic, strong) AFormulaView * nextFormulaView;
@end

@implementation FormulaDetailViewController

- (instancetype)initWithFormulas:(NSArray <JobFormulaQuery *> *)formulas index:(int)index
{
    self = [super init];
    if (self) {
        self.formulas = formulas;
        self.index = index;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.midTitle = @"配方详情";
    
    float orgY = self.navbarView.frame.origin.y + self.navbarView.frame.size.height ;
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, orgY, self.view.frame.size.width, self.view.frame.size.height - orgY)];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    [self.view addSubview:self.scrollView];
    
    self.formulaView = [[AFormulaView alloc] initWithFrame:self.scrollView.bounds];
    __weak typeof(self) weakSelf = self;
    self.formulaView.confirmBlk = ^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf showConfirmView];
    };
    self.formulaView.adjustBlk = ^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf showAdjustView];
    };
    [self.scrollView addSubview:self.formulaView];
    self.scrollView.delegate = self;
    
    self.downTipView = [[RefreshView alloc] initWithFrame:CGRectMake(0, self.scrollView.height, self.scrollView.width, 32)];
    self.downTipView.normalText = @"上拉查看下个配方";
    self.downTipView.endText = @"已经到底啦";
    self.downTipView.iconName = @"arrowup";
    [self.scrollView addSubview:self.downTipView];
    
    self.upTipView = [[RefreshView alloc] initWithFrame:CGRectMake(0, -32, self.scrollView.width, 32)];
    self.upTipView.normalText = @"下拉查看上个配方";
    self.upTipView.endText = @"已经是第一个啦";
    self.upTipView.iconName = @"arrowdown";
    [self.scrollView addSubview:self.upTipView];
    
    JobFormulaQuery * formula = self.formulas[self.index];
    [self getFormulaWith:formula.id];
    [self getNextFormula];
}

- (void)setIndex:(int)index
{
    _index = index;
    
    self.upTipView.end = (self.index == 0)?YES:NO;
    self.downTipView.end = (self.index == self.formulas.count-1)?YES:NO;
    
    [self getNextFormula];
}


- (void)getFormulaWith:(NSNumber *)Id
{
    __weak typeof(self) weakSelf = self;
//    NSString * url = [NSString stringWithFormat:@"/enocolor/client/formula/%@",Id];
    NSString * url = [NSString stringWithFormat:@"/enocolor/client/formula/238833"];
    [[NetWorkAPIManager defaultManager] commonGET:url parm:@{} registerClass:[Formula class] Success:^(NSURLSessionDataTask * _Nonnull task, ResponseObject * _Nonnull responseObj) {
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.formulaView.formula = responseObj.data.firstObject;
        float height = [AFormulaView heightWithFormula:responseObj.data.firstObject];
        strongSelf.formulaView.frame = CGRectMake(0, 0, strongSelf.scrollView.width, height);
        strongSelf.scrollView.contentSize = CGSizeMake(strongSelf.scrollView.width, height);
        self.downTipView.frame = CGRectMake(0, self.formulaView.bottom, self.scrollView.width, 32);
        
    } Failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [CommonTool getErrorMessage:error];
    }];
}

- (void)getNextFormula
{
    if (self.index == self.formulas.count - 1) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    JobFormulaQuery * formula = self.formulas[self.index +1];
//    NSString * url = [NSString stringWithFormat:@"/enocolor/client/formula/%@",formula.id];
    NSString * url = [NSString stringWithFormat:@"/enocolor/client/formula/238833"];
    [[NetWorkAPIManager defaultManager] commonGET:url parm:@{} registerClass:[Formula class] Success:^(NSURLSessionDataTask * _Nonnull task, ResponseObject * _Nonnull responseObj) {
        __strong typeof(self) strongSelf = weakSelf;
        Formula * formula = responseObj.data.firstObject;
        float height = [AFormulaView heightWithFormula:formula];
        if (self.nextFormulaView) {
            [self.nextFormulaView removeFromSuperview];
        }
        self.nextFormulaView = [[AFormulaView alloc] initWithFrame:CGRectMake(0, strongSelf.downTipView.bottom, strongSelf.scrollView.width, height)];
        self.nextFormulaView.formula = formula;
        [self.scrollView addSubview:self.nextFormulaView];
        strongSelf.scrollView.contentSize = CGSizeMake(strongSelf.scrollView.width, strongSelf.formulaView.bottom);
        
    } Failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [CommonTool getErrorMessage:error];
    }];
}

- (void)getLastFormula
{
    if (self.index == 0) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
//    JobFormulaQuery * formula = self.formulas[self.index -1];
//    NSString * url = [NSString stringWithFormat:@"/enocolor/client/formula/%@",formula.id];
    NSString * url = [NSString stringWithFormat:@"/enocolor/client/formula/238833"];
    [[NetWorkAPIManager defaultManager] commonGET:url parm:@{} registerClass:[Formula class] Success:^(NSURLSessionDataTask * _Nonnull task, ResponseObject * _Nonnull responseObj) {
        __strong typeof(self) strongSelf = weakSelf;
        Formula * formula = responseObj.data.firstObject;
        float height = [AFormulaView heightWithFormula:formula];
        self.lastFormulaView = [[AFormulaView alloc] initWithFrame:CGRectMake(0, strongSelf.downTipView.bottom, strongSelf.scrollView.width, height)];
        self.lastFormulaView.formula = formula;
        [self.scrollView addSubview:self.lastFormulaView];
        strongSelf.scrollView.contentSize = CGSizeMake(strongSelf.scrollView.width, self.nextFormulaView.bottom);
        
    } Failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [CommonTool getErrorMessage:error];
    }];
}

//上车
- (void)showConfirmView
{
    MeasureViewController * measureCtrl = [[MeasureViewController alloc] initWithFormula:self.formulaView.formula];
    measureCtrl.job = self.job;
    [measureCtrl showOn:self];
}

- (void)showAdjustView
{
    AdjustViewController * adjustCtrl = [[AdjustViewController alloc] initWithFormula:self.formulaView.formula];
    adjustCtrl.job = self.job;
    [self.navigationController pushViewController:adjustCtrl animated:YES];
}


#pragma mark Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ((scrollView.contentOffset.y > (self.downTipView.top-self.scrollView.height) + 150) && self.scrollView.isDragging ) {
        if (self.nextFormulaView) {
            [self.formulaView removeFromSuperview];
            self.formulaView = self.nextFormulaView;
            self.nextFormulaView = nil;
            self.formulaView.frame = CGRectMake(0, 0, self.formulaView.width, self.formulaView.height);
            self.downTipView.frame = CGRectMake(0, self.formulaView.bottom, self.scrollView.width, 32);
            self.scrollView.contentOffset = CGPointMake(0, 0);
            self.scrollView.contentSize = CGSizeMake(self.scrollView.width, self.formulaView.bottom);
            if (self.index < self.formulas.count -1) {
                self.index = self.index + 1;
                [self getNextFormula];
            }
        }
        
    }else if ((scrollView.contentOffset.y <= -150) && self.scrollView.isDragging ) {
        if (self.lastFormulaView) {
            [self.formulaView removeFromSuperview];
            self.formulaView = self.lastFormulaView;
            self.lastFormulaView = nil;
            self.formulaView.frame = CGRectMake(0, 0, self.formulaView.width, self.formulaView.height);
            self.upTipView.frame = CGRectMake(0, -32, self.scrollView.width, 32);
            self.scrollView.contentOffset = CGPointMake(0, 0);
            self.scrollView.contentSize = CGSizeMake(self.scrollView.width, self.formulaView.bottom);
            if (self.index >= 1) {
                self.index = self.index - 1;
                [self getLastFormula];
            }
        }else {
            if (self.index >= 1)  {
                [self getLastFormula];
            }
        }
        
    }else {
        
        
    }
    
//    if ((scrollView.contentOffset.y <= self.downTipView.bottom) && (scrollView.contentOffset.y > self.downTipView.bottom - 10)) {
//        [self.formulaView removeFromSuperview];
//        self.formulaView = self.nextFormulaView;
//        self.nextFormulaView = nil;
//        self.formulaView.frame = CGRectMake(0, 0, self.formulaView.width, self.formulaView.height);
//        self.downTipView.frame = CGRectMake(0, self.formulaView.bottom, self.scrollView.width, 32);
//        self.scrollView.contentOffset = CGPointMake(0, 0);
//        self.index = self.index + 1;
//        [self getNextFormula];
//    }else {
//        float height = [AFormulaView heightWithFormula:self.nextFormulaView.formula];
//        self.nextFormulaView.frame = CGRectMake(0, self.downTipView.bottom, self.scrollView.width, height);
//        self.scrollView.contentSize = CGSizeMake(self.scrollView.width, self.nextFormulaView.bottom);
//    }
}

@end
