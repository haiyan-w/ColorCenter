//
//  CommonTextField.h
//  EnochCar
//
//  Created by 王海燕 on 2021/5/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class CommonTextField;
@protocol CommonTextFieldDelegate <NSObject>
 
- (void)textFieldDeleteBackward:(CommonTextField *)textField;
 
@end

@interface CommonTextField : UITextField
@property (nonatomic,weak)id <CommonTextFieldDelegate> commonDelegate;
@end

NS_ASSUME_NONNULL_END
