//
//  UserViewController.m
//  ColorCenter
//
//  Created by 王海燕 on 2022/10/19.
//

#import "UserViewController.h"
#import "SettingViewController.h"
#import "ItemCollectionViewCell.h"
#import "SettingTableViewCell.h"
#import "MemberViewController.h"
#import <SDWebImage/SDWebImage.h>
#import "CommonButton.h"
#import "UIColor+CustomColor.h"
#import "UIView+Frame.h"
#import "UIFont+CustomFont.h"
#import "NetWorkAPIManager.h"
#import "CommonTool.h"
#import "UserInfoViewCtrl.h"

@interface UserViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UIImageView * bgImg;
@property (strong, nonatomic) UIButton * settingBtn;
@property (strong, nonatomic) UIButton * myQRCodeBtn;
@property (strong, nonatomic) UILabel * hiLab;
@property (strong, nonatomic) UILabel * nameLab;
@property (strong, nonatomic) UILabel * cellphoneLab;
@property (strong, nonatomic) UIImageView * headImg;
@property (strong, nonatomic) UICollectionView * collectionView;
@property (strong, nonatomic) NSArray * collectiondDatasource;
@property (strong, nonatomic) UITableView * tableView;
@property (strong, nonatomic) NSArray * tableViewDatasource;

@property (nonatomic, strong) User * user;
@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor bgWhiteColor];
    
    self.bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 218)];
    self.bgImg.image = [UIImage imageNamed:@"bgImg"];
    [self.view addSubview:self.bgImg];
    
    self.settingBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 40 -16, 46, 40, 40)];
    [self.settingBtn addTarget:self action:@selector(settingBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.settingBtn setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    [self.view addSubview:self.settingBtn];
    
    self.myQRCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.settingBtn.frame.origin.x - 40 - 8, self.settingBtn.frame.origin.y, 40, 40)];
    [self.myQRCodeBtn addTarget:self action:@selector(myQRCodeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.myQRCodeBtn setImage:[UIImage imageNamed:@"qrcode"] forState:UIControlStateNormal];
    [self.view addSubview:self.myQRCodeBtn];
    self.myQRCodeBtn.hidden = YES;
    
    self.hiLab = [[UILabel alloc] initWithFrame:CGRectMake(24, 120, 200, 32)];
    self.hiLab.font = [UIFont systemFontOfSize:24 weight:UIFontWeightMedium];
    self.hiLab.textColor = [UIColor darkTextColor];
    [self.view addSubview:self.hiLab];
    
    self.nameLab = [[UILabel alloc] initWithFrame:CGRectMake(self.hiLab.frame.origin.x, (self.hiLab.frame.origin.y + self.hiLab.frame.size.height), self.hiLab.frame.size.width, self.hiLab.frame.size.height)];
    self.nameLab.font = [UIFont systemFontOfSize:24 weight:UIFontWeightMedium];
    self.nameLab.textColor = [UIColor darkTextColor];
    [self.view addSubview:self.nameLab];
    
    self.cellphoneLab = [[UILabel alloc] initWithFrame:CGRectMake(self.nameLab.frame.origin.x, (self.nameLab.frame.origin.y + self.nameLab.frame.size.height+8), self.nameLab.frame.size.width, 20)];
    self.cellphoneLab.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    self.cellphoneLab.textColor = [UIColor textColor];
    [self.view addSubview:self.cellphoneLab];
    
    self.headImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 72-36, 120, 72, 72)];
    self.headImg.image = [UIImage imageNamed:@"defaultHead"];
    self.headImg.layer.cornerRadius = 36;
    self.headImg.backgroundColor = [UIColor whiteColor];
    self.headImg.layer.masksToBounds = YES;
    [self.view addSubview:self.headImg];
    
    UIImageView * cameraImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.headImg.right - 24, self.headImg.bottom - 24, 24, 24)];
    cameraImg.image = [UIImage imageNamed:@"cameraIcon"];
    [self.view addSubview:cameraImg];
    
    UIButton * headBtn = [[UIButton alloc] initWithFrame:self.headImg.frame];
    [headBtn addTarget:self action:@selector(headBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:headBtn];
    
    self.hiLab.text = @"Hi,";
    self.nameLab.text = @"以诺行汽修公司";
    self.cellphoneLab.text = @"13465321236";
    
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(85, 80);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(16, 276, self.view.frame.size.width - 2*16, 80) collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.layer.cornerRadius = 8.0;
    [self.collectionView registerNib:[UINib nibWithNibName:@"ItemCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"ItemCollectionViewCell"];
//    [self.view addSubview:self.collectionView];
    
    self.collectiondDatasource = @[[[Item alloc] initWith:@"成员" icon:@"item1"], [[Item alloc] initWith:@"设备" icon:@"item2"], [[Item alloc] initWith:@"安全/隐私" icon:@"item3"], [[Item alloc] initWith:@"应用端" icon:@"item4"]];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(16, (self.collectionView.frame.origin.y + self.collectionView.frame.size.height +12), self.collectionView.frame.size.width, 96)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.layer.cornerRadius = 8.0;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"SettingTableViewCell" bundle:nil] forCellReuseIdentifier:@"SettingTableViewCell"];
//    [self.view addSubview:self.tableView];
    
    SettingItem * item1 = [[SettingItem alloc] init];
    item1.titleStr = @"语言";
    item1.hasNext = YES;
    
    SettingItem * item2 = [[SettingItem alloc] init];
    item2.titleStr = @"协议与隐私";
    item2.hasNext = YES;
    
    self.tableViewDatasource = @[item1, item2];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.user = [NetWorkAPIManager defaultManager].curUser;
}

- (void)setUser:(User *)user
{
    _user = user;
    
    self.nameLab.text = user.name;
    self.cellphoneLab.text = user.cellphone;
    NSString * imageUrl = user.avartar;
    if (imageUrl.length > 0) {
        [self.headImg sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    }else {
        self.headImg.image = [UIImage imageNamed:@"defaultHead"];
    }
}

- (void)settingBtnClicked
{
    SettingViewController * settingCtrl = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:settingCtrl animated:YES];
}

- (void)myQRCodeBtnClicked
{
    
}

- (void)headBtnClicked
{
    [self showUserInfoCtrl];
}

- (void)showUserInfoCtrl
{
    UserInfoViewCtrl * userCtrl = [[UserInfoViewCtrl alloc] init];
    [self.navigationController pushViewController:userCtrl animated:YES];
}


#pragma mark collection Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collectiondDatasource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ItemCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ItemCollectionViewCell" forIndexPath:indexPath];
    cell.item = self.collectiondDatasource[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
            MemberViewController * memberCtrl = [[MemberViewController alloc] init];
            [self.navigationController pushViewController:memberCtrl animated:YES];
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
            
        default:
            break;
    }
}


#pragma mark tableview Ddelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableViewDatasource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SettingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SettingTableViewCell"];
    
    cell.item = self.tableViewDatasource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}


@end
