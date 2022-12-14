//
//  NSObject+DictionaryToModel.m
//  EnochCar
//
//  Created by 王海燕 on 2022/9/5.
//

#import "NSObject+DictionaryToModel.h"
#import <objc/message.h>

@implementation NSObject (DictionaryToModel)


/*
 *  根据模型中属性，去字典中取出对应的value并赋值给模型的属性
 *  遍历取出所有属性
 */
+ (instancetype)modelWithDict:(NSDictionary *)dict {
    //1. 创建对应的对象
    id objc = [[self alloc] init];
    
    //2. 利用runtime给对象中的属性赋值
    /*
     Ivar: 成员变量；
     class_copyIvarList(): 获取类中的所有成员变量；
     第一个参数：表示获取哪个类的成员变量；
     第二个参数：表示这个类有多少成员变量；
     返回值Ivar *：指的是一个ivar数组，会把所有成员变量放在一个数组中，通过返回数组就全部获取到。
     */
    unsigned int count = 0;
    Ivar *ivarList = class_copyIvarList(self, &count);
    
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivarList[i];
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        NSString *key = [ivarName substringFromIndex:1];
        id value = dict[key];
        
        if (!value) {
            NSDictionary *customKeyDict = [self modelCustomPropertyMapper];
            NSString *customKey = customKeyDict[key];
            value = dict[customKey];
        }
        
        if (value) {
            [objc setValue:value forKey:key];
        }
    }
    
    return objc;
}

+ (instancetype)modelWithDict2:(NSDictionary *)dict {
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    id objc = [[self alloc] init];
    
    unsigned int count = 0;
    Ivar *ivarList = class_copyIvarList(self, &count);
    
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivarList[i];
        
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        NSString *ivarType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        
        ivarType = [ivarType stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        ivarType = [ivarType stringByReplacingOccurrencesOfString:@"@" withString:@""];
        
        NSString *key = [ivarName substringFromIndex:1];
        
        id value = dict[key];
        if (!value) {
            NSDictionary *customKeyDict = [self modelCustomPropertyMapper];
            NSString *customKey = customKeyDict[key];
            value = dict[customKey];
        }
        
        if ([value isKindOfClass:[NSDictionary class]] && ![ivarType hasPrefix:@"NS"]) {
            Class modelClass = NSClassFromString(ivarType);
            
            if (modelClass) {
                value = [modelClass modelWithDict2:value];
            }
        }
        
        if ([value isKindOfClass:[NSArray class]]) {
            if ([self respondsToSelector:@selector(arrayContainModelClass)]) {
                // 转换成id类型，就能调用任何对象的方法
                id idSelf = self;
                // 获取数组中字典对应的模型
                NSString *type =  [idSelf arrayContainModelClass][key];
                if (type) {
                    // 生成模型
                    Class classModel = NSClassFromString(type);
                    NSMutableArray *arrM = [NSMutableArray array];
                    // 遍历字典数组，生成模型数组
                    for (NSDictionary *dict in value) {
                        // 字典转模型
                        id model =  [classModel modelWithDict2:dict];
                        if (model) {
                            [arrM addObject:model];
                        } else {
                            //如果数组中的某个元素并不是个字典，则不做解析
                            [arrM addObject:dict];
                        }
                    }
                    // 把模型数组赋值给value
                    value = arrM;
                }
            }
        }
        
        if ([value isKindOfClass:[NSString class]] &&[ivarType hasPrefix:@"LocalDateTime"]) {
            value = [value stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        }
        
        if (value) {
            [objc setValue:value forKey:key];
        }
    }
    
    return objc;
}


/**
 获取指定类的变量
 
 @param cls 被获取变量的类
 @return 变量名称集合 [NSString *]
 */
NSArray * getClassIvar(Class cls) {
    
    if (!cls) return @[];
    
    NSMutableArray * all_p = [NSMutableArray array];
    
    unsigned int a;
    
    Ivar * iv = class_copyIvarList(cls, &a);
    
    for (unsigned int i = 0; i < a; i++) {
        Ivar i_v = iv[i];
        [all_p addObject:[NSString stringWithFormat:@"%s", ivar_getName(i_v)]];
    }
    
    free(iv);
    
    return [all_p copy];
}



/**
 获取指定类（以及其父类）的所有变量
 
 @param cls 被获取变量的类
 @param until_class 当查找到此类时会停止查找，当设置为 nil 时，默认采用 [NSObject class]
 @return 变量名称集合 [NSString *]
 */
NSArray * getAllIvar(Class cls, Class until_class) {
    
    Class stop_class = until_class ?: [NSObject class];
    
    if (class_getSuperclass(cls) == stop_class) return @[];
    
    NSMutableArray * all_p = [NSMutableArray array];
    
    [all_p addObjectsFromArray:getClassIvar(cls)];
    
    if (class_getSuperclass(cls) == stop_class) {
        return [all_p copy];
    } else {
        [all_p addObjectsFromArray:getAllIvar([cls superclass], stop_class)];
    }
    
    return [all_p copy];
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{};
}

+ (NSDictionary *)arrayContainModelClass {
    return @{};
}


@end
