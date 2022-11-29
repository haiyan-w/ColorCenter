//
//  SelectWorkOrderCtrl.m
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/14.
//

#import "SelectWorkOrderCtrl.h"
#import "UIView+Frame.h"
#import "LoadTableView.h"
#import "NetWorkAPIManager.h"
#import "CommonTool.h"
#import "WorkOrderTableCell.h"
#import "UIColor+CustomColor.h"

@interface SelectWorkOrderCtrl () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UILabel * titleLab;
@property (strong, nonatomic) UILabel * countLab;
@property (strong, nonatomic) LoadTableView * tableView;
@property (strong, nonatomic) NSMutableArray <WorkOrderQuery *> * datasource;
@end

@implementation SelectWorkOrderCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 88, self.view.width, self.view.height - 88)];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.contentView];
    
    self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(16, 24, self.contentView.width - 2*16, 24)];
    self.titleLab.textColor = [UIColor darkTextColor];
    self.titleLab.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    self.titleLab.text = @"添加维修工单";
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.titleLab];
    
    UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(16, 62, self.contentView.width - 2*16, 1)];
    line1.backgroundColor = [UIColor lineColor];
    [self.contentView addSubview:line1];
    
    UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(16, 106, self.contentView.width - 2*16, 1)];
    line2.backgroundColor = [UIColor lineColor];
    [self.contentView addSubview:line2];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(24, 74, 120, 20)];
    label.text = @"以诺行喷涂OA授权";
    label.textColor = [UIColor darkTextColor];
    label.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    [self.contentView addSubview:label];
    
    self.countLab = [[UILabel alloc] initWithFrame:CGRectMake(self.contentView.width - 100 - 24, 74, 100, 20)];
    self.countLab.text = @"0个维修中";
    self.countLab.textColor = [UIColor customRedColor];
    self.countLab.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    self.countLab.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.countLab];
    
    self.tableView = [[LoadTableView alloc] initWithFrame:CGRectMake(16, 118, self.contentView.width - 2*16, self.contentView.height - 118)];
    [self.tableView registerClass:[WorkOrderTableCell class] forCellReuseIdentifier:@"WorkOrderTableCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.emptyText = @"暂无内容";
    self.tableView.emptyImgName = @"empty_noContent";
    [self.contentView addSubview: self.tableView];
    
    __weak typeof(self) weakSelf = self;

    self.tableView.refreshBlock = ^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf loadData];
    };

    self.tableView.loadMoreBlock = ^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf loadMore];
    };
    
    self.backgroundView = self.bgView;
    self.gestureView = self.bgView;
    self.moveView = self.contentView;
    
}


- (void)loadData
{
    __weak typeof(self) weakSelf = self;
    [[NetWorkAPIManager defaultManager] commonGET:@"/enocolor/client/work/order" parm:@{} registerClass:[WorkOrderQuery class] Success:^(NSURLSessionDataTask * _Nonnull task, ResponseObject * _Nonnull responseObj) {
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.countLab.text = [NSString stringWithFormat:@"%@个维修中",responseObj.meta.paging.itemCount];
        
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
    [[NetWorkAPIManager defaultManager] commonGET:@"/enocolor/client/work/order" parm:@{@"pageIndex":[NSNumber numberWithInteger:self.tableView.pageIndex+1]} registerClass:[WorkOrderQuery class] Success:^(NSURLSessionDataTask * _Nonnull task, ResponseObject * _Nonnull responseObj) {
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
    WorkOrderTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"WorkOrderTableCell"];
    [cell setWorkOrder:self.datasource[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 84;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WorkOrderQuery * order = self.datasource[indexPath.row];
    __weak typeof(self) weakSelf = self;
    [self dismissWithCompletion:^{
        __strong typeof(self) strongSelf = weakSelf;
        if (self.selectBlk) {
            self.selectBlk(order);
        }
    }];
}

@end
