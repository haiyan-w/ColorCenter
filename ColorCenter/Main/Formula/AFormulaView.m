//
//  AFormulaView.m
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/16.
//

#import "AFormulaView.h"
#import "FormulaHeadView.h"
#import "UIView+Frame.h"
#import "CommonTool.h"
#import "UIColor+CustomColor.h"
#import "AFormulaTableCell.h"
#import "NetWorkAPIManager.h"
#import "JobHistory.h"


@interface AFormulaView () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) FormulaHeadView * headView;

@property(nonatomic, readwrite, strong) UIView * titleView;
@property(nonatomic, readwrite, strong) UILabel * label1;
@property(nonatomic, readwrite, strong) UILabel * label2;
@property(nonatomic, readwrite, strong) UILabel * label3;

@property(nonatomic, readwrite, strong) UITableView * tableView;
@property (strong, nonatomic) NSMutableArray * datasource;

@property(nonatomic, readwrite, strong) UIView * btnView;
@property(nonatomic, readwrite, strong) UIButton * confirmBtn;//上车
@property(nonatomic, readwrite, strong) UIButton * adjustBtn;//微调
@end

@implementation AFormulaView

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
    self.headView = [[FormulaHeadView alloc] init];
    [self addSubview:self.headView];
    
    self.titleView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headView.bottom+16, self.width, 40)];
    [self addSubview:self.titleView];
    
    self.label1 = [[UILabel alloc] initWithFrame:CGRectMake(24, (self.titleView.height - 24)/2, 40, 24)];
    self.label1.textColor = [UIColor darkTextColor];
    self.label1.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    self.label1.text = @"编号";
    [self.titleView addSubview:self.label1];
    
    self.label2 = [[UILabel alloc] initWithFrame:CGRectMake(124, (self.titleView.height - 24)/2, 34, 24)];
    self.label2.textColor = [UIColor darkTextColor];
    self.label2.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    self.label2.text = @"色母";
    [self.titleView addSubview:self.label2];
    
    self.label3 = [[UILabel alloc] initWithFrame:CGRectMake((self.titleView.height - 24 - 40), (self.titleView.height - 24)/2, 40, 24)];
    self.label3.textColor = [UIColor darkTextColor];
    self.label3.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    self.label3.text = @"重量";
    self.label3.textAlignment = NSTextAlignmentRight;
    [self.titleView addSubview:self.label3];
    
    self.btnView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 80, self.width, 80)];
    [self addSubview:self.btnView];
    self.confirmBtn = [[UIButton alloc] init];
    self.confirmBtn.backgroundColor = [UIColor bgWhiteColor];
    self.confirmBtn.layer.cornerRadius = 16.0;
    [self.confirmBtn setTitle:@"上车" forState:UIControlStateNormal];
    [self.confirmBtn setTitleColor:[UIColor textColor] forState:UIControlStateNormal];
    self.confirmBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    [self.confirmBtn addTarget:self action:@selector(confirmBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.btnView addSubview:self.confirmBtn];
    
    self.adjustBtn = [[UIButton alloc] init];
    self.adjustBtn.backgroundColor = [UIColor customRedColor];
    self.adjustBtn.layer.cornerRadius = 16.0;
    [self.adjustBtn setTitle:@"微调" forState:UIControlStateNormal];
    [self.adjustBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.adjustBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    [self.adjustBtn addTarget:self action:@selector(adjustBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.btnView addSubview:self.adjustBtn];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.titleView.bottom + 4, self.width, self.btnView.top - (self.titleView.bottom + 4))];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[AFormulaTableCell class] forCellReuseIdentifier:@"AFormulaTableCell"];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    [self addSubview:self.tableView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.headView.frame = CGRectMake(0, 0, self.width, 118);
    
    self.titleView.frame = CGRectMake(0, self.headView.bottom+12, self.width, 48);
    self.label1.frame = CGRectMake(24, (self.titleView.height - 24)/2, 40, 24);
    self.label2.frame = CGRectMake(124, (self.titleView.height - 24)/2, 34, 24);
    self.label3.frame = CGRectMake((self.titleView.width - 24 - 40), (self.titleView.height - 24)/2, 40, 24);
    
    self.tableView.frame = CGRectMake(0, self.titleView.bottom, self.width, [AFormulaView tableHeightWithFormula:self.formula]);
    
    self.btnView.frame = CGRectMake(0, self.tableView.bottom + 24, self.width, 84);
    float btnW = (self.width - 2*32 - 12)/2.0;
    self.confirmBtn.frame = CGRectMake(32, 0, btnW, 32);
    self.adjustBtn.frame = CGRectMake(self.confirmBtn.right + 12, 0, btnW, 32);
}

- (void)confirmBtnClicked
{
    if (self.confirmBlk) {
        self.confirmBlk();
    }
}

- (void)adjustBtnClicked
{
    if (self.adjustBlk) {
        self.adjustBlk();
    }
}

- (void)setFormula:(Formula *)formula
{
    _formula = formula;
    
    ColorPanel * panel = formula.colorPanel;
    NSMutableArray * colors = [NSMutableArray array];
    for (ColorPanelAngle * angel in panel.angles) {
        UIColor * color = [UIColor colorWithRed:angel.rgbR.intValue/255.0 green:angel.rgbG.intValue/255.0 blue:angel.rgbB.intValue/255.0 alpha:1];
        [colors addObject:(__bridge id)color.CGColor];
    }
    [self.headView setName:formula.colorName brand:[CommonTool vehicleModelToString:formula.vehicleSpec] time:formula.preparedDateTime colors:colors];
    
    self.datasource = [NSMutableArray arrayWithArray:formula.details];
    [self.tableView reloadData];
  
    [self layoutSubviews];
}

- (void)setJob:(Job *)job
{
    _job = job;
    
    
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
    AFormulaTableCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AFormulaTableCell"];
    cell.item = self.datasource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}



+ (float)heightWithFormula:(Formula *)formula
{
    float headH = 118 + 60;
    float bottomH = 118;
    float height = headH + bottomH;
    
    for (FormulaDetail * detail in formula.details) {
        height += [AFormulaTableCell heightWithFormulaDetail:detail];
    }
    
    return height;
}

+ (float)tableHeightWithFormula:(Formula *)formula
{
    float height = 0;
    
    for (FormulaDetail * detail in formula.details) {
        height += [AFormulaTableCell heightWithFormulaDetail:detail];
    }
    
    return height;
}

@end
