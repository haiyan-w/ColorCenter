//
//  AreaPicker.m
//  EnochCar
//
//  Created by 王海燕 on 2021/9/8.
//

#import "AreaPicker.h"
#import "PickerViewController.h"
//#import "NetWorkAPIManager.h"
#import "UIColor+CustomColor.h"

@interface AreaPicker ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic,readwrite,strong)NSMutableArray * allAreas;
@property(nonatomic,readwrite,strong)NSArray * provinces;
@property(nonatomic,readwrite,strong)NSArray * cities;
@property(nonatomic,readwrite,strong)NSArray * districts;
@end

@implementation AreaPicker

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initDataSource];
    
    [self setTitle:@"选择地区"];
    self.pickViewDelegate = self;
    self.pickViewDatasource = self;
    
}

-(void)initDataSource
{
    [self queryProvince];
}

-(void)queryProvince
{
//    __weak AreaPicker * weakself = self;
//    [[NetWorkAPIManager defaultManager] queryAreaWithCode:NULL Success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary * dic = responseObject;
//        NSArray * array = [dic objectForKey:@"data"];
//        weakself.provinces = [NSArray arrayWithArray:array];
//        [weakself.pickerView reloadComponent:0];
//        [weakself pickerView:self.pickerView didSelectRow:0 inComponent:0];
//
//    } Failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//    }];
}

-(void)queryCityWithCode:(NSNumber*)code
{
//    __weak AreaPicker * weakself = self;
//    [[NetWorkAPIManager defaultManager] queryAreaWithCode:code Success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//        NSDictionary * dic = responseObject;
//        NSArray * array = [dic objectForKey:@"data"];
//        self.cities = [NSArray arrayWithArray:array];
//        [self.pickerView reloadComponent:1];
//        [weakself pickerView:self.pickerView didSelectRow:0 inComponent:1];
//
//
//    } Failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//    }];
}


-(void)queryDistrictWithCode:(NSNumber*)code
{
//    __weak AreaPicker * weakself = self;
//    [[NetWorkAPIManager defaultManager] queryAreaWithCode:code Success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        NSDictionary * dic = responseObject;
//        NSArray * array = [dic objectForKey:@"data"];
//        self.districts = [NSArray arrayWithArray:array];
//        [self.pickerView reloadComponent:2];
//        [weakself pickerView:self.pickerView didSelectRow:0 inComponent:2];
//        
//    } Failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//    }];
}

-(NSString*)getDataString
{
    NSString * resultStr = @"";
    NSString * district = nil;
    NSString * province = [[self.provinces objectAtIndex:[self.pickerView selectedRowInComponent:0]] objectForKey:@"name"];
    NSString * city = [[self.cities objectAtIndex:[self.pickerView selectedRowInComponent:1]] objectForKey:@"name"];
    if (self.districts && (self.districts.count > 0)) {
        district = [[self.districts objectAtIndex:[self.pickerView selectedRowInComponent:2]] objectForKey:@"name"];
    }
  
    if (district) {
        resultStr = [NSString stringWithFormat:@"%@/%@/%@", province, city,district];
    }else {
        resultStr = [NSString stringWithFormat:@"%@/%@", province, city];
    }
    
    return resultStr;
}

-(NSDictionary*)getSelectedItems
{
    NSMutableDictionary * district = nil;
    NSMutableDictionary * province = [NSMutableDictionary dictionaryWithDictionary:[self.provinces objectAtIndex:[self.pickerView selectedRowInComponent:0]]];
    NSMutableDictionary * city = [NSMutableDictionary dictionaryWithDictionary:[self.cities objectAtIndex:[self.pickerView selectedRowInComponent:1]]];
    NSDictionary * resultDic = city;
    [city setValue:province forKey:@"parent"];
    
    if (self.districts && (self.districts.count > 0)) {
        district = [NSMutableDictionary dictionaryWithDictionary:[self.districts objectAtIndex:[self.pickerView selectedRowInComponent:2]]];
        if (district) {
            [district setValue:city forKey:@"parent"];
            resultDic = district;
        }
    }
    return resultDic;
}
    
#pragma pickview
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger num = 0;
    switch (component) {
        case 0:
            num = self.provinces.count;
            break;
        case 1:
            num = self.cities.count;
            break;
        case 2:
            num = self.districts.count;
            break;
        default:
            break;
    }
    return num;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component API_UNAVAILABLE(tvos)
{
    return pickerView.frame.size.width/3.0;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component API_UNAVAILABLE(tvos)
{
    return 42;
}
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component API_UNAVAILABLE(tvos)
{
    NSString * title = @"";
    switch (component) {
        case 0:
            title = [[self.provinces objectAtIndex:row] objectForKey:@"name"];
            break;
        case 1:
            title = [[self.cities objectAtIndex:row] objectForKey:@"name"];
            break;
        case 2:
            title = [[self.districts objectAtIndex:row] objectForKey:@"name"];
            break;
        default:
            break;
    }
    return nil;
}

- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component API_AVAILABLE(ios(6.0)) API_UNAVAILABLE(tvos)
{
    NSString * title = @"";
    switch (component) {
        case 0:
            title = [[self.provinces objectAtIndex:row] objectForKey:@"name"];
            break;
        case 1:
            title = [[self.cities objectAtIndex:row] objectForKey:@"name"];
            break;
        case 2:
            title = [[self.districts objectAtIndex:row] objectForKey:@"name"];
            break;
        default:
            break;
    }
    
    NSMutableAttributedString * attrTitle = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16 weight:UIFontWeightRegular],NSForegroundColorAttributeName:[UIColor textColor]}];
    return attrTitle;

}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view API_UNAVAILABLE(tvos)
{
    UILabel *pickerLabel = (UILabel*)view;
        if (!pickerLabel){
            pickerLabel = [[UILabel alloc] init];
        }
    [pickerLabel setTextColor:[UIColor textColor]];
    pickerLabel.adjustsFontSizeToFitWidth = YES;
    [pickerLabel setTextAlignment:NSTextAlignmentCenter];
    [pickerLabel setBackgroundColor:[UIColor clearColor]];
    [pickerLabel setFont:[UIFont systemFontOfSize:16.0f weight:UIFontWeightRegular]];
    pickerLabel.attributedText = [self pickerView:pickerView attributedTitleForRow:row forComponent:component];
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component API_UNAVAILABLE(tvos)
{
    
    switch (component) {
        case 0:
        {
            [self queryCityWithCode:[[self.provinces objectAtIndex:row] objectForKey:@"code"] ];
        }
            break;
        case 1:
        {
            [self queryDistrictWithCode:[[self.cities objectAtIndex:row] objectForKey:@"code"] ];
        }
            break;
            
        default:
            break;
    }
}

@end
