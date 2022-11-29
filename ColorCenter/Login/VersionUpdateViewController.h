//
//  VersionUpdateViewController.h
//  EnochCar
//
//  Created by 王海燕 on 2021/10/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface VersionUpdateViewController : UIViewController

-(instancetype)initWithNotes:(NSString*)releaseNotes version:(NSString *)version;

-(void)showOn:(UIViewController *)viewCtrl;

@end

NS_ASSUME_NONNULL_END
