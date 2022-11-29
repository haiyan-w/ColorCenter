//
//  UIColor+CustomColor.m
//  EnochCar
//
//  Created by 王海燕 on 2021/10/9.
//

#import "UIColor+CustomColor.h"

@implementation UIColor (CustomColor)

-(BOOL)isSameColor:(UIColor *)color
{
    if (CGColorEqualToColor(self.CGColor, color.CGColor)) {
        return YES;
    }else {
        return NO;
    }
}

//主题色（主界面背景tab栏、textfield光标颜色）
+(UIColor*)tintColor
{
    return [UIColor colorWithRed:24/255.0 green:188/255.0 blue:188/255.0 alpha:1];
}

//按钮禁用的浅绿色
+(UIColor*)lightTintColor
{
    return [UIColor colorWithRed:138/255.0 green:227/255.0 blue:218/255.0 alpha:1];
}

//填充用的浅绿色
+(UIColor*)fillTintColor
{
    return [UIColor colorWithRed:235/255.0 green:252/255.0 blue:250/255.0 alpha:1];
}

//背景白色调颜色
+(UIColor*)bgWhiteColor
{
    return [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
}

//背景黑色调颜色
+(UIColor*)bgBlackColor
{
    return [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:0.5];
}

//普通文字颜色
+(UIColor*)textColor
{
    return [UIColor colorWithRed:89/255.0 green:89/255.0 blue:89/255.0 alpha:1];
}

//深黑文字颜色（标题加粗等文字颜色）
+(UIColor*)darkTextColor
{
    return [UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1];
}

//浅黑文字颜色（tab未选中颜色）
+(UIColor*)slightTextColor;
{
    return [UIColor colorWithRed:140/255.0 green:140/255.0 blue:140/255.0 alpha:1];
}


//浅灰文字颜色（placeholder）
+(UIColor*)lightTextColor
{
    return [UIColor colorWithRed:191/255.0 green:191/255.0 blue:191/255.0 alpha:1];
}

//线条颜色
+(UIColor*)lineColor
{
    return [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
}


////浅蓝填充色
//+(UIColor*)lightBlueFillColor
//{
//    return [UIColor colorWithRed:240/255.0 green:244/255.0 blue:255/255.0 alpha:1];
//}

////浅红填充色
//+(UIColor*)lightRedFillColor
//{
//    return [UIColor colorWithRed:255/255.0 green:241/255.0 blue:240/255.0 alpha:1];
//}

//按钮等黄色
+(UIColor*)customYellowColor
{
    return [UIColor colorWithRed:252/255.0 green:215/255.0 blue:139/255.0 alpha:1];
}



//按钮禁用的灰色
+(UIColor*)greyColor
{
    return [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
}

//金额等数字的红色
+(UIColor*)customRedColor
{
    return [UIColor colorWithRed:227/255.0 green:77/255.0 blue:89/255.0 alpha:1];
}

////维修中状态的蓝色
//+(UIColor*)customBlueColor
//{
//    return [UIColor colorWithRed:0/255.0 green:132/255.0 blue:244/255.0 alpha:1];
//}

////结清状态的绿色
//+(UIColor*)customGreenColor
//{
//    return [UIColor colorWithRed:82/255.0 green:196/255.0 blue:26/255.0 alpha:1];
//}

////标签、tab背景等蓝绿色
//+(UIColor*)customBlueGreenColor
//{
//    return [UIColor colorWithRed:24/255.0 green:188/255.0 blue:188/255.0 alpha:1];
//}

////可点文字的颜色（蓝色）
//+(UIColor*)clickableTextColor
//{
//    return [UIColor colorWithRed:89/255.0 green:156/255.0 blue:255/255.0 alpha:1];
//}

//边框颜色
+(UIColor*)borderColor
{
    return [UIColor colorWithRed:217/255.0 green:217/255.0 blue:217/255.0 alpha:1];
}



@end
