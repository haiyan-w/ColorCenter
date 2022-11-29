//
//  Job.m
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/11.
//

#import "Job.h"

@implementation Job

+ (NSDictionary *)arrayContainModelClass {
    return @{};
}

- (BOOL)isFinished
{
    return [self.status.code isEqualToString:@"V"];
}


@end
