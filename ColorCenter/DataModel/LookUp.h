//
//  LookUp.h
//  EnochCar
//
//  Created by 王海燕 on 2022/4/20.
//

#import "BaseModel.h"
#import "CommonType.h"
#import "LookUp.h"

NS_ASSUME_NONNULL_BEGIN

//@interface LookUp : CommonType
@interface LookUp : BaseModel
@property(nonatomic,readwrite,copy) NSString * code;
@property(nonatomic,readwrite,copy) NSString * descriptionStr;
@property(nonatomic,readwrite,copy) NSString * message;
@property(nonatomic,readwrite,copy) NSString * type;


//tool
- (instancetype)initWithCode:(NSString *)code message:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
