//
//  AdjustTableCell.h
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/16.
//

#import <UIKit/UIKit.h>
#import "FormulaDetail.h"

NS_ASSUME_NONNULL_BEGIN

@interface AdjustTableCell : UITableViewCell
@property(nonatomic, readwrite, strong) UITextField * countTF;
@property (strong, nonatomic) FormulaDetail * item;
@end

NS_ASSUME_NONNULL_END
