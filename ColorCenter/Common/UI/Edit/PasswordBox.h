//
//  PasswordBox.h
//  EnochCar
//
//  Created by 王海燕 on 2022/8/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PasswordBox : UIView

-(void)setText:(NSString*)text;

-(NSString*)getText;

-(void)setPlaceHolder:(NSString * _Nullable)placeHolder;

@end

NS_ASSUME_NONNULL_END
