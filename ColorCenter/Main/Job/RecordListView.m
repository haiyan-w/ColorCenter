//
//  RecordListView.m
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/2.
//

#import "RecordListView.h"
#import "FormulaRecordTableViewCell.h"
#import "FormulaRecordHeaderFooterView.h"
#import "NetWorkAPIManager.h"
#import "CommonTool.h"
#import "MeasureViewController.h"

@interface RecordListView ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView * tableView;
@property (strong, nonatomic) NSArray <JobHistory *>* datasource;

@property (assign, nonatomic) BOOL isJobFinished;
@end


@implementation RecordListView

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
    self.tableView = [[UITableView alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:@"FormulaRecordTableViewCell" bundle:nil] forCellReuseIdentifier:@"FormulaRecordTableViewCell"];
    [self.tableView registerClass:[FormulaRecordHeaderFooterView class] forCellReuseIdentifier:@"FormulaRecordHeaderFooterView"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.bounces = NO;//必须是NO
    [self addSubview: self.tableView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.tableView.frame = CGRectMake(0, 12, self.frame.size.width, self.frame.size.height- [CommonTool bottomSpace] - 12);

}

- (void)setJob:(Job *)job
{
    _job =  job;
    
    [self getJobHistory];
}

- (void)getJobHistory
{
    __weak typeof(self) weakSelf = self;
    NSString * url = [NSString stringWithFormat:@"/enocolor/client/job/%@/history",self.job.id];
    [[NetWorkAPIManager defaultManager] commonGET:url parm:@{} registerClass:[JobHistory class] Success:^(NSURLSessionDataTask * _Nonnull task, ResponseObject * _Nonnull responseObj) {
        __strong typeof(self) strongSelf = weakSelf;
        
        strongSelf.datasource = responseObj.data;
        for (JobHistory * history in strongSelf.datasource) {
            if (history.isFinished) {
                strongSelf.isJobFinished = YES;
            }
        }
        [strongSelf.tableView reloadData];
        
    } Failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [CommonTool showError:error];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count +2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = nil;
    if (indexPath.row == 0){
        FormulaRecordHeaderFooterView * view = [tableView dequeueReusableCellWithIdentifier:@"FormulaRecordHeaderFooterView"];
        view.isFooter = NO;
        view.datetime = self.job.preparedDatetime;
        cell = view;
    }else if (indexPath.row == self.datasource.count+2-1){
        FormulaRecordHeaderFooterView * view = [tableView dequeueReusableCellWithIdentifier:@"FormulaRecordHeaderFooterView"];
        view.isFooter = YES;
        view.datetime = self.job.preparedDatetime;
        view.disabled = !self.isJobFinished;
        cell = view;
    }else {
        FormulaRecordTableViewCell * recordCell = [tableView dequeueReusableCellWithIdentifier:@"FormulaRecordTableViewCell"];
        JobHistory * history = self.datasource[indexPath.row-1];
        recordCell.jobHistory = history;
        recordCell.isJobFinished = self.isJobFinished;
        cell = recordCell;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 70;
    if ((indexPath.row == 0) ||(indexPath.row == self.datasource.count+2-1)){
        height = 48;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.row == 0) ||(indexPath.row == self.datasource.count+2-1)){
        return;
    }else {
        JobHistory * history = self.datasource[indexPath.row-1];
        MeasureViewController * measureCtrl = [[MeasureViewController alloc] initWithJobHistoryId:history.id];
        [measureCtrl showOn:self.viewCtrl];
    }
}


@end
