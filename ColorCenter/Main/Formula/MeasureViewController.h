//
//  MeasureViewController.h
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/18.
//

#import "GestureViewController.h"
#import "UIView+Frame.h"
#import "NetWorkAPIManager.h"
#import "CommonTool.h"
#import "UIColor+CustomColor.h"
#import "JobHistory.h"

NS_ASSUME_NONNULL_BEGIN

@interface MeasureViewController : GestureViewController
@property (nonatomic, strong)JobHistory * jobHistory;
@property (nonatomic, strong)Job * job;
@property (nonatomic, assign)BOOL canAdjust;//是否能微调

- (instancetype)initWithJobHistoryId:(NSNumber *)jobHistoryId;
//- (instancetype)initWithJobHistory:(JobHistory *)jobHistory;
- (instancetype)initWithFormula:(Formula *)formula;
@end

NS_ASSUME_NONNULL_END
