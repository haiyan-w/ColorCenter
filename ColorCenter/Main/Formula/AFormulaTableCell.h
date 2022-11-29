//
//  AFormulaTableCell.h
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/16.
//

#import <UIKit/UIKit.h>
#import "FormulaDetail.h"

NS_ASSUME_NONNULL_BEGIN

@interface AFormulaTableCell : UITableViewCell
@property (strong, nonatomic) FormulaDetail * item;

+ (float)heightWithFormulaDetail:(FormulaDetail *)formulaDetail;
@end

NS_ASSUME_NONNULL_END
