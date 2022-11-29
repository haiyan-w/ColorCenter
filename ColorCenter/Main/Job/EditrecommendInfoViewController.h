//
//  EditrecommendInfoViewController.h
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/11.
//

#import <UIKit/UIKit.h>
#import "GestureViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface EditrecommendInfoViewController : GestureViewController
@property (nonatomic, strong) void (^sureBlk)(NSArray * brand, NSString * year, NSString * colorCode);
- (instancetype)initWithBrand:(NSArray *)brand year:(NSString *)year colorCode:(NSString *)colorCode;
@end

NS_ASSUME_NONNULL_END
