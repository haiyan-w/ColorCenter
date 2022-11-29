//
//  MeasureViewController.m
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/18.
//

#import "MeasureViewController.h"
#import "CommonButton.h"
#import "AFormulaTableCell.h"
#import "NetWorkAPIManager.h"
#import "Job.h"
#import "BlueToothViewController.h"
#import "BlueToothManager.h"
#import "AdjustViewController.h"

@interface MeasureViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UILabel * titleLab;
@property (strong, nonatomic) UILabel * subLab;

@property (strong, nonatomic) UIView * totalView;
@property (strong, nonatomic) UILabel * countLab;

@property(nonatomic, readwrite, strong) UIView * tableTitleView;
@property (strong, nonatomic) UITableView * tableView;
@property (strong, nonatomic) NSArray <FormulaDetail *> * datasource;

@property(nonatomic, readwrite, strong) UIView * btnView;
@property(nonatomic, readwrite, strong) CommonButton * measureBtn;//测量

@property(nonatomic, readwrite, strong) CommonButton * adjustBtn;//再次微调
@property(nonatomic, readwrite, strong) CommonButton * jobfinishBtn;//上车

@property(nonatomic, readwrite, strong) NSNumber * jobHistoryId;
@property(nonatomic, readwrite, strong) Formula * formula;
@end

@implementation MeasureViewController

- (instancetype)initWithJobHistoryId:(NSNumber *)jobHistoryId
{
    self = [super init];
    if (self) {
        self.jobHistoryId = jobHistoryId;
    }
    return self;
}


- (instancetype)initWithJobHistory:(JobHistory *)jobHistory
{
    self = [super init];
    if (self) {
        self.jobHistory = jobHistory;
        
    }
    return self;
}

