//
//  BleTool.m
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/17.
//

#import "BleTool.h"

@implementation BleTool

// 转为本地大小端模式 返回Signed类型的数据
+ (signed int)signedDataTointWithData:(NSData *)data Location:(NSInteger)location Offset:(NSInteger)offset {
    signed int value=0;
    NSData *intdata= [data subdataWithRange:NSMakeRange(location, offset)];
    if (offset==2) {
        value=CFSwapInt16BigToHost(*(int*)([intdata bytes]));
    }
    else if (offset==4) {
        value = CFSwapInt32BigToHost(*(int*)([intdata bytes]));
    }
    else if (offset==1) {
        signed char *bs = (signed char *)[[data subdataWithRange:NSMakeRange(location, 1) ] bytes];
        value = *bs;
    }
    return value;
}

// 转为本地大小端模式 返回Unsigned类型的数据
+ (unsigned int)unsignedDataTointWithData:(NSData *)data Location:(NSInteger)location Offset:(NSInteger)offset {
    unsigned int value=0;
    NSData *intdata= [data subdataWithRange:NSMakeRange(location, offset)];

    if (offset==2) {
        value=CFSwapInt16LittleToHost(*(int*)([intdata bytes]));
    }
    else if (offset==4) {
        value = CFSwapInt32LittleToHost(*(int*)([intdata bytes]));
    }
    else if (offset==1) {
        unsigned char *bs = (unsigned char *)[[data subdataWithRange:NSMakeRange(location, 1) ] bytes];
        value = *bs;
    }
    return value;
}

+ (float)dataToFloat:(NSData *)data Location:(NSInteger)location
{
    NSData *floatdata= [data subdataWithRange:NSMakeRange(location, 4)];
    float result[1];
    [floatdata getBytes:result length:4];
    return result[0];
}



@end
