//
//  CommonTextField.m
//  EnochCar
//
//  Created by 王海燕 on 2021/5/18.
//

#import "CommonTextField.h"

@implementation CommonTextField



//监听删除事件
- (void)deleteBackward
{
    if ([self.commonDelegate respondsToSelector:@selector(textFieldDeleteBackward:)]) {
        [self.commonDelegate textFieldDeleteBackward:self];
    }
    [super deleteBackward];
}


@end
