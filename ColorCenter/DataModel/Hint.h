//
//  Hint.h
//  EnochCar
//
//  Created by 王海燕 on 2022/3/23.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"
#import "CommonType.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSString * HintTypeCode NS_STRING_ENUM;
FOUNDATION_EXPORT HintTypeCode const HintTypePaymentMethod;




@interface Hint : BaseModel
@property(nonatomic,readwrite,strong) ValueType * type;
@property(nonatomic,readwrite,copy) NSString * name;
@property(nonatomic,readwrite,copy) NSString * hint;
@end

NS_ASSUME_NONNULL_END
