//
//  FormulaDetailViewController.h
//  ColorCenter
//
//  Created by 王海燕 on 2022/10/31.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"
#import "JobFormulaQuery.h"
#import "Job.h"

NS_ASSUME_NONNULL_BEGIN

@interface FormulaDetailViewController : CommonViewController
@property (weak, nonatomic) Job * job;
- (instancetype)initWithFormulas:(NSArray <JobFormulaQuery *> *)formulas index:(int)index;
@end

NS_ASSUME_NONNULL_END
