//
//  WorkOrderTableCell.h
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/14.
//

#import <UIKit/UIKit.h>
#import "WorkOrderQuery.h"

NS_ASSUME_NONNULL_BEGIN

@interface WorkOrderTableCell : UITableViewCell
//@property (strong, nonatomic) WorkOrderQuery * workOrder;

- (void)setWorkOrder:(WorkOrderQuery *)workOrder;
@end

NS_ASSUME_NONNULL_END
