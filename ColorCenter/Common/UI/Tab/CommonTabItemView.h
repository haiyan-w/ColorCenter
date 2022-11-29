//
//  CommonTabItemView.h
//  EnochCar
//
//  Created by 王海燕 on 2022/4/24.
//

#import <UIKit/UIKit.h>
#import "BadgeView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommonTabItemView : UIView
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIButton *button;
@property (nullable,nonatomic,strong) BadgeView *badge;

@property(nonatomic,readwrite,assign)CGFloat topPadding;

-(void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
@end

NS_ASSUME_NONNULL_END
