//
//  BaseTabView.m
//  EnochCar
//
//  Created by 王海燕 on 2022/10/8.
//

#import "BaseTabView.h"

@implementation BaseTabView

-(void)setIndex:(NSInteger)index
{
    _index = index;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabview:indexChanged:)]) {
        [self.delegate tabview:self indexChanged:_index];
    }
}

- (void)indexChange
{
    
}

@end
