//
//  PickerViewController.m
//  EnochCar
//
//  Created by 王海燕 on 2021/9/8.
//

#import "PickerViewController.h"

@interface PickerViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property(nonatomic,strong)UILabel * titlelab;
@property(nonatomic,strong)UIView * bgView;
@property(nonatomic,strong)UIView * contentView;
@property(nonatomic,strong)UIButton * cancelBtn;
@property(nonatomic,strong)UIButton * sureBtn;
@property(nonatomic,strong)NSString * dataString;
@end

@implementation PickerViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    self.bgView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.bgView.backgroundColor = [UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:0.5];
    [self.view addSubview:self.bgView];
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-300, self.view.frame.size.width, 300)];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 12;
    [self.view addSubview:self.contentView];
    
    self.titlelab = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 150)/2, 17, 150, 20)];
    self.titlelab.textColor = [UIColor lightTextColor];
    self.titlelab.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    self.titlelab.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.titlelab];
    
    self.cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 17, 40, 22)];
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightRegular]];
    [self.cancelBtn setTitleColor:[UIColor colorWithRed:250/255.0 green:199/255.0 blue:72/255.0 alpha:1] forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.cancelBtn];
    
    self.sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 20 - 40, 17, 40, 22)];
    [self.sureBtn setTitle:@"完成" forState:UIControlStateNormal];
    [self.sureBtn.titleLabel setFont:[UIFont systemFontOfSize:16 weight:UIFontWeightRegular]];
    [self.sureBtn setTitleColor:[UIColor colorWithRed:250/255.0 green:199/255.0 blue:72/255.0 alpha:1] forState:UIControlStateNormal];
    [self.sureBtn addTarget:self action:@selector(sureBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.sureBtn];
    
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, self.contentView.frame.size.width, self.contentView.frame.size.height - 40)];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    [self.contentView addSubview:self.pickerView];
    
    [self.pickerView reloadAllComponents];
    
    self.backgroundView = self.bgView;
    self.moveView = self.contentView;
    self.gestureView = self.bgView;
 
//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taponbg:)];
//    [self.bgView addGestureRecognizer:tap];
}

-(void)setTitle:(NSString *)title
{
    self.titlelab.text = title;
}

-(void)setPickViewDatasource:(id<UIPickerViewDataSource>)pickViewDatasource
{
    self.pickerView.dataSource = self;
}

-(void)setPickViewDelegate:(id<UIPickerViewDelegate>)pickViewDelegate
{
    self.pickerView.delegate = self;
}

//-(void)taponbg:(UIGestureRecognizer*)gesture
//{
//    [self dismiss];
//}

-(void)cancelBtnClicked
{
    [self dismiss];
}

-(void)sureBtnClicked
{
    if ([self.delegate respondsToSelector:@selector(pickerViewController:selectData:)]) {
        [self.delegate pickerViewController:self selectData:[self getDataString]];
    }
    if ([self.delegate respondsToSelector:@selector(pickerViewController:selectItems:)]) {
        [self.delegate pickerViewController:self selectItems:[self getSelectedItems]];
    }
    
    [self dismiss];
}

-(NSString*)getDataString
{
    return @"";
}
-(NSDictionary*)getSelectedItems
{
    return @{};
}

@end
