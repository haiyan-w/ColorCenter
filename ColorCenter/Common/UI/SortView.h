//
//  SortView.h
//  EnochCar
//
//  Created by 王海燕 on 2022/3/15.
//

#import <UIKit/UIKit.h>
#import "LookUp.h"

NS_ASSUME_NONNULL_BEGIN

@class SortView;

typedef enum{
    Layout_Right,
    Layout_Left
} LayoutDirction;


@protocol SortViewDelegate <NSObject>
-(void)btnClickedOn:(SortView*)view;
@end

@interface SortView : UIView
@property (nonatomic,weak) UIViewController * viewCtrl;
@property(nonatomic,readwrite,assign) CGFloat maxLenth;
@property(nonatomic,readwrite,assign) LayoutDirction layoutDirction;
@property(nonatomic,readwrite,weak) id<SortViewDelegate> delegate;
@property(nonatomic,readwrite,copy) NSString * title;
@property(nonatomic,readwrite,strong) NSArray <LookUp *> * items;
@property(nonatomic,readwrite,strong) LookUp * curItem;


@property(nonatomic,readwrite,copy) void (^changeBlock)(LookUp * item);

-(void)setText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
