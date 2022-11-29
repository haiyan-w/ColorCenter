//
//  CommonTool.m
//  EnochCar
//
//  Created by HAIYAN on 2021/5/16.
//

#import "CommonTool.h"
#import "UIColor+CustomColor.h"
#import <sys/utsname.h>
#import <AVFoundation/AVFoundation.h>
#import "NSNumber+Common.h"
#import "AlertViewController.h"
#import "NSDate+Tool.h"
#import "NSError+tool.h"

@implementation CommonTool


+(BOOL)isVinValid:(NSString *)vinString
{
    if (vinString.length == 17) {
        return YES;
    }
    return NO;
}

+(BOOL)isCellphoneValid:(NSString *)phoneString
{
//    if (phoneString.length != 11){
//        return NO;
//    }else {
//
//        //移动号段正则表达式
//        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(17[0-9])|(18[2-4,7-8]))\\d{8}$";
//
//        //联通号段正则表达式
//        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(17[0-9])|(18[5,6]))\\d{8}$";
//
//        //电信号段正则表达式
//        NSString *CT_NUM = @"^((133)|(153)|(17[0-9])|(18[0,1,9]))\\d{8}$";
    
    //全号段
    //^(13[0-9]|14[01456879]|15[0-35-9]|16[2567]|17[0-8]|18[0-9]|19[0-35-9])\d{8}$
    
    
//
//        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
//
//        BOOL isMatch1 = [pred1 evaluateWithObject:phoneString];
//        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
//        BOOL isMatch2 = [pred2 evaluateWithObject:phoneString];
//        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
//        BOOL isMatch3 = [pred3 evaluateWithObject:phoneString];
//
//        if (isMatch1 || isMatch2 || isMatch3) {
//            return YES;
//
//        }else {
//            return NO;
//        }
//
//    }
    
    //
    NSString * MATCHES = @"^[0-9][0-9]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MATCHES];
    if ([pred evaluateWithObject:phoneString]) {
        return YES;
    }
    return NO;
}

+(NSString *)getNowTimestamp
{
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval a=[dat timeIntervalSince1970];
    
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    
    return timeString;
}

//tool
+(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
   if (jsonString == nil) {
       return nil;
   }
   NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
   NSError *err;
   NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                       options:NSJSONReadingMutableContainers
                                                         error:&err];
   if(err) {
       NSLog(@"json解析失败：%@",err);
       return nil;
   }
   return dic;
}

//从带空格车牌获取不带空格的车牌
+(NSString *)getPlateNoString:(NSString *)plateNo
{
    NSString * newstring = [plateNo stringByReplacingOccurrencesOfString:@" " withString:@""];
    return newstring;
}


//获取带空格分隔的车牌号
+(NSString *)getPlateNoSpaceString:(NSString *)plateNo
{
    if (!plateNo) {
        return @"";
    }
    NSString * substring = plateNo;
    NSString * plateNo2 = @"";
    if (substring.length >= 2) {
        NSString * headstring = [plateNo substringToIndex:2];
        substring = [substring substringFromIndex:2];
//        plateNo2 = [NSString stringWithFormat:@"%@ %@",headstring,substring];
        plateNo2 = [NSString stringWithFormat:@"%@%@",headstring,substring];
    }else {
        plateNo2 = [plateNo2 stringByAppendingString:substring];
    }
    return plateNo2;
}

//获取带空格分隔的车牌号属性字符串
+(NSAttributedString *)getPlateNoSpaceAttributedString:(NSMutableAttributedString *)plateNoAttr
{
    if (!plateNoAttr) {
        return [[NSAttributedString alloc] init];
    }
    
    if(plateNoAttr.string.length > 2 )
    {
        [plateNoAttr insertAttributedString:[[NSAttributedString alloc] initWithString:@" " attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14 weight:UIFontWeightRegular]}] atIndex:2];
    }
    
    return plateNoAttr;
}

