//
//  AdjustViewController.m
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/16.
//

#import "AdjustViewController.h"
#import "UIView+Frame.h"
#import "UIColor+CustomColor.h"
#import "AdjustTableCell.h"
#import "ColorMasterViewCtrl.h"
#import "FormulaHeadView.h"
#import "CommonTool.h"
#import "CommonButton.h"
#import "MeasureViewController.h"

@interface AdjustViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property(nonatomic, readwrite, strong) FormulaHeadView * headView;

@property(nonatomic, readwrite, strong) UIView * totalView;
@property(nonatomic, readwrite, strong) UILabel * countLab;

@property(nonatomic, readwrite, strong) UIView * titleView;
@property(nonatomic, readwrite, strong) UITableView * tableView;
@property (strong, nonatomic) NSMutableArray <FormulaDetail *> * datasource;

@property(nonatomic, readwrite, strong) UIView * btnView;
@property(nonatomic, readwrite, strong) CommonButton * paintVerifiedBtn;//上车
@property(nonatomic, readwrite, strong) CommonButton * adjustSureBtn;//确认微调

@property(nonatomic, readwrite, strong) Formula * formula;
@property(nonatomic, readwrite, strong) NSNumber * jobHistoryId;
@end

@implementation AdjustViewController

- (instancetype)initWithFormula:(Formula *)formula
{
    self = [super init];
    if (self) {
        self.formula = formula;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.midTitle = @" 配方微调";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.headView = [[FormulaHeadView alloc] initWithFrame:CGRectMake(0, self.navbarView.bottom, self.view.width, 118)];
    ColorPanel * panel = self.formula.colorPanel;
    NSMutableArray * colors = [NSMutableArray array];
    for (ColorPanelAngle * angel in panel.angles) {
        UIColor * color = [UIColor colorWithRed:angel.rgbR.intValue/255.0 green:angel.rgbG.intValue/255.0 blue:angel.rgbB.intValue/255.0 alpha:1];
        [colors addObject:(__bridge id)color.CGColor];
    }
    [self.headView setName:self.formula.colorName brand:[CommonTool vehicleModelToString:self.formula.vehicleSpec] time:self.formula.preparedDateTime colors:colors];
    [self.view addSubview:self.headView];
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(16, 117, self.headView.width - 2*16, 1)];
    line.backgroundColor = [UIColor lineColor];
    [self.headView addSubview:line];
    
    self.totalView = [[UIView alloc] initWithFrame:CGRectMake(16, self.headView.bottom+24, self.view.width-2*16, 46)];
    self.totalView.backgroundColor = [UIColor bgWhiteColor];
    self.totalView.layer.cornerRadius = 8.0;
    [self.view addSubview:self.totalView];
    
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
    
    self.titleView = [[UIView alloc] initWithFrame:CGRectMake(0, self.totalView.bottom+16, self.view.width, 40)];
    [self.view addSubview:self.titleView];
    
    UILabel * label1 = [[UILabel alloc] initWithFrame:CGRectMake(24, (self.titleView.height - 24)/2, 40, 24)];
    label1.textColor = [UIColor darkTextColor];
    label1.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    label1.text = @"编号";
    [self.titleView addSubview:label1];
    
    UILabel * label2 = [[UILabel alloc] initWithFrame:CGRectMake(124, (self.titleView.height - 24)/2, 34, 24)];
    label2.textColor = [UIColor darkTextColor];
    label2.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    label2.text = @"色母";
    [self.titleView addSubview:label2];
    
    UIButton * addBtn = [[UIButton alloc] initWithFrame:CGRectMake(label2.right, (self.titleView.height - 40)/2, 40, 40)];
    [addBtn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.titleView addSubview:addBtn];
    
    UILabel * label3 = [[UILabel alloc] initWithFrame:CGRectMake((self.titleView.width - 24 - 40), (self.titleView.height - 24)/2, 40, 24)];
    label3.textColor = [UIColor darkTextColor];
    label3.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    label3.text = @"重量";
    label3.textAlignment = NSTextAlignmentRight;
    [self.titleView addSubview:label3];
    
    self.btnView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 80, self.view.width, 80)];
    [self.view addSubview:self.btnView];
    float btnW = (self.view.width - 2*24 - 12)/2.0;
    self.paintVerifiedBtn = [[CommonButton alloc] initWithFrame:CGRectMake(24, 0, btnW, 44) title:@"上车"];
    [self.paintVerifiedBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    self.paintVerifiedBtn.backgroundColor = [UIColor whiteColor];
    self.paintVerifiedBtn.layer.borderColor = [UIColor borderColor].CGColor;
    self.paintVerifiedBtn.layer.borderWidth = 1;
    [self.paintVerifiedBtn addTarget:self action:@selector(paintVerifiedBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.btnView addSubview:self.paintVerifiedBtn];
    
    self.adjustSureBtn = [[CommonButton alloc] initWithFrame:CGRectMake(self.paintVerifiedBtn.right + 12, 0, btnW, 44) title:@"确认微调"];
    [self.adjustSureBtn addTarget:self action:@selector(adjustSureBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.btnView addSubview:self.adjustSureBtn];
    
    self.datasource = [NSMutableArray arrayWithArray:self.formula.details];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.titleView.bottom + 4, self.view.width, self.btnView.top - (self.titleView.bottom + 4))];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[AdjustTableCell class] forCellReuseIdentifier:@"AdjustTableCell"];
    [self.view addSubview:self.tableView];

    [self totalRecount];
}

