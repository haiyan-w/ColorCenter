//
//  GradientView.h
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GradientView : UIImageView
@property (strong, nonatomic) NSArray * colors;
- (void)setColors:(NSArray *)colors;
@end

NS_ASSUME_NONNULL_END
