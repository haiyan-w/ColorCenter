//
//  PopMenuCell.h
//  PopMenu
//
//  Created by 王海燕 on 2021/5/20.
//

#import <UIKit/UIKit.h>

@interface PopMenuCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labText;
@property (strong, nonatomic) IBOutlet UIView *separateLine;

@property (strong, nonatomic) IBOutlet UIImageView *icon;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *iconWidthConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *spaceConstaint;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
