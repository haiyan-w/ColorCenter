//
//  NSNumber+Common.h
//  EnochCar
//
//  Created by 王海燕 on 2021/7/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSNumber (Common)
- (NSString *)DoubleStringValueWithDigits:(NSUInteger)digits;

+ (NSNumber *)numberWithDouble:(double)number digits:(NSUInteger)digits;

+ (NSNumber *)numberWithFloat:(float)number digits:(NSUInteger)digits;
@end

NS_ASSUME_NONNULL_END
