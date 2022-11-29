//
//  IlluminantType.h
//  BlueToothTest
//
//  Created by 王海燕 on 2022/10/21.
//

#import <Foundation/Foundation.h>
#import "AbstractShape.h"

NS_ASSUME_NONNULL_BEGIN

@interface IlluminantType : AbstractShape
//@property(assign, nonatomic) int start;
//@property(assign, nonatomic) int interval;
//@property(strong, nonatomic) NSArray * values;

- (instancetype)initD65;

- (NSNumber *)getValue:(int)pos;

@end

NS_ASSUME_NONNULL_END