- (instancetype)initWithFormula:(Formula *)formula
{
    self = [super init];
    if (self) {
        self.formula = formula;
        self.datasource = formula.details;
    }
    return self;
}

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
    self.titleLab.text = @"";
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.titleLab];
    
    self.subLab = [[UILabel alloc] initWithFrame:CGRectMake(16, 54, self.contentView.width - 2*16, 22)];
    self.subLab.textColor = [UIColor slightTextColor];
    self.subLab.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    self.subLab.text = @"";
    self.subLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.subLab];
    
    self.totalView = [[UIView alloc] initWithFrame:CGRectMake(16, 100, self.contentView.width-2*16, 46)];
    self.totalView.backgroundColor = [UIColor bgWhiteColor];
    self.totalView.layer.cornerRadius = 8.0;
    [self.contentView addSubview:self.totalView];
    
    UIImageView * icon = [[UIImageView alloc] initWithFrame:CGRectMake(16, (self.totalView.height - 16)/2, 16, 16)];
    icon.image = [UIImage imageNamed:@"droplet"];
    [self.totalView addSubview:icon];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(40, (self.totalView.height - 22)/2, 100, 22)];
    label.textColor = [UIColor darkTextColor];
    label.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    label.text = @"用量";
    [self.totalView addSubview:label];
    
    self.countLab = [[UILabel alloc] initWithFrame:CGRectMake((self.totalView.width - 100 -16), (self.totalView.height - 22)/2, 100, 22)];
    self.countLab.textColor = [UIColor textColor];
    self.countLab.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    self.countLab.textAlignment = NSTextAlignmentRight;
    self.countLab.text = @"0g";
    [self.totalView addSubview:self.countLab];
    
    self.tableTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, self.totalView.bottom+16, self.view.width, 40)];
    [self.contentView addSubview:self.tableTitleView];
    
    UILabel * label1 = [[UILabel alloc] initWithFrame:CGRectMake(24, (self.tableTitleView.height - 24)/2, 40, 24)];
    label1.textColor = [UIColor darkTextColor];
    label1.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    label1.text = @"编号";
    [self.tableTitleView addSubview:label1];
    
    UILabel * label2 = [[UILabel alloc] initWithFrame:CGRectMake(124, (self.tableTitleView.height - 24)/2, 34, 24)];
    label2.textColor = [UIColor darkTextColor];
    label2.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    label2.text = @"色母";
    [self.tableTitleView addSubview:label2];
    
    UILabel * label3 = [[UILabel alloc] initWithFrame:CGRectMake((self.tableTitleView.width - 24 - 40), (self.tableTitleView.height - 24)/2, 40, 24)];
    label3.textColor = [UIColor darkTextColor];
    label3.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    label3.text = @"重量";
    label3.textAlignment = NSTextAlignmentRight;
    [self.tableTitleView addSubview:label3];
    
    self.btnView = [[UIView alloc] initWithFrame:CGRectMake(0, self.contentView.height - 80, self.contentView.width, 80)];
    [self.contentView addSubview:self.btnView];
    self.measureBtn = [[CommonButton alloc] initWithFrame:CGRectMake(24, 2, self.btnView.width - 2*24, 44) title:@"测量"];
    [self.measureBtn setImage:[UIImage imageNamed:@"measure"] forState:UIControlStateNormal];
    [self.measureBtn addTarget:self action:@selector(measureBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.btnView addSubview:self.measureBtn];
    self.measureBtn.hidden = YES;
    
    float btnW = (self.view.width - 2*24 - 12)/2.0;
    self.adjustBtn = [[CommonButton alloc] initWithFrame:CGRectMake(24, 2, btnW, 44) title:@"再次微调"];
    self.adjustBtn.backgroundColor = [UIColor whiteColor];
    self.adjustBtn.layer.borderColor = [UIColor borderColor].CGColor;
    self.adjustBtn.layer.borderWidth = 1.0;
    [self.adjustBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [self.adjustBtn addTarget:self action:@selector(adjustBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.btnView addSubview:self.adjustBtn];
    
    self.jobfinishBtn = [[CommonButton alloc] initWithFrame:CGRectMake(self.adjustBtn.right + 12, 2, btnW, 44) title:@"上车"];
    [self.jobfinishBtn addTarget:self action:@selector(jobfinishBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.btnView addSubview:self.jobfinishBtn];
    
    self.tableView.frame = CGRectMake(0, self.tableTitleView.bottom + 4, self.view.width, self.btnView.top - (self.tableTitleView.bottom + 4) - 4);
    [self.contentView addSubview:self.tableView];
    
    self.backgroundView = self.bgView;
    self.gestureView = self.bgView;
    self.moveView = self.contentView;
    
    if (self.jobHistoryId) {
        [self getJobHistory];
    }else {
        self.job = self.job;
    }
    [self totalRecount];
}

- (void)getJobHistory
{
    NSString * url = [NSString stringWithFormat:@"/enocolor/client/job/history/%@",self.jobHistoryId];
    __weak typeof(self) weakSelf = self;
    [[NetWorkAPIManager defaultManager] commonGET:url parm:@{} registerClass:[JobHistory class] Success:^(NSURLSessionDataTask * _Nonnull task, ResponseObject * _Nonnull responseObj) {
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.jobHistory = responseObj.data.firstObject;
        
    } Failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [CommonTool showError:error];
    }];
}


- (void)setJobHistory:(JobHistory *)jobHistory
{
    _jobHistory = jobHistory;
    
    self.titleLab.text = [NSString stringWithFormat:@"%@/%@",jobHistory.job.colorName, jobHistory.job.colorCode];
    self.subLab.text = jobHistory.preparedDatetime;
    BOOL isFinished = [self.jobHistory isFinished];
    self.measureBtn.hidden = !isFinished;
    self.adjustBtn.hidden = isFinished;
    self.jobfinishBtn.hidden = self.adjustBtn.hidden;
    
    self.datasource = jobHistory.details;
    [self.tableView reloadData];
}

- (void)setCanAdjust:(BOOL)canAdjust
{
    _canAdjust = canAdjust;
    
    self.adjustBtn.enabled = canAdjust;
}

- (void)setJob:(Job *)job
{
    _job = job;
    
    self.titleLab.text = [NSString stringWithFormat:@"%@/%@",job.colorName, job.colorCode];
}

- (void)setDatasource:(NSArray<FormulaDetail *> *)datasource
{
    _datasource = datasource;
    
    [self totalRecount];
}


- (void)measureBtnClicked
{
    if ([BlueToothManager defaultManager].peripheral) {
        //蓝牙已连接
        BlueToothViewController * bleCtrl = [BlueToothViewController defaultBLEController];
        __weak typeof(self) weakSelf = self;
        bleCtrl.measureBlk = ^(StandardSample * _Nullable sample) {
            __strong typeof(self) strongSelf = weakSelf;
            strongSelf.measureBtn.enabled = YES;
            
        };
        [bleCtrl measure];
    }else {
        [[BlueToothViewController defaultBLEController] showOn:self];
    }
    
}


- (void)adjustBtnClicked
{
    AdjustViewController * adjustCtrl = [[AdjustViewController alloc] initWithFormula:self.formula];
    adjustCtrl.modalPresentationStyle  = UIModalPresentationOverCurrentContext;
    adjustCtrl.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:adjustCtrl animated:YES completion:nil];
}

- (void)jobfinishBtnClicked
{
    if (self.jobHistoryId) {
        [self jobFinished];
    }else {
        //创建任务调色历史
        JobHistory * jobHistory = [[JobHistory alloc] init];
        jobHistory.referencedFormula = self.formula;
        jobHistory.details = self.datasource;
        jobHistory.job = self.job;
        
        __weak typeof(self) weakSelf = self;
        [[NetWorkAPIManager defaultManager] commonPOST:@"/enocolor/client/job/history" parm:[jobHistory convertToDictionary] registerClass:[NSObject class] Success:^(NSURLSessionDataTask * _Nonnull task, ResponseObject * _Nonnull responseObj) {
            __strong typeof(self) strongSelf = weakSelf;
            strongSelf.jobHistoryId = responseObj.data.firstObject;
            [strongSelf jobFinished];
        } Failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [CommonTool showError:error];
        }];
    } 
}