//获取带空格分隔的vin属性字符串
+(NSAttributedString *)getVinSpaceAttributedString:(NSMutableAttributedString *)vinAttr
{
    if (!vinAttr) {
        return [[NSAttributedString alloc] init];
    }
    
    NSMutableAttributedString * resultAttr = [[NSMutableAttributedString alloc] initWithAttributedString:vinAttr];
    
    if(vinAttr.string.length > 4 )
    {
        [resultAttr insertAttributedString:[[NSAttributedString alloc] initWithString:@" " attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14 weight:UIFontWeightRegular]}] atIndex:4];
    }
    
    if(vinAttr.string.length > 8+1 )
    {
        [resultAttr insertAttributedString:[[NSAttributedString alloc] initWithString:@" " attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14 weight:UIFontWeightRegular]}] atIndex:8+1];
    }
    
    if(vinAttr.string.length > 12+2 )
    {
        [resultAttr insertAttributedString:[[NSAttributedString alloc] initWithString:@" " attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14 weight:UIFontWeightRegular]}] atIndex:12+2];
    }
    
    return resultAttr;
}


//从带空格vin获取不带空格的vin码
+(NSString *)getVinString:(NSString *)spaceVin
{
    NSString * newstring = [spaceVin stringByReplacingOccurrencesOfString:@" " withString:@""];
    return newstring;
}

//获取带空格的vin码
+(NSString *)getVinSpaceString:(NSString *)vin
{
    if (!vin) {
        return @"";
    }
    NSString * substring = vin;
    NSString * vin2 = @"";
    if (substring.length > 4) {
        vin2 = [vin2 stringByAppendingString:[substring substringToIndex:4]];
        substring = [substring substringFromIndex:4];
    }else {
        
        vin2 = [vin2 stringByAppendingString:substring];
        return vin2;
    }
    if (substring.length > 4) {
        vin2 = [vin2 stringByAppendingString:[NSString stringWithFormat:@" %@",[substring substringToIndex:4]]];
        substring = [substring substringFromIndex:4];
    }else {
        vin2 = [vin2 stringByAppendingString:[NSString stringWithFormat:@" %@",substring]];
        return vin2;
    }
    if (substring.length > 4) {
        vin2 = [vin2 stringByAppendingString:[NSString stringWithFormat:@" %@",[substring substringToIndex:4]]];
        substring = [substring substringFromIndex:4];
    }else {
        vin2 = [vin2 stringByAppendingString:[NSString stringWithFormat:@" %@",substring]];
        return vin2;
    }
    if (substring.length > 5) {
        vin2 = [vin2 stringByAppendingString:[NSString stringWithFormat:@" %@",[substring substringToIndex:5]]];
        substring = [substring substringFromIndex:5];
    }else {
        vin2 = [vin2 stringByAppendingString:[NSString stringWithFormat:@" %@",substring]];
        return vin2;
    }
    
    return vin2;
}



+ (CGFloat)labelAutoCalculateRectWith:(NSString*)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize{
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    
    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    
    NSDictionary* attributes =@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize labelSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    
    labelSize.height=ceil(labelSize.height);
    
    labelSize.width=ceil(labelSize.width);
    
    return labelSize.height;
}


+ (void)changeOrientation:(UIInterfaceOrientation)orientation
{
    int val = orientation;
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

+(BOOL)isIPad
{
    BOOL isIPad = NO;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        isIPad = YES;
    }
    return isIPad;
}

+(NSString *)systemVersion
{
    NSString * systemVersion = [UIDevice currentDevice].systemVersion;
    return systemVersion;
}

+(NSString *)terminalString
{
    NSString * string = @"";
    if ([CommonTool isIPad]) {
        string = [string stringByAppendingString:@"IPAD"];
    }else {
        string = [string stringByAppendingString:@"IPHONE"];
    }
    string = [string stringByAppendingString:[NSString stringWithFormat:@"[%@]",[CommonTool systemVersion]]];
    return string;
}

+(BOOL)isIPhoneXBefore
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *model = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    NSArray * iphonexBefore = @[@"iPhone3,1",@"iPhone3,2",@"iPhone4,1",@"iPhone5,1",@"iPhone5,2",@"iPhone5,3",@"iPhone5,4",@"iPhone6,1",@"iPhone6,2",@"iPhone7,1",@"iPhone7,2",@"iPhone8,1",@"iPhone8,2",@"iPhone8,4",@"iPhone9,1",@"iPhone9,2",@"iPhone9,3",@"iPhone9,4",@"iPhone10,1",@"iPhone10,2",@"iPhone10,4",@"iPhone10,5"];//@"iPhone10,3"（iphoneX）
    
    BOOL isIPhonexBefore = NO;
    
    for (NSString * iphonemodel in iphonexBefore) {
        if ([model isEqualToString:iphonemodel]) {
            isIPhonexBefore = YES;
        }
    }
    return isIPhonexBefore;
}

