//
//  TimePickerView.m
//  EnochCar
//
//  Created by 王海燕 on 2021/8/30.
//

#import "TimePickerView.h"
#import "UIColor+CustomColor.h"


@interface TimePickerViewController()<UIPickerViewDataSource,UIPickerViewDelegate>
@property(nonatomic,strong)UIView * bgView;
@property(nonatomic,strong)UIView * contentView;
@property(nonatomic,strong)NSString * titleStr;
@property(nonatomic,strong)UIButton * cancelBtn;
@property(nonatomic,strong)UIButton * sureBtn;
@property(nonatomic,strong)NSCalendar * calendar;
@property(nonatomic,strong)NSDateComponents * component;
@property(nonatomic,strong)NSArray * years;
@property(nonatomic,strong)NSArray * months;
@property(nonatomic,strong)NSArray * days;
@property(nonatomic,strong)NSArray * hours;
@property(nonatomic,strong)NSArray * minites;
@property(nonatomic,assign)BOOL untilCurDate;
@end

@implementation TimePickerViewController

-(instancetype)initWithTimeType:(TimeType)type title:(NSString*)title years:(nullable NSArray *)years untilCurDate:(BOOL)untilCurDate
{
    self = [super init];
    if (self) {
        self.type = type;
        self.titleStr = title;
        self.years = years;
        self.untilCurDate = untilCurDate;
    }
    return self;
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:(self.titleStr)?(self.titleStr):(@"日期")];
    [self initDataSource];
    [self.pickerView reloadAllComponents];

    [self setupData];
}

-(NSString*)getDataString
{
    NSString * resultString = @"";
    switch (self.type) {
        case YY:
        {
            NSNumber * year = [self.years objectAtIndex:[self.pickerView selectedRowInComponent:0]];
            resultString = [NSString stringWithFormat:@"%@",year];
        }
            break;
        case YY_MM:
        {
            NSNumber * year = [self.years objectAtIndex:[self.pickerView selectedRowInComponent:0]];
            NSNumber * month = [self.months objectAtIndex:[self.pickerView selectedRowInComponent:1]];
            resultString = [NSString stringWithFormat:@"%@-%02d",year,month.intValue];
        }
            break;
        case YY_MM_DD:
        {
            NSNumber * year = [self.years objectAtIndex:[self.pickerView selectedRowInComponent:0]];
            NSNumber * month = [self.months objectAtIndex:[self.pickerView selectedRowInComponent:1]];
            NSNumber * day = [self.days objectAtIndex:[self.pickerView selectedRowInComponent:2]];
            resultString = [NSString stringWithFormat:@"%@-%02d-%02d",year,month.intValue,day.intValue];
        }
            break;
        case YY_MM_DD_HH_mm:
        {
            NSNumber * year = [self.years objectAtIndex:[self.pickerView selectedRowInComponent:0]];
            NSNumber * month = [self.months objectAtIndex:[self.pickerView selectedRowInComponent:1]];
            NSNumber * day = [self.days objectAtIndex:[self.pickerView selectedRowInComponent:2]];
            NSNumber * hour = [self.hours objectAtIndex:[self.pickerView selectedRowInComponent:3]];
            NSNumber * minite = [self.minites objectAtIndex:[self.pickerView selectedRowInComponent:4]];
            resultString = [NSString stringWithFormat:@"%@-%02d-%02d %02d:%02d:00",year,month.intValue,day.intValue ,hour.intValue,minite.intValue];
        }
            break;
            
        default:
            break;
    }
    
    return resultString;
}

-(void)initDataSource
{
    self.component = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate:[NSDate date]];
    
    if (!self.years) {
    
        int min = -30;
        int max = 30;
        
        NSMutableArray * years = [NSMutableArray array];
        
        if (self.untilCurDate)
        {
            for (int i = min; i <= 0; i++) {
                [years addObject:[NSNumber numberWithInteger:self.component.year+i]];
            }
            
        }else {
            for (int i = min; i < max; i++) {
                [years addObject:[NSNumber numberWithInteger:self.component.year+i]];
            }
        }
        
        self.years = years;
    }

    NSMutableArray * montharray = [NSMutableArray array];
    for (int i = 1; i <= 12; i++) {
        [montharray addObject:[NSNumber numberWithInteger:i]];
    }
    self.months = [NSArray arrayWithArray:montharray];
    
    NSMutableArray * dayarray = [NSMutableArray array];
    for (int i = 1; i <= 31; i++) {
        [dayarray addObject:[NSNumber numberWithInteger:i]];
    }
    self.days = [NSArray arrayWithArray:dayarray];
    
    NSMutableArray * hourarray = [NSMutableArray array];
    for (int i = 0; i <= 23; i++) {
        [hourarray addObject:[NSNumber numberWithInteger:i]];
    }
    self.hours = [NSArray arrayWithArray:hourarray];
    
    NSMutableArray * minitearray = [NSMutableArray array];
    for (int i = 0; i <= 59; i++) {
        [minitearray addObject:[NSNumber numberWithInteger:i]];
    }
    self.minites = [NSArray arrayWithArray:minitearray];
}

