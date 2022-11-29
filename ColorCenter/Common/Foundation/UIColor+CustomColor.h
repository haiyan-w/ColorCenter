//
//  UIColor+CustomColor.h
//  EnochCar
//
//  Created by 王海燕 on 2021/10/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (CustomColor)

-(BOOL)isSameColor:(UIColor *)color;

//主题色（主界面背景tab栏、textfield光标颜色）
+(UIColor*)tintColor;

//按钮禁用的浅绿色
+(UIColor*)lightTintColor;

//填充用的浅绿色
+(UIColor*)fillTintColor;

//背景白色调颜色
+(UIColor*)bgWhiteColor;

//背景黑色调颜色
+(UIColor*)bgBlackColor;

//深黑文字颜色（标题加粗等文字颜色）
+(UIColor*)darkTextColor;

//浅灰文字颜色（tab未选中颜色）
+(UIColor*)slightTextColor;

//浅灰文字颜色（placeholder）
+(UIColor*)lightTextColor;

//普通文字颜色
+(UIColor*)textColor;

//线条颜色
+(UIColor*)lineColor;

////浅蓝填充色
//+(UIColor*)lightBlueFillColor;
//
////浅红填充色
//+(UIColor*)lightRedFillColor;

//按钮等黄色
+(UIColor*)customYellowColor;

//按钮禁用的灰色
+(UIColor*)greyColor;

//金额等数字的红色
+(UIColor*)customRedColor;

////维修中状态的蓝色
//+(UIColor*)customBlueColor;
//
////结清状态的绿色
//+(UIColor*)customGreenColor;
//
////标签、tab背景等蓝绿色
//+(UIColor*)customBlueGreenColor;
//
////可点文字的颜色（蓝色）
//+(UIColor*)clickableTextColor;

//默认边框颜色-偏灰色
+(UIColor*)borderColor;


@end

NS_ASSUME_NONNULL_END
