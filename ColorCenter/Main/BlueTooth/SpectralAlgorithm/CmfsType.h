//
//  CmfsType.h
//  BlueToothTest
//
//  Created by 王海燕 on 2022/10/21.
//

#import <Foundation/Foundation.h>
#import "AbstractShape.h"

NS_ASSUME_NONNULL_BEGIN

@interface CmfsType : AbstractShape


- (instancetype)initCIE10D;

- (NSArray *)getValue:(int)pos;

@end

NS_ASSUME_NONNULL_END
