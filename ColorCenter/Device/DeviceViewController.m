//
//  DeviceViewController.m
//  ColorCenter
//
//  Created by 王海燕 on 2022/10/19.
//

#import "DeviceViewController.h"
#import "CommonTool.h"
#import "UIFont+CustomFont.h"
#import "DeviceCollectionViewCell.h"
#import "UIColor+CustomColor.h"
#import "CommonCollectionView.h"
#import "BlueToothViewController.h"
#import "DeviceCollectionReusableView.h"
#import "DataBase.h"
#import "BlueToothViewController.h"
#import "UIView+Frame.h"
#import "SpectroViewController.h"

@interface DeviceViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) CommonCollectionView * collectionView;
@property (strong, nonatomic) NSArray * datasource;

@end

@implementation DeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor bgWhiteColor];
    
    UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, [CommonTool statusbarH], self.view.frame.size.width - 40, 44)];
    titleLab.text = @"设备";
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont boldTitleFont];
    titleLab.textColor = [UIColor darkTextColor];
    [self.view addSubview:titleLab];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((self.view.frame.size.width - 2*16 - 12)/2, 160);
    layout.minimumInteritemSpacing = 12;
    
    self.collectionView = [[CommonCollectionView alloc] initWithFrame:CGRectMake(16, titleLab.bottom, self.view.frame.size.width - 2*16, self.view.frame.size.height - titleLab.bottom) collectionViewLayout:layout];
    [self.collectionView registerNib:[UINib nibWithNibName:@"DeviceCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"DeviceCollectionViewCell"];
    [self.collectionView registerClass:[DeviceCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DeviceCollectionReusableView"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.emptyImgName = @"empty_noContent";
    self.collectionView.emptyText = @"暂无已配对设备";
    self.collectionView.emptyLinkText = @"去连接";
    __weak typeof(self) weakSelf = self;
    self.collectionView.linkBlock = ^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf showBleConnectView];
    };
    [self.view addSubview:self.collectionView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[DataBase defaultDataBase] openSpectroList];
    self.datasource = [[DataBase defaultDataBase] getAllSpectro];
    [self.collectionView reloadData];
}

- (void)showBleConnectView
{
    BlueToothViewController * bleCtrl = [BlueToothViewController defaultBLEController];
    [bleCtrl showOn:self];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size = CGSizeMake(375, 48);
    return size;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.datasource.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DeviceCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DeviceCollectionViewCell" forIndexPath:indexPath];
    cell.spectro = self.datasource[indexPath.row];
    
    Spectro * curConnectSpectro = [[BlueToothViewController defaultBLEController] getSpectro];
    cell.isConnected = (curConnectSpectro.id.longValue == cell.spectro.id.longValue)?YES:NO;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    DeviceCollectionReusableView * view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DeviceCollectionReusableView" forIndexPath:indexPath];
    if (self.datasource.count > 0) {
        view.title = [NSString stringWithFormat:@"已配对的设备（%ld）", self.datasource.count];
    }else {
        view.title = @"";
    }
    
    return view;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Spectro * spectro = self.datasource[indexPath.row];
    SpectroViewController * spectroCtrl = [[SpectroViewController alloc] initWithSpectroId:spectro.id];
    [self.navigationController pushViewController:spectroCtrl animated:YES];
}

@end
