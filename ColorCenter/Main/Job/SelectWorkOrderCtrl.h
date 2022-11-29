//
//  SelectWorkOrderCtrl.h
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/14.
//

#import <UIKit/UIKit.h>
#import "GestureViewController.h"
#import "WorkOrderQuery.h"

NS_ASSUME_NONNULL_BEGIN

@interface SelectWorkOrderCtrl : GestureViewController
@property (copy, nonatomic) void(^selectBlk)(WorkOrderQuery * order);
@end

NS_ASSUME_NONNULL_END
