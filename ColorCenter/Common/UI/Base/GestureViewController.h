//
//  BaseViewController.h
//  EnochCar
//
//  Created by 王海燕 on 2021/9/29.
// 适用于下滑退出的页面

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@class GestureViewController;
@protocol GestureViewControllerDelegate <NSObject>

@optional
-(void)gestureViewController:(GestureViewController*)gestureViewController viewWillShow:(BOOL)animate;
-(void)gestureViewController:(GestureViewController*)gestureViewController viewWillDismiss:(BOOL)animate;
@end

@interface GestureViewController : UIViewController
@property(weak, nonatomic) id<GestureViewControllerDelegate> delegate;
@property(strong, nonatomic) UIView * gestureView;
@property(strong, nonatomic) UIView * moveView; //内容view
@property(strong, nonatomic) UIView * backgroundView;
@property(assign, nonatomic) CGRect moveViewOrgFrame;
@property(assign, nonatomic) BOOL needPanGesture;
@property (strong, nonatomic) NSLayoutConstraint *contentViewBottomConstraint;

-(void)showOn:(UIViewController *)viewCtrl;
-(void)dismiss;
-(void)dismissWithCompletion:(void (^ __nullable)(void))completion;
-(void)showAnimate;
-(void)dissmissAnimate;
@end

NS_ASSUME_NONNULL_END
