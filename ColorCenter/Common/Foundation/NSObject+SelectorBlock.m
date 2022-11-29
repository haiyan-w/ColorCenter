//
//  NSObject+SelectorBlock.m
//  EnochCar
//
//  Created by 王海燕 on 2021/11/8.
//

#import "NSObject+SelectorBlock.h"
#import <objc/runtime.h>

@implementation NSObject (SelectorBlock)

- (SEL)selectorBlock:(void (^)(id))block {
    NSString *selName = [NSString stringWithFormat:@"selector_%p:", block];
    SEL sel = NSSelectorFromString(selName);
    class_addMethod([self class], sel, (IMP)selectorImp, "v@:@");
    objc_setAssociatedObject(self, sel, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return sel;
}

static void selectorImp(id self, SEL _cmd, id arg) {
    void (^block)(id arg) = objc_getAssociatedObject(self, _cmd);
    if (block) block(arg);
}


@end
