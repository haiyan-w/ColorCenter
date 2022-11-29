//
//  SystemConfig.h
//  EnochCar
//
//  Created by 王海燕 on 2021/9/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN








@interface SystemConfig : NSObject
@property(nonatomic,readwrite,assign) BOOL needEngineer;//是否必须派工技师
//@property(nonatomic,readwrite,strong) NSNumber * hour;//设置的默认工时
@property(nonatomic,readwrite,strong) NSString * price;//设置的默认单价
//@property(nonatomic,readwrite,strong) NSDictionary * chargeMethod;//设置的默认项目计价方式
@property(nonatomic,readwrite,strong) NSString * chargeMethodCode;//设置的默认项目计价方式

@property(nonatomic,readwrite,assign) NSInteger maintenanceDateInterval;//默认的保养时间间隔（月）

@property(nonatomic,readwrite,assign) float maintenanceMileageInterval;//默认的保养里程

@property(nonatomic,readwrite,assign) BOOL discountForward;//项目配件折扣是否正向显示 （P：正向 N：反向）

@property(nonatomic,readwrite,assign) BOOL zeroErasing;//维修工单自动抹零

@property(nonatomic,readwrite,assign) BOOL isGoodsWarehouseDiscount;//配件打折（是否出库打折）

+(instancetype)defaultSystemConfig;
@end





NS_ASSUME_NONNULL_END
