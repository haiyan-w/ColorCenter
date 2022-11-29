//
//  OrderInfoView.h
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/15.
//

#import <UIKit/UIKit.h>
#import "WorkOrderQuery.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderInfoView : UIView
@property (copy, nonatomic) void(^operateBlk)(void);

- (void)setWorkOrder:(WorkOrderQuery *)workOrder;

@end

NS_ASSUME_NONNULL_END
