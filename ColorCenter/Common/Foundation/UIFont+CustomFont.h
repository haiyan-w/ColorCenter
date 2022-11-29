//
//  UIFont+CustomFont.h
//  EnochCar
//
//  Created by 王海燕 on 2022/3/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (CustomFont)

//标题字体（页面标题、大按钮标题）
+(UIFont *)titleFont;

//大标题加粗（导航栏标题）
+(UIFont *)boldTitleFont;

//副标题字体
+(UIFont *)subTitleFont;

//普通文字字体（输入框、tab等）
+(UIFont *)textFont;

//普通加粗文字字体（输入框标题、tab选中等）
+(UIFont *)boldTextFont;

//大按钮标题字体16
+(UIFont *)bigButtonTitleFont;

//小按钮标题字体14
+(UIFont *)smallButtonTitleFont;

//详情文字字体14
+(UIFont *)detailFont;

//提示文字字体12
+(UIFont *)tipFont;

//最小字体10（badge）
+(UIFont *)smallestFont;

@end

NS_ASSUME_NONNULL_END
