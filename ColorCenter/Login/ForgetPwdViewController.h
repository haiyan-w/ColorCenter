//
//  ForgetPwdViewController.h
//  EnochCar
//
//  Created by 王海燕 on 2022/8/1.
//

#import "CommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ForgetPwdViewController : UIViewController
@property (strong, nonatomic) void(^verifiedSuccessBlock)(NSString * cellPhone, NSString * verifyCode);
@end

NS_ASSUME_NONNULL_END
