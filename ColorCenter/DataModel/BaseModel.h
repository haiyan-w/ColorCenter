//
//  BaseModel.h
//  EnochCar
//
//  Created by 王海燕 on 2021/12/1.
//

#import <Foundation/Foundation.h>
#import "NSObject+DictionaryToModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LocalDateTime : NSString

@end

@protocol BaseModelDelegate <NSObject>

-(instancetype)initWithDictionary:(nullable NSDictionary *)dictionary;
-(NSDictionary*)convertToDictionary;

@end




@interface BaseModel : NSObject

-(instancetype)initWithDictionary:(nullable NSDictionary *)dictionary;
-(NSDictionary*)convertToDictionary;



+ (NSDictionary *)modelCustomPropertyMapper;
@end

NS_ASSUME_NONNULL_END
