//
//  StandardSample.h
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/15.
// 标样数据

#import <Foundation/Foundation.h>
#import "ColorPanel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ColorData : NSObject
@property (assign, nonatomic) int16_t data;
@end

@interface FlashDegrees : NSObject
@property (assign, nonatomic) float S_i;
@property (assign, nonatomic) float S_a;
@property (assign, nonatomic) float S_G;
@property (assign, nonatomic) float G;//颗粒度
@end

@interface StandardSample : NSObject
@property (strong, nonatomic) NSString * number;
@property (strong, nonatomic) NSString * dateTime;
@property (assign, nonatomic) int16_t angles;
@property (strong, nonatomic) ColorPanel * colorPanel;
//@property (strong, nonatomic) ColorPanelAngle * angle15;
//@property (strong, nonatomic) ColorPanelAngle * angle45;
//@property (strong, nonatomic) ColorPanelAngle * angle110;
//@property (assign, nonatomic) float granularity;//颗粒度

//@property (strong, nonatomic) NSArray <FlashDegrees *> * flashDegrees;

- (instancetype)initWithData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
