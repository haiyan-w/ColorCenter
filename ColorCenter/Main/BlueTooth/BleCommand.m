//
//  BleCommand.m
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/17.
//

#import "BleCommand.h"
#import "BleTool.h"

@implementation BleCommand

- (instancetype)initWithData:(NSData *)data
{
    self = [super init];
    if (self) {
        Byte type = [BleTool unsignedDataTointWithData:data Location:0 Offset:1];
        Byte cmdcode = [BleTool unsignedDataTointWithData:data Location:1 Offset:1];
        uint16_t len = [BleTool unsignedDataTointWithData:data Location:2 Offset:2];
        NSData * totalData = [data subdataWithRange:NSMakeRange(4, data.length - 4)];
        self.type = type;
        self.code = cmdcode;
        self.len = len;
        self.data = totalData;
    }
    return self;
}

- (NSData *)cmdToData
{
    NSMutableData * cmdData = [NSMutableData data];
    Byte type = self.type;
    Byte code = self.code;
    uint16_t len  = self.len;
    [cmdData appendBytes:&type length:1];
    [cmdData appendBytes:&code length:1];
    [cmdData appendBytes:&len length:2];
    [cmdData appendData:self.data];
    
    return cmdData;
}

@end
