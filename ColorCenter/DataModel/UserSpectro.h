//
//  UserSpectro.h
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/14.
//

#import "BaseModel.h"
#import "Spectro.h"
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserSpectro : BaseModel
@property(nonatomic,readwrite,strong) NSNumber * id;
@property(nonatomic,readwrite,copy) NSString * name;
@property(nonatomic,readwrite,copy) NSString * preparedDatetime;
@property(nonatomic,readwrite,strong) Spectro * spectro;
@property(nonatomic,readwrite,strong) User * user;
@end

NS_ASSUME_NONNULL_END
