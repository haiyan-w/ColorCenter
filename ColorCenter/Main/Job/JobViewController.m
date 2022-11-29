//
//  JobViewController.m
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/3.
//

#import "JobViewController.h"
#import "TextTabScrollView.h"
#import "UIView+Frame.h"
#import "RecordListView.h"
#import "RecommendBaseInfoView.h"
#import "EditrecommendInfoViewController.h"
#import "SelectWorkOrderCtrl.h"
#import "NetWorkAPIManager.h"
#import "CommonTool.h"
#import "JobFormulaQuery.h"

@interface JobViewController ()
{
    Job * _job;
}
@property (strong, nonatomic) UIButton * editBtn;
@property (strong, nonatomic) TextTabScrollView * tabScrollView;
@property (nonatomic, strong) RecommendBaseInfoView * baseInfoView;
@property (nonatomic, strong) RecordListView * recordListView;

@property (strong, nonatomic) Job * job;
@property (strong, nonatomic) NSArray <JobFormulaQuery *>* jobFormulas;

@property (strong, nonatomic) NSString * brand;
@property (strong, nonatomic) NSString * year;
@property (strong, nonatomic) NSString * colorNo;

@end

@implementation JobViewController

- (instancetype)initWithJobId:(NSNumber *)Id
{
    self = [super init];
    if (self) {
        self.job.id = Id;
    }
    return self;
}

- (instancetype)initWithFormulaId:(NSNumber *)Id
{
    self = [super init];
    if (self) {
        self.job.formulaId = Id;
//        self.job.colorPanel = [[ColorPanel alloc] init];
    }
    return self;
}

- (instancetype)initWithColorPanel:(ColorPanel *)colorPanel
{
    self = [super init];
    if (self) {
        self.job.colorPanel = colorPanel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.midTitle = @"智能推荐配方";
    
    self.editBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.navbarView.right - 24 - 60, self.navbarView.bottom - 4 - 40, 60, 40)];
    [self.editBtn setTitle:@"编辑信息" forState:UIControlStateNormal];
    [self.editBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    self.editBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    [self.editBtn addTarget:self action:@selector(editBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.navbarView addSubview:self.editBtn];
    
    self.tabScrollView = [[TextTabScrollView alloc] initWithFrame:CGRectMake(0, self.navbarView.bottom +12, self.view.width, self.view.height - self.navbarView.bottom -12)];
    [self.view addSubview:self.tabScrollView];
    
    TextTabItem * item1 = [[TextTabItem alloc] initWithTitle:@"基础"];
    TextTabItem * item2 = [[TextTabItem alloc] initWithTitle:@"记录"];
    
    self.tabScrollView.items = @[item1, item2];
    
    self.baseInfoView = [[RecommendBaseInfoView alloc] init];
    __weak typeof(self) weakSelf = self;
    self.baseInfoView.selectOrderBlk = ^(WorkOrderQuery * _Nonnull order) {
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.job.sprayWorkOrder = order;
        [strongSelf updateJob];
    };
    
    self.baseInfoView.viewCtrl = self;
    
    self.recordListView = [[RecordListView alloc] init];
    self.recordListView.viewCtrl = self;
    
    self.tabScrollView.viewArray = @[self.baseInfoView, self.recordListView];
    
    if (self.job.id) {
        [self getJobWith:self.job.id];
//        [self getJobWith:[NSNumber numberWithInt:1]];
    }else {
        [self createJobWithJob:self.job];
    }
}

- (Job *)job
{
    if (!_job) {
        _job = [[Job alloc] init];
    }
    return _job;
}

- (void)editBtnClicked
{
    EditrecommendInfoViewController * editCtrl = [[EditrecommendInfoViewController alloc] initWithBrand:self.job.vehicleSpec year:[NSString stringWithFormat:@"%@",self.job.year?self.job.year:@""] colorCode:self.job.colorCode];
    __weak typeof(self) weakSelf = self;
    editCtrl.sureBlk = ^(NSArray * _Nonnull brand, NSString * _Nonnull year, NSString * _Nonnull colorCode) {
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.job.vehicleSpec = brand;
        strongSelf.job.year = [NSNumber numberWithInt:year.intValue];
        strongSelf.job.colorCode = colorCode;
        [strongSelf updateJob];
    };
    [editCtrl showOn:self];
}

- (void)setJob:(Job *)job
{
    _job = job;
    
    if (job) {
        self.baseInfoView.job = job;
        self.recordListView.job = job;
    }

}

- (void)createJobWithJob:(Job *)job
{
    __weak typeof(self) weakSelf = self;
    [[NetWorkAPIManager defaultManager] commonPOST:@"/enocolor/client/job" parm:[job convertToDictionary] registerClass:[NSObject class] Success:^(NSURLSessionDataTask * _Nonnull task, ResponseObject * _Nonnull responseObj) {
        __strong typeof(self) strongSelf = weakSelf;
        NSNumber * Id = responseObj.data.firstObject;
        [strongSelf getJobWith:Id];
        
    } Failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [CommonTool showError:error];
    }];
}

- (void)getJobWith:(NSNumber *)Id
{
    NSString * url = [NSString stringWithFormat:@"/enocolor/client/job/%@",Id];
    __weak typeof(self) weakSelf = self;
    [[NetWorkAPIManager defaultManager] commonGET:url parm:@{} registerClass:[Job class] Success:^(NSURLSessionDataTask * _Nonnull task, ResponseObject * _Nonnull responseObj) {
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.job = responseObj.data.firstObject;
    } Failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [CommonTool showError:error];
    }];
}

- (void)updateJob
{
    __weak typeof(self) weakSelf = self;
    [[NetWorkAPIManager defaultManager] commonPUT:@"/enocolor/client/job" parm:[self.job convertToDictionary] Success:^(NSURLSessionDataTask * _Nonnull task, ResponseObject * _Nonnull responseObj) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf getJobWith:strongSelf.job.id];
        
    } Failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [CommonTool showError:error];
    }];
}


@end
