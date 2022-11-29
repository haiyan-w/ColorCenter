//
//  DoubleArrayShape.m
//  BlueToothTest
//
//  Created by 王海燕 on 2022/10/25.
//

#import "DoubleArrayShape.h"

@implementation DoubleArrayShape


- (NSArray *)getValue:(int)pos
{
    int diffPos = pos - self.start;
    NSArray * value = NULL;
    
    if ((diffPos % self.interval == 0)) {
        value = self.values[diffPos/self.interval];
        
    }else {
        int leftIndex = diffPos / self.interval;
        
        if (leftIndex > 0 && leftIndex < (self.values.count-1)) {
            NSArray * left = self.values[leftIndex];
            NSArray * right = self.values[leftIndex+1];
            
            NSMutableArray * diffArray = [NSMutableArray array];
            for (int i = 0; i < left.count; i++) {
                NSNumber * leftI = left[i];
                NSNumber * rightI = right[i];
                [diffArray addObject:[NSNumber numberWithDouble:rightI.doubleValue - leftI.doubleValue]];
            }
            
            NSMutableArray * deltaArray = [NSMutableArray array];
            for (int i = 0; i < diffArray.count; i++) {
                NSNumber * diff = diffArray[i];
                [deltaArray addObject:[NSNumber numberWithDouble:diff.doubleValue/self.interval]];
            }
            
            NSMutableArray * multiplyArray = [NSMutableArray array];
            for (int i = 0; i < deltaArray.count; i++) {
                NSNumber * delta = deltaArray[i];
                [deltaArray addObject:[NSNumber numberWithDouble:delta.doubleValue*(diffPos % self.interval)]];
            }
            
            NSMutableArray * addArray = [NSMutableArray array];
            for (int i = 0; i < multiplyArray.count; i++) {
                NSNumber * multiply = multiplyArray[i];
                NSNumber * leftI = left[i];
                [deltaArray addObject:[NSNumber numberWithDouble:leftI.doubleValue + multiply.doubleValue]];
            }
            
            value = addArray;
        }
    }
    
    return value;
}


@end
