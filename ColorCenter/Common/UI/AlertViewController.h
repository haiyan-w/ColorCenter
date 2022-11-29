//
//  AlertViewController.h
//  EnochCar
//
//  Created by 王海燕 on 2021/11/5.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

typedef enum
{
    AlertTop,
    AlertCenter,
    AlertBottom
}AlertPosition;



typedef void(^ActionBlock)(id);

@interface AlertAction : NSObject
@property(nonatomic,readwrite,copy)NSString * title;
@property(nonatomic,copy) ActionBlock actionBlock;

-(instancetype)initWithTitle:(NSString *)title action:(ActionBlock)action;

@end



@interface AlertItem : NSObject
@property(nonatomic,readwrite,copy)NSString * title;
@property(nonatomic,readwrite,copy)NSString * message;
@property(nonatomic,readwrite,assign)AlertPosition pos;
@property (nonatomic, readwrite,copy) NSArray<AlertAction *> *actions;

-(instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message position:(AlertPosition)pos actions:(NSArray<AlertAction *> *)actions;
@end



@class AlertViewController;

@protocol AlertViewControllerDelegate <NSObject>

@optional
-(void)alertViewWillDismiss:(AlertViewController *)alertView;

@end


@interface AlertViewController : UIViewController
@property(nonatomic,weak) id<AlertViewControllerDelegate> delegate;

-(instancetype)initWithItem:(AlertItem *)item;
-(instancetype)initWithTitle:(nullable NSString *)title message:(nullable NSString *)message position:(AlertPosition)pos actions:(NSArray<AlertAction *> *)actions;
-(void)showOn:(UIViewController *)viewCtrl;
-(void)dismissSelf;
@end

NS_ASSUME_NONNULL_END
