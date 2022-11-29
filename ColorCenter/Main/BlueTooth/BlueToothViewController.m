//
//  BlueToothViewController.m
//  ColorCenter
//
//  Created by 王海燕 on 2022/10/19.
//

#import "BlueToothViewController.h"
#import "CommonTool.h"
#import "UIFont+CustomFont.h"
#import "UIColor+CustomColor.h"
#import "BlueToothManager.h"
#import "CommonButton.h"
#import "UIImageView+Gif.h"
#import "BleTableViewCell.h"
#import "JobViewController.h"
#import "BleTableViewCell.h"

#import "UIView+Frame.h"
#import "NetWorkAPIManager.h"
#import "BleTool.h"
#import "BleCollectionCell.h"
#import "DataBase.h"

@interface BlueToothViewController () <BLEManagerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UIView * bgView;
@property (strong, nonatomic) UIView * contentView;

@property (assign, nonatomic) BLEStatus bleStatus;

@property (strong, nonatomic) UIView * scanView;
@property (strong, nonatomic) UICollectionView * collectionView;
@property (strong, nonatomic) NSArray <CBPeripheral *>* peripherals;
@property (strong, nonatomic) UILabel * scanStatusLab;
@property (strong, nonatomic) UIImageView * scanStatusIcon;

@property (strong, nonatomic) UIView * connectView;
@property (strong, nonatomic) UIImageView * deviceImg;
@property (strong, nonatomic) UIImageView * connectStatusIcon;
@property (strong, nonatomic) UILabel * connectStatusLab;

@property (strong, nonatomic) UIView * recieveDataView;
@property (strong, nonatomic) UITableView * tableView;
@property (strong, nonatomic) UILabel * spectroNameLab;

@property (strong, nonatomic) UIView * btnView;
@property (strong, nonatomic) CommonButton * cancelBtn;
@property (strong, nonatomic) CommonButton * operateBtn;

@property (weak, nonatomic) BlueToothManager * bleManager;
@property (strong, nonatomic) Spectro * spectro;
@property (strong, nonatomic) CBPeripheral * selectedPeripheral;

@property (assign, nonatomic) int standardSampleCount;//标样总数
@property (strong, nonatomic) NSMutableArray <StandardSample *>* standardSamples;//保存最新获取的20个标样
@end

@implementation BlueToothViewController

static BlueToothViewController * bleCtrl;

