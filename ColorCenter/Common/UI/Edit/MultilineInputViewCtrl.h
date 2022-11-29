//
//  MultilineInputViewCtrl.h
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MultilineInputViewCtrl : UIViewController
@property (nonatomic, copy) void (^sureBlk)(NSString * text);

- (instancetype)initWithTitle:(NSString *)title placeHolder:(NSString *)placeHolder;
-(void)showOn:(UIViewController *)viewCtrl;
@end

NS_ASSUME_NONNULL_END
