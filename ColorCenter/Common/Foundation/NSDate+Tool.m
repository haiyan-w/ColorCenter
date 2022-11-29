//
//  NSDate+Tool.m
//  EnochCar
//
//  Created by 王海燕 on 2022/3/22.
//

#import "NSDate+Tool.h"

@implementation NSDate (Tool)

+ (NSString *)nowDateStr
{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zn_Hans_CN"];
    dateFormatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierISO8601];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:+28800]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString * dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}

+ (NSString *)nowDateTimeStr
{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zn_Hans_CN"];
    dateFormatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierISO8601];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:+28800]];//北京时间
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString * dateTimeString = [dateFormatter stringFromDate:currentDate];
    return dateTimeString;
}

+ (NSString*)stringFromDateTime:(NSDate*)dateTimeStr
{
   //用于格式化NSDate对象
   NSDateFormatter*dateFormatter=[[NSDateFormatter alloc]init];
   //设置格式
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zn_Hans_CN"];
    dateFormatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierISO8601];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:+28800]];//北京时间
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
   //NSDate转NSString
   NSString *currentDateString=[dateFormatter stringFromDate:dateTimeStr];
   return currentDateString;
}

+ (NSString*)stringFromDate:(NSDate*)date
{
   //用于格式化NSDate对象
   NSDateFormatter*dateFormatter=[[NSDateFormatter alloc]init];
   //设置格式
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zn_Hans_CN"];
    dateFormatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierISO8601];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:+28800]];//北京时间
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
   //NSDate转NSString
   NSString *currentDateString=[dateFormatter stringFromDate:date];

   return currentDateString;
}

//NSString转NSDate
+ (NSDate*)dateFromString:(NSString*)dateString
{
    NSString * dateStr = dateString;
    dateStr = [dateStr stringByAppendingString:@""];
    //设置转换格式
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
//    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zn_Hans_CN"];
    formatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierISO8601];
//    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:+28800]];//北京时间
    [formatter setDateFormat:@"yyyy-MM-dd"];
    //NSString转NSDate
    NSDate *date=[formatter dateFromString:dateStr];
    return date;
}

//NSString转NSDate
+ (NSDate*)dateTimeFromString:(NSString*)string
{
    //设置转换格式
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
//    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zn_Hans_CN"];
    formatter.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierISO8601];
//    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:+28800]];//北京时间
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSString转NSDate
    NSDate *date=[formatter dateFromString:string];
    return date;
}

//// 将时间戳转换成字符串
//+(NSString *)converTime:(NSString *)time
//{
//    NSDate *frTime = [[NSDate alloc]initWithTimeIntervalSince1970:[time doubleValue]/1000.0];
//    NSString *dateTime = [self getDateStringWithDate:frTime DateFormat:@"yyyy-MM-dd HH:mm:ss"];
//   NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//   [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//   NSString *dateString = [dateFormat stringFromDate:frTime];
//
//    return dateString;
//}


+ (NSComparisonResult)compare:(NSString *)dateStr to:(NSString *)otherDateStr
{
    NSDate * date = [NSDate dateTimeFromString:dateStr];
    NSDate * otherDate = [NSDate dateTimeFromString:otherDateStr];
    return [date compare:otherDate];
}

+ (NSString*)getPriousorLaterDateFromDate:(NSDate*)date withMonth:(NSInteger)month
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];

    [comps setMonth:month];

    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierISO8601];

    NSDate * mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString * ymdString = [dateFormatter stringFromDate:mDate];

    return ymdString;

}

@end
