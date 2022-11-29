//
//  JobQuery.m
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/14.
//

#import "JobQuery.h"

@implementation JobQuery

- (BOOL)isFinished
{
    return [self.status.code isEqualToString:@"V"];
}

@end
