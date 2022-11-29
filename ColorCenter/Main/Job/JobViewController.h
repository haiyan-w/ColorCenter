//
//  JobViewController.h
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/3.
//

#import "CommonViewController.h"
#import "Job.h"

NS_ASSUME_NONNULL_BEGIN

@interface JobViewController : CommonViewController

- (instancetype)initWithJobId:(NSNumber *)Id;

- (instancetype)initWithFormulaId:(NSNumber *)Id;

- (instancetype)initWithColorPanel:(ColorPanel *)colorPanel;

@end

NS_ASSUME_NONNULL_END
