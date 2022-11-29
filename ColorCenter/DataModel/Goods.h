//
//  Goods.h
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/16.
// 色母信息

#import "BaseModel.h"
#import "LookUp.h"

NS_ASSUME_NONNULL_BEGIN

@interface Goods : BaseModel
@property(nonatomic,readwrite,strong) NSNumber * id;
@property(nonatomic,readwrite,copy) NSString * name;
@property(nonatomic,readwrite,strong) LookUp * paintType;
@property(nonatomic,readwrite,copy) NSString * rgb;
@property(nonatomic,readwrite,copy) NSString * serialNo;
@end

NS_ASSUME_NONNULL_END
