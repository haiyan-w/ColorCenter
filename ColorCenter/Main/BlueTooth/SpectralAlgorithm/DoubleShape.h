//
//  DoubleShape.h
//  BlueToothTest
//
//  Created by 王海燕 on 2022/10/21.
//

#import <Foundation/Foundation.h>
#import "IlluminantType.h"
#import "CmfsType.h"
#import "ColorSpace.h"
#import "AbstractShape.h"
#import "DoubleShape.h"

NS_ASSUME_NONNULL_BEGIN

@interface DoubleShape : AbstractShape
//@property(assign, nonatomic) int start;
//@property(assign, nonatomic) int interval;
//@property(assign, nonatomic) NSArray * values;


- (ColorSpace *)toColorSpace;


- (Xyz *)toXyz:(IlluminantType *)illuminantType cmfsType:(CmfsType *)cmfsType;

- (NSNumber *)getValue:(int)pos;

@end

NS_ASSUME_NONNULL_END
