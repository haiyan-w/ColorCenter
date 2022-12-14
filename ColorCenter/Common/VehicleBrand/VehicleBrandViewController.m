//
//  VehicleBrandViewController.m
//  EnochCar
//
//  Created by HAIYAN on 2021/6/2.
//

#import "VehicleBrandViewController.h"
#import "VehicleBrandTableViewCell.h"
#import "NetWorkAPIManager.h"
#import "IndexView.h"
#import "CommonTool.h"
#import "UIColor+CustomColor.h"
#import "UIView+Hint.h"

@interface VehicleBrandViewController ()<UITableViewDelegate,UITableViewDataSource,IndexViewDelegate,IndexViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate>
@property(strong,nonatomic)NSMutableArray * allBrands;
@property(strong,nonatomic)NSMutableArray * indexArray;
@property(strong,nonatomic)NSArray * letterArray;
@property(strong,nonatomic)NSMutableArray * datasource;
@property(strong,nonatomic)NSArray * secondBrands;
@property(strong,nonatomic)UITextField * searchTF;
@property(strong,nonatomic)UITableView * tableview;
@property(nonatomic,readwrite,strong)IndexView * indexView;
@property(nonatomic,readwrite,strong)UIView * contentView;
@property(nonatomic,readwrite,strong)UIButton * backBtn;
@property(nonatomic,readwrite,strong)UILabel * titleLab;
@property(assign,nonatomic)NSInteger depth;
@property(assign,nonatomic)NSInteger curdepth;
@property(nonatomic,readwrite,strong)NSString * lastSearchText;
@property(nonatomic,readwrite,strong)NSMutableArray * lastDatasource;
@property(assign,nonatomic)BOOL isSearching;
@end

@implementation VehicleBrandViewController


-(instancetype)initWithBrands:(NSArray *)brands
{
    self = [super init];
    if (self) {
        _allBrands = [NSMutableArray arrayWithArray:brands];
        _indexArray = [self arrayWithFirstLetterFormat:brands];
        _datasource = _indexArray;
        _depth = 2;
        self.curdepth = 1;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    
    UIView * bgview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    bgview.backgroundColor = [UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:0.5];
    [self.view addSubview:bgview];

    NSInteger topH = 94;
    NSInteger bottomH = 34;
    NSInteger maxH = [UIScreen mainScreen].bounds.size.height*0.8 -topH - bottomH;
    NSInteger cellH = 40;
    NSInteger tableH = cellH * (self.datasource.count);
    if (tableH > maxH) {
        tableH = maxH;
    }
    
    NSInteger contentH = topH + tableH +bottomH;
    
   _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - contentH, self.view.bounds.size.width, contentH)];
    _contentView.backgroundColor = [UIColor whiteColor];
    [_contentView setLRCornor];
    [self.view addSubview:_contentView];
    
    _backBtn = [[UIButton alloc] initWithFrame:CGRectMake(4, 14, 40, 40)];
    _backBtn.backgroundColor = [UIColor clearColor];
    [_backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(backToLast) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.hidden = YES;
    [_contentView addSubview:_backBtn];
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(48, 24, (self.view.bounds.size.width - 2*48), 24)];
    _titleLab.text = @"???????????????";
    _titleLab.font = [UIFont systemFontOfSize:18 weight:UIFontWeightRegular];
    _titleLab.textColor = [UIColor blackColor];
    _titleLab.textAlignment = NSTextAlignmentCenter;
    [_contentView addSubview:_titleLab];
    
    UIView * searchView = [[UIView alloc] initWithFrame:CGRectMake(20, 66, _contentView.frame.size.width - 2*20, 36)];
    searchView.layer.cornerRadius = 18;
    searchView.layer.masksToBounds = YES;
    searchView.backgroundColor = [UIColor bgWhiteColor];
    [_contentView addSubview:searchView];
    UIImageView * searchIcon = [[UIImageView alloc] initWithFrame:CGRectMake(16,(searchView.bounds.size.height - 20)/2, 20, 20)];
    searchIcon.image = [UIImage imageNamed:@"search"];
    [searchView addSubview:searchIcon];
    NSInteger orgX = 48;
    _searchTF = [[UITextField alloc] initWithFrame:CGRectMake(orgX, 0, searchView.frame.size.width-orgX -16, searchView.frame.size.height)];
    _searchTF.returnKeyType = UIReturnKeySearch;
    _searchTF.backgroundColor = [UIColor clearColor];
    _searchTF.placeholder = @"??????";
    _searchTF.delegate = self;
    _searchTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [searchView addSubview:_searchTF];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChange:) name:UITextFieldTextDidChangeNotification object:_searchTF];
    
    CGFloat orgY = (searchView.frame.origin.y + searchView.frame.size.height + 12);
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, orgY, self.view.bounds.size.width, self.contentView.frame.size.height - orgY)];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview.showsVerticalScrollIndicator = NO;
    _tableview.showsHorizontalScrollIndicator = NO;
    _tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, [CommonTool bottomSpace])];
    
    [_tableview registerNib:[UINib nibWithNibName:@"VehicleBrandTableViewCell" bundle:NULL] forCellReuseIdentifier:@"VehicleBrandTableViewCell"];
    
    [_contentView addSubview:_tableview];
    
    [_tableview reloadData];
    
    [self initIndexView];
    
    self.gestureView = bgview;
    self.moveView = self.contentView;
    self.backgroundView = bgview;
}

