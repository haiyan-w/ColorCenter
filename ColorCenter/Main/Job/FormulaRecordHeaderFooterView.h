//
//  FormulaRecordHeaderFooterView.h
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FormulaRecordHeaderFooterView : UITableViewCell
@property (assign, nonatomic) BOOL isFooter;
@property (assign, nonatomic) BOOL disabled;
@property (assign, nonatomic) NSString * datetime;
@end

NS_ASSUME_NONNULL_END
