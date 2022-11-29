//
//  JobView.m
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/1.
//

#import "JobView.h"
#import "FormulaTableViewCell.h"
#import "LoadTableView.h"
#import "NetWorkAPIManager.h"
#import "Formula.h"
#import "JobViewController.h"
#import "CommonTool.h"
#import "SortView.h"
#import "JobQuery.h"
#import "UIColor+CustomColor.h"

#define TAG_SORT_TIME 112
#define TAG_SORT_STATE 113

@interface JobView () <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic,readwrite,strong) SortView * timeSortView;
@property(nonatomic,readwrite,strong) SortView * stateSortView;
@property (strong, nonatomic) LoadTableView * tableView;
@property (strong, nonatomic) NSMutableArray <JobQuery *>* datasource;
@property (strong, nonatomic) NSIndexPath * editingIndexPath;
@end



@implementation JobView

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
    self.timeSortView = [[SortView alloc] initWithFrame:CGRectMake(24, 12, 62, 24)];
    self.timeSortView.backgroundColor = [UIColor whiteColor];
    self.timeSortView.viewCtrl = self.viewCtrl;
    self.timeSortView.maxLenth = 90;
    LookUp * item1 = [[LookUp alloc] initWithCode:@"" message:@"最新"];
    LookUp * item2 = [[LookUp alloc] initWithCode:@"preparedDatetime" message:@"最旧"];
    self.timeSortView.items = @[item1, item2];
    __weak typeof(self) weakSelf = self;
    self.timeSortView.changeBlock = ^(LookUp * _Nonnull item) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf layoutSortViews];
        [strongSelf.tableView refresh];
    };
    [self addSubview:self.timeSortView];
    
    self.stateSortView = [[SortView alloc] initWithFrame:CGRectMake(self.timeSortView.frame.origin.x + self.timeSortView.frame.size.width + 24, self.timeSortView.frame.origin.y, 77, self.timeSortView.frame.size.height)];
    self.stateSortView.backgroundColor = [UIColor whiteColor];
    self.stateSortView.viewCtrl = self.viewCtrl;
    self.stateSortView.maxLenth = 90;
    LookUp * item11 = [[LookUp alloc] initWithCode:@"" message:@"全部"];
    LookUp * item12 = [[LookUp alloc] initWithCode:@"V" message:@"已完成"];
    LookUp * item13 = [[LookUp alloc] initWithCode:@"P" message:@"进行中"];
    self.stateSortView.items = @[item11, item12, item13];
    self.stateSortView.changeBlock = ^(LookUp * _Nonnull item) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf layoutSortViews];
        [strongSelf.tableView refresh];
    };
    [self addSubview:self.stateSortView];
    
    self.tableView = [[LoadTableView alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:@"FormulaTableViewCell" bundle:nil] forCellReuseIdentifier:@"FormulaTableViewCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.emptyText = @"暂无任务";
    self.tableView.emptyImgName = @"empty_noContent";
    [self addSubview: self.tableView];

    self.tableView.refreshBlock = ^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf loadData];
    };

    self.tableView.loadMoreBlock = ^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf loadMore];
    };
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self layoutSortViews];
    self.tableView.frame = CGRectMake(16, 48, self.frame.size.width - 2*16, self.frame.size.height - 36);

}

-(void)layoutSortViews
{
    self.timeSortView.frame = CGRectMake(self.timeSortView.frame.origin.x, self.timeSortView.frame.origin.y, self.timeSortView.frame.size.width, self.timeSortView.frame.size.height);
    
    self.stateSortView.frame = CGRectMake(self.timeSortView.frame.origin.x + self.timeSortView.frame.size.width + 24, self.timeSortView.frame.origin.y, self.stateSortView.frame.size.width, self.stateSortView.frame.size.height);
    
}

- (void)setViewCtrl:(UIViewController *)viewCtrl
{
    _viewCtrl = viewCtrl;
    
    self.timeSortView.viewCtrl = viewCtrl;
    self.stateSortView.viewCtrl = viewCtrl;
}