// 默认设置当前时间
-(void)setupData
{
    switch (self.type) {
        case YY:
        {
            for (int i = 0; i < self.years.count; i++) {
                if (self.component.year == [[self.years objectAtIndex:i] integerValue]) {
                    [self.pickerView selectRow:i inComponent:0 animated:NO];
                    [self pickerView:self.pickerView didSelectRow:i inComponent:0];
                }
            }
        }
            break;
        case YY_MM:
        {
            for (int i = 0; i < self.years.count; i++) {
                if (self.component.year == [[self.years objectAtIndex:i] integerValue]) {
                    [self.pickerView selectRow:i inComponent:0 animated:NO];
                    [self pickerView:self.pickerView didSelectRow:i inComponent:0];
                }
            }

            
            for (int i = 0; i < self.months.count; i++) {
                if (self.component.month == [[self.months objectAtIndex:i] integerValue]) {
                    [self.pickerView selectRow:i inComponent:1 animated:NO];
                    [self pickerView:self.pickerView didSelectRow:i inComponent:1];
                }
            }
        }
            break;
        case YY_MM_DD:
        {
            for (int i = 0; i < self.years.count; i++) {
                if (self.component.year == [[self.years objectAtIndex:i] integerValue]) {
                    [self.pickerView selectRow:i inComponent:0 animated:NO];
                    [self pickerView:self.pickerView didSelectRow:i inComponent:0];
                }
            }

            
            for (int i = 0; i < self.months.count; i++) {
                if (self.component.month == [[self.months objectAtIndex:i] integerValue]) {
                    [self.pickerView selectRow:i inComponent:1 animated:NO];
                    [self pickerView:self.pickerView didSelectRow:i inComponent:1];
                }
            }
            [self.pickerView reloadComponent:2];
            
            for (int i = 0; i < self.days.count; i++) {
                if (self.component.day == [[self.days objectAtIndex:i] integerValue]) {
                    [self.pickerView selectRow:i inComponent:2 animated:NO];
                    [self pickerView:self.pickerView didSelectRow:i inComponent:2];
                }
            }
        }
            break;
        case YY_MM_DD_HH_mm:
        {
            for (int i = 0; i < self.years.count; i++) {
                if (self.component.year == [[self.years objectAtIndex:i] integerValue]) {
                    [self.pickerView selectRow:i inComponent:0 animated:NO];
                    [self pickerView:self.pickerView didSelectRow:i inComponent:0];
                }
            }

            
            for (int i = 0; i < self.months.count; i++) {
                if (self.component.month == [[self.months objectAtIndex:i] integerValue]) {
                    [self.pickerView selectRow:i inComponent:1 animated:NO];
                    [self pickerView:self.pickerView didSelectRow:i inComponent:1];
                }
            }
            [self.pickerView reloadComponent:2];
            
            for (int i = 0; i < self.days.count; i++) {
                if (self.component.day == [[self.days objectAtIndex:i] integerValue]) {
                    [self.pickerView selectRow:i inComponent:2 animated:NO];
                    [self pickerView:self.pickerView didSelectRow:i inComponent:2];
                }
            }
            
            for (int i = 0; i < self.hours.count; i++) {
                if (self.component.hour == [[self.hours objectAtIndex:i] integerValue]) {
                    [self.pickerView selectRow:i inComponent:3 animated:NO];
                    [self pickerView:self.pickerView didSelectRow:i inComponent:3];
                }
            }
            
            for (int i = 0; i < self.minites.count; i++) {
                if (self.component.minute == [[self.minites objectAtIndex:i] integerValue]) {
                    [self.pickerView selectRow:i inComponent:4 animated:NO];
                    [self pickerView:self.pickerView didSelectRow:i inComponent:4];
                }
            }
        }
            break;
            
        default:
            break;
    }
    
}

