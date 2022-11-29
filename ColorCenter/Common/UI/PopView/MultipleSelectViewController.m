//
//  MultipleSelectViewController.m
//  EnochCar
//
//  Created by 王海燕 on 2022/8/11.
//

#import "MultipleSelectViewController.h"
#import "UIColor+CustomColor.h"
#import "CommonTool.h"
#import "UIView+Hint.h"
#import "CommonButton.h"

#define CELL_HEIGHT 48

@interface MultipleSelectViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic,readwrite,copy)NSArray * datasource;
@property(nonatomic,readwrite,copy)NSString * poptitle;

@property(nonatomic,readwrite,strong)UIView * bgView;
@property(nonatomic,readwrite,strong)UIView * contentView;
@property(nonatomic,readwrite,strong)UILabel * titleLab;
@property(nonatomic,readwrite,strong)CommonButton * saveBtn;
//@property(nonatomic,readwrite,assign)CGRect moveViewOrgFrame;
@end

@implementation MultipleSelectViewController

-(instancetype)initWithTitle:(NSString *)title Data:(NSArray *)dataArray
{
    self = [super init];
    if (self) {
        self.poptitle = title;
        self.datasource = dataArray;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor clearColor];
    
    self.bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.bgView.backgroundColor = [UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:0.5];
    [self.view addSubview:self.bgView];
    
    NSInteger titleH = 66;
    NSInteger bottomH = [CommonTool bottomSpace];
    NSInteger maxH = [UIScreen mainScreen].bounds.size.height - 100 -titleH-bottomH - 48;
    NSInteger cellH = CELL_HEIGHT;
    NSInteger tableH = cellH * self.datasource.count;
    if (tableH > maxH) {
        tableH = maxH;
    }
    NSInteger contentH = titleH + tableH + bottomH + 48 + 2;
    
   _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - contentH, self.view.bounds.size.width, contentH)];
    _contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_contentView];
    
    UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width, titleH)];
    titleLab.text = self.poptitle;
    titleLab.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    titleLab.textColor = [UIColor darkTextColor];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:titleLab];

    UITableView * tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, titleH, self.view.bounds.size.width, tableH)];
    tableview.dataSource = self;
    tableview.delegate = self;
    [tableview registerNib:[UINib nibWithNibName:@"MultipleSelectTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MultipleSelectTableViewCell"];
    tableview.showsVerticalScrollIndicator = NO;
    tableview.showsHorizontalScrollIndicator = NO;
    tableview.bounces = NO;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.contentView addSubview:tableview];
    
    self.saveBtn = [[CommonButton alloc] initWithFrame:CGRectMake(20, self.contentView.frame.size.height - 48 - bottomH, self.contentView.frame.size.width - 2*20, 48) normalTitle:@"保存" disabledTitle:@"保存"];
    [self.saveBtn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.saveBtn];
    
    self.backgroundView = self.bgView;
    self.moveView = self.contentView;
    self.gestureView = self.bgView;
}

-(void)btnClicked
{
    __weak typeof(self) weakSelf = self;
    [self dismissWithCompletion:^{
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf.saveBlock) {
            strongSelf.saveBlock(strongSelf.datasource);
        }
    }];
    
}

#pragma mark delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MultipleSelectTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MultipleSelectTableViewCell"];
    
    if (!cell) {
        cell = [[MultipleSelectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MultipleSelectTableViewCell"];
    }
    [cell configData:[self.datasource objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}


@end