- (void)refresh
{
    [self.tableView refresh];
}

- (void)loadData
{
    __weak typeof(self) weakSelf = self;
    [[NetWorkAPIManager defaultManager] commonGET:@"/enocolor/client/job/query" parm:@{@"status":self.stateSortView.curItem.code, @"sortedBy":self.timeSortView.curItem.code} registerClass:[JobQuery class] Success:^(NSURLSessionDataTask * _Nonnull task, ResponseObject * _Nonnull responseObj) {
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
    [[NetWorkAPIManager defaultManager] commonGET:@"/enocolor/client/job/query" parm:@{@"pageIndex":[NSNumber numberWithInteger:self.tableView.pageIndex+1]} registerClass:[JobQuery class] Success:^(NSURLSessionDataTask * _Nonnull task, ResponseObject * _Nonnull responseObj) {
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



#pragma mark Delegate

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
    FormulaTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FormulaTableViewCell"];
    cell.job = self.datasource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 122;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JobQuery * job = self.datasource[indexPath.row];
    JobViewController * ctrl = [[JobViewController alloc] initWithJobId:job.id];
    [self.viewCtrl.navigationController pushViewController:ctrl animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSArray*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __weak typeof(self) weakSelf = self;
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"        " handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        __strong typeof(self) strongSelf = weakSelf;
        Job * job = strongSelf.datasource[indexPath.row];
        [strongSelf deleteAJob:job];

    }];
    
    deleteAction.backgroundColor = [UIColor blackColor];
    return @[deleteAction];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    editingStyle = UITableViewCellEditingStyleDelete;
}

// iOS11以上走这里
- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    //删除
    __weak typeof(self) weakSelf = self;

    UIContextualAction *deleteRowAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        __strong typeof(self) strongSelf = weakSelf;
        Job * job = strongSelf.datasource[indexPath.row];
        [strongSelf deleteAJob:job];
        completionHandler (YES);
    }];
    deleteRowAction.image = [UIImage imageNamed:@"delete_red"];
    deleteRowAction.backgroundColor = [UIColor bgWhiteColor];

    UISwipeActionsConfiguration *config = [UISwipeActionsConfiguration configurationWithActions:@[deleteRowAction]];
    return config;
}


- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    self.editingIndexPath = indexPath;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setupDeleteBtn];
    });
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.editingIndexPath = nil;
}

-(void)setupDeleteBtn
{
    if ([CommonTool systemVersion].floatValue >= 11.0) {
        
        // iOS11以上用trailingSwipeActionsConfigurationForRowAtIndexPath
        
//        for (UIView * subview in self.view.subviews) {
//            if ([subview isKindOfClass:NSClassFromString(@"UISwipeActionPullView")] && ([subview.subviews count] >= 1)) {
//                //删除
//                UIView * deleteView = subview.subviews[0];
//                [self setupRowActionView:deleteView imageName:@"delete_record"];
//            }
//        }
        
    }else {
        
        // iOS11以下做法
        FormulaTableViewCell * cell = [self.tableView cellForRowAtIndexPath:self.editingIndexPath];
        for (UIView *subView in cell.subviews) {
            if ([subView isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")] && [subView.subviews count] >= 1)
            {
                // 删除
                UIView *deleteContentView = subView.subviews[0];
                [self setupRowActionView:deleteContentView imageName:@"delete_red"];
            }
        }
    }
}

// 设置背景图片
- (void)setupRowActionView:(UIView *)rowActionView imageName:(NSString *)imageName
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [rowActionView addSubview:imageView];
}

- (void)deleteAJob:(Job *)job
{
    NSString * url = [NSString stringWithFormat:@"/enocolor/client/job/%@",job.id];
    __weak typeof(self) weakSelf = self;
    [[NetWorkAPIManager defaultManager] commonDelete:url parm:@{} Success:^(NSURLSessionDataTask * _Nonnull task, ResponseObject * _Nonnull responseObj) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf.tableView refresh];
        
    } Failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [CommonTool showError:error];
    }];
}

@end
