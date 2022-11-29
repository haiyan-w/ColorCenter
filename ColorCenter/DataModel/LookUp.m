//
//  LookUp.m
//  EnochCar
//
//  Created by 王海燕 on 2022/4/20.
//

#import "LookUp.h"

@implementation LookUp

- (instancetype)initWithCode:(NSString *)code message:(NSString *)message
{
    self = [super init];
    if (self) {
        self.code = code;
        self.message = message;
    }
    return self;
}

@end