+(CGFloat)statusbarH
{
    return [[UIApplication sharedApplication] statusBarFrame].size.height;
}

+(CGFloat)navbarH
{
    return 44.f;
}

+(CGFloat)topbarH
{
    return [[UIApplication sharedApplication] statusBarFrame].size.height + 44.f;
}

+(CGFloat)bottomH
{
    if([CommonTool isIPhoneXBefore]){
        return 0.f;
    }else {
        return 34.f;
    }
}

+(CGFloat)bottomSpace
{
    if([CommonTool isIPhoneXBefore]){
        return 12.f;
    }else {
        return 34.f;
    }
}

//  检查输入字符是否符合密码范围
+(BOOL)passwordInputCheck:(NSString *)string
{
    NSString *pattern = @"^[A-Za-z0-9`~!@#$%^&*\\-_+=;:',.?/\\[\\]~！？，。、|；：'’“”""(){}<>·～¥——+「」：“《》\\\\]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:string];
    return isMatch;
}

//检查新密码是否符合规则
+(BOOL)passwordRuleCheck:(NSString*)password
{
    if ([CommonTool isEmptyString:password]) {
        return NO;
    }
    
//    NSString *pattern = @"^(?![0-9]+$)(?![A-Za-z]+$)(?![`~!@#\$%^&*\\-_+=;:',.?/\\[\\]~！？，。、|；：’“”(){}<>]+$)([A-Za-z0-9`~!@#\$%^&*\\-_+=;:',.?/\\[\\]~！？，。、|；：’“”(){}<>]){6,12}$";
    NSString *pattern = @"^(?![0-9]+$)(?![A-Za-z]+$)(?![`~!@#$%^&*\\-_+=;:',.?/\\[\\]~！？，。、|；：'’“”""(){}<> ·～¥——+「」：“《》\\\\]+$)([A-Za-z0-9`~!@#$%^&*\\-_+=;:',.?/\\[\\]~！？，。、|；：'’“”""(){}<> ·～¥——+「」：“《》\\\\]){6,12}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
}

+ (UIImage *)imageWithImageSimple:( UIImage *)image scaledToRect:(CGRect)newRect
{
    UIGraphicsBeginImageContextWithOptions(newRect.size, false, 1.0);
    [image drawInRect : CGRectMake ( newRect.origin.x , newRect.origin.y ,newRect.size.width ,newRect.size.height )];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext ();
    UIGraphicsEndImageContext ();
    return newImage;
}

+ (UIImage *)cropImage:(UIImage *)image toRect:(CGRect)rect {

    CGFloat x = rect.origin.x;

    CGFloat y = rect.origin.y;

    CGFloat width = rect.size.width;

    CGFloat height = rect.size.height;

    CGRect croprect = CGRectMake(floor(x), floor(y), round(width), round(height));

//    UIImage *toCropImage = [image fixOrientation];// 纠正方向

//    CGImageRef cgImage = CGImageCreateWithImageInRect(toCropImage.CGImage, croprect);
    CGImageRef cgImage = CGImageCreateWithImageInRect(image.CGImage, croprect);

    UIImage *cropped = [UIImage imageWithCGImage:cgImage];

    CGImageRelease(cgImage);

    return cropped;

}

