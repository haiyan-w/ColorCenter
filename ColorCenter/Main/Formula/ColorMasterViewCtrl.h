//
//  ColorMasterViewCtrl.h
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/16.
//

#import "GestureViewController.h"
#import "Goods.h"

NS_ASSUME_NONNULL_BEGIN

@interface ColorMasterViewCtrl : GestureViewController
@property (copy, nonatomic) void(^selectBlk)(Goods * goods);
@end

NS_ASSUME_NONNULL_END
