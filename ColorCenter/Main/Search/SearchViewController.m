//
//  SearchViewController.m
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/11.
//

#import "SearchViewController.h"
#import "SearchTextView.h"
#import "SearchHistoryView.h"
#import "UIColor+CustomColor.h"
#import "UIView+Frame.h"
#import "LoadTableView.h"
#import "VehicleBrandViewController.h"
#import "NetWorkAPIManager.h"
#import "CommonTool.h"
#import "IconTextButton.h"
#import "SearchTableViewCell.h"
#import "FormulaQuery.h"
#import "JobViewController.h"
#import "DataBase.h"

@interface SearchViewController ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) SearchTextView * searchTextView;
@property (nonatomic, strong) UIButton * searchBtn;
@property (nonatomic, strong) IconTextButton * brandBtn;
@property (nonatomic, strong) IconTextButton * subBrandBtn;

@property (nonatomic, strong) SearchHistoryView * historyView;
@property (nonatomic, strong) LoadTableView * tableView;
@property (strong, nonatomic) NSMutableArray <FormulaQuery *>* datasource;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navbarView.backgroundColor = [UIColor clearColor];
    self.searchTextView = [[SearchTextView alloc] initWithFrame:CGRectMake(48, self.navbarView.bottom - 36 - 6, self.navbarView.width - 48-65, 36)];
    self.searchTextView.textField.placeholder = @"颜色名称/色号/车品牌/车型";
    __weak typeof(self) weakSelf = self;
    self.searchTextView.textChangedBlock = ^(NSString * _Nonnull text) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf searchTextChanged];
    };
    
    self.searchTextView.returnBlock = ^(NSString * _Nonnull text) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf searchBtnClicked];
    };
    
    [self.navbarView addSubview:self.searchTextView];
    
    UIButton * searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.searchTextView.right + 12 , self.searchTextView.top, self.navbarView.right - self.searchTextView.right - 2*12, self.searchTextView.height)];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    [searchBtn addTarget:self action:@selector(searchBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.navbarView addSubview:searchBtn];
    
    self.brandBtn = [[IconTextButton alloc] initWithFrame:CGRectMake(25, self.navbarView.bottom + 12, 95, 32)];
    [self.brandBtn setTitle:@"车品牌" forState:UIControlStateNormal];
    [self.brandBtn setImage:[UIImage imageNamed:@"drop_s"] forState:UIControlStateNormal];
    [self.brandBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    self.brandBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    self.brandBtn.midSpace = 4.0;
    self.brandBtn.isIconRight = YES;
    [self.brandBtn addTarget:self action:@selector(selectBrand) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.brandBtn];
    
    self.subBrandBtn = [[IconTextButton alloc] initWithFrame:CGRectMake(self.brandBtn.right +1 , self.brandBtn.top, self.brandBtn.width, self.brandBtn.height)];
    [self.subBrandBtn setTitle:@"车型" forState:UIControlStateNormal];
    [self.subBrandBtn setImage:[UIImage imageNamed:@"drop_s"] forState:UIControlStateNormal];
    [self.subBrandBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    self.subBrandBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    self.subBrandBtn.midSpace = 4.0;
    self.subBrandBtn.isIconRight = YES;
    [self.subBrandBtn addTarget:self action:@selector(selectBrand) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.subBrandBtn];
    
    self.historyView = [[SearchHistoryView alloc] initWithFrame:CGRectMake(0, self.brandBtn.bottom + 20, self.view.width, self.view.height -(self.brandBtn.bottom + 20) - 100)];
    self.historyView.selectBlk = ^(NSString * _Nonnull text) {
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf.searchTextView setTags:@[text]];
        [strongSelf.tableView refresh];
    };
    
    [self.view addSubview:self.historyView];
    [self.historyView refresh];
    
    self.tableView.frame = CGRectMake(16, self.brandBtn.bottom + 12, self.view.width-2*16, self.view.height - (self.brandBtn.bottom + 12));
    [self.view addSubview:self.tableView];
    self.tableView.hidden = YES;
}

- (void)searchTextChanged
{
    if ([self.searchTextView getText].length == 0){
        self.historyView.hidden = ([self.historyView historyCount] > 0)?NO:YES;
        self.tableView.hidden = YES;
    }
}

- (void)searchBtnClicked
{
    [CommonTool resign];
    //生成一条搜索记录
    NSString * searchText = [self.searchTextView getText];
    if (searchText.length > 0) {
        [[DataBase defaultDataBase] openSearchHistoryList];
        [[DataBase defaultDataBase] insertASearchText:searchText];
        [self.historyView refresh];
    }
    
    self.historyView.hidden = YES;
    self.tableView.hidden = NO;
    
    [self.tableView refresh];
}


- (void)selectBrand
{
    [CommonTool resign];
    if ([NetWorkAPIManager defaultManager].vehicleModels.count <= 0) {
        __weak typeof(self) weakSelf = self;
        [[NetWorkAPIManager defaultManager] queryVehicleBrandsuccess:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf showVehicleBrand];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [CommonTool showError:error];
        }];
    }else {
        [self showVehicleBrand];
    }
    
}

- (void)showVehicleBrand
{
    VehicleBrandViewController * brandCtrl = [[VehicleBrandViewController alloc] initWithBrands:[NetWorkAPIManager defaultManager].vehicleModels];
    
    __weak typeof(self) weakSelf = self;
    brandCtrl.selectBlock = ^(NSArray * _Nonnull model) {
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.searchTextView.tags = model;
    };
    
    [brandCtrl showOn:self];
}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField
//{
//    [self searchBtnClicked];
//    
//    return YES;
//}



- (void)searchData
{
    
    __weak typeof(self) weakSelf = self;
    [[NetWorkAPIManager defaultManager] commonGET:@"/enocolor/client/formula/query" parm:@{@"search":[self.searchTextView getText]} registerClass:[FormulaQuery class] Success:^(NSURLSessionDataTask * _Nonnull task, ResponseObject * _Nonnull responseObj) {
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
    [[NetWorkAPIManager defaultManager] commonGET:@"/enocolor/client/formula/query" parm:@{@"search":self.searchTextView.textField.text, @"pageIndex":[NSNumber numberWithInteger:self.tableView.pageIndex+1]} registerClass:[FormulaQuery class] Success:^(NSURLSessionDataTask * _Nonnull task, ResponseObject * _Nonnull responseObj) {
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


#pragma TableView

- (NSMutableArray *)datasource
{
    if (!_datasource) {
        _datasource = [NSMutableArray array];
    }
    return _datasource;
}

- (LoadTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[LoadTableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[SearchTableViewCell class] forCellReuseIdentifier:@"SearchTableViewCell"];
        
        __weak typeof(self) weakSelf = self;
        _tableView.refreshBlock = ^{
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf searchData];
        };
        
        _tableView.loadMoreBlock = ^{
            __strong typeof(self) strongSelf = weakSelf;
            [strongSelf loadMore];
        };
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SearchTableViewCell"];
    FormulaQuery * formulaQuery = self.datasource[indexPath.row];
    [cell setTitle:formulaQuery.colorName subTitle:[CommonTool vehicleModelToString:formulaQuery.vehicleSpecs]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 86;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FormulaQuery * formulaQuery = self.datasource[indexPath.row];
    JobViewController * ctrl = [[JobViewController alloc] initWithFormulaId:formulaQuery.id];
    [self.navigationController pushViewController:ctrl animated:YES];
}


@end