+ (BOOL)validateFloatStr:(NSString*)numberStr {
    BOOL res = YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    int i = 0;
    while (i < numberStr.length) {
        NSString * string = [numberStr substringWithRange:NSMakeRange(i, 1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length == 0) {
            res = NO;
            break;
        }
        i++;
    }
    return res;
}


+ (BOOL)validateFloatStr:(NSString*)text withDigit:(NSInteger)digit
{
    NSString * MATCHES = @"^[0-9.]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MATCHES];
    if (![pred evaluateWithObject:text]) {
        return NO;
    }
    
    NSArray * array = [text componentsSeparatedByString:@"."];
    if (array.count > 2) {
        //不止一个 .
        return  NO;
    }
    if (array.count == 2)
    {
        NSString * digitStr = array[1];
        if (digitStr.length > digit) {
            return  NO;
        }
    }
    
    return YES;
}


+ (BOOL)validatePercentStr:(NSString*)numberStr {
    
    if (![CommonTool validateFloatStr:numberStr withDigit:2]) {
        return  NO;
    }
    
    float value = numberStr.floatValue;
    if ((value < 0) || (value > 100)) {
        return  NO;
    }
    
    return YES;
}

+ (BOOL)validateCellPhoneStr:(NSString*)text
{
    NSString * MATCHES = @"^[0-9]{0,11}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MATCHES];
    if (![pred evaluateWithObject:text]) {
        return NO;
    }
    
    return YES;
}

+ (BOOL)validateCellPhoneToSend:(NSString*)text
{
    NSString * MATCHES = @"^[1][0-9]{0,11}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MATCHES];
    if (![pred evaluateWithObject:text]) {
        return NO;
    }
    
    return YES;
}

+(NSString *)getErrorMessage:(NSError *_Nonnull)error
{
    NSString * message = [error errorMessage];
    if ((!message)||(message.length == 0)) {
            message = @"服务器异常";
    }
    return message;
}

+(NSDictionary *)getErrorInfo:(NSError *_Nonnull)error
{
    NSString * info = [error.userInfo objectForKey:@"body"];
    NSDictionary * dic = [CommonTool dictionaryWithJsonString:info];
    NSDictionary * msgDic = [[dic objectForKey:@"errors"] firstObject];
    return msgDic;
}

+(NSMutableAttributedString * )getMoneyAttributedStringWith:(nullable NSNumber*)money bigFont:(UIFont *)bigfont smallFont:(UIFont *)smallfont
{
    NSString * amountStr = [NSString stringWithFormat:@"¥ %.2f",[money doubleValue]];
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithString:amountStr];
    NSRange range = [amountStr rangeOfString:amountStr];
    NSRange range1 = [amountStr rangeOfString:@"¥"];
    NSRange range2 = [amountStr rangeOfString:@"."];
    [attrStr addAttributes:@{NSForegroundColorAttributeName:[UIColor customRedColor]} range:range];
    [attrStr addAttributes:@{NSFontAttributeName:smallfont} range:range1];
    [attrStr addAttributes:@{NSFontAttributeName:bigfont} range:NSMakeRange(range1.location+1, range2.location-range1.location- range1.length)];
    [attrStr addAttributes:@{NSFontAttributeName:smallfont} range:NSMakeRange(range2.location, amountStr.length-range2.location)];
    return attrStr;
}

+(NSString *)stringFromNumber:(NSNumber *)number
{
    NSString * amountStr = [NSString stringWithFormat:@"%@",number?number:@""];
    
    return amountStr;
}

+(BOOL)isEmptyString:(NSString *)string
{
    if (!string || string.length == 0) {
        return YES;
    }
    return NO;
}

// 是否包含表情符号
+ (BOOL)isContainsEmoji:(NSString *)string
{
    __block BOOL isEomji = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:

    ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {

        const unichar hs = [substring characterAtIndex:0];

        if (0xd800 <= hs && hs <= 0xdbff) {

            if (substring.length > 1) {

                const unichar ls = [substring characterAtIndex:1];

                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;

                if (0x1d000 <= uc && uc <= 0x1f77f)
                {
                    isEomji = YES;
                }
            }
        } else if (substring.length > 1) {

        const unichar ls = [substring characterAtIndex:1];

        if (ls == 0x20e3|| ls ==0xfe0f) {

            isEomji = YES;

        }

    } else {

        if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
            isEomji = YES;

        } else if (0x2B05 <= hs && hs <= 0x2b07) {

         isEomji = YES;

        } else if (0x2934 <= hs && hs <= 0x2935) {

            isEomji = YES;

        } else if (0x3297 <= hs && hs <= 0x3299) {
            isEomji =YES;
        } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
            isEomji = YES;
    }
}
}];

    return isEomji;

}

+(void)resign
{
    UIWindow * keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView * firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    [firstResponder resignFirstResponder];
}

/**
 比较两个版本号的大小（2.0）
 @param v1 第一个版本号
 @param v2 第二个版本号
 @return 版本号相等,返回0; v1小于v2,返回-1; 否则返回1.
 */