+(instancetype)defaultBLEController
{
    static dispatch_once_t predicateBle;
    dispatch_once(&predicateBle, ^{
        bleCtrl = [[BlueToothViewController alloc] init];
    });
    
    return bleCtrl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview: self.bgView];
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 442), self.view.frame.size.width, 442)];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview: self.contentView];
    
    UILabel * titleLab = [[UILabel alloc] initWithFrame:CGRectMake(20, 24, self.view.frame.size.width - 40, 26)];
    titleLab.text = @"设备连接";
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont titleFont];
    [self.contentView addSubview:titleLab];
    
    self.btnView = [[UIView alloc] initWithFrame:CGRectMake(0, self.contentView.frame.size.height - 80, self.contentView.frame.size.width, 80)];
    [self.contentView addSubview:self.btnView];

    float space = 24;
    float btnW = (self.contentView.frame.size.width - 2*space - 12)/2;
    self.cancelBtn = [[CommonButton alloc] initWithFrame:CGRectMake(space, 2, btnW, 44) title:@"取消"];
    [self.cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.cancelBtn.layer.borderColor = [UIColor borderColor].CGColor;
    self.cancelBtn.layer.borderWidth = 1.0;
    self.cancelBtn.backgroundColor = [UIColor whiteColor];
    [self.cancelBtn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [self.btnView addSubview:self.cancelBtn];
    
    self.operateBtn = [[CommonButton alloc] initWithFrame:CGRectMake(space + btnW + 12, 2, btnW, 44) title:@"连接"];
    [self.operateBtn addTarget:self action:@selector(operateBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.btnView addSubview:self.operateBtn];
    self.operateBtn.enabled = NO;
    
    self.backgroundView = self.bgView;
    self.moveView = self.contentView;
    self.gestureView = self.bgView;

//    StandardSample * sample = [[StandardSample alloc] initWithData:[self standardSampleData]];
//    [self.standardSamples addObject:sample];
//
//    StandardSample * sample2 = [[StandardSample alloc] initWithData:[self standardSampleData]];
//    [self.standardSamples addObject:sample2];

    self.bleManager = [BlueToothManager defaultManager];
    self.bleManager.delegate = self;
}

- (Spectro *)getSpectro
{
    return _spectro;
}


- (void)cancelBtnClicked
{
    switch (self.bleStatus) {
        case BLE_Scanning:
        {
            [self.bleManager stopScan];
        }
            break;
        case BLE_ReceivingData:
        {
            [self.bleManager disConnect];
        }
            break;
            
        default:
        {
            [self dismiss];
        }
            break;
    }
    
}

- (void)operateBtnClicked
{
    switch (self.bleStatus) {
        case BLE_Default:
        {
            
        }
            break;
        case BLE_Scanning:
        {
            if (self.peripherals.count > 0) {
                if (self.selectedPeripheral) {
                    [self.bleManager connect:self.selectedPeripheral];
                }
            }
            
        }
            break;
        case BLE_ScanFinished:
        {
            if (self.peripherals.count > 0) {
                if (self.selectedPeripheral) {
                    [self.bleManager connect:self.selectedPeripheral];
                }
            }else {
                [self.bleManager startScan];
            }
            
        }
            break;
        case BLE_disConnect:
        {
            if (self.selectedPeripheral) {
                [self.bleManager connect:self.selectedPeripheral];
            }
        }
            break;
        default:
        {
            [self dismiss];
        }
            break;
    }
}


- (void)scanBlueTooth
{
    
}

- (void)setBleStatus:(BLEStatus)bleStatus
{
    _bleStatus = bleStatus;
    
    switch (bleStatus) {
        case BLE_Default:
        {
            
        }
            break;
        case BLE_Scanning:
        {
            [self.contentView addSubview:self.scanView];
            self.scanStatusIcon.frame = CGRectMake((self.scanView.frame.size.width - 48)/2,80 , 48, 48);
             NSURL * url = [[NSURL alloc]initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"loading.gif" ofType:nil]];
             [self.scanStatusIcon setGif:url];
            
            self.scanStatusLab.text = @"检测中...";
            
            [self.cancelBtn setNormalTitle:@"取消" disabledTitle:@"取消"];
            [self.operateBtn setNormalTitle:@"连接" disabledTitle:@"连接"];
            self.operateBtn.enabled = NO;
        }
            break;
        case BLE_ScanFinished:
        {
            if (self.peripherals.count > 0) {
                [self.scanStatusIcon.layer removeAllAnimations];
                self.scanStatusIcon.frame = CGRectZero;

                self.scanStatusLab.text = @"请选择设备！";
                self.operateBtn.enabled = YES;
                 
                self.collectionView.hidden = NO;
                self.recieveDataView.hidden = YES;
//                self.collectionView.frame = CGRectMake(0, 74, self.contentView.width, 160);
                [self.cancelBtn setNormalTitle:@"取消" disabledTitle:@"取消"];
                [self.operateBtn setNormalTitle:@"连接" disabledTitle:@"连接"];
                self.operateBtn.enabled = YES;
                
            }else {
                [self.scanStatusIcon.layer removeAllAnimations];
                self.scanStatusIcon.frame = CGRectMake((self.scanView.frame.size.width - 160)/2, 72, 160, 126);
                self.scanStatusIcon.image = [UIImage imageNamed:@"empty_noContent"];
                
                self.scanStatusLab.text = @"未检测到任何设备";
                
                [self.cancelBtn setNormalTitle:@"取消" disabledTitle:@"取消"];
                [self.operateBtn setNormalTitle:@"重新检测" disabledTitle:@"重新检测"];
                self.operateBtn.enabled = YES;
                self.collectionView.hidden = YES;
            }
            
        }
            break;
        case BLE_Connecting:
        {
            [self.contentView addSubview:self.connectView];
            
            self.connectStatusIcon.frame = CGRectMake(164,142 , 48, 48);
             NSURL * url = [[NSURL alloc]initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"loading.gif" ofType:nil]];
             [self.connectStatusIcon setGif:url];

            self.connectStatusLab.text = @"设备连接中...";

            [self.cancelBtn setNormalTitle:@"取消" disabledTitle:@"取消"];
            [self.operateBtn setNormalTitle:@"重试" disabledTitle:@"重试"];
        }
            break;
        case BLE_ConnectSuccess:
        {
            [self.contentView addSubview:self.connectView];
            [self.connectStatusIcon.layer removeAllAnimations];
            self.connectStatusIcon.image = [UIImage imageNamed:@"mark_success"];
            
            self.connectStatusLab.text = @"设备已连接";
            
            self.peripherals  = @[];
            [self.collectionView reloadData];
            
            [self.cancelBtn setNormalTitle:@"断开" disabledTitle:@"断开"];
            [self.operateBtn setNormalTitle:@"保持连接" disabledTitle:@"保持连接"];
        
        }
            break;
        case BLE_disConnect:
        {
//            [self.contentView addSubview:self.connectView];
//            [self.connectStatusIcon.layer removeAllAnimations];
//            self.connectStatusIcon.image = [UIImage imageNamed:@"mark_fail"];
//
//            self.connectStatusLab.text = @"连接有问题，请查看设备";
//
//            [self.cancelBtn setNormalTitle:@"取消" disabledTitle:@"取消"];
//            [self.operateBtn setNormalTitle:@"重试" disabledTitle:@"重试"];
            [self.bleManager startScan];

        }
            break;
        case BLE_ReceivingData:
        {
            [self.contentView addSubview:self.recieveDataView];
            self.spectroNameLab.text = [NSString stringWithFormat:@"以诺行测色仪%@",self.bleManager.peripheral.name];
            
            [self.cancelBtn setNormalTitle:@"断开" disabledTitle:@"断开"];
            [self.operateBtn setNormalTitle:@"保持连接" disabledTitle:@"保持连接"];

        }
            break;
            
        default:
            break;
    }
}

