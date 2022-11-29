//
//  SearchTextView.h
//  EnochCar
//
//  Created by 王海燕 on 2022/9/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchTextView : UIView
@property (strong, nonatomic) UITextField * textField;
@property(nonatomic,readwrite,copy) void(^textChangedBlock)(NSString * text);
@property(nonatomic,readwrite,copy) void(^returnBlock)(NSString * text);
@property(nonatomic, copy) NSString * placeHolder;

@property (strong, nonatomic) NSArray * tags;

- (NSString *)getText;
@end

NS_ASSUME_NONNULL_END