+ (NSInteger)compareVersion:(NSString *)v1 to:(NSString *)v2 {
    // 都为空，相等，返回0
    if (!v1 && !v2) {
        return 0;
    }
    
    // v1为空，v2不为空，返回-1
    if (!v1 && v2) {
        return -1;
    }
    
    // v2为空，v1不为空，返回1
    if (v1 && !v2) {
        return 1;
    }
    
    // 获取版本号字段
    NSArray *v1Array = [v1 componentsSeparatedByString:@"."];
    NSArray *v2Array = [v2 componentsSeparatedByString:@"."];
    // 取字段最大的，进行循环比较
    NSInteger bigCount = (v1Array.count > v2Array.count) ? v1Array.count : v2Array.count;
    
    for (int i = 0; i < bigCount; i++) {
        // 字段有值，取值；字段无值，置0。
        NSInteger value1 = (v1Array.count > i) ? [[v1Array objectAtIndex:i] integerValue] : 0;
        NSInteger value2 = (v2Array.count > i) ? [[v2Array objectAtIndex:i] integerValue] : 0;
        if (value1 > value2) {
            // v1版本字段大于v2版本字段，返回1
            return 1;
        } else if (value1 < value2) {
            // v2版本字段大于v1版本字段，返回-1
            return -1;
        }
        
        // 版本相等，继续循环。
    }

    // 版本号相等
    return 0;
}


+ (void)movFileTransformToMP4WithSourceUrl:(NSURL *)sourceUrl completion:(void(^)(NSString *Mp4FilePath))comepleteBlock
{
    /**
     *  mov格式转mp4格式
     */
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:sourceUrl options:nil];
    
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    NSLog(@"%@",compatiblePresets);
    
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetHighestQuality];
       
        NSString * tempPath = NSTemporaryDirectory();

        NSString * resultPath = [tempPath stringByAppendingPathComponent:@"movTo.mp4"];
        
        NSLog(@"output File Path : %@",resultPath);
        
        [[NSFileManager defaultManager] removeItemAtURL:[NSURL fileURLWithPath:resultPath] error:NULL];
        
        exportSession.outputURL = [NSURL fileURLWithPath:resultPath];
        
        exportSession.outputFileType = AVFileTypeMPEG4;//可以配置多种输出文件格式
        
        exportSession.shouldOptimizeForNetworkUse = YES;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
         
         {
            dispatch_async(dispatch_get_main_queue(), ^{
                                      
                                  });
             
             switch (exportSession.status) {
                     
                 case AVAssetExportSessionStatusUnknown:
                     
////                     NSLog(@"AVAssetExportSessionStatusUnknown");
//                     CLOUDMESSAGETIPS(@"视频格式转换出错Unknown", 0.8); //自定义错误提示信息
                     break;
                     
                 case AVAssetExportSessionStatusWaiting:
                     
////                     NSLog(@"AVAssetExportSessionStatusWaiting");
//                     CLOUDMESSAGETIPS(@"视频格式转换出错Waiting", 0.8);
                     break;
                     
                 case AVAssetExportSessionStatusExporting:
                     
////                     NSLog(@"AVAssetExportSessionStatusExporting");
//                     CLOUDMESSAGETIPS(@"视频格式转换出错Exporting", 0.8);
 
                     break;
                     
                 case AVAssetExportSessionStatusCompleted:
                 {
                     
//                     NSLog(@"AVAssetExportSessionStatusCompleted");
 
                     comepleteBlock(resultPath);
                     
                     
                     NSLog(@"mp4 file size:%lf MB",[NSData dataWithContentsOfURL:exportSession.outputURL].length/1024.f/1024.f);
                 }
                     break;
                     
                 case AVAssetExportSessionStatusFailed:
                     
////                     NSLog(@"AVAssetExportSessionStatusFailed");
//                     CLOUDMESSAGETIPS(@"视频格式转换出错Unknown", 0.8);
 
                     break;
                     
                 case AVAssetExportSessionStatusCancelled:
                     
////                     NSLog(@"AVAssetExportSessionStatusFailed");
//                     CLOUDMESSAGETIPS(@"视频格式转换出错Cancelled", 0.8);
 
                     break;
                     
             }
             
         }];
        
    }
}