- (void)BLEManagerDidUpdateState:(BLEStatus)status
{
    self.bleStatus = status;
}

- (void)BLEManagerDidConnectPeripheral:(CBPeripheral *)peripheral
{
    __weak typeof(self) weakSelf = self;
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, (ino64_t)(2 * NSEC_PER_SEC));
    dispatch_after(time, dispatch_get_global_queue(0, 0), ^{
        __strong typeof(self) strongSelf = weakSelf;
        [strongSelf createSpectroWith:peripheral];
    });

}


- (void)BLEManagerDidUpdatePeripheral:(NSArray *)scanedPeripherals
{
    self.peripherals = scanedPeripherals;
    [self.collectionView reloadData];
    
    if (self.peripherals.count > 0) {
        [self.scanStatusIcon.layer removeAllAnimations];
        self.scanStatusLab.text = @"请选择设备！";
    }
}

- (void)BLEManagerDidRecieveData:(NSData *)recievedData
{
    BleCommand * cmd = [[BleCommand alloc] initWithData:recievedData];
    if ((cmd.type == CMD_RETURN) && (cmd.code == GetStandardSamplesCount)) {
        //获取标样总数
        uint32_t count = [BleTool unsignedDataTointWithData:cmd.data Location:0 Offset:cmd.len];
        self.standardSampleCount = count;
        [self getStandardSampleAt:self.standardSampleCount-1];
        
        self.bleStatus = BLE_ReceivingData;
    }else if ((cmd.type == CMD_NOTIFICATION) && (cmd.code == AboutSample)) {
        //获取标样
        if (cmd.len == 2048) {
            //标样数据转换
            StandardSample * sample = [[StandardSample alloc] initWithData:cmd.data];
            [self.standardSamples addObject:sample];
            [self.tableView reloadData];
        }else {
            [CommonTool showHint:@"标样获取失败"];
        }
        
        if (self.standardSamples.count < 20) {
            [self getStandardSampleAt:self.standardSampleCount-self.standardSamples.count -1];
        }
    }else if ((cmd.type == CMD_NOTIFICATION) && (cmd.code == CheckAndMeasure)) {
        //测量返回标样记录
        StandardSample * sample = nil;
        if (cmd.len == 2048) {
            //标样数据转换
            sample = [[StandardSample alloc] initWithData:cmd.data];
            [self.standardSamples addObject:sample];
            [self.tableView reloadData];
        }else {
            [CommonTool showHint:@"测量失败"];
        }
        
        if (self.measureBlk) {
            self.measureBlk(sample);
        }
    }
    
}

