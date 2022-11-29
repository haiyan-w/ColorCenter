//
//  MultipleSelectViewController.h
//  EnochCar
//
//  Created by 王海燕 on 2022/8/11.
//

#import "GestureViewController.h"
#import "MultipleSelectTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MultipleSelectViewController : GestureViewController
@property(nonatomic,readwrite,copy) void(^saveBlock)(NSArray * dataArray);

-(instancetype)initWithTitle:(NSString *)title Data:(NSArray <SelectItem *> *)dataArray;
@end

NS_ASSUME_NONNULL_END
