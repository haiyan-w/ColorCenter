//
//  BaseInputViewCtrl.h
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseInputViewCtrl : UIViewController
@property (nonatomic, copy) NSString * titleStr;
@property (nonatomic, copy) NSString * placeHolder;
@property (nonatomic, copy) void (^sureBlk)(NSString * text);
@end

NS_ASSUME_NONNULL_END