- (void)createSpectroWith:(CBPeripheral *)peripheral
{
    //创建测色仪绑定
    Spectro * spectro = [[Spectro alloc] init];
    spectro.serialNo = peripheral.name;
    
    __weak typeof(self) weakSelf = self;
    [[NetWorkAPIManager defaultManager] commonPOST:@"/enocolor/client/spectro" parm:[spectro convertToDictionary] registerClass:[NSObject class] Success:^(NSURLSessionDataTask * _Nonnull task, ResponseObject * _Nonnull responseObj) {
        
        __strong typeof(self) strongSelf = weakSelf;
        NSNumber * Id = responseObj.data.firstObject;
        [strongSelf getSpectroWith:Id];
        
    } Failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [CommonTool showError:error];
    }];
}


//获取测色仪绑定详情
- (void)getSpectroWith:(NSNumber *)Id
{
    __weak typeof(self) weakSelf = self;
    
    NSString * url = [NSString stringWithFormat:@"/enocolor/client/spectro/%@",Id];
    [[NetWorkAPIManager defaultManager] commonGET:url parm:@{} registerClass:[Spectro class] Success:^(NSURLSessionDataTask * _Nonnull task, ResponseObject * _Nonnull responseObj) {
        __strong typeof(self) strongSelf = weakSelf;
        strongSelf.spectro = responseObj.data.firstObject;
        
        [strongSelf startGetSamples];
        
        [[DataBase defaultDataBase] openSpectroList];
        [[DataBase defaultDataBase] insertASpectro:strongSelf.spectro];
        
    } Failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [CommonTool showError:error];
    }];
}


- (void)startGetSamples
{
    [self getStandardSampleCount];
}

//获取标样总数
- (void)getStandardSampleCount
{
    BleCommand * cmd = [[BleCommand alloc] init];
    cmd.type = 0x02;
    cmd.code = 0x01;
    cmd.len = 0;
    [self.bleManager sendCommend:[cmd cmdToData]];
}

//获取标样
- (void)getStandardSampleAt:(int)index
{
    BleCommand * cmd = [[BleCommand alloc] init];
    cmd.type = 0x01;
    cmd.code = 0x06;
    cmd.len = 4;
    uint32_t pos = index;
    cmd.data = [NSData dataWithBytes:&pos length:cmd.len];
    [self.bleManager sendCommend:[cmd cmdToData]];
}

- (void)measure
{
    BleCommand * cmd = [[BleCommand alloc] init];
    cmd.type = 0x01;
    cmd.code = 0x04;
    cmd.len = 0;
    [self.bleManager sendCommend:[cmd cmdToData]];
}

#pragma mark

- (UIView *)scanView
{
    if (!_scanView) {
        _scanView = [[UIView alloc] initWithFrame:CGRectMake(0, 62, self.contentView.width, 300)];
        _scanView.backgroundColor = [UIColor whiteColor];
        self.scanStatusLab.frame = CGRectMake(0, 216, _scanView.frame.size.width, 24);
        [_scanView addSubview:self.scanStatusLab];
        self.scanStatusIcon = [[UIImageView alloc]initWithFrame:CGRectMake((_scanView.frame.size.width - 48)/2,80 , 48, 48)];
        [_scanView addSubview:self.scanStatusIcon];
    }
    return _scanView;
}

- (UILabel *)scanStatusLab
{
    if (!_scanStatusLab) {
        _scanStatusLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 24)];
        _scanStatusLab.font = [UIFont textFont];
        _scanStatusLab.textColor = [UIColor textColor];
        _scanStatusLab.textAlignment = NSTextAlignmentCenter;
    }
    return _scanStatusLab;
}

- (UIView *)connectView
{
    if (!_connectView) {
        _connectView = [[UIView alloc] initWithFrame:CGRectMake(0, 62, self.contentView.width, 300)];
        _connectView.backgroundColor = [UIColor whiteColor];
        self.deviceImg = [[UIImageView alloc] initWithFrame:CGRectMake((_contentView.width - 124)/2, 24, 124, 116)];
        self.deviceImg.image = [UIImage imageNamed:@"deviceBig"];
        [_connectView addSubview:self.deviceImg];
        self.connectStatusIcon = [[UIImageView alloc] initWithFrame:CGRectMake((_contentView.width - 36)/2, 172, 36, 36)];
        [_connectView addSubview:self.connectStatusIcon];
        self.connectStatusLab = [[UILabel alloc] initWithFrame:CGRectMake(0, self.connectStatusIcon.bottom +8, _connectView.width, 24)];
        self.connectStatusLab.font = [UIFont textFont];
        self.connectStatusLab.textColor = [UIColor textColor];
        self.connectStatusLab.textAlignment = NSTextAlignmentCenter;
        [_connectView addSubview:self.connectStatusLab];
        
    }
    return _connectView;
}

