//
//  BaseScrollView.m
//  EnochCar
//
//  Created by 王海燕 on 2021/12/29.
//

#import "BaseScrollView.h"

@implementation BaseScrollView

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self baseViewInit];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseViewInit];
    }
    return self;
}

-(void)baseViewInit
{
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.bounces = NO;
    self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}


//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    return YES;
//}

@end
