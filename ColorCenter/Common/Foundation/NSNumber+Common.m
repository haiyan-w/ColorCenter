//
//  NSNumber+Common.m
//  EnochCar
//
//  Created by 王海燕 on 2021/7/1.
//

#import "NSNumber+Common.h"

@implementation NSNumber (Common)

- (NSString *)DoubleStringValueWithDigits:(NSUInteger)digits
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.maximumFractionDigits = digits;
    [formatter setGroupingSeparator:@""];
    
    NSString *retString = [formatter stringFromNumber:self];
    return retString;
}


+ (NSNumber *)numberWithDouble:(double)number digits:(NSUInteger)digits
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.maximumFractionDigits = digits;
    [formatter setGroupingSeparator:@""];
    
    NSString *retString = [formatter stringFromNumber:[NSNumber numberWithDouble:number]];
    NSNumber * resultNum = [NSNumber numberWithDouble:retString.doubleValue];
    return resultNum;
}

+ (NSNumber *)numberWithFloat:(float)number digits:(NSUInteger)digits
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.maximumFractionDigits = digits;
    [formatter setGroupingSeparator:@""];
    
    NSString *retString = [formatter stringFromNumber:[NSNumber numberWithFloat:number]];
    NSNumber * resultNum = [NSNumber numberWithFloat:retString.floatValue];
    return resultNum;
}

@end
