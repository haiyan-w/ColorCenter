//
//  CommonButton.h
//  EnochCar
//
//  Created by 王海燕 on 2021/9/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommonButton : UIButton

-(instancetype)initWithFrame:(CGRect)frame title:(NSString*)title;
-(instancetype)initWithFrame:(CGRect)frame normalTitle:(NSString*)normalTitle disabledTitle:(NSString*)disabledTitle;
-(void)setNormalTitle:(NSString*)normalTitle disabledTitle:(NSString*)disabledTitle;
@end

NS_ASSUME_NONNULL_END
