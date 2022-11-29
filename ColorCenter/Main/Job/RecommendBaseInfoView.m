//
//  RecommendedFormulaBaseInfoView.m
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/3.
//

#import "RecommendBaseInfoView.h"
#import "RecommendBaseTableCell.h"
#import "LoadTableView.h"
#import "NetWorkAPIManager.h"
#import "FormulaDetailViewController.h"
#import "CommonTool.h"
#import "JobFormulaQuery.h"
#import "LoopTipView.h"
#import "OrderInfoView.h"
#import "UIView+Frame.h"
#import "SelectWorkOrderCtrl.h"
#import "UIColor+CustomColor.h"

@interface RecommendBaseInfoView ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) LoopTipView * tipView;
@property (strong, nonatomic) OrderInfoView * orderView;
@property (strong, nonatomic) LoadTableView * tableView;
@property (strong, nonatomic) NSMutableArray <JobFormulaQuery *>* datasource;
@end

@implementation RecommendBaseInfoView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self viewInit];
    }
    
    return self;
}

- (void)viewInit
{
    __weak typeof(self) weakSelf = self;
    
    self.tipView = [[LoopTipView alloc] init];
    [self addSubview:self.tipView];
    
    self.orderView = [[OrderInfoView alloc] init];
    self.orderView.operateBlk = ^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf showSelectOrder];
    };
    [self addSubview:self.orderView];
    
    self.tableView = [[LoadTableView alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:@"RecommendBaseTableCell" bundle:nil] forCellReuseIdentifier:@"RecommendBaseTableCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.emptyText = @"暂无配方";
    self.tableView.emptyImgName = @"empty_noContent";
    [self addSubview: self.tableView];
    self.tableView.backgroundColor = [UIColor clearColor];

    self.tableView.refreshBlock = ^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf loadData];
    };

    self.tableView.loadMoreBlock = ^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf loadMore];
    };

    [self.tipView play];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!self.job.sprayWorkOrder) {
        self.tipView.frame = CGRectMake(0, 12, self.width, 32);
    }else {
        self.tipView.frame = CGRectMake(0, 12, self.width, 0);
    }
    
    self.orderView.frame = CGRectMake(16, self.tipView.bottom + 12, self.width - 2*16, 48);
    if (self.job.sprayWorkOrder) {
        self.orderView.frame = CGRectMake(16, self.tipView.bottom + 12, self.width - 2*16, 72);
    }
    
    self.tableView.frame = CGRectMake(0, self.orderView.bottom + 12, self.frame.size.width, self.frame.size.height - 36);
}

- (void)showSelectOrder
{
    SelectWorkOrderCtrl * orderCtrl = [[SelectWorkOrderCtrl alloc] init];
    __weak typeof(self) weakSelf = self;
    orderCtrl.selectBlk = ^(WorkOrderQuery * _Nonnull order) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf.selectOrderBlk) {
            strongSelf.selectOrderBlk(order);
        }
    };
    [orderCtrl showOn:self.viewCtrl];
}

- (void)setJob:(Job *)job
{
    _job =  job;
    
    [self.orderView setWorkOrder:job.sprayWorkOrder];
    [self layoutSubviews];
    [self.tableView refresh];
}

- (void)refresh
{
    [self.tableView refresh];
}

- (void)loadData
{
    if (!self.job.id) {
        [self.datasource removeAllObjects];
        [self.tableView refreshSuccess];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    NSString * url = [NSString stringWithFormat:@"/enocolor/client/job/%@/formula",self.job.id];
    [[NetWorkAPIManager defaultManager] commonGET:url parm:@{} registerClass:[JobFormulaQuery class] Success:^(NSURLSessionDataTask * _Nonnull task, ResponseObject * _Nonnull responseObj) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf.datasource removeAllObjects];
        if (responseObj.data.count > 0) {
            [strongSelf.datasource addObjectsFromArray:responseObj.data];
        }
        strongSelf.tableView.pageIndex = responseObj.meta.paging.pageIndex.integerValue;
        strongSelf.tableView.pageCount = responseObj.meta.paging.pageCount.integerValue;
        [strongSelf.tableView refreshSuccess];
        
    } Failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf.tableView refreshFailureWith:[CommonTool getErrorMessage:error]];
    }];
}

- (void)loadMore
{
    __weak typeof(self) weakSelf = self;
    NSString * url = [NSString stringWithFormat:@"/enocolor/client/job/%@/formula",self.job.id];
    [[NetWorkAPIManager defaultManager] commonGET:url parm:@{@"pageIndex":[NSNumber numberWithInteger:self.tableView.pageIndex+1]} registerClass:[JobFormulaQuery class] Success:^(NSURLSessionDataTask * _Nonnull task, ResponseObject * _Nonnull responseObj) {
        __strong typeof(self) strongSelf = weakSelf;
        __weak typeof(self) weakSelf2 = strongSelf;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(self) strongSelf2 = weakSelf2;
            strongSelf2.tableView.pageIndex = responseObj.meta.paging.pageIndex.integerValue;
            strongSelf2.tableView.pageCount = responseObj.meta.paging.pageCount.integerValue;
            if (responseObj.data.count > 0) {
                [strongSelf2.datasource addObjectsFromArray:responseObj.data];
            }
            [strongSelf2.tableView loadMoreSuccess];
        });
        
    } Failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        __strong typeof(self) strongSelf = weakSelf;
        __weak typeof(self) weakSelf2 = strongSelf;
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(self) strongSelf2 = weakSelf2;
            [strongSelf2.tableView loadMoreFailure];
        });
    }];
}


- (NSMutableArray *)datasource
{
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendBaseTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"RecommendBaseTableCell"];
    cell.formula = self.datasource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 234;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FormulaDetailViewController * ctrl = [[FormulaDetailViewController alloc] initWithFormulas:self.datasource index:indexPath.row];
    ctrl.job = self.job;
    [self.viewCtrl.navigationController pushViewController:ctrl animated:YES];
}

@end