-(void)initIndexView
{
    NSInteger indexH = 19*self.letterArray.count;
    NSInteger maxH = self.tableview.frame.size.height;
    NSInteger orgY = self.tableview.frame.origin.y + (maxH - indexH)/2;
    
    self.indexView = [[IndexView alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width - 32, orgY, 32, 19*self.letterArray.count)];
    self.indexView.titleColor = [UIColor slightTextColor];
    self.indexView.selectTitleColor = [UIColor whiteColor];
    self.indexView.delegate = self;
    self.indexView.dataSource = self;
    [self.contentView addSubview:self.indexView];
    [self.indexView reload];
    [self.indexView setSelectionIndex:0];
}

-(void)setCurdepth:(NSInteger)curdepth
{
    _curdepth = curdepth;
    if (curdepth == 1 && !self.isSearching) {
        self.indexView.hidden = NO;
        [self.indexView setSelectionIndex:0];
    }else {
        self.indexView.hidden = YES;
    }
    
}

-(void)setIsSearching:(BOOL)isSearching
{
    _isSearching = isSearching;
    if (_curdepth == 1 && !self.isSearching) {
        self.indexView.hidden = NO;
        [self.indexView setSelectionIndex:0];
    }else {
        self.indexView.hidden = YES;
    }
}

-(void)taponbg:(UIGestureRecognizer*)gesture
{
    [self dismiss];
}

-(void)taponContentView:(UIGestureRecognizer*)gesture
{
    [CommonTool resign];
}

//?????????????????????
-(void)backToLast
{
    [CommonTool resign];
    self.curdepth -=1;
    _backBtn.hidden = YES;
    _titleLab.text = @"????????????";
    _searchTF.text = self.lastSearchText;
    [self searchData:_searchTF.text];
}


//notify
-(void)textChange:(NSNotification*)notice
{
    UITextField * textfield = notice.object;
    [self searchData:textfield.text];
}

