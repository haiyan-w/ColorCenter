//
//  AbstractShape.h
//  BlueToothTest
//
//  Created by 王海燕 on 2022/10/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AbstractShape : NSObject
@property(assign, nonatomic) int start;
@property(assign, nonatomic) int interval;
@property(strong, nonatomic) NSArray * values;

- (int)end;
@end

NS_ASSUME_NONNULL_END
