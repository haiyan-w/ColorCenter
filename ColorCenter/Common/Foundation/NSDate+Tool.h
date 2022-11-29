//
//  NSDate+Tool.h
//  EnochCar
//
//  Created by 王海燕 on 2022/3/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (Tool)

//当前日期字符串 eg. 2022-03-18
+ (NSString *)nowDateStr;

//当前日期时间字符串 eg. 2022-03-18 10:30:00
+ (NSString *)nowDateTimeStr;

//NSDate转NSString
+(NSString*)stringFromDate:(NSDate*)date;

//NSString转NSDate
+(NSDate*)dateFromString:(NSString*)string;

//NSString转NSDate
+ (NSDate*)dateTimeFromString:(NSString*)string;

+ (NSComparisonResult)compare:(NSString *)dateStr to:(NSString *)otherDateStr;

+ (NSString*)getPriousorLaterDateFromDate:(NSDate*)date withMonth:(NSInteger)month;
@end

NS_ASSUME_NONNULL_END
