//
//  GradientView.m
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/16.
//

#import "GradientView.h"

@interface  GradientView ()
@property (strong, nonatomic) CAGradientLayer * gradientlayer;
@end

@implementation GradientView

- (void)setColors:(NSArray *)colors
{
    [self.gradientlayer removeFromSuperlayer];
    self.gradientlayer = [CAGradientLayer layer];
    self.gradientlayer.colors = colors;
    NSMutableArray * locations = [NSMutableArray array];
    for (int i = 0; i < colors.count; i++) {
        [locations addObject:@(1/colors.count)];
    }
    self.gradientlayer.locations = locations;
    
    self.gradientlayer.startPoint = CGPointMake(0, 0);
    self.gradientlayer.endPoint = CGPointMake(0, 1.0);
    self.gradientlayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self.layer addSublayer:self.gradientlayer];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.gradientlayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}

@end
