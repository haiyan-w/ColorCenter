//
//  TextTabScrollView.h
//  EnochCar
//
//  Created by 王海燕 on 2022/8/12.
//

#import <UIKit/UIKit.h>
#import "TextTabView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TextTabScrollView : UIView
@property(nullable, nonatomic, strong) TextTabView * tabbar;
@property(nonatomic,readwrite,assign) NSInteger index;
@property(nullable, nonatomic, copy) NSArray<TextTabItem *> *items;
@property(nullable, nonatomic, strong) NSArray<UIView *> *viewArray;

@end

NS_ASSUME_NONNULL_END