#pragma pickview
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    NSInteger num = 1;
    switch (self.type) {
        case YY:
        {
            num = 1;
        }
            break;
        case YY_MM:
        {
            num = 2;
        }
            break;
        case YY_MM_DD:
        {
            num = 3;
        }
            break;
        case YY_MM_DD_HH_mm:
        {
            num = 5;
        }
            break;
            
        default:
            break;
    }
    
    return num;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger num = 0;
    switch (component) {
        case 0:
            num = self.years.count;
            break;
        case 1:
            num = self.months.count;
            break;
        case 2:
            num = self.days.count;
            break;
        case 3:
            num = self.hours.count;
            break;
        case 4:
            num = self.minites.count;
            break;
            
        default:
            break;
    }
    return num;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component API_UNAVAILABLE(tvos)
{
    NSInteger num = 1;
    switch (self.type) {
        case YY:
        {
            num = 1;
        }
            break;
        case YY_MM:
        {
            num = 2;
        }
            break;
        case YY_MM_DD:
        {
            num = 3;
        }
            break;
        case YY_MM_DD_HH_mm:
        {
            num = 5;
        }
            break;
            
        default:
            break;
    }
    
    return (self.pickerView.frame.size.width-10)/num;
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
            title = [NSString stringWithFormat:@"%@年",[self.years objectAtIndex:row]];
            break;
        case 1:
            title = [NSString stringWithFormat:@"%@月",[self.months objectAtIndex:row]];
            break;
        case 2:
            title = [NSString stringWithFormat:@"%@日",[self.days objectAtIndex:row]];
            break;
        case 3:
            title = [NSString stringWithFormat:@"%@时",[self.hours objectAtIndex:row]];
            break;
        case 4:
            title = [NSString stringWithFormat:@"%@分",[self.minites objectAtIndex:row]];
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
            title = [NSString stringWithFormat:@"%@",[self.years objectAtIndex:row]];
            break;
        case 1:
            title = [NSString stringWithFormat:@"%@月",[self.months objectAtIndex:row]];
            break;
        case 2:
            title = [NSString stringWithFormat:@"%@日",[self.days objectAtIndex:row]];
            break;
        case 3:
            title = [NSString stringWithFormat:@"%@时",[self.hours objectAtIndex:row]];
            break;
        case 4:
            title = [NSString stringWithFormat:@"%@分",[self.minites objectAtIndex:row]];
            break;
            
        default:
            break;
    }
    
    NSMutableParagraphStyle * paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setAlignment:NSTextAlignmentCenter];
    
    NSMutableAttributedString * attrTitle = [[NSMutableAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16 weight:UIFontWeightRegular],NSForegroundColorAttributeName:[UIColor textColor],NSParagraphStyleAttributeName:paragraph}];
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
            NSNumber * year = [self.years objectAtIndex:[self.pickerView selectedRowInComponent:0]];
            NSInteger months = [self monthsWithYear:year.integerValue untilCurDate:self.untilCurDate];
            NSMutableArray * montharray = [NSMutableArray array];
            for (int i = 1; i <= months; i++) {
                [montharray addObject:[NSNumber numberWithInteger:i]];
            }
            if (self.type > 1) {
                self.months = [NSArray arrayWithArray:montharray];
                [pickerView selectRow:0 inComponent:1 animated:YES];
                [pickerView reloadAllComponents];
            }
            
        }
            break;
        case 1:
        {
            NSNumber * year = [self.years objectAtIndex:[self.pickerView selectedRowInComponent:0]];
            NSNumber * month = [self.months objectAtIndex:[self.pickerView selectedRowInComponent:1]];
            
            if (self.type > 2) {
                NSInteger days = [self daysWithYear:year.integerValue month:month.integerValue untilCurDate:self.untilCurDate];
                NSMutableArray * dayarray = [NSMutableArray array];
                for (int i = 1; i <= days; i++) {
                    [dayarray addObject:[NSNumber numberWithInteger:i]];
                }
                self.days = [NSArray arrayWithArray:dayarray];
                [pickerView selectRow:0 inComponent:2 animated:YES];
                [pickerView reloadAllComponents];
            }
            
        }
            break;
            
        default:
            break;
    }
}


-(NSInteger)monthsWithYear:(NSInteger)year untilCurDate:(BOOL)untilCurDate
{
    // 字符串转日期

    NSString *dateStr = [NSString stringWithFormat:@"%ld-01-05 00:00:00",year];

    NSDateFormatter *format = [[NSDateFormatter alloc] init];

    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";

    NSDate *date = [format dateFromString:dateStr];

    // 当前日历

    NSCalendar *calendar = [NSCalendar currentCalendar];

    NSRange range = [calendar rangeOfUnit:NSCalendarUnitMonth inUnit:NSCalendarUnitYear forDate:date];
    NSUInteger length = range.length;
    if (untilCurDate) {
        NSDate * curDate = [NSDate date] ;
        NSInteger curYear = [calendar component:NSCalendarUnitYear fromDate:curDate];
        if (curYear == year) {
            NSInteger month = [calendar component:NSCalendarUnitMonth fromDate:curDate];
            length = month;
        }
    }

    return length;
}

-(NSInteger)daysWithYear:(NSInteger) year month:(NSInteger)month untilCurDate:(BOOL)untilCurDate{

    // 字符串转日期

    NSString *dateStr = [NSString stringWithFormat:@"%ld-%ld-05 00:00:00",year,month];

    NSDateFormatter *format = [[NSDateFormatter alloc] init];

    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";

    NSDate *date = [format dateFromString:dateStr];

    // 当前日历

    NSCalendar *calendar = [NSCalendar currentCalendar];

    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];

    NSUInteger length = range.length;
    if (untilCurDate) {
        NSDate * curDate = [NSDate date] ;
        NSInteger curYear = [calendar component:NSCalendarUnitYear fromDate:curDate];
        NSInteger curMonth = [calendar component:NSCalendarUnitMonth fromDate:curDate];
        if ((curYear == year) && (curMonth == month)){
            NSInteger day = [calendar component:NSCalendarUnitDay fromDate:curDate];
            length = day;
        }
    }

    return length;

}


@end
