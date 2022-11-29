//
//  JobView.h
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JobView : UIView
@property (weak, nonatomic) UIViewController * viewCtrl;

- (void)refresh;

@end

NS_ASSUME_NONNULL_END
