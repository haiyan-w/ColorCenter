//
//  ColorSpace.h
//  BlueToothTest
//
//  Created by 王海燕 on 2022/10/25.
//

#import <Foundation/Foundation.h>
#import "Xyz2LabIlluminant.h"

NS_ASSUME_NONNULL_BEGIN

@class Labch;

@interface Xyz : NSObject
@property(assign, nonatomic) double x;
@property(assign, nonatomic) double y;
@property(assign, nonatomic) double z;

- (Labch *)toLabch:(Xyz2LabIlluminant *)xyz2LabIlluminant;
@end

@interface Rgb : NSObject
@property(assign, nonatomic) int r;
@property(assign, nonatomic) int g;
@property(assign, nonatomic) int b;
@end

@interface Labch : NSObject
@property(assign, nonatomic) double l;
@property(assign, nonatomic) double a;
@property(assign, nonatomic) double b;
@property(assign, nonatomic) double c;
@property(assign, nonatomic) double h;

- (Rgb *)toRgb;
@end



@interface ColorSpace : NSObject
@property(strong, nonatomic) Xyz * xyz;
@property(strong, nonatomic) Labch * labch;
@property(strong, nonatomic) Rgb * rgb;
@end

NS_ASSUME_NONNULL_END
