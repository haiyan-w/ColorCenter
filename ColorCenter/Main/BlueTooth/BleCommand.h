//
//  BleCommand.h
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BleCommand : NSObject
@property (assign, nonatomic) Byte type;
@property (assign, nonatomic) Byte code;
@property (assign, nonatomic) uint16_t len;
@property (strong, nonatomic) NSData * data;

- (instancetype)initWithData:(NSData *)data;
- (NSData *)cmdToData;
@end

NS_ASSUME_NONNULL_END
