//
//  TimePickerView.h
//  EnochCar
//
//  Created by 王海燕 on 2021/8/30.
//

#import <UIKit/UIKit.h>
#import "PickerViewController.h"

NS_ASSUME_NONNULL_BEGIN


typedef enum {
    YY = 1,
    YY_MM,
    YY_MM_DD,
    YY_MM_DD_HH_mm
}TimeType;


@interface TimePickerViewController : PickerViewController
@property (nonatomic,assign) TimeType type;
//@property (nonatomic,assign) BOOL needTime;  /*NO:显示 年-月-日 YES：显示 年-月-日 时:分*/

-(instancetype)initWithTimeType:(TimeType)type title:(NSString*)title years:(nullable NSArray *)years untilCurDate:(BOOL)untilCurDate;

//-(instancetype)initWithTime:(BOOL)needtime title:(NSString*)title years:(nullable NSArray *)years;
//
///*untilCurDate:截止到当前日期 年-月-日 */
//-(instancetype)initWithTime:(BOOL)needtime title:(NSString*)title years:(nullable NSArray *)years curDate:(BOOL)curDate;
@end

NS_ASSUME_NONNULL_END
