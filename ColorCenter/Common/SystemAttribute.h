//
//  SystemAttribute.h
//  EnochCar
//
//  Created by 王海燕 on 2021/12/30.
//

#import <Foundation/Foundation.h>
#import "CommonType.h"

NS_ASSUME_NONNULL_BEGIN

@class Attribute;

@interface SystemAttribute : NSObject
@property(nonatomic,strong) Attribute * id;
@property(nonatomic,copy)  NSString * value;
-(instancetype)initWithDictionary:(nullable NSDictionary *)dictionary;
-(NSDictionary*)convertToDictionary;
@end


@interface Attribute : NSObject
@property(nonatomic,copy)  NSString * valueType;
@property(nonatomic,copy)  NSString * code;
@property(nonatomic,strong)  CommonType * keyType;
@property(nonatomic,copy)  NSString * message;
@property(nonatomic,copy)  NSString * type;
@property(nonatomic,copy)  NSString * description;
@property(nonatomic,copy)  NSString * onAttributeKey;
@property(nonatomic,copy)  NSArray * onAttributeValues;
-(instancetype)initWithDictionary:(nullable NSDictionary *)dictionary;
-(NSDictionary*)convertToDictionary;
@end

NS_ASSUME_NONNULL_END
