//
//  ItemCollectionViewCell.m
//  ColorCenter
//
//  Created by 王海燕 on 2022/10/27.
//

#import "ItemCollectionViewCell.h"


@implementation Item
- (instancetype)initWith:(NSString *)name icon:(NSString *)iconName
{
    self = [super init];
    if (self) {
        self.name = name;
        self.iconname = iconName;
    }
    return self;
}
@end


@interface ItemCollectionViewCell()
@property (strong, nonatomic) IBOutlet UIImageView *icon;
@property (strong, nonatomic) IBOutlet UILabel *lab;

@end

@implementation ItemCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setItem:(Item *)item
{
    _item = item;
    
    self.lab.text = item.name;
    self.icon.image = [UIImage imageNamed:item.iconname];
}

@end