- (UIView *)recieveDataView
{
    if (!_recieveDataView) {
        _recieveDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 62, self.contentView.frame.size.width, 300)];
        _recieveDataView.backgroundColor = [UIColor whiteColor];
        UILabel * leftLab  = [[UILabel alloc] initWithFrame:CGRectMake(24, 12, 60, 22)];
        leftLab.text = @"设备名称";
        leftLab.textColor = [UIColor textColor];
        leftLab.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        [_recieveDataView addSubview: leftLab];
        
        self.spectroNameLab = [[UILabel alloc] initWithFrame:CGRectMake(104, 12, _recieveDataView.frame.size.width - 104 - 24, 22)];
        self.spectroNameLab.text = [NSString stringWithFormat:@"以诺行测色仪%@",self.bleManager.peripheral.name];
        self.spectroNameLab.textColor = [UIColor textColor];
        self.spectroNameLab.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        self.spectroNameLab.textAlignment = NSTextAlignmentRight;
        [_recieveDataView addSubview:self.spectroNameLab];
        
        self.tableView.frame = CGRectMake(0, 46, _recieveDataView.width, 250);
        [_recieveDataView addSubview:self.tableView];
    }
    
    return _recieveDataView;
}

- (NSMutableArray<StandardSample *> *)standardSamples
{
    if (!_standardSamples) {
        _standardSamples = [NSMutableArray array];
    }
    return  _standardSamples;
}

#pragma mark Collection

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(120, 160);
        layout.minimumInteritemSpacing = 12;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        float orgY = 74;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, orgY, self.contentView.frame.size.width, 160) collectionViewLayout:layout];
        [_collectionView registerNib:[UINib nibWithNibName:@"BleCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"BleCollectionCell"];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.allowsMultipleSelection = YES;
        _collectionView.layer.masksToBounds = YES;
        [self.contentView addSubview:_collectionView];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.peripherals.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BleCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BleCollectionCell" forIndexPath:indexPath];
    CBPeripheral * peripheral = self.peripherals[indexPath.row];
    cell.name = peripheral.name;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CBPeripheral * peripheral = self.peripherals[indexPath.row];
    self.selectedPeripheral = peripheral;
    self.operateBtn.enabled = YES;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedPeripheral = nil;
}

#pragma mark tableview

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 46, self.contentView.width, 230)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[BleTableViewCell class] forCellReuseIdentifier:@"BleTableViewCell"];
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.standardSamples.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BleTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"BleTableViewCell"];
    StandardSample * sample = self.standardSamples[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@  %@",sample.number,sample.dateTime];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [UIColor lightTextColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StandardSample * sample = self.standardSamples[indexPath.row];
    JobViewController * recommandCtrl = [[JobViewController alloc] initWithColorPanel:sample.colorPanel];
    [self.navigationController pushViewController:recommandCtrl animated:YES];
}


