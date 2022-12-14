//
//  SettingTableViewCell.h
//  EnochCar
//
//  Created by 王海燕 on 2021/6/16.
//

#import <UIKit/UIKit.h>
#import "SettingItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface SettingTableViewCell : UITableViewCell
@property (strong, nonatomic) SettingItem * item;
@end

NS_ASSUME_NONNULL_END
