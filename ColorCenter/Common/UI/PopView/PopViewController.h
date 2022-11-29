//
//  PopViewController.h
//  EnochCar
//
//  Created by 王海燕 on 2021/5/20.
//

#import <UIKit/UIKit.h>
#import "GestureViewController.h"

NS_ASSUME_NONNULL_BEGIN


@class PopViewController;

@protocol PopViewDelagate <NSObject>
@required

-(void)popview:(PopViewController *)popview disSelectRowAtIndex:(NSInteger)index;

@end

@interface PopViewController : GestureViewController

@property(nonatomic,nullable,weak)id<PopViewDelagate> delegate;
@property(nonatomic,readwrite,assign) NSInteger tag;
@property(nonatomic,readwrite,copy) void(^selectBlock)(NSInteger index, NSString * string);

-(instancetype)initWithTitle:(NSString *)title Data:(NSArray *)dataArray;

-(void)showIn:(UIViewController *)viewCtrl;
@end

NS_ASSUME_NONNULL_END
