//
//  AbstractShape.m
//  BlueToothTest
//
//  Created by 王海燕 on 2022/10/21.
//

#import "AbstractShape.h"

@implementation AbstractShape

- (int)end
{
    int end = self.start + (int)(self.values.count - 1) * self.interval;
    return end;
}

@end
