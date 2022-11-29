//
//  FormulaRecordTableViewCell.h
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/2.
//

#import <UIKit/UIKit.h>
#import "JobHistory.h"

NS_ASSUME_NONNULL_BEGIN

@interface FormulaRecordTableViewCell : UITableViewCell
@property (weak, nonatomic) JobHistory * jobHistory;
@property (assign, nonatomic) BOOL isJobFinished;
@end

NS_ASSUME_NONNULL_END
