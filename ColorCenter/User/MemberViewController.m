//
//  MemberViewController.m
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/2.
//

#import "MemberViewController.h"
#import "LoadTableView.h"
#import "MemberTableViewCell.h"
#import "NetWorkAPIManager.h"
#import "UIView+Hint.h"
#import "UIView+Frame.h"
#import "PopViewController.h"

@interface MemberViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) LoadTableView * tableView;
@property (strong, nonatomic) NSMutableArray * datasource;
@end

@implementation MemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.midTitle = @"成员";
    
    self.tableView = [[LoadTableView alloc] initWithFrame:CGRectMake(0, self.navbarView.bottom, self.view.frame.size.width, self.view.frame.size.height - self.navbarView.bottom)];
    [self.tableView registerNib:[UINib nibWithNibName:@"MemberTableViewCell" bundle:nil] forCellReuseIdentifier:@"MemberTableViewCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    __weak typeof(self) weakSelf = self;
    
    self.tableView.refreshBlock = ^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf loadData];
    };
    
    self.tableView.loadMoreBlock = ^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf loadMore];
    };
    
    [self.view addSubview: self.tableView];
}



- (void)loadData
{
    __weak typeof(self) weakSelf = self;
    [[NetWorkAPIManager defaultManager] commonGET:@"/enocolor/client/formula" parm:@{} registerClass:[NSObject class] Success:^(NSURLSessionDataTask * _Nonnull task, ResponseObject * _Nonnull responseObj) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf.datasource removeAllObjects];
        if (responseObj.data.count > 0) {
            [strongSelf.datasource addObjectsFromArray:responseObj.data];
        }
        [strongSelf.tableView endRefresh];
        
    } Failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        __strong typeof(self) strongSelf = weakSelf;
        
        
        
    }];
}

- (void)loadMore
{
    __weak typeof(self) weakSelf = self;
    [[NetWorkAPIManager defaultManager] commonGET:@"/enocolor/client/formula" parm:@{@"pageIndex":[NSNumber numberWithInteger:self.tableView.pageIndex+1]} registerClass:[NSObject class] Success:^(NSURLSessionDataTask * _Nonnull task, ResponseObject * _Nonnull responseObj) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf.datasource removeAllObjects];
        if (responseObj.data.count > 0) {
            [strongSelf.datasource addObjectsFromArray:responseObj.data];
        }
        [strongSelf.tableView endRefresh];
        
    } Failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        __strong typeof(self) strongSelf = weakSelf;
        
        
        
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
//    return self.datasource.count;
    return 11;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MemberTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MemberTableViewCell"];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PopViewController * popCtrl = [[PopViewController alloc] initWithTitle:@"编辑" Data:@[@"暂停使用"]];
    __weak  typeof(self) weakSelf = self;
    popCtrl.selectBlock = ^(NSInteger index, NSString * _Nonnull string) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf pauseMemberAt:indexPath.row];
    };
    [popCtrl showOn:self];
}

- (void)pauseMemberAt:(NSInteger)index
{
    [self.tableView refresh];
}


@end