//上车
- (void)jobFinished
{
    // 完成任务调色
     NSString * url = [NSString stringWithFormat:@"/enocolor/client/job/history/%@/finish",self.jobHistoryId];
     __weak typeof(self) weakSelf = self;
     [[NetWorkAPIManager defaultManager] commonPOST:url parm:@{} registerClass:[NSObject class] Success:^(NSURLSessionDataTask * _Nonnull task, ResponseObject * _Nonnull responseObj) {
         __strong typeof(self) strongSelf = weakSelf;
         [strongSelf getJobHistory];
         
     } Failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [CommonTool showError:error];
     }];
}


- (void)uploadMeasureSample:(StandardSample *)sample
{
//    上传任务测色数据
    __weak typeof(self) weakSelf = self;
    NSString * url = [NSString stringWithFormat:@"/enocolor/client/job/history/%@/color",self.jobHistory.id];
    [[NetWorkAPIManager defaultManager] commonPOST:url parm:[sample.colorPanel convertToDictionary] registerClass:[NSObject class] Success:^(NSURLSessionDataTask * _Nonnull task, ResponseObject * _Nonnull responseObj) {
        __strong typeof(self) strongSelf = weakSelf;
        [CommonTool showHint:@"上传测量光谱数据成功"];
        
    } Failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [CommonTool showError:error];
    }];
}


#pragma tableView

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.tableTitleView.bottom + 4, self.view.width, self.btnView.top - (self.tableTitleView.bottom + 4) - 4)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[AFormulaTableCell class] forCellReuseIdentifier:@"AFormulaTableCell"];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AFormulaTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AFormulaTableCell"];
    cell.item = self.datasource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}


- (void)totalRecount
{
    float total = 0;
    for (FormulaDetail * detail in self.datasource) {
        total += detail.weight.floatValue;
    }
    self.countLab.text = [NSString stringWithFormat:@"%.1fg",total];
}

@end
