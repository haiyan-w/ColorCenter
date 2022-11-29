//
//  BlueToothViewController.h
//  ColorCenter
//
//  Created by 王海燕 on 2022/10/19.
//

#import <UIKit/UIKit.h>
#import "GestureViewController.h"
#import "Spectro.h"
#import "StandardSample.h"

NS_ASSUME_NONNULL_BEGIN

@interface BlueToothViewController : GestureViewController
@property (nonatomic, copy) void(^measureBlk)(StandardSample * _Nullable sample);
+(instancetype)defaultBLEController;

- (Spectro *)getSpectro;

- (void)measure;//测量标样
@end

NS_ASSUME_NONNULL_END