+ (void)movFileTransformToMP4WithSourceUrl:(NSURL *)sourceUrl index:(NSInteger)index completion:(void(^)(NSString *Mp4FilePath, NSString * errMsg))comepleteBlock
{
    /**
     *  mov格式转mp4格式
     */
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:sourceUrl options:nil];
    
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    NSLog(@"%@",compatiblePresets);
    
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetHighestQuality];
       
        NSString * tempPath = NSTemporaryDirectory();

        NSString * resultPath = [tempPath stringByAppendingPathComponent:[NSString stringWithFormat:@"movTo_%d.mp4",index]];
        
        NSLog(@"output File Path : %@",resultPath);
        
        [[NSFileManager defaultManager] removeItemAtURL:[NSURL fileURLWithPath:resultPath] error:NULL];
        
        exportSession.outputURL = [NSURL fileURLWithPath:resultPath];
        
        exportSession.outputFileType = AVFileTypeMPEG4;//可以配置多种输出文件格式
        
        exportSession.shouldOptimizeForNetworkUse = YES;
        
        [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
         
         {
            dispatch_async(dispatch_get_main_queue(), ^{
                                      
                                  });
            NSString * errMsg = nil;
             switch (exportSession.status) {
                     
                 case AVAssetExportSessionStatusUnknown:
                     
                     errMsg = @"视频格式转换出错";
////                     NSLog(@"AVAssetExportSessionStatusUnknown");
//                     CLOUDMESSAGETIPS(@"视频格式转换出错Unknown", 0.8); //自定义错误提示信息
                     break;
                     
                 case AVAssetExportSessionStatusWaiting:
                     errMsg = @"视频格式转换出错";
////                     NSLog(@"AVAssetExportSessionStatusWaiting");
//                     CLOUDMESSAGETIPS(@"视频格式转换出错Waiting", 0.8);
                     break;
                     
                 case AVAssetExportSessionStatusExporting:
                     errMsg = @"视频格式转换出错";
////                     NSLog(@"AVAssetExportSessionStatusExporting");
//                     CLOUDMESSAGETIPS(@"视频格式转换出错Exporting", 0.8);
 
                     break;
                     
                 case AVAssetExportSessionStatusCompleted:
                 {
                     
//                     NSLog(@"AVAssetExportSessionStatusCompleted");
 
//                     comepleteBlock(resultPath);
                     
                     
                     NSLog(@"mp4 file size:%lf MB",[NSData dataWithContentsOfURL:exportSession.outputURL].length/1024.f/1024.f);
                 }
                     break;
                     
                 case AVAssetExportSessionStatusFailed:
                     errMsg = @"视频格式转换出错";
////                     NSLog(@"AVAssetExportSessionStatusFailed");
//                     CLOUDMESSAGETIPS(@"视频格式转换出错Unknown", 0.8);
 
                     break;
                     
                 case AVAssetExportSessionStatusCancelled:
                     errMsg = @"视频格式转换出错";
////                     NSLog(@"AVAssetExportSessionStatusFailed");
//                     CLOUDMESSAGETIPS(@"视频格式转换出错Cancelled", 0.8);
 
                     break;
                     
             }
            
            comepleteBlock(resultPath, errMsg);
             
         }];
        
    }
}

/// 裁剪框背景的处理
+ (void)overlayClippingWithView:(UIView *)view cropRect:(CGRect)cropRect{
    UIBezierPath *path= [UIBezierPath bezierPathWithRect:[UIScreen mainScreen].bounds];
    CAShapeLayer *layer = [CAShapeLayer layer];
    [path appendPath:[UIBezierPath bezierPathWithRect:cropRect]];
    layer.path = path.CGPath;
    layer.fillRule = kCAFillRuleEvenOdd;
    layer.fillColor = [[UIColor blackColor] CGColor];
    layer.opacity = 0.5;
    [view.layer addSublayer:layer];
}


+(void)showAlertWithTitle:(NSString*)title message:(NSString*)message
{
    AlertAction * sure = [[AlertAction alloc] initWithTitle:@"知道了" action:^(id _Nonnull arg) {
        
    }];
    AlertViewController * alert = [[AlertViewController alloc] initWithTitle:title message:message position:AlertCenter actions:@[sure]];
    [alert showOn:[UIApplication sharedApplication].keyWindow.rootViewController];
}

