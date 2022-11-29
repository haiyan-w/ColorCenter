//
//  RecommendBaseTableCell.h
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/16.
//

#import <UIKit/UIKit.h>
#import "JobFormulaQuery.h"

NS_ASSUME_NONNULL_BEGIN

@interface RecommendBaseTableCell : UITableViewCell
@property (strong, nonatomic) JobFormulaQuery * formula;
@end

NS_ASSUME_NONNULL_END
