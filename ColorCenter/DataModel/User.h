//
//  User.h
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/14.
//

#import "BaseModel.h"
#import "LookUp.h"

NS_ASSUME_NONNULL_BEGIN

@interface User : BaseModel
@property(nonatomic,readwrite,strong) NSNumber * id;
@property(nonatomic,readwrite,copy) NSString * name;
@property(nonatomic,readwrite,copy) NSString * nickname;
@property(nonatomic,readwrite,strong) LookUp * status;

@property(nonatomic,readwrite,copy) NSString * address;
@property(nonatomic,readwrite,copy) NSString * areaCode;
@property(nonatomic,readwrite,copy) NSString * avartar;
@property(nonatomic,readwrite,copy) NSString * cellphone;
@property(nonatomic,readwrite,copy) NSString * contact;

@property(nonatomic,readwrite,strong) NSNumber * branchId;
@property(nonatomic,readwrite,copy) NSString * tenantId;
@property(nonatomic,readwrite,copy) NSString * ssoUserId;
@end

NS_ASSUME_NONNULL_END