- (NSData *)standardSampleData
{
    Byte data[2048] = {0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x54,0x30,0x30,0x30 ,0x30,0x31,0x00,0x30 ,0x80,0x00,0xe6,0x07 ,0x0a,0x13 ,0x11,0x1d ,0x0f,0x00,0x2a,0x00 ,0xc6,0x1a,0x10,0x1c ,0x0d,0x1d,0x4b,0x1d ,0x73,0x1d,0xaa,0x1d ,0x42,0x1e,0x45,0x1f ,0x3b,0x20 ,0xcb,0x20,0xcd,0x21,0x74,0x23 ,0x00,0x25,0x0d,0x26 ,0xa4,0x26,0xd7,0x26 ,0xfa,0x26,0x6b,0x27 ,0xbb,0x28,0xa0,0x2a ,0xde,0x2b,0x9c,0x2c ,0x84,0x30,0x14,0x32 ,0xac,0x2d,0x29,0x2e ,0x9e,0x2e,0xe2,0x2e ,0x50,0x2f,0xf6,0x2e ,0x62,0x2f,0xfa,0x03 ,0x05,0x05,0x9f,0x05 ,0x31,0x06,0x85,0x06 ,0x3f,0x06,0x63,0x05 ,0x3c,0x04,0x0d,0x03 ,0x0f,0x02,0x7a,0x01 ,0x2d,0x01,0xff,0x00 ,0xdf,0x00,0xce,0x00 ,0xc5,0x00,0xbd,0x00 ,0xbf,0x00,0xc8,0x00 ,0xcd,0x00,0xce,0x00 ,0xcd,0x00,0xc6,0x00 ,0xd4,0x00,0xf2,0x00 ,0x29,0x01,0x7d,0x01 ,0xcd,0x01,0x16,0x02 ,0x50,0x02,0x92,0x02 ,0x6d,0x10,0xdb,0x11 ,0x9a,0x12,0xb1,0x12 ,0xb2,0x12,0xd6,0x12 ,0x4e,0x13,0x54,0x14 ,0x34,0x15,0xb5,0x15 ,0xc0,0x16,0x93,0x18 ,0x66,0x1a,0x98,0x1b ,0x01,0x1c,0xf4,0x1b ,0xd9,0x1b,0x1a,0x1c ,0x63,0x1d,0x4f,0x1f ,0x78,0x20,0xf6,0x20 ,0x21,0x21,0x2e,0x21 ,0x4a,0x21,0x90,0x21 ,0x9c,0x21,0x7c,0x21 ,0x87,0x21,0x20,0x21 ,0x40,0x21,0x44,0x00 ,0x98,0x00,0xa9,0x00 ,0xb6,0x00,0xbc,0x00 ,0xaf,0x00,0x96,0x00 ,0x7d,0x00,0x68,0x00 ,0x54,0x00,0x4a,0x00 ,0x46,0x00,0x43,0x00 ,0x43,0x00,0x3e,0x00 ,0x3a,0x00,0x3e,0x00 ,0x42,0x00,0x48,0x00 ,0x4b,0x00,0x48,0x00 ,0x43,0x00,0x40,0x00 ,0x46,0x00,0x5b,0x00 ,0x7a,0x00,0xa1,0x00 ,0xc0,0x00,0xd1,0x00 ,0xda,0x00,0xe1,0x00 ,0x50,0x0f,0x8b,0x10 ,0x3b,0x11,0x3a,0x11 ,0x20,0x11,0x39,0x11 ,0xaa,0x11,0xad,0x12 ,0x89,0x13,0x05,0x14 ,0x14,0x15,0xfb,0x16 ,0xd5,0x18,0xfe,0x19 ,0x67,0x1a,0x55,0x1a ,0x30,0x1a,0x6b,0x1a ,0xa8,0x1b,0xa2,0x1d ,0xd6,0x1e,0x3d,0x1f ,0x5d,0x1f,0x58,0x1f ,0x5e,0x1f,0x8b,0x1f ,0x7b,0x1f,0x4d,0x1f ,0x52,0x1f,0xda,0x1e ,0xf5,0x1e,0x00,0x00 ,0x47,0x00,0x57,0x00 ,0x5c,0x00,0x5d,0x00 ,0x59,0x00,0x4f,0x00 ,0x44,0x00,0x3f,0x00 ,0x39,0x00,0x34,0x00 ,0x32,0x00,0x32,0x00 ,0x32,0x00,0x2e,0x00 ,0x2b,0x00,0x2e,0x00 ,0x34,0x00,0x37,0x00 ,0x3b,0x00,0x38,0x00 ,0x30,0x00,0x2d,0x00 ,0x34,0x00,0x48,0x00 ,0x68,0x00,0x8a,0x00 ,0xa9,0x00,0xb2,0x00 ,0xba,0x00,0xbc,0x00 ,0x29,0x0c,0xf2,0x0c ,0x4d,0x0d,0x4b,0x0d ,0x5d,0x0d,0x9e,0x0d ,0x38,0x0e,0x23,0x0f ,0xb9,0x0f,0x3a,0x10 ,0x6d,0x11,0x25,0x13 ,0x88,0x14,0x49,0x15 ,0x80,0x15,0x5a,0x15 ,0x49,0x15,0xc2,0x15 ,0x29,0x17,0xb7,0x18 ,0x68,0x19,0x9c,0x19 ,0xa7,0x19,0x9b,0x19 ,0x9b,0x19,0xbf,0x19 ,0xb5,0x19,0x95,0x19 ,0x7a,0x19,0x08,0x19 ,0x6e,0x19,0x58,0x0f ,0x63,0x10,0xe9,0x10 ,0xbd,0x10,0xba,0x10 ,0xf2,0x10,0xac,0x11 ,0xb0,0x12,0x61,0x13 ,0xf7,0x13,0x54,0x15 ,0x2f,0x17,0xca,0x18 ,0x9b,0x19,0xd2,0x19 ,0xac,0x19,0x9f,0x19 ,0x1c,0x1a,0xae,0x1b ,0x60,0x1d,0x2d,0x1e ,0x65,0x1e,0x78,0x1e ,0x7f,0x1e,0x71,0x1e ,0x76,0x1e,0x4e,0x1e ,0x5e,0x1e,0x5b,0x1e ,0x48,0x1e,0xa5,0x1e ,0xcd,0x12,0x04,0x14 ,0x7e,0x14,0x72,0x14 ,0x87,0x14,0xb1,0x14 ,0x5f,0x15,0x6d,0x16 ,0x22,0x17,0xab,0x17 ,0x14,0x19,0x0f,0x1b ,0xa9,0x1c,0x85,0x1d ,0xbd,0x1d,0xa1,0x1d ,0x90,0x1d,0x10,0x1e ,0xb3,0x1f,0x88,0x21 ,0x60,0x22,0xad,0x22 ,0xc8,0x22,0xbf,0x22 ,0xc5,0x22,0xf5,0x22 ,0xf2,0x22,0xd6,0x22 ,0xcb,0x22,0x43,0x22 ,0xc4,0x22,0xf5,0x13 ,0x0f,0x15,0x64,0x15 ,0x50,0x15,0x57,0x15 ,0x8a,0x15,0x38,0x16 ,0x48,0x17,0xf4,0x17 ,0x90,0x18,0x00,0x1a ,0xff,0x1b,0xb1,0x1d ,0x9e,0x1e,0xd9,0x1e ,0xaf,0x1e,0x9f,0x1e ,0x20,0x1f,0xca,0x20 ,0xa5,0x22,0x83,0x23 ,0xc9,0x23,0xd9,0x23 ,0xda,0x23,0xdf,0x23 ,0x09,0x24,0xf5,0x23 ,0xcc,0x23,0xb9,0x23 ,0x27,0x23,0xaf,0x23 ,0xf4,0x0e,0xf8,0x0f ,0x4f,0x10,0x3d,0x10 ,0x43,0x10,0x72,0x10 ,0x17,0x11,0x21,0x12 ,0xc6,0x12,0x63,0x13 ,0xcd,0x14,0xc6,0x16 ,0x62,0x18,0x41,0x19 ,0x7b,0x19,0x53,0x19 ,0x43,0x19,0xcc,0x19 ,0x6f,0x1b,0x37,0x1d ,0x0c,0x1e,0x55,0x1e ,0x61,0x1e,0x5e,0x1e ,0x61,0x1e,0x8a,0x1e ,0x84,0x1e,0x56,0x1e ,0x37,0x1e,0xae,0x1d ,0x14,0x1e,0x10,0x0d ,0xab,0x0d,0xfc,0x0d ,0xe7,0x0d,0x04,0x0e ,0x3d,0x0e,0xd3,0x0e ,0xc7,0x0f,0x6f,0x10 ,0x00,0x11,0x3f,0x12 ,0x13,0x14,0x9d,0x15 ,0x6f,0x16,0x9e,0x16 ,0x75,0x16,0x59,0x16 ,0xcd,0x16,0x4b,0x18 ,0xed,0x19,0xb5,0x1a ,0xe8,0x1a,0xf9,0x1a ,0xf1,0x1a,0xe9,0x1a ,0x18,0x1b,0xfa,0x1a ,0xe4,0x1a,0xd3,0x1a ,0x59,0x1a,0xab,0x1a ,0x00,0x00,0x80,0x3f ,0x00,0x00,0x80,0xbf ,0x00,0x00,0x80,0xbf ,0x00,0x00,0x80,0xbf ,0x00,0x00,0x80,0x3f ,0x00,0x00,0x80,0x3f ,0x00,0x00,0x80,0x3f ,0x00,0x00,0x80,0x3f ,0x00,0x00,0x80,0xbf ,0x00,0x00,0x80,0xbf  ,0x00,0x00,0x80,0xbf ,0x00,0x00,0x80,0x3f ,0x00,0x00,0x80,0x3f ,0x00,0x00,0x80,0x3f ,0x00,0x00,0x80,0x3f ,0x00,0x00,0x80,0xbf  ,0x00,0x00,0x80,0xbf ,0x00,0x00,0x80,0xbf ,0x00,0x00,0x80,0x3f ,0x00,0x00,0x80,0x3f ,0x00,0x00,0x80,0x3f ,0x00,0x00,0x80,0x3f ,0x00,0x00,0x80,0xbf ,0x00,0x00,0x80,0xbf ,0x00,0x00,0x80,0xbf ,0x00,0x00,0x80,0x3f ,0x00,0x00,0x80,0x3f ,0x00,0x00,0x80,0x3f ,0x00,0x00,0x80,0x3f ,0x00,0x00,0x80,0xbf ,0x00,0x00,0x80,0xbf ,0x00,0x00,0x80,0xbf ,0x00,0x00,0x80,0x3f ,0x00,0x00,0x80,0x3f ,0x00,0x00,0x80,0x3f ,0x00,0x00,0x80,0x3f ,0x00,0x00,0x80,0xbf ,0x00,0x00,0x80,0xbf ,0x00,0x00,0x80,0xbf ,0x00,0x00,0x80,0x3f ,0x00,0x00,0x80,0x3f ,0x00,0x00,0x80,0x3f ,0x00,0x00,0x80,0x3f ,0x00,0x00,0x80,0xbf ,0x00,0x00,0x80,0xbf ,0x00,0x00,0x80,0xbf ,0x00,0x00,0x80,0x3f ,0x00,0x00,0x80,0x3f ,0x00,0x00,0x80,0x3f ,0x00,0x00,0x80,0x3f ,0x00,0x00,0x80,0xbf ,0x00,0x00,0x80,0xbf ,0x00,0x00,0x80,0xbf ,0x00,0x00,0x80,0x3f ,0x00,0x00,0x80,0x3f ,0x00,0x00,0x80,0x3f ,0x00,0x00,0x80,0x3f ,0x00,0x00,0x80,0xbf ,0x00,0x00,0x80,0xbf ,0x00,0x00,0x80,0xbf ,0x00,0x00,0x80,0x3f ,0x00,0x00,0x80,0x3f ,0x00,0x00,0x80,0x3f ,0x00,0x00,0x80,0x3f ,0x00,0x00,0x80,0xbf ,0x00,0x00,0x80,0xbf ,0x00,0x00,0x80,0xbf ,0x00,0x00,0x80,0x3f ,0x00,0x00,0x80,0x3f ,0x00,0x00,0x80,0x3f ,0x00,0x00,0x80,0x3f ,0x00,0x00,0x80,0xbf ,0x00,0x00,0x80,0xbf ,0x00,0x00,0x80,0xbf ,0x00,0x00,0x80,0x3f ,0x00,0x00,0x80,0x3f ,0x00,0x00,0x80,0x3f ,0x00,0x00,0x80,0x3f ,0x00,0x00,0x80,0xbf ,0x00,0x00,0x80,0xbf ,0x00,0x00,0x80,0xbf ,0x00,0x00,0x80,0x3f ,0x00,0x00,0x80,0x3f ,0x00,0x00,0x80,0x3f ,0x85,0xeb,0x31,0xc0 ,0xae,0x47,0x29,0xc1 ,0x71,0x3d,0x1e,0xc1 ,0x40,0x0f,0x1b,0x40 ,0x71,0x3d,0x0a,0xc0 ,0x52,0xb8,0xfe,0x40 ,0x14,0xae,0x0f,0x41 ,0xae,0x47,0x89,0x40 ,0x00,0x00,0x00,0x42 ,0x6c,0x68,0x93,0x41 ,0xb3,0x5c,0xf6,0x40 ,0xae,0x47,0x89,0x40 ,0x00,0x80,0x85,0x41 ,0x17,0x97,0xa8,0x41 ,0x83,0x6e,0xb8,0x40 ,0xae,0x47,0x89,0x40 ,0xae,0x47,0x81,0xbf ,0xec,0x51,0x38,0x40 ,0xe1,0x7a,0x14,0x41 ,0xae,0x47,0x89,0x40 ,0x00,0x00,0x00,0x42 ,0xad,0x5f,0x3b,0x40 ,0x31,0x9d,0x25,0x40 ,0xae,0x47,0x89,0x40 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00 ,0x00,0x00,0x00,0x00};
    
    
    NSData * data2 = [NSData dataWithBytes:data length:2048];
    return data2;
}

@end
