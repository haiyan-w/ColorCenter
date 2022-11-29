//
//  DoubleArrayShape.h
//  BlueToothTest
//
//  Created by 王海燕 on 2022/10/25.
//

#import <Foundation/Foundation.h>
#import "IlluminantType.h"
#import "CmfsType.h"
#import "LagrangeCoefficientsType.h"
#import "AbstractShape.h"

NS_ASSUME_NONNULL_BEGIN

@interface DoubleArrayShape : AbstractShape
//@property(assign, nonatomic) int start;
//@property(assign, nonatomic) int interval;
//@property(assign, nonatomic) NSArray * values;

- (instancetype)initWith:(IlluminantType *)illuminantType cmfsType:(CmfsType *)cmfsType;

- (NSArray *)getValue:(int)pos;
@end

NS_ASSUME_NONNULL_END
