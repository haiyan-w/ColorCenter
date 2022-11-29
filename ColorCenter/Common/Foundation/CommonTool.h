//
//  CommonTool.h
//  EnochCar
//
//  Created by HAIYAN on 2021/5/16.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NSError+tool.h"

typedef enum  {
    Top,
    Center,
    Bottom
}Positon;


NS_ASSUME_NONNULL_BEGIN

@interface CommonTool : NSObject


+ (BOOL)isVinValid:(NSString *)vinString;

+ (BOOL)isCellphoneValid:(NSString *)phoneString;

+ (NSString *)getNowTimestamp;

+(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

//从带空格车牌获取不带空格的车牌
+(NSString *)getPlateNoString:(NSString *)plateNo;

//获取带空格分隔的车牌号
+(NSString *)getPlateNoSpaceString:(NSString *)plateNo;

//获取带空格分隔的车牌号属性字符串
+(NSAttributedString *)getPlateNoSpaceAttributedString:(NSMutableAttributedString *)plateNoAttr;

//从带空格vin获取不带空格的vin码
+(NSString *)getVinString:(NSString *)spaceVin;

//获取带空格的vin码
+(NSString *)getVinSpaceString:(NSString *)vin;

//获取带空格分隔的vin属性字符串
+(NSAttributedString *)getVinSpaceAttributedString:(NSMutableAttributedString *)vinAttr;

//获取时间戳水印路径
+(NSString *)getTimeWatermarkString;

//获取存档水印路径
+(NSString *)getFileWatermarkString;

+ (CGFloat)labelAutoCalculateRectWith:(NSString*)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize;

+ (void)changeOrientation:(UIInterfaceOrientation)orientation;

+(BOOL)isIPad;

+(NSString *)systemVersion;

+(NSString *)terminalString;

+(BOOL)isIPhoneXBefore;

+(CGFloat)statusbarH;

+(CGFloat)navbarH;

+(CGFloat)topbarH;

+(CGFloat)bottomH;

//底部留空距离
+(CGFloat)bottomSpace;

//  检查输入字符是否符合密码范围
+(BOOL)passwordInputCheck:(NSString *)string;

//检查新密码是否符合规则
+(BOOL)passwordRuleCheck:(NSString*)password;

+ (UIImage *)imageWithImageSimple:( UIImage *)image scaledToRect:(CGRect)newRect;

+ (UIImage *)cropImage:(UIImage *)image toRect:(CGRect)rect;

+(NSDictionary *)getErrorInfo:(NSError *_Nonnull)error;

//获取错误信息
+(NSString *)getErrorMessage:(NSError *_Nonnull)error;

//金额格式字符串（eg. ¥200.00）
+(NSMutableAttributedString * )getMoneyAttributedStringWith:(nullable NSNumber*)money bigFont:(UIFont *)bigfont smallFont:(UIFont *)smallfont;

+(NSString*)stringFromNumber:(NSNumber *)number;

+ (BOOL)validateFloatStr:(NSString*)numberStr;

+ (BOOL)validateFloatStr:(NSString*)text withDigit:(NSInteger)digit;

+ (BOOL)validatePercentStr:(NSString*)numberStr;

//输入金额检查，最多小数点后2位
+(BOOL)inputAmountValid:(NSString *)text;

+ (double)doubleValueWithDouble:(double)number digits:(NSUInteger)digits;

+ (BOOL)isZeroFloat:(float)value;

+ (BOOL)validateCellPhoneStr:(NSString*)text;
+ (BOOL)validateCellPhoneToSend:(NSString*)text;


//退出键盘
+(void)resign;

+(BOOL)isEmptyString:(NSString *)string;

// 是否包含表情符号
+ (BOOL)isContainsEmoji:(NSString *)string;

/**
 比较两个版本号的大小（2.0）
 @param v1 第一个版本号
 @param v2 第二个版本号
 @return 版本号相等,返回0; v1小于v2,返回-1; 否则返回1.
 */
+ (NSInteger)compareVersion:(NSString *)v1 to:(NSString *)v2;

+ (void)movFileTransformToMP4WithSourceUrl:(NSURL *)sourceUrl completion:(void(^)(NSString *Mp4FilePath))comepleteBlock;

+ (void)movFileTransformToMP4WithSourceUrl:(NSURL *)sourceUrl index:(NSInteger)index completion:(void(^)(NSString *Mp4FilePath, NSString * errMsg))comepleteBlock;

+ (void)overlayClippingWithView:(UIView *)view cropRect:(CGRect)cropRect;


+(void)showAlertWithTitle:(NSString*)title message:(NSString*)message;

+(void)showAlertWithTitle:(NSString*)title message:(NSString*)message yesAction:(void (^)(void))yesBlock noAction:(void (^)(void))noBlock;

+(void)showError:(NSError *)error;

+ (NSString *)getDateFromDateTime:(NSString *)datetime;

+(void)showHint:(NSString *)message;

+ (NSString *)vehicleModelToString:(NSArray *)model;

@end

NS_ASSUME_NONNULL_END
