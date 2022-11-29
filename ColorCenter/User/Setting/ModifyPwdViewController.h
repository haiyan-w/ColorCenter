//
//  ModifyPwdViewController.h
//  EnochCar
//
//  Created by 王海燕 on 2021/5/24.
//

#import "CommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ModifyPwdViewController : CommonViewController
-(instancetype)initWithForget:(BOOL)isForget cellphone:(NSString *)cellphone verifyCode:(NSString *)verifyCode;
@end

NS_ASSUME_NONNULL_END
