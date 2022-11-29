//
//  JobHistory.m
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/11.
//

#import "JobHistory.h"

@implementation JobHistory

+ (NSDictionary *)arrayContainModelClass {
    return @{@"details" : @"FormulaDetail"};
}


- (BOOL)isFinished
{
    return [self.status.code isEqualToString:@"V"];
}


@end
