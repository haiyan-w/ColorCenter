//
//  ColorMasterViewCtrl.m
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/16.
//

#import "ColorMasterViewCtrl.h"
#import "UIView+Frame.h"
#import "LoadTableView.h"
#import "NetWorkAPIManager.h"
#import "CommonTool.h"
#import "ColorMasterTableCell.h"
#import "UIColor+CustomColor.h"
#import "CommonSearchText.h"
#import "Goods.h"

@interface ColorMasterViewCtrl ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UILabel * titleLab;
@property (strong, nonatomic) CommonSearchText * searchText;
@property (strong, nonatomic) LoadTableView * tableView;
@property (strong, nonatomic) NSMutableArray <Goods *> * datasource;
@end

@implementation ColorMasterViewCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 650, self.view.width, 650)];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.contentView];
    
    self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(16, 24, self.contentView.width - 2*16, 24)];
    self.titleLab.textColor = [UIColor darkTextColor];
    self.titleLab.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    self.titleLab.text = @"添加色母";
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.titleLab];
    
    self.searchText = [[CommonSearchText alloc] initWithFrame:CGRectMake(16, self.titleLab.bottom +12, self.contentView.width-2*16, 36)];
    self.searchText.textField.placeholder  = @"色母编号/名称";
    [self.contentView addSubview:self.searchText];
    
    self.tableView = [[LoadTableView alloc] initWithFrame:CGRectMake(16, self.searchText.bottom +12, self.contentView.width - 2*16, self.contentView.height - 118)];
    [self.tableView registerClass:[ColorMasterTableCell class] forCellReuseIdentifier:@"ColorMasterTableCell"];
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
    [[NetWorkAPIManager defaultManager] commonGET:@"/enocolor/client/goods" parm:@{} registerClass:[Goods class] Success:^(NSURLSessionDataTask * _Nonnull task, ResponseObject * _Nonnull responseObj) {
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
    [[NetWorkAPIManager defaultManager] commonGET:@"/enocolor/client/goods" parm:@{@"pageIndex":[NSNumber numberWithInteger:self.tableView.pageIndex+1]} registerClass:[Goods class] Success:^(NSURLSessionDataTask * _Nonnull task, ResponseObject * _Nonnull responseObj) {
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
    ColorMasterTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"ColorMasterTableCell"];
    cell.goods = self.datasource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Goods * goods = self.datasource[indexPath.row];
    __weak typeof(self) weakSelf = self;
    [self dismissWithCompletion:^{
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf.selectBlk) {
            strongSelf.selectBlk(goods);
        }
    }];
}

@end
