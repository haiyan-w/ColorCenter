//
//  UserSpectroQuery.h
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/14.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserSpectroQuery : BaseModel
@property(nonatomic,readwrite,strong) NSNumber * id;
@property(nonatomic,readwrite,copy) NSString * name;
@property(nonatomic,readwrite,copy) NSString * preparedDatetime;
@property(nonatomic,readwrite,copy) NSString * spectroBrand;
@property(nonatomic,readwrite,strong) NSNumber * spectroId;
@property(nonatomic,readwrite,copy) NSString * spectroManufacturerDate;
@property(nonatomic,readwrite,copy) NSString * spectroName;
@property(nonatomic,readwrite,copy) NSString * spectroSerialNo;
@end

NS_ASSUME_NONNULL_END
