//
//  CommonSearchText.h
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CommonSearchText : UIView
@property (strong, nonatomic) UITextField * textField;
@property(nonatomic,nullable,weak)id<UITextFieldDelegate> delegate;
@property(nonatomic,readwrite,copy) void(^beginEditBlock)(void);
@property(nonatomic, copy) NSString * placeHolder;
@end

NS_ASSUME_NONNULL_END
