//
//  PickerViewController.h
//  EnochCar
//
//  Created by 王海燕 on 2021/9/8.
//

#import <UIKit/UIKit.h>
#import "GestureViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class PickerViewController;

@protocol PickerViewControllerDelegate <NSObject>
@optional
-(void)pickerViewController:(PickerViewController*)picker selectData:(NSString*)string;
-(void)pickerViewController:(PickerViewController*)picker selectItems:(NSDictionary*)item;
@end

@interface PickerViewController : GestureViewController
@property (nonatomic,weak) id<PickerViewControllerDelegate> delegate;
@property(nonatomic,strong)UIPickerView * pickerView;
@property (nonatomic,weak) id<UIPickerViewDataSource> pickViewDatasource;
@property (nonatomic,weak) id<UIPickerViewDelegate> pickViewDelegate;
@property (nonatomic,assign) NSUInteger tag;
-(void)setTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
