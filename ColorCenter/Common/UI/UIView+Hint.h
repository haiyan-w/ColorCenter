//
//  UIView+Hint.h
//  EnochCar
//
//  Created by 王海燕 on 2021/6/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface UIView (Hint)

-(void)setLRCornor;

-(void)setLRCornor:(float)cornerRadius;

-(void)setBottomLRCornor:(CGFloat)cornerRadius;

-(UIView *)findFirstResponder;


@end

NS_ASSUME_NONNULL_END
