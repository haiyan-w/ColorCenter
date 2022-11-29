//
//  MultipleSelectTableViewCell.h
//  EnochCar
//
//  Created by 王海燕 on 2022/8/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectItem : NSObject
@property (strong, nonatomic) NSString * text;
@property (assign, nonatomic) BOOL select;
@property (assign, nonatomic) BOOL disabled;//可选否
@end

@interface MultipleSelectTableViewCell : UITableViewCell

-(void)configData:(SelectItem *)item;
@end

NS_ASSUME_NONNULL_END
