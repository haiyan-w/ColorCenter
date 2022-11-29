//
//  SettingItem.h
//  EnochCar
//
//  Created by 王海燕 on 2022/2/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SettingItem : NSObject
@property (strong, nonatomic)NSString * iconName;
@property (strong, nonatomic)NSString * titleStr;
@property (strong, nonatomic)NSString * rightStr;
@property (strong, nonatomic)NSString * subTitleStr;
@property (assign, nonatomic)BOOL hasNext;
@property (strong, nonatomic)void(^nextBlock)(void);
@end

NS_ASSUME_NONNULL_END
