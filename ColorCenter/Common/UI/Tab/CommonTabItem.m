//
//  commonTabItem.m
//  EnochCar
//
//  Created by 王海燕 on 2021/5/19.
//
#import "CommonTabItem.h"
#import <UIKit/UIKit.h>


@interface CommonTabItem()
@property (nonatomic,assign)CommonTabItemStyle style;
@end

@implementation CommonTabItem

- (instancetype)initWithImagename:(NSString *)imagename selectedImage:(NSString *)selectedImagename 
{
    self = [super init];
    if (self) {
        _style = CommonTabItemStyleImage;
        _imageName = imagename;
        _selectedImageName = selectedImagename;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        _style = CommonTabItemStyleText;
        _title = title;
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title tag:(NSInteger)tag
{
    self = [super init];
    if (self) {
        _style = CommonTabItemStyleText;
        _title = title;
        _tag = tag;
    }
    return self;
}

- (instancetype)initWithAttrText:(NSAttributedString *)attrText
{
    self = [super init];
    if (self) {
        _style = CommonTabItemStyleAttrText;
        _attrTitle = attrText;
    }
    return self;
}

- (instancetype)initWithAttrText:(NSAttributedString *)attrText selectedAttr:(NSAttributedString*)selectedAttrText
{
    self = [super init];
    if (self) {
        _style = CommonTabItemStyleAttrText;
        _attrTitle = attrText;
        _selectedAttrTitle = selectedAttrText;
    }
    return self;
}


-(CommonTabItemStyle)style
{
    return _style;
}

@end