-(void)searchData:(NSString*)searchText
{
    NSString * text = [searchText stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (text.length>0) {
        self.isSearching = YES;
    }else {
        self.isSearching = NO;
    }
    
    if (_curdepth == 1) {
        
        if (text.length > 0) {
            //????????????
            NSMutableArray * array = [NSMutableArray array];
            for (NSDictionary * adata in _allBrands) {
                if ([[adata objectForKey:@"name"] localizedCaseInsensitiveContainsString:text]||[[adata objectForKey:@"nameHint"] localizedCaseInsensitiveContainsString:text]) {
                    [array addObject:adata];
                }
            }
            _datasource = array;
        }else {
            _indexArray = [self arrayWithFirstLetterFormat:_allBrands];
            _datasource = _indexArray;
        }
        
    }else {
        if (text.length > 0) {
            NSMutableArray * array = [NSMutableArray array];
            for (NSDictionary * adata in _secondBrands) {
                if ([[adata objectForKey:@"name"] localizedCaseInsensitiveContainsString:text]||[[adata objectForKey:@"nameHint"] localizedCaseInsensitiveContainsString:text]) {
                    [array addObject:adata];
                }
            }
            _datasource = array;
        }else {
            _datasource = [NSMutableArray arrayWithArray:_secondBrands];
        }
    }
    
    [self.tableview reloadData];
}
    

#pragma mark - UITableViewDelagate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_curdepth == 1 && !self.isSearching) {
        return self.datasource.count;
    }else {
        return 1;
    }
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (_curdepth == 1 && !self.isSearching) {
        NSString * title = [self.letterArray objectAtIndex:section];
        return title;
    }else {
        return nil;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_curdepth == 1 && !self.isSearching) {
        NSArray * array = [self.datasource objectAtIndex:section];
        return [array count];
    }else {
        return self.datasource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * celldata =nil;
    
    if (_curdepth == 1 && !self.isSearching){
        NSArray * array = [self.datasource objectAtIndex:indexPath.section];
        celldata = [array objectAtIndex:indexPath.row];
    }else {
        celldata = [self.datasource objectAtIndex:indexPath.row];
    }
    
    VehicleBrandTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"VehicleBrandTableViewCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"VehicleBrandTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"VehicleBrandTableViewCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"VehicleBrandTableViewCell"];
    }
    cell.namelab.text = [celldata objectForKey:@"name"];
//    NSArray * models = [celldata objectForKey:@"models"];
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [CommonTool resign];
    if (_curdepth == 1 ){
        self.lastSearchText = _searchTF.text;
        NSDictionary * data = [NSDictionary dictionary];
        if (!self.isSearching) {
            data = [[self.datasource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        }else {
            data = [self.datasource objectAtIndex:indexPath.row];
        }
        NSArray * models = [data objectForKey:@"models"];
        self.curdepth +=1;
        _titleLab.text = [data objectForKey:@"name"];
        self.datasource = [NSMutableArray arrayWithArray:models];
        self.secondBrands = [NSArray arrayWithArray:models];
        _backBtn.hidden = NO;
        _searchTF.text = @"";
        [self.tableview reloadData];
    }else {
        NSDictionary * data = [self.datasource objectAtIndex:indexPath.row];
        if (self.selectBlock) {
            self.selectBlock([NSArray arrayWithObjects:_titleLab.text, [data objectForKey:@"name"], nil]);
        }
        
        [self dismiss];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    [self.indexView tableView:tableView willDisplayHeaderView:view forSection:section];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section {
    [self.indexView tableView:tableView didEndDisplayingHeaderView:view forSection:section];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    [CommonTool resign];
    [self.indexView scrollViewDidScroll:scrollView];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [CommonTool resign];
    return YES;
}

-(NSMutableArray *)arrayWithFirstLetterFormat:(NSArray *)dataArray
{
    NSMutableDictionary * indexDic = [[NSMutableDictionary alloc] init];
    for (NSDictionary * adata in dataArray) {
        NSString * nameHint = [[[adata objectForKey:@"nameHint"] substringToIndex:1] capitalizedString];
        NSMutableArray * indexData = [indexDic objectForKey:nameHint];
        if (indexData) {
            [indexData addObject:adata];
        }else {
            [indexDic setObject:[NSMutableArray array] forKey:nameHint];
        }
    }

    //???????????????
    self.letterArray = [indexDic keysSortedByValueUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSString *letter1 = [[[obj1 firstObject] objectForKey:@"nameHint"] substringToIndex:1];
        NSString *letter2 = [[[obj2 firstObject] objectForKey:@"nameHint"] substringToIndex:1];
        if ([letter1 characterAtIndex:0] < [letter2 characterAtIndex:0]) {
             return NSOrderedAscending;
         }
         return NSOrderedDescending;
    }];
    
    NSMutableArray * arr = [NSMutableArray array];
    for (NSString * key in self.letterArray) {
        [arr addObject:[indexDic objectForKey:key]];
    }
    
    return arr;
}


-(NSArray<NSString*>*)sectionIndexTitles
{
    return self.letterArray;
}

//???????????????
- (void)selectedSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

////??????????????????????????????????????????
//- (void)addIndicatorView:(UIView *)view {
//    [self.view addSubview:view];
//}

@end
