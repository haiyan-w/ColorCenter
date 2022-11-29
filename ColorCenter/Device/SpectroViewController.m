//
//  SpectroViewController.m
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/21.
//

#import "SpectroViewController.h"
#import "UIView+Frame.h"
#import "UIView+Hint.h"
#import "SettingTableViewCell.h"
#import "Spectro.h"
#import "NetWorkAPIManager.h"
#import "CommonTool.h"
#import "UIColor+CustomColor.h"
#import "CommonButton.h"
#import "OneLineInputViewCtrl.h"
#import "MultilineInputViewCtrl.h"
#import "DataBase.h"

@interface SpectroViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * datasource;
@property (nonatomic, strong) CommonButton * cancelBtn;

@property (nonatomic, strong) NSNumber * spectroId;
@property (nonatomic, strong) Spectro * spectro;
@end

@implementation SpectroViewController

- (instancetype)initWithSpectroId:(NSNumber *)spectroId
{
    self = [super init];
    if (self) {
        self.spectroId = spectroId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.midTitle = @"测色仪";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initDataSourceWith:self.spectro];
    
    float orgY = self.navbarView.bottom;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(16, orgY, self.view.width - 2*16, self.view.height - orgY - 80)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"SettingTableViewCell" bundle:nil] forCellReuseIdentifier:@"SettingTableViewCell"];
    [self.view addSubview:self.tableView];
    
    self.cancelBtn = [[CommonButton alloc] initWithFrame:CGRectMake(24, self.view.height - 44- 34, self.view.width - 2*24, 44) title:@"取消配对"];
    self.cancelBtn.backgroundColor = [UIColor lightTintColor];
    self.cancelBtn.layer.cornerRadius = 22.0;
    [self.cancelBtn setTitleColor:[UIColor tintColor] forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelBtn];
    
    [self getSpectro];
    
}

- (void)setSpectro:(Spectro *)spectro
{
    _spectro = spectro;
    
    [self initDataSourceWith:spectro];
    [self.tableView reloadData];
}

- (void)getSpectro
{
    NSString * url = [NSString stringWithFormat:@"/enocolor/client/spectro/%@", self.spectroId];
    __weak  typeof(self) weakSelf = self;
    [[NetWorkAPIManager defaultManager] commonGET:url parm:@{} registerClass:[Spectro class] Success:^(NSURLSessionDataTask * _Nonnull task, ResponseObject * _Nonnull responseObj) {
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.spectro = responseObj.data.firstObject;
        
    } Failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [CommonTool showError:error];
    }];
}

- (void)updateSpectro
{
    __weak  typeof(self) weakSelf = self;
    [[NetWorkAPIManager defaultManager] commonPUT:@"/enocolor/client/spectro" parm:[self.spectro convertToDictionary] Success:^(NSURLSessionDataTask * _Nonnull task, ResponseObject * _Nonnull responseObj) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf getSpectro];
    } Failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [CommonTool showError:error];
    }];
}

-(void)initDataSourceWith:(Spectro *)spectro
{
    __weak typeof(self) weakSelf = self;
    
    SettingItem * item1 = [[SettingItem alloc] init];
    item1.titleStr = @"重命名";
    item1.rightStr = spectro.name;
    item1.hasNext = YES;
    item1.nextBlock = ^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf rename];
    };

    
    SettingItem * item2 = [[SettingItem alloc] init];
    item2.titleStr = @"ID";
    item2.rightStr = spectro.serialNo;
    item2.hasNext = NO;
    
    SettingItem * item3 = [[SettingItem alloc] init];
    item3.titleStr = @"型号";
    item3.rightStr = spectro.brand;
    item3.hasNext = NO;
    
    SettingItem * item4 = [[SettingItem alloc] init];
    item4.titleStr = @"使用范围";
    item4.rightStr = @"所有功能";
    item4.hasNext = NO;

    SettingItem * item5 = [[SettingItem alloc] init];
    item5.titleStr = @"生产日期";
    item5.rightStr = spectro.manufacturerDate;
    item5.hasNext = NO;
    
    SettingItem * item6 = [[SettingItem alloc] init];
    item6.titleStr = @"保修范围";
    item6.rightStr = @"保修期内";
    item6.hasNext = NO;
    
    SettingItem * item7 = [[SettingItem alloc] init];
    item7.iconName = @"call";
    item7.titleStr = @"电话咨询";
    item7.subTitleStr = @"";
    item7.hasNext = YES;
    item7.nextBlock = ^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf call];
    };
    
    SettingItem * item8 = [[SettingItem alloc] init];
    item8.iconName = @"feedback";
    item8.titleStr = @"问题反馈";
    item8.subTitleStr = @"";
    item8.hasNext = YES;
    item8.nextBlock = ^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf feedback];
    };
    
    self.datasource = [[NSMutableArray alloc] initWithObjects:@[item1],@[item2,item3, item4,item5,item6],@[item7],@[item8],nil];
}

- (void)rename
{
    OneLineInputViewCtrl * inputCtrl = [[OneLineInputViewCtrl alloc] initWithTitle:@"重命名" placeHolder:self.spectro.name];
    
    __weak typeof(self) weakSelf = self;
    inputCtrl.sureBlk = ^(NSString * _Nonnull text) {
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.spectro.name = text;
        [strongSelf updateSpectro];
    };
    
    [inputCtrl showOn:self];
}

- (void)call
{
    
}

- (void)feedback
{
    MultilineInputViewCtrl * inputCtrl = [[MultilineInputViewCtrl alloc] initWithTitle:@"问题反馈" placeHolder:@"请填写您的问题..."];
    [inputCtrl showOn:self];
    
    __weak typeof(self) weakSelf = self;
    inputCtrl.sureBlk = ^(NSString * _Nonnull text) {
        __strong typeof(self) strongSelf = weakSelf;
        
    };
}

- (void)cancelBtnClicked
{
    [[DataBase defaultDataBase] openSpectroList];
    [[DataBase defaultDataBase] deleteASpectro:self.spectro];
}

#pragma mark Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 48;
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    float height = 12;
    return height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.datasource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * array = [self.datasource objectAtIndex:section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SettingTableViewCell"];
    SettingItem * item = [[self.datasource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.item = item;
    cell.backgroundColor = [UIColor bgWhiteColor];
    
    NSArray * array = [self.datasource objectAtIndex:indexPath.section];

    if (array.count > 1) {
        if (indexPath.row == 0) {
            [cell setLRCornor:8.0];
        }else if (indexPath.row == (array.count-1)) {
            [cell setBottomLRCornor:8.0];
        }
    }else {
        cell.layer.cornerRadius = 8.0;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingItem * item = [[self.datasource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (item.hasNext) {
        if (item.nextBlock) {
            item.nextBlock();
        }
    }
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,0)];
    headerView.backgroundColor = [UIColor whiteColor];
    return headerView;
}

@end
