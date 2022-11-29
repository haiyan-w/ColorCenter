//
//  VehicleBrandViewController.h
//  EnochCar
//
//  Created by HAIYAN on 2021/6/2.
//

#import <UIKit/UIKit.h>
#import "GestureViewController.h"

NS_ASSUME_NONNULL_BEGIN


@interface VehicleBrandViewController : GestureViewController
@property(nullable,nonatomic, copy) void (^selectBlock) (NSArray * model);
-(instancetype)initWithBrands:(NSArray *)brands;
@end

NS_ASSUME_NONNULL_END
