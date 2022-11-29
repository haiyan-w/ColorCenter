//
//  UIFont+CustomFont.m
//  EnochCar
//
//  Created by 王海燕 on 2022/3/11.
//

#import "UIFont+CustomFont.h"

@implementation UIFont (CustomFont)

//标题字体（页面标题、大按钮标题）
+(UIFont *)titleFont
{
    return [UIFont systemFontOfSize:18 weight:UIFontWeightRegular];
}

//大标题加粗（导航栏标题）
+(UIFont *)boldTitleFont
{
    return [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
}

//副标题字体
+(UIFont *)subTitleFont
{
    return [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
}

//普通文字字体（输入框、tab等）
+(UIFont *)textFont
{
    return [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
}

//普通加粗文字字体（输入框标题、tab选中等）
+(UIFont *)boldTextFont
{
    return [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
}

//大按钮标题字体16
+(UIFont *)bigButtonTitleFont
{
    return [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
}

//小按钮标题字体14
+(UIFont *)smallButtonTitleFont
{
    return [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
}

//详情文字字体14
+(UIFont *)detailFont
{
    return [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
}

//提示性文字字体12
+(UIFont *)tipFont
{
    return [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
}

//最小字体10（badge）
+(UIFont *)smallestFont
{
    return [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];
}

@end
