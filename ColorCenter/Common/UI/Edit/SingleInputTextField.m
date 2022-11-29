//
//  SingleInputTextField.m
//  EnochCar
//
//  Created by 王海燕 on 2022/8/4.
//

#import "SingleInputTextField.h"


@implementation SingleInputTextField

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}


@end
