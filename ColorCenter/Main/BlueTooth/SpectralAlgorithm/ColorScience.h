//
//  ColorScience.h
//  BlueToothTest
//
//  Created by 王海燕 on 2022/10/21.
//

#import <Foundation/Foundation.h>
#import "DoubleShape.h"

NS_ASSUME_NONNULL_BEGIN




@interface ColorScience : NSObject

- (instancetype)initWithData:(NSData *)data;

- (DoubleShape *)buildSpectroData:(NSArray *)data start:(int)start interval:(int)interval;

@end

NS_ASSUME_NONNULL_END
