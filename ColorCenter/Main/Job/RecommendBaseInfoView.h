//
//  RecommendedFormulaBaseInfoView.h
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/3.
//

#import <UIKit/UIKit.h>
#import "Job.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecommendBaseInfoView : UIView
@property (weak, nonatomic) UIViewController * viewCtrl;
@property (weak, nonatomic) Job * job;
@property (copy, nonatomic) void(^selectOrderBlk)(WorkOrderQuery * order);
@end

NS_ASSUME_NONNULL_END
