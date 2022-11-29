//
//  BaseModel.m
//  EnochCar
//
//  Created by 王海燕 on 2021/12/1.
//

#import "BaseModel.h"
#import <objc/runtime.h>


@implementation LocalDateTime


@end


//@interface BaseModel ()<BaseModelDelegate>
//@property(nonatomic,readwrite,copy) NSDictionary * rawDic;
@interface BaseModel ()
@end

@implementation BaseModel


-(instancetype)initWithDictionary:(nullable NSDictionary *)dictionary
{
    if (!dictionary) {
        return nil;
    }
    
    self = [[self class] modelWithDict2:dictionary];
    if (self) {

    }
    
    return self;
}


-(NSDictionary*)convertToDictionary
{
    return [self dicFromObject:self];
}



+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"description":@"descriptionStr", @"newSurface" : @"pnewSurface"};
}




//+ (NSDictionary *)dictionaryWithModel:(id)model
//{
//    if (nil == model) {
//        return nil;
//    }
//
//    NSMutableDictionary  * dic = [NSMutableDictionary dictionary];
//    NSString * className = NSStringFromClass([model class]);
//    id classObj = objc_getClass([className UTF8String]);
//    unsigned int count = 0;
//    objc_property_t * properties = class_copyPropertyList(classObj, &count);
//
//    for (int i = 0; i<count; i++) {
//        objc_property_t property = properties[i];
//
//        NSString * propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
//
//        id propertyValue = nil;
//        id valueObj = [model valueForKey:propertyName];
//        if ([valueObj isKindOfClass:[NSDictionary class]]) {
//            propertyValue = [NSDictionary dictionaryWithDictionary:valueObj];
//        }
//    }
//}


//model转化为字典
- (NSDictionary *)dicFromObject:(NSObject *)object {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList([object class], &count);
    
    for (int i = 0; i < count; i++) {
        objc_property_t property = propertyList[i];
        const char *cName = property_getName(property);
        NSString *name = [NSString stringWithUTF8String:cName];
        NSObject *value = [object valueForKey:name];//valueForKey返回的数字和字符串都是对象
        
        if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
            //string , bool, int ,NSinteger
            if ([name localizedCaseInsensitiveContainsString:@"Datetime"]) {
                NSString * datetime = (NSString *)value;
                [dic setObject:[datetime stringByReplacingOccurrencesOfString:@" " withString:@"T"] forKey:name];
            }else {
                [dic setObject:value forKey:name];
            }
            
        } else if ([value isKindOfClass:[NSArray class]]) {
            //数组或字典
            [dic setObject:[self arrayWithObject:value] forKey:name];
        } else if ([value isKindOfClass:[NSDictionary class]]) {
            //数组或字典
            [dic setObject:[self dicWithObject:value] forKey:name];
        } else if (value == nil) {
            //null
            //[dic setObject:[NSNull null] forKey:name];//这行可以注释掉?????
        }else {
            //model
            [dic setObject:[self dicFromObject:value] forKey:name];
        }
    }
    
    return [dic copy];
}

- (NSArray *)arrayWithObject:(id)object {
    //数组
    NSMutableArray *array = [NSMutableArray array];
    NSArray *originArr = (NSArray *)object;
    if ([originArr isKindOfClass:[NSArray class]]) {
        for (NSObject *object in originArr) {
            if ([object isKindOfClass:[NSString class]]||[object isKindOfClass:[NSNumber class]]) {
                //string , bool, int ,NSinteger
                [array addObject:object];
            } else if ([object isKindOfClass:[NSArray class]]) {
                //数组或字典
                [array addObject:[self arrayWithObject:object]];
            } else if ([object isKindOfClass:[NSDictionary class]]) {
                //数组或字典
                [array addObject:[self dicWithObject:object]];
            } else {
                //model
                [array addObject:[self dicFromObject:object]];
            }
        }
        return [array copy];
    }
    return array.copy;
}

- (NSDictionary *)dicWithObject:(id)object {
    //字典
    NSDictionary *originDic = (NSDictionary *)object;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if ([object isKindOfClass:[NSDictionary class]]) {
        for (NSString *key in originDic.allKeys) {
            id object = [originDic objectForKey:key];
            if ([object isKindOfClass:[NSString class]]||[object isKindOfClass:[NSNumber class]]) {
                //string , bool, int ,NSinteger
                [dic setObject:object forKey:key];
            } else if ([object isKindOfClass:[NSArray class]]) {
                //数组或字典
                [dic setObject:[self arrayWithObject:object] forKey:key];
            } else if ([object isKindOfClass:[NSDictionary class]]) {
                //数组或字典
                [dic setObject:[self dicWithObject:object] forKey:key];
            } else {
                //model
                [dic setObject:[self dicFromObject:object] forKey:key];
            }
        }
        return [dic copy];
    }
    return dic.copy;
}


@end
