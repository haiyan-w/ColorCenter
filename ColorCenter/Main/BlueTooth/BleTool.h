//
//  BleTool.h
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BleTool : NSObject

// 转为本地大小端模式 返回Signed类型的数据
+ (signed int)signedDataTointWithData:(NSData *)data Location:(NSInteger)location Offset:(NSInteger)offset;

// 转为本地大小端模式 返回Unsigned类型的数据
+ (unsigned int)unsignedDataTointWithData:(NSData *)data Location:(NSInteger)location Offset:(NSInteger)offset;

+ (float)dataToFloat:(NSData *)data Location:(NSInteger)location;

@end

NS_ASSUME_NONNULL_END
