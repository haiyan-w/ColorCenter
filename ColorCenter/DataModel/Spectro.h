//
//  Spectro.h
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/14.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface Spectro : BaseModel
@property(nonatomic,readwrite,strong) NSNumber * id;
@property(nonatomic,readwrite,copy) NSString * brand;
@property(nonatomic,readwrite,copy) NSString * manufacturerDate;
@property(nonatomic,readwrite,copy) NSString * name;
@property(nonatomic,readwrite,copy) NSString * serialNo;
@end

NS_ASSUME_NONNULL_END
