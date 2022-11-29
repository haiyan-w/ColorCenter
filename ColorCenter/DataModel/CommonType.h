//
//  CommonType.h
//  EnochCar
//
//  Created by 王海燕 on 2021/12/1.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommonType : BaseModel
@property(nonatomic,readwrite,copy) NSString * code;
@property(nonatomic,readwrite,copy) NSString * descriptionStr;
@property(nonatomic,readwrite,copy) NSString * message;
@property(nonatomic,readwrite,copy) NSString * type;

//-(instancetype)initWithDictionary:(nullable NSDictionary *)dictionary;
//-(NSDictionary*)convertToDictionary;
@end


//@interface FlagType : CommonType
@interface FlagType : BaseModel
@property(nonatomic,readwrite,copy) NSString * code;
@property(nonatomic,readwrite,copy) NSString * descriptionStr;
@property(nonatomic,readwrite,copy) NSString * message;
@property(nonatomic,readwrite,copy) NSString * type;
@property(nonatomic,readwrite,strong) NSNumber * value;

@end


//@interface InflatedFlag : CommonType
@interface InflatedFlag : BaseModel
@property(nonatomic,readwrite,copy) NSString * code;
@property(nonatomic,readwrite,copy) NSString * descriptionStr;
@property(nonatomic,readwrite,copy) NSString * message;
@property(nonatomic,readwrite,copy) NSString * type;
@property(nonatomic,readwrite,strong) NSNumber * inflated;

@end

//@interface ValueType : CommonType
@interface ValueType : BaseModel
@property(nonatomic,readwrite,copy) NSString * code;
@property(nonatomic,readwrite,copy) NSString * descriptionStr;
@property(nonatomic,readwrite,copy) NSString * message;
@property(nonatomic,readwrite,copy) NSString * type;
@property(nonatomic,readwrite,strong) NSString * valueType;
@end



@interface Clerk : BaseModel
@property(nonatomic,readwrite,strong) NSNumber * id;
@property(nonatomic,readwrite,copy) NSString * name;

//-(instancetype)initWithDictionary:(nullable NSDictionary *)dictionary;
//-(NSDictionary*)convertToDictionary;
@end




@interface CustomerCategory : BaseModel
@property(nonatomic,readwrite,strong) NSNumber * id;//long
@property(nonatomic,readwrite,copy) NSString * name;//类别名称

//-(instancetype)initWithDictionary:(nullable NSDictionary *)dictionary;
//-(NSDictionary*)convertToDictionary;
@end



NS_ASSUME_NONNULL_END
