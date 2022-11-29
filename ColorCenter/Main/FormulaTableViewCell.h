//
//  FormulaTableViewCell.h
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/1.
//

#import <UIKit/UIKit.h>
#import "JobQuery.h"

NS_ASSUME_NONNULL_BEGIN

@interface FormulaTableViewCell : UITableViewCell
@property (strong, nonatomic) JobQuery * job;
@end

NS_ASSUME_NONNULL_END
