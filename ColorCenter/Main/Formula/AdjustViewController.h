//
//  AdjustViewController.h
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/16.
//

#import "CommonViewController.h"
#import "Formula.h"
#import "Job.h"

NS_ASSUME_NONNULL_BEGIN

@interface AdjustViewController : CommonViewController
@property (weak, nonatomic) Job * job;
- (instancetype)initWithFormula:(Formula *)formula;
@end

NS_ASSUME_NONNULL_END
