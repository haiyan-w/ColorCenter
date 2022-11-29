//
//  NSObject+SelectorBlock.h
//  EnochCar
//
//  Created by 王海燕 on 2021/11/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (SelectorBlock)

- (SEL)selectorBlock:(void (^)(id))block;

static void selectorImp(id self, SEL _cmd, id arg);

@end

NS_ASSUME_NONNULL_END