- (void)addBtnClicked
{
    ColorMasterViewCtrl * colorCtrl = [[ColorMasterViewCtrl  alloc] init];
    __weak typeof(self) weakSelf = self;
    colorCtrl.selectBlk = ^(Goods * _Nonnull goods) {
        __strong typeof(self) strongSelf = weakSelf;
        FormulaDetail * detail = [[FormulaDetail alloc] init];
        detail.goods = goods;
        [strongSelf.datasource addObject:detail];
        [strongSelf.tableView reloadData];
    };
    [colorCtrl showOn:self];
}


- (void)paintVerifiedBtnClicked
{
    if (self.jobHistoryId) {
        MeasureViewController * measureCtrl = [[MeasureViewController alloc] initWithJobHistoryId:self.jobHistoryId];
        measureCtrl.job = self.job;
        [measureCtrl showOn:self];
    }else {
        MeasureViewController * measureCtrl = [[MeasureViewController alloc] initWithFormula:self.formula];
        measureCtrl.job = self.job;
        [measureCtrl showOn:self];
    }
}

- (void)adjustSureBtnClicked
{
    //创建任务调色历史
    JobHistory * jobHistory = [[JobHistory alloc] init];
    jobHistory.referencedFormula = self.formula;
    jobHistory.details = self.datasource;
    jobHistory.job = self.job;
    
    __weak typeof(self) weakSelf = self;
    [[NetWorkAPIManager defaultManager] commonPOST:@"/enocolor/client/job/history" parm:[jobHistory convertToDictionary] registerClass:[NSObject class] Success:^(NSURLSessionDataTask * _Nonnull task, ResponseObject * _Nonnull responseObj) {
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.jobHistoryId = responseObj.data.firstObject;
        [CommonTool showHint:@"创建任务调色历史成功"];
        
    } Failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [CommonTool showError:error];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AdjustTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AdjustTableCell"];
    cell.item = self.datasource[indexPath.row];
    cell.countTF.tag = indexPath.row;
    cell.countTF.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * text = textField.text;
    text = [text stringByReplacingCharactersInRange:range withString:string];
    
    NSInteger tag = textField.tag;
    
    FormulaDetail * detail = self.datasource[tag];
    detail.weight = [NSNumber numberWithFloat:text.floatValue];
    [self totalRecount];
    
    return YES;
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
