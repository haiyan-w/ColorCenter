//
//  SignatureModel.h
//  EnochCar
//
//  Created by 王海燕 on 2022/7/28.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SignatureModel : BaseModel
@property(nonatomic,readwrite,strong) NSNumber * expire;//long
@property(nonatomic,readwrite,copy) NSString * OSSAccessKeyId;
@property(nonatomic,readwrite,copy) NSString * dir;
@property(nonatomic,readwrite,copy) NSString * policy;
@property(nonatomic,readwrite,copy) NSString * host;
@property(nonatomic,readwrite,copy) NSString * accessId;
@property(nonatomic,readwrite,copy) NSString * signature;


//签名是否过期
-(BOOL)isExpired;
@end

NS_ASSUME_NONNULL_END
