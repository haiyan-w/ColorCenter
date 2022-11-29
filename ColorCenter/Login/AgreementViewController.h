//
//  AgreementViewController.h
//  EnochCar
//
//  Created by 王海燕 on 2021/6/3.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AgreementViewController : BaseViewController

-(instancetype)initWithResource:(NSString *)resourceStr;

-(void)showIn:(UIViewController *)viewCtrl;

@end

NS_ASSUME_NONNULL_END
