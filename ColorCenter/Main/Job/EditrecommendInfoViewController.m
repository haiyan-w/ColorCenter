//
//  EditrecommendInfoViewController.m
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/11.
//

#import "EditrecommendInfoViewController.h"
#import "VehicleBrandViewController.h"
#import "NetWorkAPIManager.h"
#import "CommonTool.h"
#import "TimePickerView.h"

@interface EditrecommendInfoViewController ()<PickerViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UITextField *brandTF;
@property (strong, nonatomic) IBOutlet UITextField *timeTF;
@property (strong, nonatomic) IBOutlet UITextField *colorTF;

@property (strong, nonatomic) NSArray <NSString *>* brand;
@property (strong, nonatomic) NSString * year;
@property (strong, nonatomic) NSString * colorCode;
@end

@implementation EditrecommendInfoViewController

- (instancetype)initWithBrand:(NSArray *)brand year:(NSString *)year colorCode:(NSString *)colorCode
{
    self = [super init];
    if (self) {
        self.brand = brand;
        self.year = year;
        self.colorCode = colorCode;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.brandTF.text = [CommonTool vehicleModelToString:self.brand];
    self.timeTF.text = self.year;
    self.colorTF.text = self.colorCode;
    
    self.backgroundView = self.bgView;
    self.gestureView = self.bgView;
    self.moveView = self.contentView;
}


- (IBAction)selectBrandBtnClicked:(id)sender
{
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
        strongSelf.brandTF.text = [CommonTool vehicleModelToString:model];
        strongSelf.brand = model;
    };
    
    [brandCtrl showOn:self];
}



- (IBAction)selectTimeBtnClicked:(id)sender {
    
    TimePickerViewController * timeCtrl = [[TimePickerViewController alloc] initWithTimeType:YY title:@"年份" years:nil untilCurDate:YES];
    timeCtrl.delegate = self;
    [timeCtrl showOn:self]; 
}

- (IBAction)saveBtnClicked:(id)sender {
    
    __weak typeof(self) weakSelf = self;
    [self dismissWithCompletion:^{
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf.sureBlk) {
            strongSelf.sureBlk(strongSelf.brand, strongSelf.timeTF.text, strongSelf.colorTF.text);
        }
    }];
}

-(void)pickerViewController:(PickerViewController*)picker selectData:(NSString*)string
{
    self.timeTF.text = string;
}



@end