+(void)showAlertWithTitle:(NSString*)title message:(NSString*)message yesAction:(void (^)(void))yesBlock noAction:(void (^)(void))noBlock
{
    AlertAction * cancel = [[AlertAction alloc] initWithTitle:@"否" action:^(id _Nonnull arg) {
        noBlock();
    }];
    AlertAction * sure = [[AlertAction alloc] initWithTitle:@"是" action:^(id _Nonnull arg) {
        yesBlock();
    }];
    
    AlertViewController * alert = [[AlertViewController alloc] initWithTitle:title message:message position:AlertCenter actions:@[cancel,sure]];
    [alert showOn:[UIApplication sharedApplication].keyWindow.rootViewController];
    
}

+(void)showError:(NSError *)error
{
    [CommonTool showHint:[error errorMessage]];
}




//输入金额检查，最多小数点后2位
+(BOOL)inputAmountValid:(NSString *)text
{
    return [CommonTool validateFloatStr:text withDigit:2];
}


+ (double)doubleValueWithDouble:(double)number digits:(NSUInteger)digits
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    formatter.maximumFractionDigits = digits;
    [formatter setGroupingSeparator:@""];
    
    NSString *retString = [formatter stringFromNumber:[NSNumber numberWithDouble:number]];
    NSNumber * resultNum = [NSNumber numberWithDouble:retString.doubleValue];
    return resultNum.doubleValue;
}

+ (BOOL)isZeroFloat:(float)value
{
    BOOL result = NO;
    const float EPSINON = 0.000001;//精度
    if ((value >= -EPSINON) && (value <= EPSINON)) {
        result = YES;
    }
    return result;
}

+ (NSString *)getDateFromDateTime:(NSString *)datetime
{
    NSArray * array = [datetime componentsSeparatedByString:@" "];
    NSString * date = array.firstObject;
    if (nil == date) {
        date = @"";
    }
    return date;
}


#pragma mark hint

+(void)showHint:(NSString *)message
{
    [CommonTool showHint:message position:Top];
}

+(void)showHint:(NSString *)message position:(Positon)pos
{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *showview =  [[UIView alloc]init];
    showview.backgroundColor = [UIColor colorWithRed:76/255.0 green:76/255.0 blue:76/255.0 alpha:1];
    showview.frame = CGRectMake(1, 1, 1, 1);
    showview.alpha = 1.0f;
    showview.layer.cornerRadius = 5.0f;
    showview.layer.masksToBounds = YES;
    [window addSubview:showview];
    
    UILabel *label = [[UILabel alloc]init];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
//    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15.f weight:UIFontWeightRegular],
                                   NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    
    CGSize labelSize = [message boundingRectWithSize:CGSizeMake(220, 200)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:attributes context:nil].size;
 
    label.frame = CGRectMake(10, 10, labelSize.width +2, labelSize.height);
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:15];
    label.numberOfLines = 0;
    [showview addSubview:label];
        
    
    switch (pos) {
        case Top:
        {
            showview.frame = CGRectMake((screenSize.width - labelSize.width - 20)/2,
                                            100,
                                               labelSize.width+20,
                                                   labelSize.height+20);
        }
            break;
        case Center:
        {
            showview.frame = CGRectMake((screenSize.width - labelSize.width - 20)/2,
                                        (screenSize.height - labelSize.height - 20)/2,
                                               labelSize.width+20,
                                                   labelSize.height+20);
        }
            break;
        case Bottom:
        {
            showview.frame = CGRectMake((screenSize.width - labelSize.width - 20)/2,
                                                    screenSize.height - 100,
                                                       labelSize.width+20,
                                                           labelSize.height+20);
        }
            break;
            
        default:
            break;
    }
        [UIView animateWithDuration:3 animations:^{
            showview.alpha = 0;
        } completion:^(BOOL finished) {
            [showview removeFromSuperview];
        }];
}


+ (NSString *)vehicleModelToString:(NSArray *)model
{
    NSMutableString * string = [NSMutableString string];
    for (NSString * text in model) {
        if (string.length > 0 && text.length > 0) {
            [string appendString:@" "];
        }
        [string appendString:text?text:@""];
    }
    return string;
}


@end
